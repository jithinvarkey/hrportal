<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Separation;
use App\Models\OffboardingTemplate;
use App\Models\OffboardingItem;
use App\Models\Employee;
use App\Services\SeparationService;
use Illuminate\Http\Request;
use Carbon\Carbon;

class SeparationController extends Controller
{
    public function __construct(protected SeparationService $service) {}

    // ── Stats ──────────────────────────────────────────────────────────────
    public function stats()
    {
        $base = $this->scopedQuery();

        return response()->json([
            'pending_manager'  => (clone $base)->where('status','pending_manager')->count(),
            'pending_hr'       => (clone $base)->where('status','pending_hr')->count(),
            'offboarding'      => (clone $base)->where('status','offboarding')->count(),
            'completed_ytd'    => (clone $base)->where('status','completed')->whereYear('updated_at',now()->year)->count(),
            'by_type'          => (clone $base)->selectRaw('type, count(*) as total')->groupBy('type')->pluck('total','type'),
        ]);
    }

    // ── List ───────────────────────────────────────────────────────────────
    public function index(Request $request)
    {
        $query = $this->scopedQuery()
            ->with(['employee.department','employee.designation','initiatedBy'])
            ->when($request->status, function ($q) use ($request) {
                $statuses = array_filter(explode(',', (string) $request->status));
                return count($statuses) > 1 ? $q->whereIn('status', $statuses) : $q->where('status', $request->status);
            })
            ->when($request->type,     fn($q) => $q->where('type',   $request->type))
            ->when($request->search,   fn($q) =>
                $q->whereHas('employee', fn($eq) =>
                    $eq->where('first_name','like',"%{$request->search}%")
                      ->orWhere('last_name','like',"%{$request->search}%")
                      ->orWhere('employee_code','like',"%{$request->search}%")
                )
            )
            ->orderBy('created_at','desc');

        return response()->json($query->paginate(15));
    }

    // ── Show ───────────────────────────────────────────────────────────────
    public function show($id)
    {
        $sep = Separation::with([
            'employee.department','employee.designation','employee.leaveAllocations.leaveType',
            'initiatedBy','managerApprover','hrApprover','rejectedBy',
            'checklistItems.completedBy',
        ])->findOrFail($id);
        if (!$this->canViewSeparation($sep)) {
            return response()->json(['message' => 'You do not have permission to view this separation.'], 403);
        }
        return response()->json(['separation' => $sep]);
    }

    // ── Create ─────────────────────────────────────────────────────────────
    public function store(Request $request)
    {
        $request->validate([
            'employee_id'     => 'required|exists:employees,id',
            'type'            => 'required|in:resignation,termination,end_of_contract,retirement,abandonment,mutual_agreement',
            'reason'          => 'required|string|min:10',
            'last_working_day'=> 'required|date|after:today',
            'reason_category' => 'nullable|in:personal,better_opportunity,relocation,health,misconduct,performance,restructuring,contract_end,other',
            'notice_waived'   => 'boolean',
        ]);

        $user = auth()->user();
        $isHR = $this->canCreateAnySeparation($user);
        $employeeId = $isHR ? (int) $request->employee_id : (int) $user->employee?->id;

        if (!$employeeId) {
            return response()->json(['message' => 'Your user is not linked to an employee record.'], 422);
        }

        if (!$isHR && $request->type !== 'resignation') {
            return response()->json(['message' => 'Employees can submit resignation requests only.'], 403);
        }

        $type = $isHR ? $request->type : 'resignation';
        $emp     = Employee::findOrFail($employeeId);
        $lwDay   = Carbon::parse($request->last_working_day);
        $today   = now()->startOfDay();
        $noticeDays = (int)$lwDay->diffInDays($today);

        $sep = Separation::create([
            'reference'          => $this->service->generateReference(),
            'employee_id'        => $employeeId,
            'type'               => $type,
            'status'             => in_array($type, ['termination','abandonment']) ? 'pending_hr' : 'pending_manager',
            'request_date'       => now()->toDateString(),
            'last_working_day'   => $request->last_working_day,
            'notice_period_start'=> now()->toDateString(),
            'notice_period_days' => $noticeDays,
            'notice_waived'      => $request->notice_waived ?? false,
            'notice_waived_reason'=> $request->notice_waived_reason,
            'reason'             => $request->reason,
            'reason_category'    => $request->reason_category,
            'hr_notes'           => $isHR ? $request->hr_notes : null,
            'initiated_by'       => auth()->id(),
            'exit_interview_required' => !in_array($type, ['abandonment']),
        ]);

        return response()->json(['message' => 'Separation request created.', 'separation' => $sep->load('employee')], 201);
    }

