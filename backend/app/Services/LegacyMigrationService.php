<?php

namespace App\Services;

use App\Models\Department;
use App\Models\Designation;
use App\Models\Employee;
use App\Models\LeaveRequest;
use App\Models\LeaveType;
use App\Models\Loan;
use App\Models\LoanType;
use App\Models\Unit;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use ZipArchive;

class LegacyMigrationService
{
    private const MODULE_ORDER = ['departments', 'job_positions', 'employees', 'leave_records', 'loan_records'];
    private array $departmentAliases = [];
    private array $unitAliases = [];

    public function migrate(UploadedFile $file, string $scope = 'all', bool $dryRun = false): array
    {
        $this->departmentAliases = [];
        $this->unitAliases = [];
        $rowsByModule = $this->readFile($file, $scope);
        $summary = [];

        foreach (self::MODULE_ORDER as $module) {
            if ($scope !== 'all' && $scope !== $module) {
                continue;
            }

            $rows = $rowsByModule[$module] ?? [];
            $moduleSummary = [
                'module' => $module,
                'label' => $this->moduleLabel($module),
                'processed' => count($rows),
                'success' => 0,
                'skipped' => 0,
                'failed' => 0,
                'errors' => [],
            ];

            foreach ($rows as $index => $row) {
                $line = $row['_line'] ?? ($index + 2);
                try {
                    if ($this->rowIsEmpty($row)) {
                        $moduleSummary['skipped']++;
                        continue;
                    }

                    if ($dryRun) {
                        $this->validateRow($module, $row);
                    } else {
                        DB::transaction(fn () => $this->migrateRow($module, $row));
                    }

                    $moduleSummary['success']++;
                } catch (\Throwable $e) {
                    $moduleSummary['failed']++;
                    $moduleSummary['errors'][] = [
                        'row' => $line,
                        'message' => $e->getMessage(),
                        'data' => $this->publicRow($row),
                    ];
                    Log::warning('Legacy migration row failed.', [
                        'module' => $module,
                        'row' => $line,
                        'error' => $e->getMessage(),
                    ]);
                }
            }

            $summary[] = $moduleSummary;
        }

        return [
            'dry_run' => $dryRun,
            'file' => $file->getClientOriginalName(),
            'scope' => $scope,
            'modules' => $summary,
            'totals' => [
                'processed' => array_sum(array_column($summary, 'processed')),
                'success' => array_sum(array_column($summary, 'success')),
                'skipped' => array_sum(array_column($summary, 'skipped')),
                'failed' => array_sum(array_column($summary, 'failed')),
            ],
        ];
    }

    private function readFile(UploadedFile $file, string $scope): array
    {
        $extension = strtolower($file->getClientOriginalExtension());
        if ($extension === 'csv') {
            return $this->groupRows($this->readCsv($file->getRealPath()), $scope);
        }

        if ($extension === 'xlsx') {
            return $this->readXlsx($file->getRealPath(), $scope);
        }

        throw new \RuntimeException('Unsupported file type. Upload CSV or Excel file.');
    }

    private function readCsv(string $path): array
    {
        $handle = fopen($path, 'r');
        if (!$handle) {
            throw new \RuntimeException('Unable to read uploaded CSV file.');
        }

        $headers = null;
        $rows = [];
        $line = 0;
        while (($data = fgetcsv($handle)) !== false) {
            $line++;
            if ($headers === null) {
                $headers = array_map(fn ($h) => $this->key($h), $data);
                continue;
            }
            $row = [];
            foreach ($headers as $i => $header) {
                if ($header === '') {
                    continue;
                }
                $row[$header] = trim((string) ($data[$i] ?? ''));
            }
            $row['_line'] = $line;
            $rows[] = $row;
        }
        fclose($handle);

        return $rows;
    }

