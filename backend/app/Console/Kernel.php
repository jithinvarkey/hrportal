<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // Run every day at 00:05 AM Riyadh time
        $schedule->command('leave:accrue')
                 ->dailyAt('00:05')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/leave-accrual.log'));

        // Mark overdue requests daily (closure — no artisan command required)
        $schedule->call(function () {
            \App\Models\EmployeeRequest::whereNotIn('status', ['completed','rejected','cancelled'])
                ->where('due_date', '<', now()->toDateString())
                ->update(['is_overdue' => true]);
        })->name('mark-overdue-requests')->dailyAt('07:00')->timezone('Asia/Riyadh')->withoutOverlapping();

        // Auto-generate contract renewal requests 60 days before expiry
        $schedule->command('contracts:generate-renewals --days=60')
                 ->dailyAt('06:00')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/contract-renewals.log'));

        $schedule->command('birthday-wishes:send')
                 ->dailyAt('08:00')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/birthday-wishes.log'));

        $schedule->command('attendance:notify-missed-checkouts')
                 ->dailyAt('12:01')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/missed-checkouts.log'));

        $schedule->command('leave:notify-contract-expiry')
                 ->dailyAt('08:30')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/annual-leave-contract-expiry.log'));

        $schedule->command('leave:send-monthly-reminder')
                 ->dailyAt('16:26')
                 ->timezone('Asia/Riyadh')
                 ->withoutOverlapping()
                 ->appendOutputTo(storage_path('logs/monthly-leave-reminder.log'));
    }

    protected function commands(): void
    {
        $this->load(__DIR__ . '/Commands');
        require base_path('routes/console.php');
    }
}
