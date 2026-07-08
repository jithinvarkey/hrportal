<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Services\LegacyMigrationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LegacyMigrationController extends Controller
{
    public function __construct(private LegacyMigrationService $service)
    {
    }

    public function import(Request $request): JsonResponse
    {
        $this->allowLongRunningImport();

        if (!$this->canMigrate()) {
            return response()->json(['message' => 'Only Super Admin or HR Manager can run legacy data migration.'], 403);
        }

        $data = $request->validate([
            'file' => 'required|file|mimes:csv,txt,xlsx|max:20480',
            'scope' => 'nullable|in:all,departments,job_positions,employees,employee_managers,leave_records,loan_records',
            'dry_run' => 'nullable|boolean',
        ]);

        $summary = $this->service->migrate(
            $request->file('file'),
            $data['scope'] ?? 'all',
            $request->boolean('dry_run')
        );

        return response()->json([
            'message' => $request->boolean('dry_run') ? 'Migration file validated.' : 'Migration completed.',
            'summary' => $summary,
        ]);
    }

    private function allowLongRunningImport(): void
    {
        @ini_set('max_execution_time', '0');
        @ini_set('memory_limit', '1024M');
        @set_time_limit(0);
        ignore_user_abort(true);
    }

    private function canMigrate(): bool
    {
        return DB::table('model_has_roles')
            ->join('roles', 'roles.id', '=', 'model_has_roles.role_id')
            ->where('model_has_roles.model_id', auth()->id())
            ->where('model_has_roles.model_type', get_class(auth()->user()))
            ->whereIn('roles.name', ['super_admin', 'hr_manager'])
            ->exists();
    }
}