    private function readXlsx(string $path, string $scope): array
    {
        if (!class_exists(ZipArchive::class)) {
            throw new \RuntimeException('Excel import requires PHP ZipArchive. CSV upload is still supported.');
        }

        $zip = new ZipArchive();
        if ($zip->open($path) !== true) {
            throw new \RuntimeException('Unable to read uploaded Excel file.');
        }

        $sharedStrings = $this->readSharedStrings($zip);
        $sheets = $this->workbookSheets($zip);
        $rowsByModule = array_fill_keys(self::MODULE_ORDER, []);

        foreach ($sheets as $sheet) {
            $module = $this->moduleFromName($sheet['name']);
            if (!$module || ($scope !== 'all' && $scope !== $module)) {
                continue;
            }
            $rowsByModule[$module] = array_merge(
                $rowsByModule[$module],
                $this->readWorksheet($zip, $sheet['path'], $sharedStrings)
            );
        }

        $zip->close();

        return $rowsByModule;
    }

    private function readSharedStrings(ZipArchive $zip): array
    {
        $xml = $zip->getFromName('xl/sharedStrings.xml');
        if (!$xml) {
            return [];
        }
        $doc = simplexml_load_string($xml);
        $strings = [];
        foreach ($doc->si ?? [] as $si) {
            if (isset($si->t)) {
                $strings[] = (string) $si->t;
            } else {
                $text = '';
                foreach ($si->r ?? [] as $run) {
                    $text .= (string) $run->t;
                }
                $strings[] = $text;
            }
        }
        return $strings;
    }

    private function workbookSheets(ZipArchive $zip): array
    {
        $workbook = simplexml_load_string((string) $zip->getFromName('xl/workbook.xml'));
        $rels = simplexml_load_string((string) $zip->getFromName('xl/_rels/workbook.xml.rels'));
        $targets = [];
        foreach ($rels->Relationship ?? [] as $rel) {
            $targets[(string) $rel['Id']] = 'xl/' . ltrim((string) $rel['Target'], '/');
        }

        $sheets = [];
        foreach ($workbook->sheets->sheet ?? [] as $sheet) {
            $attrs = $sheet->attributes('http://schemas.openxmlformats.org/officeDocument/2006/relationships');
            $rid = (string) $attrs['id'];
            if (!empty($targets[$rid])) {
                $sheets[] = ['name' => (string) $sheet['name'], 'path' => $targets[$rid]];
            }
        }
        return $sheets;
    }

    private function readWorksheet(ZipArchive $zip, string $path, array $sharedStrings): array
    {
        $xml = $zip->getFromName($path);
        if (!$xml) {
            return [];
        }

        $sheet = simplexml_load_string($xml);
        $headers = [];
        $rows = [];
        foreach ($sheet->sheetData->row ?? [] as $rowNode) {
            $line = (int) $rowNode['r'];
            $values = [];
            foreach ($rowNode->c ?? [] as $cell) {
                $ref = (string) $cell['r'];
                $col = $this->columnIndex($ref);
                $values[$col] = $this->cellValue($cell, $sharedStrings);
            }

            if (!$headers) {
                ksort($values);
                $headers = array_map(fn ($h) => $this->key($h), array_values($values));
                continue;
            }

            $item = [];
            foreach ($headers as $i => $header) {
                if ($header === '') {
                    continue;
                }
                $item[$header] = trim((string) ($values[$i] ?? ''));
            }
            $item['_line'] = $line;
            $rows[] = $item;
        }

        return $rows;
    }

    private function cellValue(\SimpleXMLElement $cell, array $sharedStrings): string
    {
        $type = (string) $cell['t'];
        if ($type === 's') {
            return (string) ($sharedStrings[(int) $cell->v] ?? '');
        }
        if ($type === 'inlineStr') {
            return (string) ($cell->is->t ?? '');
        }
        return (string) ($cell->v ?? '');
    }

    private function columnIndex(string $ref): int
    {
        $letters = preg_replace('/[^A-Z]/', '', strtoupper($ref));
        $number = 0;
        foreach (str_split($letters) as $letter) {
            $number = ($number * 26) + (ord($letter) - 64);
        }
        return max(0, $number - 1);
    }

