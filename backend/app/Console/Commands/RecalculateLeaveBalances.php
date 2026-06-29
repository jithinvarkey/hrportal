<?php

namespace App\Console\Commands;

use App\Models\LeaveAllocation;
use App\Models\LeaveRequest;
use App\Models\LeaveType;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

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
        $createdAllocations = $this->ensureMissingAllocations($dryRun, $employeeFilter);

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
            [$yearStart, $yearEnd] = $this->allocationPeriod($allocation);

            $base = LeaveRequest::query()
                ->where('employee_id', $allocation->employee_id)
                ->where('leave_type_id', $allocation->leave_type_id)
                ->whereDate('start_date', '<=', $yearEnd->toDateString())
                ->whereDate('end_date', '>=', $yearStart->toDateString());

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
            '%s %d missing leave allocations. %s %d leave allocation balances.',
            $dryRun ? '[DRY RUN] Would create' : 'Created',
            $createdAllocations,
            $dryRun ? '[DRY RUN] Would update' : 'Updated',
            $updated
        ));

        return self::SUCCESS;
    }

    private function ensureMissingAllocations(bool $dryRun, ?string $employeeFilter): int
    {
        $requests = LeaveRequest::query()
            ->with(['employee', 'leaveType'])
            ->whereIn('status', ['approved', 'pending', 'manager_approved'])
            ->when($employeeFilter, function ($query, $value) {
                $query->whereHas('employee', function ($employeeQuery) use ($value) {
                    $employeeQuery->where('id', $value)->orWhere('employee_code', $value);
                });
            })
            ->orderBy('employee_id')
            ->orderBy('leave_type_id')
            ->orderBy('start_date')
            ->get();

        $seen = [];
        $created = 0;

        foreach ($requests as $request) {
            if (!$request->employee || !$request->leaveType || !$request->start_date) {
                continue;
            }

            $startDate = Carbon::parse($request->start_date)->startOfDay();
            $periodStart = $this->periodStartForRequest($request->leaveType, $request->employee, $startDate);
            $year = (int) $periodStart->year;
            $key = $request->employee_id . ':' . $request->leave_type_id . ':' . $year;

            if (isset($seen[$key])) {
                continue;
            }
            $seen[$key] = true;

            $exists = LeaveAllocation::where([
                'employee_id' => $request->employee_id,
                'leave_type_id' => $request->leave_type_id,
                'year' => $year,
            ])->exists();

            if ($exists) {
                continue;
            }

            $created++;

            if ($dryRun) {
                continue;
            }

            LeaveAllocation::create([
                'employee_id' => $request->employee_id,
                'leave_type_id' => $request->leave_type_id,
                'year' => $year,
                'allocated_days' => $this->allocatedDaysFor($request->leaveType, $request->employee, $periodStart),
                'used_days' => 0,
                'pending_days' => 0,
                'remaining_days' => 0,
                'carried_forward_days' => 0,
                'used_hours' => 0,
                'pending_hours' => 0,
                'annual_entitlement' => $this->allocatedDaysFor($request->leaveType, $request->employee, $periodStart),
                'accrual_year_start' => $this->isAnnualLeave($request->leaveType) ? $periodStart->toDateString() : null,
                'last_accrual_date' => now('Asia/Riyadh')->toDateString(),
            ]);
        }

        return $created;
    }

    private function allocationPeriod(LeaveAllocation $allocation): array
    {
        if ($allocation->accrual_year_start) {
            $start = Carbon::parse($allocation->accrual_year_start)->startOfDay();
            return [$start, $start->copy()->addYear()->subDay()->endOfDay()];
        }

        $start = Carbon::create((int) $allocation->year, 1, 1)->startOfDay();
        return [$start, $start->copy()->endOfYear()];
    }

    private function periodStartForRequest(LeaveType $leaveType, $employee, Carbon $requestStart): Carbon
    {
        if (!$this->isAnnualLeave($leaveType) || !$employee->hire_date) {
            return Carbon::create((int) $requestStart->year, 1, 1)->startOfDay();
        }

        $hireDate = Carbon::parse($employee->hire_date)->startOfDay();
        $periodStart = Carbon::create((int) $requestStart->year, (int) $hireDate->month, (int) $hireDate->day)->startOfDay();

        if ($periodStart->gt($requestStart)) {
            $periodStart->subYear();
        }

        return $periodStart;
    }

    private function allocatedDaysFor(LeaveType $leaveType, $employee, Carbon $periodStart): float
    {
        if (!$this->isAnnualLeave($leaveType) || !$employee->hire_date) {
            return (float) ($leaveType->days_allowed ?? 0);
        }

        $hireDate = Carbon::parse($employee->hire_date)->startOfDay();
        $contractYearsCompleted = max(0, $hireDate->diffInYears($periodStart));

        return $contractYearsCompleted >= 5 ? 30.0 : 22.0;
    }

    private function isAnnualLeave(LeaveType $leaveType): bool
    {
        return (bool) $leaveType->is_annual
            || strtoupper((string) $leaveType->code) === 'AL'
            || str_contains(strtolower((string) $leaveType->name), 'annual');
    }
}
