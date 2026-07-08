<?php

namespace App\Services;

use App\Mail\NewHireOnboardingLinkMail;
use App\Models\Employee;
use App\Models\EmployeeOnboardingLink;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class NewHireOnboardingService
{
    public function __construct(private RecruitmentDocumentService $documents)
    {
    }

    public function createAndEmailLink(Employee $employee, ?string $loginEmail = null, ?string $tempPassword = null): ?string
    {
        $rawToken = Str::random(64);
        $expiresAt = now()->addDays(14);

        EmployeeOnboardingLink::create([
            'employee_id' => $employee->id,
            'token_hash' => hash('sha256', $rawToken),
            'expires_at' => $expiresAt,
            'created_by' => auth()->id(),
        ]);

        $frontendUrl = (string) config('app.frontend_url', config('app.url'));

        $url = rtrim($frontendUrl, '/') . '/public/onboarding/' . $rawToken;

        try {
            $attachments = $this->documents->onboardingAttachments($employee);
            Mail::to($employee->email)->send(new NewHireOnboardingLinkMail(
                $employee,
                $url,
                $loginEmail,
                $tempPassword,
                $expiresAt->format('d M Y h:i A'),
                $attachments
            ));
        } catch (\Throwable $e) {
            Log::warning('New hire onboarding email failed.', [
                'employee_id' => $employee->id,
                'email' => $employee->email,
                'error' => $e->getMessage(),
            ]);
        }

        return $url;
    }
}