    // ── Update (HR can edit before approval) ──────────────────────────────
    public function update(Request $request, $id)
    {
        $sep = Separation::with('employee')->findOrFail($id);
        if (!$this->canViewSeparation($sep)) {
            return response()->json(['message' => 'You do not have permission to edit this separation.'], 403);
        }
        if (!in_array($sep->status, ['draft','pending_manager','pending_hr'])) {
            return response()->json(['message' => 'Cannot edit at this stage.'], 422);
        }
        $payload = $request->only([
            'last_working_day','reason','reason_category','hr_notes',
            'notice_waived','notice_waived_reason','exit_interview_required',
        ]);
        if (!$this->canCreateAnySeparation(auth()->user())) {
            unset($payload['hr_notes'], $payload['exit_interview_required']);
        }
        $sep->update($payload);
        return response()->json(['separation' => $sep->fresh()]);
    }

    // ── Approve ────────────────────────────────────────────────────────────
    public function approve(Request $request, $id)
    {
        $sep  = Separation::with('employee')->findOrFail($id);
        $user = auth()->user();

        switch ($sep->status) {
            case 'pending_manager':
                if (!$this->canApproveManagerStage($sep, $user)) {
                    return response()->json(['message' => 'Only the employee direct manager can approve this stage.'], 403);
                }
                $sep->update([
                    'status'              => 'pending_hr',
                    'manager_approved_by' => $user->id,
                    'manager_approved_at' => now(),
                ]);
                break;

            case 'pending_hr':
                if (!$this->canApproveHrStage($user)) {
                    return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can approve this stage.'], 403);
                }
                // Calculate settlement
                $gratuity  = $this->service->calculateGratuity($sep->employee, $sep->type, $sep->last_working_day);
                $encash    = $this->service->calculateLeaveEncashment($sep->employee);
                $additions = (float)($request->other_additions ?? 0);
                $deductions= (float)($request->other_deductions ?? 0);
                $settlement= max(0, $gratuity + $encash + $additions - $deductions);

                $sep->update([
                    'status'              => 'approved',
                    'hr_approved_by'      => $user->id,
                    'hr_approved_at'      => now(),
                    'gratuity_amount'     => $gratuity,
                    'leave_encashment'    => $encash,
                    'other_additions'     => $additions,
                    'other_deductions'    => $deductions,
                    'final_settlement_amount' => $settlement,
                    'hr_notes'            => $request->hr_notes ?? $sep->hr_notes,
                ]);
                break;

            case 'approved':
                // Move to offboarding — generate checklist
                if (!$this->canManageOffboarding($user)) {
                    return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can start offboarding.'], 403);
                }
                $sep->update(['status' => 'offboarding']);
                $this->service->generateChecklist($sep);
                // Mark employee status
                $sep->employee->update(['status' => 'inactive']);
                break;

            default:
                return response()->json(['message' => 'Cannot approve at this stage.'], 422);
        }

        return response()->json(['message' => 'Approved.', 'separation' => $sep->fresh('employee')]);
    }

