<?php

namespace App\Mail;

use App\Models\Employee;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class NewHireOnboardingLinkMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public Employee $employee,
        public string $onboardingUrl,
        public ?string $loginEmail = null,
        public ?string $tempPassword = null,
        public ?string $expiresAt = null,
    ) {
    }

    public function build(): self
    {
        return $this->subject('Complete your employee onboarding details')
            ->view('emails.new-hire-onboarding-link');
    }
}
