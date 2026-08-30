<?php

namespace App\Listeners;

use App\Models\User;
use Illuminate\Mail\Events\MessageSending;
use Symfony\Component\Mime\Address;
use Throwable;

class SetHrManagerReplyTo
{
    /**
     * Route replies to every outgoing application email to the HR manager.
     */
    public function handle(MessageSending $event): void
    {
        try {
            $hrManager = User::query()
                ->whereNotNull('email')
                ->whereHas('roles', fn ($query) => $query->where('name', 'hr_manager'))
                ->orderBy('id')
                ->first(['id', 'name', 'email']);
        } catch (Throwable) {
            // Mail must remain available while the database is unavailable, such
            // as during initial migrations or a temporary database outage.
            return;
        }

        if (!$hrManager || !filter_var($hrManager->email, FILTER_VALIDATE_EMAIL)) {
            return;
        }

        $event->message->replyTo(new Address($hrManager->email, $hrManager->name ?: ''));
    }
}