    // ── Reject ─────────────────────────────────────────────────────────────
    public function reject(Request $request, $id)
    {
        $request->validate(['reason' => 'required|string|min:5']);
        $sep = Separation::with('employee')->findOrFail($id);

        if (!in_array($sep->status, ['pending_manager','pending_hr'])) {
            return response()->json(['message' => 'Cannot reject at this stage.'], 422);
        }
        $user = auth()->user();
        if (
            ($sep->status === 'pending_manager' && !$this->canApproveManagerStage($sep, $user)) ||
            ($sep->status === 'pending_hr' && !$this->canApproveHrStage($user))
        ) {
            return response()->json(['message' => 'You do not have permission to reject this separation.'], 403);
        }
        $sep->update([
            'status'           => 'rejected',
            'rejected_by'      => auth()->id(),
            'rejected_at'      => now(),
            'rejection_reason' => $request->reason,
        ]);
        return response()->json(['message' => 'Separation request rejected.']);
    }

    // ── Cancel ─────────────────────────────────────────────────────────────
    public function cancel($id)
    {
        $sep = Separation::with('employee')->findOrFail($id);
        $user = auth()->user();
        $isOwn = (int) $sep->employee_id === (int) $user?->employee?->id;
        if (!$isOwn && !$this->canApproveManagerStage($sep, $user) && !$this->canApproveHrStage($user)) {
            return response()->json(['message' => 'You do not have permission to cancel this separation.'], 403);
        }
        if (!in_array($sep->status, ['draft','pending_manager','pending_hr'])) {
            return response()->json(['message' => 'Cannot cancel at this stage.'], 422);
        }
        $sep->update(['status' => 'cancelled']);
        return response()->json(['message' => 'Separation cancelled.']);
    }

