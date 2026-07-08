<?php

namespace App\Mail;

use App\Models\JobApplication;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Storage;

class RecruitmentOfferMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public JobApplication $application,
        public array $attachmentsMeta = [],
    ) {
    }

    public function build(): self
    {
        $mail = $this->subject('Job Offer - Diamond Insurance Broker')
            ->view('emails.recruitment-offer');

        foreach ($this->attachmentsMeta as $attachment) {
            $path = $attachment['path'] ?? null;
            if ($path && Storage::exists($path)) {
                $mail->attach(Storage::path($path), [
                    'as' => $attachment['name'] ?? basename($path),
                    'mime' => $attachment['mime'] ?? 'application/pdf',
                ]);
            }
        }

        return $mail;
    }
}
