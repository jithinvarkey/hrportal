<?php

declare(strict_types=1);

namespace App\Services\Communications;

use App\Mail\CommunicationPublishedMail;
use App\Models\AppNotification;
use App\Models\Employee;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

/**
 * Fans out in-app notifications to employees. Centralises audience resolution
 * so announcements and policies share one targeting implementation.
 */
class NotificationService
{
    /**
     * Resolve the set of active employee ids an announcement targets.
     *
     * @param string     $audienceType 'all' | 'departments' | 'roles'
     * @param array|null $departmentIds
     * @param array|null $roles        role names
     * @return Collection<int>
     */
    public function resolveAudience(string $audienceType, ?array $departmentIds, ?array $roles): Collection
    {
        $query = Employee::query()->where('status', 'active');

        if ($audienceType === 'departments' && !empty($departmentIds)) {
            $query->whereIn('department_id', $departmentIds);
        } elseif ($audienceType === 'roles' && !empty($roles)) {
            // Employees whose linked user holds any of the given roles.
            $userIds = DB::table('model_has_roles')
                ->join('roles', 'roles.id', '=', 'model_has_roles.role_id')
                ->whereIn('roles.name', $roles)
                ->pluck('model_has_roles.model_id');
            $query->whereIn('user_id', $userIds);
        }

        return $query->pluck('id');
    }

    /**
     * Create a notification for each employee id.
     *
     * @param Collection<int>|array $employeeIds
     */
    public function notifyMany($employeeIds, string $type, string $title, ?string $body, ?string $link, ?int $refId = null): int
    {
        $now  = now();
        $rows = collect($employeeIds)->map(fn ($id) => [
            'employee_id' => $id,
            'type'        => $type,
            'title'       => $title,
            'body'        => $body,
            'link'        => $link,
            'ref_id'      => $refId,
            'read_at'     => null,
            'created_at'  => $now,
            'updated_at'  => $now,
        ])->all();

        foreach (array_chunk($rows, 500) as $chunk) {
            AppNotification::insert($chunk);
        }

        return count($rows);
    }

    /**
     * Send email to the same employee audience used by in-app notifications.
     *
     * @param Collection<int>|array $employeeIds
     */
    public function emailMany($employeeIds, string $type, string $title, ?string $body, string $link, ?string $titleAr = null, ?string $bodyAr = null): int
    {
        $ids = collect($employeeIds)->filter()->unique()->values();
        if ($ids->isEmpty()) {
            return 0;
        }

        $employees = Employee::whereIn('id', $ids)
            ->whereNotNull('email')
            ->where('email', '<>', '')
            ->get(['id', 'first_name', 'last_name', 'email']);

        $sent = 0;
        foreach ($employees as $employee) {
            try {
                Mail::to($employee->email)->queue(new CommunicationPublishedMail(
                    $type,
                    $title,
                    $body,
                    $link,
                    trim($employee->first_name . ' ' . $employee->last_name) ?: 'Employee',
                    $titleAr,
                    $bodyAr,
                ));
                $sent++;
            } catch (\Throwable $e) {
                Log::warning('Communication email failed', [
                    'employee_id' => $employee->id,
                    'type'        => $type,
                    'title'       => $title,
                    'error'       => $e->getMessage(),
                ]);
            }
        }

        return $sent;
    }
}
