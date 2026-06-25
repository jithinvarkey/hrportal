<?php
namespace App\Services;

use App\Models\JobApplication;
use App\Models\Employee;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class RecruitmentService
{
    public function __construct() {}

    public function sendInterviewInvite($interview): void
    {
        // Mail::to($interview->application->applicant_email)->send(new InterviewInviteMail($interview));
    }

    public function generateOfferLetter(JobApplication $app, array $data): array
    {
        // PDF generation placeholder - implement view when ready
        $path = "recruitment/offers/{$app->id}_offer.pdf";
        return ['pdf_path' => $path, 'salary' => $data['offered_salary'] ?? null];
    }

    /**
     * Convert a hired applicant into a full Employee record.
     * Returns employee + temp password + onboarding tasks created.
     */
    public function hireApplicant(JobApplication $app, array $data): array
    {
        $nameParts = explode(' ', $app->applicant_name, 2);
        $firstName = $nameParts[0];
        $lastName  = $nameParts[1] ?? '-';
        $tempPassword = 'Password@123';

        // Find or create User account
        $isNewUser = false;
        $user = User::where('email', $app->applicant_email)->first();
        if ($user) {
            if (!$user->hasRole('employee')) {
                $user->assignRole('employee');
            }
        } else {
            $isNewUser = true;
            $user = User::create([
                'name'     => $app->applicant_name,
                'email'    => $app->applicant_email,
                'password' => Hash::make($tempPassword),
            ]);
            $user->assignRole('employee');
        }

        // Prevent duplicate employee records
        $existingEmployee = Employee::where('user_id', $user->id)->first();
        if ($existingEmployee) {
            return [
                'employee'         => $existingEmployee->load('department','designation'),
                'employee_code'    => $existingEmployee->employee_code,
                'temp_password'    => null,
                'is_new'           => false,
                'onboarding_tasks' => $existingEmployee->onboardingTasks()->count(),
                'login_email'      => $user->email,
            ];
        }

        $empCode = $this->generateEmployeeCode();

        $departmentId = $data['department_id'] ?? $app->jobPosting?->department_id;
        $unitId = $data['unit_id'] ?? null;

        $employee = Employee::create([
            'user_id'          => $user->id,
            'first_name'       => $firstName,
            'last_name'        => $lastName,
            'email'            => $app->applicant_email,
            'phone'            => $app->applicant_phone,
            'hire_date'        => $data['hire_date']        ?? now()->toDateString(),
            'employment_type'  => $data['employment_type']  ?? $app->jobPosting?->employment_type ?? 'full_time',
            'salary'           => $data['salary']           ?? 0,
            'department_id'    => $departmentId,
            'unit_id'          => $unitId,
            'designation_id'   => $data['designation_id']   ?? $app->jobPosting?->designation_id,
            'manager_id'       => $data['manager_id']       ?? null,
            'probation_period' => $data['probation_period'] ?? 90,
            'status'           => 'probation',
            'employee_code'    => $empCode,
        ]);

        $this->createDefaultLeaveAllocations($employee);
        $onboardingTasks = $this->createOnboardingTasks($employee, $data);

        return [
            'employee'         => $employee->load('department','designation'),
            'employee_code'    => $empCode,
            'temp_password'    => $isNewUser ? $tempPassword : null,
            'is_new'           => $isNewUser,
            'onboarding_tasks' => count($onboardingTasks),
            'login_email'      => $app->applicant_email,
        ];
    }

    /**
     * Create standard onboarding tasks for a new employee.
     * Customise the list as needed for your organisation.
     */
    private function createOnboardingTasks(Employee $employee, array $data): array
    {
        $hireDate = \Carbon\Carbon::parse($data['hire_date'] ?? now());
        $tasks = [];

        $defaultTasks = [
            ['title' => 'Provide company laptop and accessories',     'category' => 'it_setup',     'days' => 1],
            ['title' => 'Create email and system accounts',           'category' => 'it_setup',     'days' => 1],
            ['title' => 'Prepare ID badge and access card',           'category' => 'hr_documents', 'days' => 1],
            ['title' => 'Set up workstation and desk allocation',      'category' => 'it_setup',     'days' => 1],
            ['title' => 'Sign employment contract',                   'category' => 'hr_documents', 'days' => 1],
            ['title' => 'Collect required personal documents',        'category' => 'hr_documents', 'days' => 3],
            ['title' => 'Register bank and payroll details',          'category' => 'hr_documents', 'days' => 3],
            ['title' => 'Complete mandatory compliance training',     'category' => 'training',     'days' => 7],
            ['title' => 'Introduce to team and department',           'category' => 'introduction', 'days' => 1],
            ['title' => 'Set up buddy or mentor',                     'category' => 'introduction', 'days' => 3],
            ['title' => '30-day probation check-in',                  'category' => 'probation',    'days' => 30],
            ['title' => '90-day probation review',                    'category' => 'probation',    'days' => (int)($data['probation_period'] ?? 90)],
        ];

        foreach ($defaultTasks as $i => $t) {
            $task = \App\Models\OnboardingTask::create([
                'employee_id' => $employee->id,
                'title'       => $t['title'],
                'category'    => $t['category'],
                'status'      => 'pending',
                'due_date'    => $hireDate->copy()->addDays($t['days'])->toDateString(),
                'sort_order'  => $i + 1,
            ]);
            $tasks[] = $task;
        }

        // Add custom tasks from request if any
        if (!empty($data['custom_tasks'])) {
            foreach ($data['custom_tasks'] as $j => $ct) {
                $tasks[] = \App\Models\OnboardingTask::create([
                    'employee_id' => $employee->id,
                    'title'       => $ct,
                    'category'    => 'hr_documents',
                    'status'      => 'pending',
                    'sort_order'  => count($defaultTasks) + $j + 1,
                ]);
            }
        }

        return $tasks;
    }

    /** Generate next employee code e.g. EMP0042 */
    private function generateEmployeeCode(): string
    {
        $last = \App\Models\Employee::withTrashed()->orderBy('id', 'desc')->first();
        $next = $last ? intval(substr($last->employee_code, 3)) + 1 : 1;
        return 'EMP' . str_pad((string)$next, 4, '0', STR_PAD_LEFT);
    }

    /** Create annual leave allocations for all active leave types */
    private function createDefaultLeaveAllocations(\App\Models\Employee $employee): void
    {
        $year  = now()->year;
        $types = \App\Models\LeaveType::where('is_active', true)->get();
        foreach ($types as $type) {
            \App\Models\LeaveAllocation::firstOrCreate(
                ['employee_id' => $employee->id, 'leave_type_id' => $type->id, 'year' => $year],
                [
                    'allocated_days' => $type->days_allowed,
                    'used_days'      => 0,
                    'pending_days'   => 0,
                    'remaining_days' => $type->days_allowed,
                ]
            );
        }
    }
}