    // ── Complete (after offboarding done) ──────────────────────────────────
    public function complete(Request $request, $id)
    {
        $sep = Separation::with('employee')->findOrFail($id);
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can complete offboarding.'], 403);
        }
        if ($sep->status !== 'offboarding') {
            return response()->json(['message' => 'Separation is not in offboarding stage.'], 422);
        }
        $sep->update([
            'status'                 => 'completed',
            'settlement_paid'        => $request->settlement_paid ?? false,
            'settlement_paid_date'   => $request->settlement_paid ? now()->toDateString() : null,
            'settlement_notes'       => $request->settlement_notes,
        ]);
        // Fully terminate the employee
        $sep->employee->update([
            'status'           => 'terminated',
            'termination_date' => $sep->last_working_day,
        ]);
        return response()->json(['message' => 'Separation completed. Employee marked as terminated.']);
    }

    // ── Update settlement ──────────────────────────────────────────────────
    public function updateSettlement(Request $request, $id)
    {
        $sep = Separation::findOrFail($id);
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can update settlement.'], 403);
        }
        $sep->update($request->only([
            'gratuity_amount','leave_encashment','other_additions','other_deductions',
            'final_settlement_amount','settlement_paid','settlement_paid_date','settlement_notes',
        ]));
        return response()->json(['separation' => $sep->fresh()]);
    }

    // ── Exit interview ─────────────────────────────────────────────────────
    public function updateExitInterview(Request $request, $id)
    {
        $sep = Separation::findOrFail($id);
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can record exit interviews.'], 403);
        }
        $sep->update([
            'exit_interview_done'  => true,
            'exit_interview_date'  => $request->date ?? now()->toDateString(),
            'exit_interview_notes' => $request->notes,
        ]);
        return response()->json(['message' => 'Exit interview recorded.']);
    }

    // ── Checklist item update ─────────────────────────────────────────────
    public function updateChecklistItem(Request $request, $sepId, $itemId)
    {
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can update offboarding checklist.'], 403);
        }
        $item = OffboardingItem::where('separation_id', $sepId)->findOrFail($itemId);
        $item->update([
            'status'       => $request->status,
            'notes'        => $request->notes,
            'completed_by' => in_array($request->status, ['completed']) ? auth()->id() : null,
            'completed_at' => in_array($request->status, ['completed']) ? now() : null,
        ]);
        return response()->json(['item' => $item->fresh()]);
    }

    // ── Offboarding Templates CRUD ─────────────────────────────────────────
    public function templates()
    {
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can manage checklist templates.'], 403);
        }
        return response()->json(['templates' => OffboardingTemplate::orderBy('category')->orderBy('sort_order')->get()]);
    }

    public function storeTemplate(Request $request)
    {
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can manage checklist templates.'], 403);
        }
        $request->validate(['title' => 'required|string|max:150']);
        return response()->json(['template' => OffboardingTemplate::create($request->all())], 201);
    }

    public function updateTemplate(Request $request, $id)
    {
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can manage checklist templates.'], 403);
        }
        $t = OffboardingTemplate::findOrFail($id);
        $t->update($request->all());
        return response()->json(['template' => $t]);
    }

    public function deleteTemplate($id)
    {
        if (!$this->canManageOffboarding(auth()->user())) {
            return response()->json(['message' => 'Only HR Manager, Finance Manager, or CEO can manage checklist templates.'], 403);
        }
        OffboardingTemplate::findOrFail($id)->delete();
        return response()->json(['message' => 'Template deleted.']);
    }

    // ── Calculate settlement preview ───────────────────────────────────────
    public function settlementPreview(Request $request)
    {
        if (!$this->canCreateAnySeparation(auth()->user())) {
            return response()->json(['message' => 'Only HR can preview settlements while creating separation requests.'], 403);
        }
        $emp      = Employee::findOrFail($request->employee_id);
        $gratuity = $this->service->calculateGratuity($emp, $request->type, $request->last_working_day);
        $encash   = $this->service->calculateLeaveEncashment($emp);
        return response()->json([
            'gratuity_amount'  => $gratuity,
            'leave_encashment' => $encash,
            'total'            => $gratuity + $encash,
            'years_of_service' => round($emp->hire_date ? now()->floatDiffInYears($emp->hire_date) : 0, 1),
        ]);
    }

    private function scopedQuery()
    {
        $user = auth()->user();
        $query = Separation::query();

        if ($this->canViewAllSeparations($user)) {
            return $query;
        }

        if ($user?->hasRole('department_manager') && $user->employee) {
            return $query->where(function ($q) use ($user) {
                $q->where('employee_id', $user->employee->id)
                    ->orWhereHas('employee', fn($employee) => $employee->where('manager_id', $user->employee->id));
            });
        }

        return $query->where('employee_id', $user?->employee?->id ?: 0);
    }

    private function canViewSeparation(Separation $sep): bool
    {
        $user = auth()->user();
        if ($this->canViewAllSeparations($user)) return true;
        if ((int) $sep->employee_id === (int) $user?->employee?->id) return true;
        return $user?->hasRole('department_manager')
            && (int) $sep->employee?->manager_id === (int) $user?->employee?->id;
    }

    private function canViewAllSeparations($user): bool
    {
        return $user?->hasAnyRole(['super_admin', 'ceo', 'hr_manager', 'hr_staff', 'finance_manager']);
    }

    private function canCreateAnySeparation($user): bool
    {
        return $user?->hasAnyRole(['super_admin', 'ceo', 'hr_manager', 'hr_staff']);
    }

    private function canApproveManagerStage(Separation $sep, $user): bool
    {
        if ($user?->hasAnyRole(['super_admin', 'ceo'])) return true;
        return $user?->hasRole('department_manager')
            && (int) $sep->employee?->manager_id === (int) $user?->employee?->id;
    }

    private function canApproveHrStage($user): bool
    {
        return $user?->hasAnyRole(['super_admin', 'ceo', 'hr_manager', 'finance_manager']);
    }

    private function canManageOffboarding($user): bool
    {
        return $user?->hasAnyRole(['super_admin', 'ceo', 'hr_manager', 'finance_manager']);
    }
}
