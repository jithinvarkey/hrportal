<?php

namespace App\Console\Commands;

use App\Models\LeaveAllocation;
use App\Models\LeaveRequest;
use Carbon\Carbon;
use Illuminate\Console\Command;

class RecalculateLeaveBalances extends Command
{
    protected $signature = 'leave:recalculate-balances
        {--dry-run : Preview changes without saving}
        {--employee= : Limit to one employee id or employee_code}';

    protected $description = 'Recalculate leave allocation used/pending/remaining values from leave request approval statuses';

    public function handle(): int
    {
        $dryRun = (bool) $this->option('dry-run');
        $employeeFilter = $this->option('employee');

        $allocations = LeaveAllocation::query()
            ->with(['employee', 'leaveType'])
            ->when($employeeFilter, function ($query, $value) {
                $query->whereHas('employee', function ($employeeQuery) use ($value) {
                    $employeeQuery->where('id', $value)->orWhere('employee_code', $value);
                });
            })
            ->orderBy('employee_id')
            ->orderBy('year')
            ->get();

        $updated = 0;
        $rows = [];

        foreach ($allocations as $allocation) {
            $yearStart = Carbon::create((int) $allocation->year, 1, 1)->startOfDay();
            $yearEnd = $yearStart->copy()->endOfYear();

            $base = LeaveRequest::query()
                ->where('employee_id', $allocation->employee_id)
                ->where('leave_type_id', $allocation->leave_type_id)
                ->whereBetween('start_date', [$yearStart->toDateString(), $yearEnd->toDateString()]);

            $usedDays = (float) (clone $base)->where('status', 'approved')->sum('total_days');
            $pendingDays = (float) (clone $base)->whereIn('status', ['pending', 'manager_approved'])->sum('total_days');
            $usedHours = (float) (clone $base)->where('status', 'approved')->sum('total_hours');
            $pendingHours = (float) (clone $base)->whereIn('status', ['pending', 'manager_approved'])->sum('total_hours');

            $available = (float) $allocation->allocated_days + (float) ($allocation->carried_forward_days ?? 0);
            $remaining = max(0, round($available - $usedDays - $pendingDays, 2));

            $changed = round((float) $allocation->used_days, 2) !== round($usedDays, 2)
                || round((float) $allocation->pending_days, 2) !== round($pendingDays, 2)
                || round((float) $allocation->remaining_days, 2) !== round($remaining, 2)
                || round((float) ($allocation->used_hours ?? 0), 2) !== round($usedHours, 2)
                || round((float) ($allocation->pending_hours ?? 0), 2) !== round($pendingHours, 2);

            if (!$changed) {
                continue;
            }

            $updated++;
            $rows[] = [
                $allocation->employee?->employee_code,
                $allocation->leaveType?->name,
                $allocation->year,
                (float) $allocation->used_days . ' -> ' . $usedDays,
                (float) $allocation->pending_days . ' -> ' . $pendingDays,
                (float) $allocation->remaining_days . ' -> ' . $remaining,
            ];

            if (!$dryRun) {
                $allocation->update([
                    'used_days' => $usedDays,
                    'pending_days' => $pendingDays,
                    'remaining_days' => $remaining,
                    'used_hours' => $usedHours,
                    'pending_hours' => $pendingHours,
                ]);
            }
        }

        $this->table(
            ['Employee', 'Leave Type', 'Year', 'Used Days', 'Pending Days', 'Remaining Days'],
            array_slice($rows, 0, 30)
        );

        if (count($rows) > 30) {
            $this->line('Showing first 30 changed rows only.');
        }

        $this->info(sprintf(
            '%s %d leave allocation balances.',
            $dryRun ? '[DRY RUN] Would update' : 'Updated',
            $updated
        ));

        return self::SUCCESS;
    }
}