    private function groupRows(array $rows, string $scope): array
    {
        $rowsByModule = array_fill_keys(self::MODULE_ORDER, []);
        foreach ($rows as $row) {
            $module = $scope === 'all'
                ? $this->moduleFromName((string) ($row['module'] ?? ''))
                : $scope;
            if ($module) {
                $rowsByModule[$module][] = $row;
            }
        }
        return $rowsByModule;
    }

    private function migrateRow(string $module, array $row): void
    {
        $this->validateRow($module, $row);
        match ($module) {
            'departments' => $this->department($row),
            'job_positions' => $this->jobPosition($row),
            'employees' => $this->employee($row),
            'leave_records' => $this->leaveRecord($row),
            'loan_records' => $this->loanRecord($row),
            default => throw new \InvalidArgumentException('Unknown migration module.'),
        };
    }

    private function validateRow(string $module, array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $required = match ($module) {
            'departments' => ['name'],
            'job_positions' => ['title'],
            'employees' => ['first_name', 'last_name', 'email', 'hire_date'],
            'leave_records' => ['employee_code', 'leave_type', 'start_date', 'end_date'],
            'loan_records' => ['employee_code', 'loan_type', 'amount', 'installments'],
            default => [],
        };
        foreach ($required as $field) {
            if (($row[$field] ?? '') === '') {
                throw new \InvalidArgumentException("Missing required field: {$field}");
            }
        }
    }

    private function department(array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $name = trim($row['name']);
        $legacyCode = trim((string) ($row['code'] ?? ''));
        $unitId = trim((string) ($row['unitid'] ?? $row['unit_id'] ?? ''));
        $branch = trim((string) ($row['branch'] ?? $row['branch_name'] ?? $unitId));
        $this->findOrCreateUnit($unitId, $row['unit_name'] ?? $row['branch_name'] ?? null);
        $description = $this->departmentDescription(
            trim((string) ($row['description'] ?? '')),
            $legacyCode,
            $branch
        );

        $department = Department::whereRaw('LOWER(name) = ?', [strtolower($name)])->first();

        if (!$department) {
            $code = $legacyCode ?: Str::upper(Str::slug($name, '_'));
            $department = Department::updateOrCreate(
                ['code' => $this->uniqueDepartmentCode($code)],
                [
                    'name' => $name,
                    'description' => $description ?: null,
                    'headcount_budget' => $this->departmentHeadcountBudget($row['headcount_budget'] ?? null),
                    'is_active' => $this->bool($row['is_active'] ?? true),
                ]
            );
        } else {
            $department->update([
                'description' => $this->mergeDepartmentDescription($department->description, $description),
                'headcount_budget' => $department->headcount_budget ?? $this->departmentHeadcountBudget($row['headcount_budget'] ?? null),
                'is_active' => $department->is_active || $this->bool($row['is_active'] ?? true),
            ]);
        }

        $this->rememberDepartmentAlias($department, $legacyCode, $name);
    }

    private function jobPosition(array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $department = $this->findDepartment($row['department_code'] ?? null, $row['department'] ?? null);
        Designation::updateOrCreate(
            ['title' => $row['title'], 'department_id' => $department?->id],
            [
                'level' => ($row['level'] ?? '') ?: 'staff',
                'min_salary' => $this->nullableDecimal($row['min_salary'] ?? null),
                'max_salary' => $this->nullableDecimal($row['max_salary'] ?? null),
                'is_active' => $this->bool($row['is_active'] ?? true),
            ]
        );
    }

