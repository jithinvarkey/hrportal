<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class AnnualLeaveContractExpiryMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public string $employeeName,
        public string $contractExpiryDate,
        public float $remainingDays,
        public float $carryForwardLimit,
    ) {
    }

    public function build(): self
    {
        return $this->subject("Annual leave balance reminder - contract expires {$this->contractExpiryDate}")
            ->view('emails.annual-leave-contract-expiry');
    }
}
