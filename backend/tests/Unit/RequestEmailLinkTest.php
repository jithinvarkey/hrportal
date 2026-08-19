<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Mail\AnnualLeaveContractExpiryMail;
use App\Mail\LeaveStatusMail;
use App\Mail\LoanApprovedMail;
use App\Mail\LoanRejectedMail;
use App\Mail\LoanRequestSubmittedMail;
use App\Mail\MonthlyLeaveReminderMail;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\LeaveType;
use App\Models\Loan;
use App\Models\LoanType;
use Tests\TestCase;

class RequestEmailLinkTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        config()->set('app.frontend_url', 'https://hr.example.test');
    }

    public function test_leave_request_email_links_to_exact_request(): void
    {
        $leave = new LeaveRequest([
            'start_date' => '2026-08-12',
            'end_date' => '2026-08-13',
            'total_days' => 2,
            'status' => 'pending',
        ]);
        $leave->id = 55;
        $leave->setRelation('employee', new Employee(['first_name' => 'Amal', 'last_name' => 'Test']));
        $leave->setRelation('leaveType', new LeaveType(['name' => 'Annual Leave']));

        $mail = new LeaveStatusMail($leave, 'submitted', 'Manager');

        $this->assertSame('https://hr.example.test/leave?request_id=55', $mail->requestUrl);
        $this->assertStringContainsString('View Leave Request', $mail->render());
    }

    /** @dataProvider hourlyExcuseProvider */
    public function test_hourly_excuse_email_displays_hours_and_time_range(string $name, string $code): void
    {
        $leave = new LeaveRequest([
            'start_date' => '2026-08-04',
            'end_date' => '2026-08-04',
            'start_time' => '09:30',
            'end_time' => '11:00',
            'total_days' => 0,
            'total_hours' => 1.5,
            'status' => 'pending',
        ]);
        $leave->id = 56;
        $leave->setRelation('employee', new Employee(['first_name' => 'Jithin', 'last_name' => 'Varkey']));
        $leave->setRelation('leaveType', new LeaveType([
            'name' => $name,
            'code' => $code,
            'is_hourly' => true,
        ]));

        $rendered = (new LeaveStatusMail($leave, 'submitted', 'Manager'))->render();

        $this->assertStringContainsString('1.5 hours (09:30 – 11:00)', $rendered);
        $this->assertStringNotContainsString('0.0 day(s)', $rendered);
    }

    public static function hourlyExcuseProvider(): array
    {
        return [
            'business excuse' => ['Business Excuse', 'BE'],
            'personal excuse' => ['Personal Excuse', 'PE'],
        ];
    }

    public function test_all_loan_request_emails_link_to_exact_request(): void
    {
        $loan = new Loan([
            'reference' => 'LN-2026-0001',
            'requested_amount' => 5000,
            'status' => 'pending_hr',
        ]);
        $loan->id = 77;
        $loan->setRelation('employee', new Employee(['first_name' => 'Fahad', 'last_name' => 'Test']));
        $loan->setRelation('loanType', new LoanType(['name' => 'Personal Loan']));

        foreach ([
            new LoanRequestSubmittedMail($loan, 'HR Manager'),
            new LoanApprovedMail($loan, 'Fahad'),
            new LoanRejectedMail($loan, 'Fahad'),
        ] as $mail) {
            $this->assertSame('https://hr.example.test/loans?loan_id=77', $mail->requestUrl);
            $this->assertStringContainsString('View Loan Request', $mail->render());
        }
    }

    public function test_general_leave_emails_link_to_employee_leave_page(): void
    {
        $annualReminder = new AnnualLeaveContractExpiryMail('Fahad', '30 Sep 2026', 12, 10);
        $monthlyReminder = new MonthlyLeaveReminderMail('Leave reminder', 'Please submit your leave requests.');

        $this->assertSame('https://hr.example.test/leave/my', $annualReminder->leaveUrl);
        $this->assertSame('https://hr.example.test/leave/my', $monthlyReminder->leaveUrl);
        $this->assertStringContainsString('View Leave Balance', $annualReminder->render());
        $this->assertStringContainsString('Open Leave Requests', $monthlyReminder->render());
    }
}