    private function employee(array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $email = strtolower($row['email']);
        $user = User::firstOrCreate(
            ['email' => $email],
            [
                'name' => trim($row['first_name'] . ' ' . $row['last_name']),
                'password' => Hash::make(($row['password'] ?? '') ?: 'Password@123'),
            ]
        );
        if (!$user->hasRole('employee')) {
            $user->assignRole('employee');
        }

        $department = $this->findDepartment($row['department_code'] ?? null, $row['department'] ?? null);
        $unit = $this->findOrCreateUnit($row['unitid'] ?? $row['unit_id'] ?? null, $row['unit_name'] ?? $row['branch_name'] ?? null);
        $designation = $this->findDesignation($row['job_position'] ?? $row['designation'] ?? null, $department?->id);
        $code = $row['employee_code'] ?: $this->nextEmployeeCode();

        Employee::updateOrCreate(
            ['email' => $email],
            [
                'user_id' => $user->id,
                'employee_code' => $code,
                'first_name' => $row['first_name'],
                'last_name' => $row['last_name'],
                'phone' => $row['phone'] ?? null,
                'dob' => $this->date($row['dob'] ?? null),
                'gender' => $this->enum($row['gender'] ?? null, ['male', 'female', 'other']),
                'marital_status' => $this->enum($row['marital_status'] ?? null, ['single', 'married', 'divorced', 'widowed']),
                'hire_date' => $this->date($row['hire_date']) ?: now()->toDateString(),
                'employment_type' => $this->enum($row['employment_type'] ?? null, ['full_time', 'part_time', 'contract', 'intern']) ?: 'full_time',
                'status' => $this->enum($row['status'] ?? null, ['active', 'inactive', 'terminated', 'on_leave', 'probation']) ?: 'active',
                'salary' => $this->nullableDecimal($row['salary'] ?? null) ?? 0,
                'department_id' => $department?->id,
                'unit_id' => $unit?->id,
                'designation_id' => $designation?->id,
                'address' => $row['address'] ?? null,
                'city' => $row['city'] ?? null,
                'country' => $row['country'] ?? null,
                'national_id' => $row['national_id'] ?? null,
                'bank_name' => $row['bank_name'] ?? null,
                'bank_account' => $row['bank_account'] ?? null,
                'emergency_contact_name' => $row['emergency_contact_name'] ?? null,
                'emergency_contact_phone' => $row['emergency_contact_phone'] ?? null,
            ]
        );
    }

    private function leaveRecord(array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $employee = $this->employeeByCode($row['employee_code']);
        $leaveType = LeaveType::firstOrCreate(
            ['code' => Str::upper(Str::slug($row['leave_type'], '_'))],
            ['name' => $row['leave_type'], 'days_allowed' => 0, 'is_paid' => true, 'is_active' => true]
        );

        LeaveRequest::updateOrCreate(
            [
                'employee_id' => $employee->id,
                'leave_type_id' => $leaveType->id,
                'start_date' => $this->date($row['start_date']),
                'end_date' => $this->date($row['end_date']),
            ],
            [
                'total_days' => $this->nullableDecimal($row['total_days'] ?? null) ?? 1,
                'status' => $this->enum($row['status'] ?? null, ['pending', 'approved', 'rejected', 'cancelled']) ?: 'approved',
                'reason' => ($row['reason'] ?? '') ?: 'Legacy migration',
                'approved_at' => ($row['status'] ?? 'approved') === 'approved' ? now() : null,
            ]
        );
    }

    private function loanRecord(array $row): void
    {
        $row = $this->normalizeLegacyAliases($row);
        $employee = $this->employeeByCode($row['employee_code']);
        $amount = $this->nullableDecimal($row['amount']) ?? 0;
        $installments = max(1, (int) $row['installments']);
        $loanType = LoanType::firstOrCreate(
            ['code' => Str::upper(Str::slug($row['loan_type'], '_'))],
            ['name' => $row['loan_type'], 'max_amount' => 0, 'max_installments' => max(12, $installments), 'is_active' => true]
        );

        Loan::updateOrCreate(
            ['reference' => ($row['reference'] ?? '') ?: $this->nextLoanReference()],
            [
                'employee_id' => $employee->id,
                'loan_type_id' => $loanType->id,
                'requested_amount' => $amount,
                'approved_amount' => $this->nullableDecimal($row['approved_amount'] ?? null) ?? $amount,
                'installments' => $installments,
                'monthly_installment' => round($amount / $installments, 2),
                'purpose' => ($row['purpose'] ?? '') ?: 'Legacy migration',
                'notes' => $row['notes'] ?? null,
                'status' => $this->enum($row['status'] ?? null, ['pending_manager', 'pending_hr', 'pending_finance', 'approved', 'disbursed', 'completed', 'rejected', 'cancelled']) ?: 'approved',
                'disbursed_date' => $this->date($row['disbursed_date'] ?? null),
                'first_installment_date' => $this->date($row['first_installment_date'] ?? null),
                'total_paid' => $this->nullableDecimal($row['total_paid'] ?? null) ?? 0,
                'balance_remaining' => $this->nullableDecimal($row['balance_remaining'] ?? null) ?? $amount,
            ]
        );
    }

