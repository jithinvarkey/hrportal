<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\LeaveType;
use App\Models\LeaveRequest;
use App\Models\EmployeeRequest;
use App\Models\RequestType;
use App\Models\LeaveAllocation;
use App\Services\LeaveService;
use App\Services\RequestActivityService;
use App\Services\AnnualTicketService;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class LeaveController extends Controller {

    protected $service;
    protected $activityService;

    public function __construct(LeaveService $service, RequestActivityService $activityService, protected AnnualTicketService $annualTickets) {
        $this->service = $service;
        $this->activityService = $activityService;
    }

    public function ticketOptions(Request $request) {
        $employee = auth()->user()->employee;
        abort_unless($employee, 404, 'Employee record not found.');
        $year = (int) ($request->query('year') ?: now()->year);
        return response()->json(['ticket_options' => $this->annualTickets->options($employee, $year)]);
    }

    private function logLeaveActivity(LeaveRequest $leave, string $event, string $description, array $properties = []): void {
        $this->activityService->record($leave, 'leave_request', $event, $description, $properties);
    }

    /**
     * Get the authenticated user's role names directly from the DB.
     * Bypasses Spatie's guard resolution which fails with Sanctum.
     */
    private function userRoles(): array {
        $user = auth()->user();
        return DB::table('model_has_roles')
                        ->join('roles', 'roles.id', '=', 'model_has_roles.role_id')
                        ->where('model_has_roles.model_id', $user->id)
                        ->where('model_has_roles.model_type', get_class($user))
                        ->pluck('roles.name')
                        ->toArray();
    }

    private function hasAnyRoleDB(array $roles): bool {
        return count(array_intersect($this->userRoles(), $roles)) > 0;
    }

    private function visibleLeaveTypeIdsForDepartment(?int $departmentId): ?array {
        if (!$departmentId) {
            return [];
        }

        $configuredTypeIds = DB::table('leave_type_department_visibility')
                ->distinct()
                ->pluck('leave_type_id')
                ->toArray();

        if (empty($configuredTypeIds)) {
            return null;
        }

        $visibleConfiguredIds = DB::table('leave_type_department_visibility')
                ->where('department_id', $departmentId)
                ->where('is_visible', true)
                ->pluck('leave_type_id')
                ->toArray();

        return array_values(array_unique(array_merge(
            LeaveType::whereNotIn('id', $configuredTypeIds)->pluck('id')->toArray(),
            $visibleConfiguredIds
        )));
    }

    private function leaveTypeVisibleForEmployee(LeaveType $leaveType, $employee): bool {
        if (!$employee?->department_id) {
            return false;
        }

        $hasVisibilityConfig = DB::table('leave_type_department_visibility')
                ->where('leave_type_id', $leaveType->id)
                ->exists();

        if (!$hasVisibilityConfig) {
            return true;
        }

        return DB::table('leave_type_department_visibility')
                ->where('leave_type_id', $leaveType->id)
                ->where('department_id', $employee->department_id)
                ->where('is_visible', true)
                ->exists();
    }

    private function isOwnLeaveRequest(LeaveRequest $leave, $user): bool {
        if ($user->employee && (int) $leave->employee_id === (int) $user->employee->id) {
            return true;
        }

        $leave->loadMissing('employee');
        return $leave->employee && (int) $leave->employee->user_id === (int) $user->id;
    }

    private function leaveRequestScope($user, bool $isHRAdmin, bool $isMgr) {
        $query = LeaveRequest::query();

        if ($isHRAdmin) {
            return $query;
        }

        if ($isMgr && $user->employee) {
            $teamIds = $user->employee->subordinates()->pluck('id');
            $teamIds->push($user->employee->id);
            return $query->whereIn('employee_id', $teamIds);
        }

        if ($user->employee) {
            return $query->where('employee_id', $user->employee->id);
        }

        return $query->whereRaw('1 = 0');
    }

    private function actionableLeaveRequestScope($user, bool $isHRAdmin, bool $isMgr) {
        $query = LeaveRequest::query();

        if ($isHRAdmin) {
            $query->whereIn('status', ['pending', 'manager_approved']);
        } elseif ($isMgr && $user->employee) {
            $query->where('status', 'pending')
                    ->whereIn('employee_id', $user->employee->subordinates()->pluck('id'));
        } else {
            return $query->whereRaw('1 = 0');
        }

        if ($user->employee) {
            $query->where('employee_id', '!=', $user->employee->id);
        }

        return $query->whereDoesntHave('employee', fn($eq) => $eq->where('user_id', $user->id));
    }

    public function types() {
        $user = auth()->user();
        $isHRAdmin = rescue(fn() => $this->hasAnyRoleDB(['super_admin', 'hr_manager', 'hr_staff']), false, false);

        $query = LeaveType::where('is_active', true)
                ->when(!$isHRAdmin, function ($q) use ($user) {
                    $visibleIds = $this->visibleLeaveTypeIdsForDepartment($user->employee?->department_id);
                    if (is_array($visibleIds)) {
                        $q->whereIn('id', $visibleIds);
                    }
                });

        return response()->json(['types' => $query->orderBy('name')->get()]);
    }

    public function storeType(Request $request) {
        if (!$this->canManageLeaveTypes()) {
            return response()->json(['message' => 'You do not have permission to manage leave types.'], 403);
        }

        $request->validate([
            'name' => 'required|string|max:100',
            'code' => 'required|string|max:20|unique:leave_types',
            'days_allowed' => 'required|integer|min:0',
            'is_paid' => 'boolean',
            'carry_forward' => 'boolean',
            'requires_document' => 'boolean',
            'is_active' => 'boolean',
            'skip_manager_approval' => 'boolean',
            'is_hourly' => 'boolean',
            'monthly_hours_limit' => 'nullable|numeric|min:0.5|max:200',
            'description' => 'nullable|string',
        ]);
        return response()->json(['type' => LeaveType::create($request->all())], 201);
    }

    public function updateType(Request $request, $id) {
        if (!$this->canManageLeaveTypes()) {
            return response()->json(['message' => 'You do not have permission to manage leave types.'], 403);
        }

        $type = LeaveType::findOrFail($id);
        $request->validate([
            'name' => 'sometimes|string|max:100',
            'days_allowed' => 'sometimes|integer|min:0',
            'is_paid' => 'boolean',
            'carry_forward' => 'boolean',
            'requires_document' => 'boolean',
            'is_active' => 'boolean',
            'skip_manager_approval' => 'boolean', // sick leave policy
            'is_hourly' => 'boolean',
            'monthly_hours_limit' => 'nullable|numeric|min:0.5|max:200',
            'description' => 'nullable|string',
        ]);
        $type->update($request->all());
        return response()->json(['type' => $type->fresh()]);
    }

    public function typeVisibility($id) {
        $type = LeaveType::findOrFail($id);
        $departments = \App\Models\Department::where('is_active', true)
                ->orderBy('name')
                ->get(['id', 'name', 'code']);

        $configured = DB::table('leave_type_department_visibility')
                ->where('leave_type_id', $type->id)
                ->get()
                ->keyBy('department_id');

        $visibility = $departments->map(function ($department) use ($configured, $type) {
            $row = $configured->get($department->id);

            return [
                'department_id' => $department->id,
                'department_name' => $department->name,
                'department_code' => $department->code,
                'leave_type_id' => $type->id,
                'visibility_id' => $row?->id,
                'is_visible' => $row ? (bool) $row->is_visible : true,
            ];
        });

        return response()->json(['visibility' => $visibility]);
    }

    public function saveTypeVisibility(Request $request, $id) {
        if (!$this->canManageLeaveTypes()) {
            return response()->json(['message' => 'You do not have permission to manage leave types.'], 403);
        }

        $type = LeaveType::findOrFail($id);
        $request->validate([
            'visibility' => 'required|array',
            'visibility.*.department_id' => 'required|exists:departments,id',
            'visibility.*.is_visible' => 'required|boolean',
        ]);

        foreach ($request->visibility as $row) {
            DB::table('leave_type_department_visibility')->updateOrInsert(
                    [
                        'leave_type_id' => $type->id,
                        'department_id' => $row['department_id'],
                    ],
                    [
                        'is_visible' => (bool) $row['is_visible'],
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]
            );
        }

        return response()->json(['message' => 'Department visibility saved successfully.']);
    }

    private function canManageLeaveTypes(): bool {
        return $this->hasAnyRoleDB(['super_admin', 'hr_manager', 'hr_staff']);
    }

    public function index(Request $request) {
        $user = auth()->user();

        // ── Role check via raw DB (no Spatie, no guard issues) ────────────────
        $userRoles = rescue(fn() => DB::table('model_has_roles')
                        ->join('roles', 'roles.id', '=', 'model_has_roles.role_id')
                        ->where('model_has_roles.model_id', $user->id)
                        ->pluck('roles.name')->toArray(), [], false);

        $isHRAdmin = (bool) array_intersect($userRoles, ['super_admin', 'hr_manager', 'hr_staff']);
        $isMgr = in_array('department_manager', $userRoles);

        $query = LeaveRequest::with(['employee.department', 'leaveType'])
                ->when(!$isHRAdmin, function ($q) use ($user, $isMgr) {
                    if ($isMgr && $user->employee) {
                        $teamIds = $user->employee->subordinates()->pluck('id');
                        if (!request()->needs_action) {
                            $teamIds->push($user->employee->id);
                        }
                        $q->whereIn('employee_id', $teamIds);
                    } elseif ($user->employee) {
                        $q->where('employee_id', $user->employee->id);
                    }
                })
                ->when($request->needs_action, fn($q) => $q->whereIn('status',
                                $isHRAdmin ? ['pending', 'manager_approved'] : ['pending']
                        ))
                ->when($request->needs_action && $user->employee, fn($q) => $q->where('employee_id', '!=', $user->employee->id))
                ->when($request->needs_action, fn($q) => $q->whereDoesntHave('employee', fn($eq) => $eq->where('user_id', $user->id)))
                ->when(!$request->needs_action && $request->status, fn($q) => $q->where('status', $request->status))
                ->when($request->employee_id, fn($q) => $q->where('employee_id', $request->employee_id))
                ->when($request->leave_type_id, fn($q) => $q->where('leave_type_id', $request->leave_type_id))
                ->when($request->search, function ($q) use ($request) {
                    $search = trim((string) $request->search);
                    $q->where(function ($sub) use ($search) {
                        $sub->where('reason', 'like', "%{$search}%")
                            ->orWhereHas('employee', function ($employeeQuery) use ($search) {
                                $employeeQuery->where('first_name', 'like', "%{$search}%")
                                    ->orWhere('last_name', 'like', "%{$search}%")
                                    ->orWhere('email', 'like', "%{$search}%")
                                    ->orWhere('employee_code', 'like', "%{$search}%");
                            });
                    });
                })
                ->orderBy('created_at', 'desc');

        $perPage = min(max((int) $request->input('per_page', 10), 10), 100);
        $paginated = $query->orderByDesc('id')->paginate($perPage);
        $paginated->getCollection()->transform(function ($leave) use ($user) {
            $isOwn = $this->isOwnLeaveRequest($leave, $user);
            $leave->setAttribute('can_approve', !$isOwn);
            $leave->setAttribute('can_reject', !$isOwn);
            return $leave;
        });

        return response()->json($paginated);
    }

    public function store(Request $request) {
        $leaveType = LeaveType::findOrFail($request->leave_type_id);
        $employee = auth()->user()->employee;

        if (!$this->leaveTypeVisibleForEmployee($leaveType, $employee)) {
            return response()->json(['message' => "{$leaveType->name} is not available for your department."], 403);
        }

        // ── Business Excuse (hourly) ──────────────────────────────────────
        if ($leaveType->is_hourly) {
            $request->validate([
                'leave_type_id' => 'required|exists:leave_types,id',
                'start_date' => 'required|date|after_or_equal:today',
                'start_time' => 'required|date_format:H:i',
                'end_time' => 'required|date_format:H:i|after:start_time',
                'reason' => 'required|string|min:5',
            ]);

            $employee = $employee->load('department');
            $hours = $this->service->calculateExcuseHours(
                    $request->start_date,
                    $request->start_time,
                    $request->end_time
            );

            $error = $this->service->validateHourlyExcuse(
                    $employee,
                    $leaveType,
                    $request->start_date,
                    $request->start_time, $request->end_time, $hours
            );

            if ($error)
                return response()->json(['message' => $error], 422);

            // Document upload for hourly types
            $documentPath = null;
            if ($request->hasFile('document')) {
                $request->validate(['document' => 'file|mimes:pdf,jpg,jpeg,png|max:5120']);
                $documentPath = $request->file('document')->store(
                        "leave-documents/{$employee->id}", 'public'
                );
            }

            $leaveRequest = LeaveRequest::create([
                        'employee_id' => $employee->id,
                        'leave_type_id' => $request->leave_type_id,
                        'start_date' => $request->start_date,
                        'end_date' => $request->start_date,
                        'start_time' => $request->start_time,
                        'end_time' => $request->end_time,
                        'total_days' => 0,
                        'total_hours' => $hours,
                        'document_path' => $documentPath,
                        'status' => $leaveType->skip_manager_approval ? 'manager_approved' : 'pending',
                        'reason' => $request->reason,
            ]);

            $this->logLeaveActivity($leaveRequest, 'submitted', "{$leaveType->name} leave request submitted.", [
                'to_status' => $leaveRequest->status,
                'total_hours' => $hours,
                'notes' => $request->reason,
            ]);

            $this->service->updateLeaveBalance($leaveRequest, 'submit');
            $this->service->notifyManager($leaveRequest, 'submitted');
            return response()->json(['message' => "{$leaveType->name} of {$hours}h submitted", 'request' => $leaveRequest->load('leaveType')], 201);
        }

        // ── Standard (daily) leave ────────────────────────────────────────
        $request->validate([
            'leave_type_id' => 'required|exists:leave_types,id',
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after_or_equal:start_date',
            'reason' => 'required|string|min:10',
            'is_half_day' => 'nullable|boolean',
            'half_day_period' => 'nullable|in:morning,afternoon',
            'requires_exit_reentry' => 'nullable|boolean',
            'requires_ticket' => 'nullable|boolean',
            'destination_country' => 'nullable|string|max:100',
            'ticket_dependent_ids' => 'nullable|array|max:3',
            'ticket_dependent_ids.*' => 'integer',
        ]);

        $employee = auth()->user()->employee;
        $isHalfDay = (bool) $request->is_half_day;
        $requiresTicket = $leaveType->is_annual ? (bool) $request->requires_ticket : false;
        $ticketYear = (int) date('Y', strtotime($request->start_date));
        $dependentIds = $this->annualTickets->validateSelection(
            $employee,
            $requiresTicket,
            array_map('intval', $request->input('ticket_dependent_ids', [])),
            $ticketYear
        );

        // Half day: force start_date = end_date, total = 0.5 days
        if ($isHalfDay) {
            $request->merge(['end_date' => $request->start_date]);
        }

        $totalDays = $isHalfDay ? 0.5 : $this->service->calculateWorkingDays($request->start_date, $request->end_date);

        $allocation = LeaveAllocation::where([
                    'employee_id' => $employee->id,
                    'leave_type_id' => $request->leave_type_id,
                    'year' => Carbon::parse($request->start_date)->year,
                ])->first();

        if ($allocation && $allocation->remaining_days < $totalDays) {
            return response()->json(['message' => "Insufficient leave balance. Available: {$allocation->remaining_days} days"], 422);
        }

        // ── Document upload (required if leave type has requires_document=true) ──
        if ($leaveType->requires_document && !$request->hasFile('document')) {
            return response()->json(['message' => "A supporting document is required for '{$leaveType->name}' leave."], 422);
        }

        $documentPath = null;
        if ($request->hasFile('document')) {
            $request->validate(['document' => 'file|mimes:pdf,jpg,jpeg,png|max:5120']);
            $documentPath = $request->file('document')->store(
                    "leave-documents/{$employee->id}", 'public'
            );
        }

        $leaveRequest = LeaveRequest::create(array_merge($request->only(['leave_type_id', 'start_date', 'end_date', 'reason']), [
                    'employee_id' => $employee->id,
                    'total_days' => $totalDays,
                    'is_half_day' => $isHalfDay,
                    'half_day_period' => $isHalfDay ? $request->half_day_period : null,
                    'requires_exit_reentry' => $leaveType->is_annual ? (bool) $request->requires_exit_reentry : false,
                    'requires_ticket' => $requiresTicket,
                    'ticket_year' => $requiresTicket ? $ticketYear : null,
                    'ticket_count' => $requiresTicket ? 1 + count($dependentIds) : 0,
                    'destination_country' => $leaveType->is_annual ? $request->destination_country : null,
                    'document_path' => $documentPath,
                    'status' => $leaveType->skip_manager_approval ? 'manager_approved' : 'pending',
        ]));

        if ($requiresTicket) {
            $this->annualTickets->savePassengers($leaveRequest, $employee, $dependentIds);
        }

        $this->logLeaveActivity($leaveRequest, 'submitted', "{$leaveType->name} leave request submitted.", [
            'to_status' => $leaveRequest->status,
            'total_days' => $totalDays,
            'notes' => $request->reason,
        ]);
        $this->service->updateLeaveBalance($leaveRequest, 'submit');
        /*
          |--------------------------------------------------------------------------
          | FIND ANY EMPLOYEE IN THE SAME DEPARTMENT WHO HAS APPLIED FOR ANNUAL LEAVE WITH IN THE SAME DATE PERIOD
          |--------------------------------------------------------------------------
         */
        
          $conflicts = $this->service->getDepartmentLeaveConflicts($leaveRequest);

        /*
          |--------------------------------------------------------------------------
          | Notify HR
          |--------------------------------------------------------------------------
         */

        $this->service->notifyManager($leaveRequest, 'submitted',$request->reason,$conflicts);
        /*
          |--------------------------------------------------------------------------
          | Notify Employee
          |--------------------------------------------------------------------------
         */
      
        
        $this->service->notifyEmployee($leaveRequest, 'submitted');

        return response()->json(['message' => 'Leave request submitted', 'request' => $leaveRequest->load('leaveType')], 201);
    }

    /**
     * Create linked HR requests after an annual leave reaches final approval.
     */
    private function createLinkedRequests(LeaveRequest $leave, $employee): void {
        $travelInfo = $leave->destination_country ? "Destination: {$leave->destination_country}. " : '';
        $dateInfo = "Annual leave: {$leave->start_date} – {$leave->end_date} ({$leave->total_days} days). ";
        $baseNote = "Auto-generated from annual leave request #{$leave->id}. {$dateInfo}{$travelInfo}";
        $passengerManifest = $leave->requires_ticket ? $this->ticketPassengerManifest($leave, $employee) : '';
        $selectionDetails = $passengerManifest
            ? "\n\nSelected ticket passengers:\n{$passengerManifest}"
            : '';

        // Exit re-entry visa request
        if ($leave->requires_exit_reentry) {
            $visaType = RequestType::where('code', 'VISA_EXIT_S')->orWhere('code', 'VISA_EXIT_M')->first();
            if (!$visaType) {
                $visaType = RequestType::where('category', 'visa')
                                ->where('name', 'LIKE', '%exit%')->first();
            }
            if ($visaType) {
                $dueDate = now()->addDays($visaType->sla_days)->toDateString();
                $this->saveLinkedRequest($leave, 'exit_reentry', [
                    'employee_id' => $employee->id,
                    'request_type_id' => $visaType->id,
                    'status' => 'pending',
                    'details' => $baseNote . 'Exit re-entry visa required before departure.' . $selectionDetails,
                    'required_by' => $leave->start_date,
                    'due_date' => $dueDate,
                    'copies_needed' => 1,
                ]);
            }
        }

        // Air ticket request
        if ($leave->requires_ticket) {
            $ticketType = RequestType::where('code', 'TRAVEL_TICKET')->first();
            if (!$ticketType) {
                $ticketType = RequestType::where('category', 'travel')
                                ->where('name', 'LIKE', '%ticket%')->first();
            }
            if ($ticketType) {
                $dueDate = now()->addDays($ticketType->sla_days)->toDateString();
                $this->saveLinkedRequest($leave, 'ticket', [
                    'employee_id' => $employee->id,
                    'request_type_id' => $ticketType->id,
                    'status' => 'pending',
                    'details' => $baseNote . "\n\nTicket passenger details:\n" . $passengerManifest,
                    'required_by' => $leave->start_date,
                    'due_date' => $dueDate,
                    'copies_needed' => max(1, (int) $leave->ticket_count),
                ]);
            }
        }
    }

    private function saveLinkedRequest(LeaveRequest $leave, string $service, array $values): void {
        $linked = EmployeeRequest::where('leave_request_id', $leave->id)
            ->where('linked_service', $service)
            ->first();

        // Adopt requests generated before source links were introduced.
        if (!$linked) {
            $linked = EmployeeRequest::where('employee_id', $leave->employee_id)
                ->where('details', 'LIKE', "%annual leave request #{$leave->id}.%")
                ->where('request_type_id', $values['request_type_id'])
                ->first();
        }

        if ($linked) {
            $linked->update(array_merge($values, [
                'leave_request_id' => $leave->id,
                'linked_service' => $service,
            ]));
            return;
        }

        EmployeeRequest::create(array_merge($values, [
            'reference' => $this->generateLeaveRef(),
            'leave_request_id' => $leave->id,
            'linked_service' => $service,
        ]));
    }

    private function ticketPassengerManifest(LeaveRequest $leave, $employee): string {
        $lines = [];
        $number = 1;
        foreach ($leave->ticketPassengers()->with('dependent')->get() as $passenger) {
            if ($passenger->passenger_type === 'employee') {
                $lines[] = implode("\n", [
                    "{$number}. Employee: {$employee->full_name}",
                    "   Employee code: {$employee->employee_code}",
                    '   Nationality: ' . ($employee->nationality ?: 'Not provided'),
                    '   Date of birth: ' . ($employee->dob?->format('Y-m-d') ?: 'Not provided'),
                    '   Email: ' . ($employee->email ?: 'Not provided'),
                    '   Phone: ' . ($employee->phone ?: 'Not provided'),
                ]);
            } else {
                $dependent = $passenger->dependent;
                $lines[] = implode("\n", [
                    "{$number}. Dependent: {$passenger->passenger_name}",
                    '   Relationship: ' . ($dependent?->relationship ? ucfirst($dependent->relationship) : 'Not provided'),
                    '   Nationality: ' . ($dependent?->nationality ?: 'Not provided'),
                    '   Date of birth: ' . ($dependent?->date_of_birth?->format('Y-m-d') ?: 'Not provided'),
                    '   Passport number: ' . ($dependent?->passport_number ?: 'Not provided'),
                    '   Passport expiry: ' . ($dependent?->passport_expiry?->format('Y-m-d') ?: 'Not provided'),
                ]);
            }
            $number++;
        }
        return implode("\n\n", $lines);
    }

    /** Generate a unique reference number for auto-created requests. */
    private function generateLeaveRef(): string {
        $year = now()->year;
        $count = EmployeeRequest::whereYear('created_at', $year)->count() + 1;
        return 'REQ-' . $year . '-' . str_pad($count, 5, '0', STR_PAD_LEFT);
    }

    public function show($id) {
        $request = LeaveRequest::with(['employee', 'leaveType', 'approver', 'managerApprover', 'ticketPassengers'])->findOrFail($id);
        $request->setAttribute('activities', $this->activityService->timeline($request));
        return response()->json(['request' => $request]);
    }

    public function approve(Request $request, $id) {
        $leave = LeaveRequest::with(['leaveType', 'employee'])->findOrFail($id);
        $user = auth()->user();

        if ($this->isOwnLeaveRequest($leave, $user)) {
            return response()->json(['message' => 'You cannot approve your own leave request.'], 403);
        }

        // ── Stage 1: Manager approval ──────────────────────────────────
        if ($leave->status === 'pending') {
            // Only managers / HR / super_admin can approve at this stage
            if (!$this->hasAnyRoleDB(['department_manager', 'hr_manager', 'hr_staff', 'super_admin'])) {
                return response()->json(['message' => 'Only a manager can approve at this stage.'], 403);
            }

            if (
                $this->hasAnyRoleDB(['department_manager']) &&
                !$this->hasAnyRoleDB(['hr_manager', 'hr_staff', 'super_admin']) &&
                (!$user->employee || (int) $leave->employee?->manager_id !== (int) $user->employee->id)
            ) {
                return response()->json(['message' => 'Only the employee direct manager can approve this leave request.'], 403);
            }

            $oldStatus = $leave->status;
            $leave->update([
                'status' => 'manager_approved',
                'manager_approved_by' => $user->id,
                'manager_approved_at' => now(),
                'manager_notes' => $request->input('notes'),
            ]);
            $this->logLeaveActivity($leave, 'manager_approved', 'Leave request approved at manager level.', [
                'from_status' => $oldStatus,
                'to_status' => 'manager_approved',
                'notes' => $request->input('notes'),
            ]);
            /*
              |--------------------------------------------------------------------------
              | Notify Employee
              |--------------------------------------------------------------------------
             */

            $this->service->notifyEmployee($leave, 'manager_approved');
            /*
              |--------------------------------------------------------------------------
              | Notify HR
              |--------------------------------------------------------------------------
             */
            $this->service->notifyManager($leave, 'manager_approved');

            return response()->json([
                        'message' => 'Approved at manager level. Awaiting HR approval.',
                        'leave' => $leave->fresh(['leaveType', 'employee', 'managerApprover']),
            ]);
        }

        // ── Stage 2: HR final approval ─────────────────────────────────
        if ($leave->status === 'manager_approved') {
            if (!$this->hasAnyRoleDB(['hr_manager', 'hr_staff', 'super_admin'])) {
                return response()->json(['message' => 'Only HR can give final approval.'], 403);
            }

            $oldStatus = $leave->status;
            $leave->update([
                'status' => 'approved',
                'approved_by' => $user->id,
                'approved_at' => now(),
            ]);
            $this->logLeaveActivity($leave, 'hr_approved', 'Leave request fully approved by HR.', [
                'from_status' => $oldStatus,
                'to_status' => 'approved',
            ]);

            if ($leave->leaveType?->is_annual) {
                $this->createLinkedRequests($leave, $leave->employee);
            }

            $this->service->updateLeaveBalance($leave, 'approve');
            /*
              |--------------------------------------------------------------------------
              | Notify Employee
              |--------------------------------------------------------------------------
             */
            $this->service->notifyEmployee($leave, 'hr_approved');

            return response()->json([
                        'message' => 'Leave fully approved by HR.',
                        'leave' => $leave->fresh(['leaveType', 'employee', 'approver', 'managerApprover']),
            ]);
        }

        return response()->json(['message' => "Cannot approve a leave with status '{$leave->status}'."], 422);
    }

    public function reject(Request $request, $id) {
        $request->validate(['reason' => 'required|string']);
        $leave = LeaveRequest::with(['leaveType', 'employee'])->findOrFail($id);
        $user = auth()->user();

        if ($this->isOwnLeaveRequest($leave, $user)) {
            return response()->json(['message' => 'You cannot reject your own leave request.'], 403);
        }

        // Track which stage the rejection occurred at
        $stage = match ($leave->status) {
            'pending' => 'manager',
            'manager_approved' => 'hr',
            default => 'unknown',
        };
        if ($leave->status === 'pending') {
            if (!$this->hasAnyRoleDB(['department_manager', 'hr_manager', 'hr_staff', 'super_admin'])) {
                return response()->json(['message' => 'Only a manager can reject at this stage.'], 403);
            }

            if (
                $this->hasAnyRoleDB(['department_manager']) &&
                !$this->hasAnyRoleDB(['hr_manager', 'hr_staff', 'super_admin']) &&
                (!$user->employee || (int) $leave->employee?->manager_id !== (int) $user->employee->id)
            ) {
                return response()->json(['message' => 'Only the employee direct manager can reject this leave request.'], 403);
            }

            $action = 'manager_rejected';
        } elseif ($leave->status === 'manager_approved') {
            if (!$this->hasAnyRoleDB(['hr_manager', 'hr_staff', 'super_admin'])) {
                return response()->json(['message' => 'Only HR can reject at this stage.'], 403);
            }

            $action = 'hr_rejected';
        } else {

            return response()->json([
                        'message' => "Cannot reject leave with status '{$leave->status}'."
                            ], 422);
        }


        $oldStatus = $leave->status;
        $leave->update([
            'status' => 'rejected',
            'rejection_reason' => $request->reason,
            'rejected_stage' => $stage,
            'approved_by' => $user->id,
        ]);
        $this->logLeaveActivity($leave, $action, "Leave request rejected at {$stage} stage.", [
            'from_status' => $oldStatus,
            'to_status' => 'rejected',
            'reason' => $request->reason,
            'stage' => $stage,
        ]);
        $this->service->updateLeaveBalance($leave, 'cancel');
        $this->service->notifyEmployee($leave, $action,$request->reason);
        return response()->json(['message' => "Leave rejected at {$stage} stage."]);
    }

    public function cancel(Request $request, $id) {
        $leave = LeaveRequest::findOrFail($id);
        if (!in_array($leave->status, ['pending', 'manager_approved', 'approved'])) {
            return response()->json(['message' => 'Cannot cancel this leave'], 422);
        }
        $oldStatus = $leave->status;
        $this->service->updateLeaveBalance($leave, 'cancel');
        $leave->update(['status' => 'cancelled']);
        $this->logLeaveActivity($leave, 'cancelled', 'Leave request cancelled.', [
            'from_status' => $oldStatus,
            'to_status' => 'cancelled',
            'reason' => $request->input('reason'),
        ]);
        $this->service->notifyEmployee($leave, 'cancelled',$request->input('reason'));
        /*
          |--------------------------------------------------------------------------
          | Notify HR
          |--------------------------------------------------------------------------
         */
        $this->service->notifyManager($leave, 'cancelled');
        return response()->json(['message' => 'Leave cancelled']);
    }

    public function balance($empId) {
        $allocations = LeaveAllocation::with('leaveType')
                ->where('employee_id', $empId)
                ->where('year', now()->year)
                ->get();
        return response()->json(['balances' => $allocations]);
    }

    public function calendar(Request $request) {
        $user = auth()->user();
        $employee = $user->employee;
        $isHRAdmin = $this->hasAnyRoleDB(['super_admin', 'hr_manager', 'hr_staff']);

        if (!$isHRAdmin && (!$employee || !$employee->department_id)) {
            return response()->json([
                'leaves' => [],
                'department' => null,
                'scope' => 'department',
            ]);
        }

        $approved = LeaveRequest::with(['employee.department', 'leaveType'])
                ->where('status', 'approved')
                ->when($request->month, fn($q) => $q->whereMonth('start_date', $request->month))
                ->when($request->year, fn($q) => $q->whereYear('start_date', $request->year))
                ->when(!$isHRAdmin, fn($q) =>
                    $q->whereHas('employee', fn($eq) => $eq->where('department_id', $employee->department_id))
                )
                ->when($isHRAdmin && $request->department_id, fn($q) =>
                    $q->whereHas('employee', fn($eq) => $eq->where('department_id', $request->department_id))
                )
                ->orderBy('start_date')
                ->get();

        return response()->json([
            'leaves' => $approved,
            'department' => $employee?->department,
            'scope' => $isHRAdmin && !$request->department_id ? 'all' : 'department',
        ]);
    }

    public function update(Request $request, $id) {
        $leave = LeaveRequest::findOrFail($id);
        if ($leave->status !== 'pending')
            return response()->json(['message' => 'Cannot edit non-pending leave'], 422);
        $leave->update($request->only(['start_date', 'end_date', 'reason']));
        $this->logLeaveActivity($leave, 'updated', 'Leave request details updated.', [
            'to_status' => $leave->status,
            'notes' => $request->input('reason'),
        ]);
        return response()->json(['message' => 'Leave updated', 'request' => $leave]);
    }

    public function runAccrual() {
        try {
            Artisan::call('leave:accrue');
            $output = Artisan::output();
            return response()->json([
                        'message' => 'Leave accrual completed successfully.',
                        'output' => $output,
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Accrual failed: ' . $e->getMessage()], 500);
        }
    }

    public function stats() {
        $user = auth()->user();
        $userRoles = rescue(fn() => $this->userRoles(), [], false);
        $isAdmin = (bool) array_intersect($userRoles, ['super_admin', 'hr_manager', 'hr_staff']);
        $isMgr = in_array('department_manager', $userRoles);
        $today = now()->toDateString();

        $baseQ = $this->leaveRequestScope($user, $isAdmin, $isMgr);
        $needsActionCount = $this->actionableLeaveRequestScope($user, $isAdmin, $isMgr)->count();
        $awaitingManagerCount = (clone $baseQ)->where('status', 'pending')->count();
        $awaitingHrCount = (clone $baseQ)->where('status', 'manager_approved')->count();
        $pendingCount = $awaitingManagerCount + $awaitingHrCount;
        $approvedCount = (clone $baseQ)->where('status', 'approved')->count();
        $rejectedCount = (clone $baseQ)->where('status', 'rejected')->count();

        $approvedMonth = (clone $baseQ)->where('status', 'approved')
                        ->whereMonth('start_date', now()->month)->whereYear('start_date', now()->year)->count();
        $onLeaveToday = (clone $baseQ)->where('status', 'approved')
                        ->where('start_date', '<=', $today)->where('end_date', '>=', $today)->count();
        $cancelledCount = (clone $baseQ)->where('status', 'cancelled')->count();

        return response()->json([
                    'pending_count' => $pendingCount,
                    'needs_action_count' => $needsActionCount,
                    'awaiting_manager_count' => $awaitingManagerCount,
                    'awaiting_hr_count' => $awaitingHrCount,
                    'approved_count' => $approvedCount,
                    'rejected_count' => $rejectedCount,
                    'approved_month' => $approvedMonth,
                    'on_leave_today' => $onLeaveToday,
                    'cancelled_count' => $cancelledCount,
        ]);
    }

    public function allBalances(Request $request) {
        $year = $request->year ?? now()->year;
        $allocations = LeaveAllocation::with(['employee.department', 'leaveType'])
                ->where('year', $year)
                ->when($request->department_id, fn($q) =>
                        $q->whereHas('employee', fn($eq) => $eq->where('department_id', $request->department_id))
                )
                ->when($request->search, fn($q) =>
                        $q->whereHas('employee', fn($eq) =>
                                $eq->where('first_name', 'like', "%{$request->search}%")
                                ->orWhere('last_name', 'like', "%{$request->search}%")
                        )
                )
                ->orderBy('employee_id')
                ->paginate(25);
        return response()->json($allocations);
    }

    public function holidays(Request $request) {
        $year = $request->year ?? now()->year;
        $holidays = \App\Models\Holiday::whereYear('date', $year)
                        ->orderBy('date')->get();
        return response()->json(['holidays' => $holidays]);
    }

    public function storeHoliday(Request $request) {
        $request->validate([
            'name' => 'required|string|max:100',
            'date' => 'required|date',
        ]);
        $holiday = \App\Models\Holiday::create($request->only(['name', 'date', 'is_recurring']));
        return response()->json(['holiday' => $holiday], 201);
    }

    public function deleteHoliday($id) {
        \App\Models\Holiday::findOrFail($id)->delete();
        return response()->json(['message' => 'Holiday deleted']);
    }

    public function excuseUsage(Request $request) {
        $user = auth()->user();
        $empId = $request->employee_id ?? $user->employee?->id;
        $year = $request->year ?? now()->year;
        $month = $request->month ?? now()->month;
        $leaveTypeId = $request->leave_type_id ? (int) $request->leave_type_id : null;

        if (!$empId)
            return response()->json(['message' => 'Employee not found'], 404);

        return response()->json($this->service->monthlyExcuseUsage($empId, $year, $month, $leaveTypeId));
    }

    
}