    private function findDepartment(?string $code, ?string $name): ?Department
    {
        if (!$code && !$name) {
            return null;
        }

        $nameKey = $this->key($name);
        if ($nameKey && isset($this->departmentAliases[$nameKey])) {
            return Department::find($this->departmentAliases[$nameKey]);
        }

        if ($name) {
            $byName = Department::whereRaw('LOWER(name) = ?', [strtolower(trim($name))])->first();
            if ($byName) {
                return $byName;
            }
        }

        $codeKey = $this->key($code);
        if ($codeKey && isset($this->departmentAliases[$codeKey])) {
            return Department::find($this->departmentAliases[$codeKey]);
        }

        if ($code) {
            return Department::where('code', $code)
                ->orWhere('description', 'like', '%Legacy code: ' . $code . '%')
                ->first();
        }

        return null;
    }

    private function rememberDepartmentAlias(Department $department, ?string $legacyCode, ?string $name): void
    {
        foreach ([$legacyCode, $name, $department->code, $department->name] as $value) {
            $key = $this->key($value);
            if ($key) {
                $this->departmentAliases[$key] = $department->id;
            }
        }
    }

    private function findOrCreateUnit($unitId, ?string $name = null): ?Unit
    {
        $unitId = trim((string) $unitId);
        if ($unitId === '') {
            return null;
        }

        $key = $this->key('unitid_' . $unitId);
        if (isset($this->unitAliases[$key])) {
            return Unit::find($this->unitAliases[$key]);
        }

        $unit = Unit::where('legacy_unitid', $unitId)->first();
        if (!$unit) {
            $label = trim((string) $name) ?: ('Unit ' . $unitId);
            $unit = Unit::firstOrCreate(
                ['code' => $this->uniqueUnitCode('UNIT_' . $unitId)],
                ['name' => $label, 'legacy_unitid' => $unitId, 'is_active' => true]
            );
        }

        $this->unitAliases[$key] = $unit->id;
        return $unit;
    }

    private function uniqueUnitCode(string $code): string
    {
        $base = Str::upper(Str::slug($code ?: 'UNIT', '_'));
        if (!Unit::where('code', $base)->exists()) {
            return $base;
        }

        $i = 2;
        while (Unit::where('code', "{$base}_{$i}")->exists()) {
            $i++;
        }
        return "{$base}_{$i}";
    }

    private function uniqueDepartmentCode(string $code): string
    {
        $base = Str::upper(Str::slug($code ?: 'DEPT', '_'));
        if (!Department::where('code', $base)->exists()) {
            return $base;
        }

        $i = 2;
        while (Department::where('code', "{$base}_{$i}")->exists()) {
            $i++;
        }
        return "{$base}_{$i}";
    }

    private function departmentDescription(string $description, string $legacyCode, string $branch): ?string
    {
        $parts = [];
        if ($description) {
            $parts[] = $description;
        }
        if ($legacyCode) {
            $parts[] = 'Legacy code: ' . $legacyCode;
        }
        if ($branch) {
            $parts[] = 'Legacy unitid: ' . $branch;
        }

        return $parts ? implode("\n", array_unique($parts)) : null;
    }

    private function mergeDepartmentDescription(?string $current, ?string $incoming): ?string
    {
        $lines = [];
        foreach ([$current, $incoming] as $text) {
            foreach (preg_split('/\R/', (string) $text) as $line) {
                $line = trim($line);
                if ($line !== '') {
                    $lines[$line] = $line;
                }
            }
        }

        return $lines ? implode("\n", array_values($lines)) : null;
    }

    private function findDesignation(?string $title, ?int $departmentId): ?Designation
    {
        if (!$title) {
            return null;
        }
        return Designation::where('title', $title)
            ->when($departmentId, fn ($q) => $q->where(fn ($s) => $s->whereNull('department_id')->orWhere('department_id', $departmentId)))
            ->first();
    }

    private function employeeByCode(string $code): Employee
    {
        return Employee::where('employee_code', $code)->orWhere('email', $code)->firstOrFail();
    }

    private function nextEmployeeCode(): string
    {
        $last = Employee::withTrashed()->orderByDesc('id')->value('employee_code');
        $next = $last ? ((int) preg_replace('/\D/', '', $last) + 1) : 1;
        return 'EMP' . str_pad((string) $next, 4, '0', STR_PAD_LEFT);
    }

    private function nextLoanReference(): string
    {
        return 'LOAN-' . now()->format('Y') . '-' . str_pad((string) (Loan::count() + 1), 5, '0', STR_PAD_LEFT);
    }

    private function moduleFromName(string $name): ?string
    {
        $key = $this->key($name);
        return [
            'department' => 'departments',
            'departments' => 'departments',
            'job_position' => 'job_positions',
            'job_positions' => 'job_positions',
            'designation' => 'job_positions',
            'designations' => 'job_positions',
            'employee' => 'employees',
            'employees' => 'employees',
            'leave_record' => 'leave_records',
            'leave_records' => 'leave_records',
            'loan_record' => 'loan_records',
            'loan_records' => 'loan_records',
        ][$key] ?? null;
    }

    private function moduleLabel(string $module): string
    {
        return ucwords(str_replace('_', ' ', $module));
    }

    private function normalizeLegacyAliases(array $row): array
    {
        $aliases = [
            'deptname' => 'name',
            'deptcode' => 'code',
            'isactive' => 'is_active',
            'createddate' => 'created_at',
            'modifieddate' => 'updated_at',
            'positionname' => 'title',
            'position_name' => 'title',
            'designation' => 'job_position',
            'position' => 'job_position',
            'empcode' => 'employee_code',
            'employeecode' => 'employee_code',
            'leavetype' => 'leave_type',
            'loantype' => 'loan_type',
        ];

        foreach ($aliases as $legacy => $canonical) {
            if (($row[$canonical] ?? '') === '' && array_key_exists($legacy, $row)) {
                $row[$canonical] = $row[$legacy];
            }
        }

        return $row;
    }

    private function key(?string $value): string
    {
        return Str::of((string) $value)->trim()->lower()->replaceMatches('/[^a-z0-9]+/', '_')->trim('_')->toString();
    }

    private function rowIsEmpty(array $row): bool
    {
        foreach ($row as $key => $value) {
            if (!str_starts_with((string) $key, '_') && trim((string) $value) !== '') {
                return false;
            }
        }
        return true;
    }

    private function publicRow(array $row): array
    {
        unset($row['password']);
        return array_filter($row, fn ($key) => !str_starts_with((string) $key, '_'), ARRAY_FILTER_USE_KEY);
    }

    private function nullableInt($value): ?int
    {
        return $value === null || $value === '' ? null : (int) $value;
    }

    private function departmentHeadcountBudget($value): int
    {
        $value = is_string($value) ? trim($value) : $value;

        if ($value === null || $value === '' || strtolower((string) $value) === 'null') {
            return 5;
        }

        return max(1, (int) $value);
    }

    private function nullableDecimal($value): ?float
    {
        return $value === null || $value === '' ? null : (float) str_replace(',', '', (string) $value);
    }

    private function bool($value): bool
    {
        return in_array(strtolower((string) $value), ['1', 'true', 'yes', 'active'], true);
    }

    private function enum(?string $value, array $allowed): ?string
    {
        $value = $this->key($value);
        return in_array($value, $allowed, true) ? $value : null;
    }

    private function date($value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }
        if (is_numeric($value)) {
            return gmdate('Y-m-d', ((int) $value - 25569) * 86400);
        }
        return date('Y-m-d', strtotime((string) $value));
    }
}
