<?php

namespace App\Services;

use App\Models\Employee;
use App\Models\EmployeeDocument;
use App\Models\JobApplication;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class RecruitmentDocumentService
{
    public function generateOfferPdf(JobApplication $application, array $data = []): array
    {
        $application->loadMissing(['jobPosting.department', 'jobPosting.designation']);
        $payload = $this->payloadForApplication($application, $data);
        $path = "recruitment/offers/application-{$application->id}-job-offer.pdf";

        $this->putPdf($path, 'recruitment.documents.job-offer', $payload);

        return $this->documentMeta($path, 'Job Offer.pdf');
    }

    public function generateNdaPdf(JobApplication|Employee $subject, array $data = []): array
    {
        $payload = $subject instanceof Employee
            ? $this->payloadForEmployee($subject, $data)
            : $this->payloadForApplication($subject, $data);

        $id = $subject instanceof Employee ? "employee-{$subject->id}" : "application-{$subject->id}";
        $path = "recruitment/nda/{$id}-nda.pdf";

        $this->putPdf($path, 'recruitment.documents.nda', $payload);

        return $this->documentMeta($path, 'NDA.pdf');
    }

    public function generateJoiningDateForm(Employee $employee, array $data = []): array
    {
        $employee->loadMissing(['department', 'designation']);
        $payload = $this->payloadForEmployee($employee, $data);
        $path = "employees/{$employee->id}/documents/joining-date-form.pdf";

        $this->putPdf($path, 'recruitment.documents.joining-date-form', $payload);

        return $this->documentMeta($path, 'Joining Date Form.pdf');
    }

    public function storeJoiningDateFormDocument(Employee $employee, array $data = []): EmployeeDocument
    {
        $meta = $this->generateJoiningDateForm($employee, $data);

        return $employee->documents()->updateOrCreate(
            ['title' => 'Joining Date Form'],
            [
                'type' => 'other',
                'file_path' => $meta['path'],
                'file_name' => $meta['name'],
                'mime_type' => 'application/pdf',
                'file_size' => Storage::size($meta['path']),
                'is_verified' => true,
                'uploaded_by' => auth()->id(),
                'verified_by' => auth()->id(),
                'verified_at' => now(),
            ]
        );
    }

    public function onboardingAttachments(Employee $employee, array $data = []): array
    {
        return [
            $this->generateNdaPdf($employee, $data),
        ];
    }

    private function putPdf(string $path, string $view, array $payload): void
    {
        $pdf = Pdf::loadView($view, $payload)->setPaper('a4');
        Storage::put($path, $pdf->output());
    }

    private function documentMeta(string $path, string $name): array
    {
        return [
            'path' => $path,
            'name' => $name,
            'mime' => 'application/pdf',
        ];
    }

    private function payloadForApplication(JobApplication $application, array $data = []): array
    {
        $salary = (float) ($data['basic_salary'] ?? $data['offered_salary'] ?? $data['salary'] ?? $application->expected_salary ?? 0);

        return $this->basePayload([
            'name' => $application->applicant_name,
            'email' => $application->applicant_email,
            'phone' => $application->applicant_phone,
            'position' => $application->jobPosting?->designation?->title ?: $application->jobPosting?->title ?: $application->position_applied,
            'department' => $application->jobPosting?->department?->name ?: $application->department?->name,
            'joining_date' => $data['joining_date'] ?? $data['hire_date'] ?? $application->available_from?->format('Y-m-d'),
            'salary' => $salary,
            'basic_salary' => $data['basic_salary'] ?? $salary,
            'housing_allowance' => $data['housing_allowance'] ?? null,
            'transport_allowance' => $data['transport_allowance'] ?? null,
            'other_allowance' => $data['other_allowance'] ?? null,
            'notes' => $data['notes'] ?? null,
        ]);
    }

    private function payloadForEmployee(Employee $employee, array $data = []): array
    {
        $salary = (float) ($data['basic_salary'] ?? $data['offered_salary'] ?? $data['salary'] ?? $employee->salary ?? 0);

        return $this->basePayload([
            'employee_code' => $employee->employee_code,
            'name' => $employee->full_name,
            'email' => $employee->email,
            'phone' => $employee->phone,
            'position' => $employee->designation?->title,
            'department' => $employee->department?->name,
            'joining_date' => $data['joining_date'] ?? $data['hire_date'] ?? $employee->hire_date?->format('Y-m-d'),
            'salary' => $salary,
            'basic_salary' => $data['basic_salary'] ?? $salary,
            'housing_allowance' => $data['housing_allowance'] ?? $employee->housing_allowance ?? null,
            'transport_allowance' => $data['transport_allowance'] ?? $employee->transport_allowance ?? null,
            'other_allowance' => $data['other_allowance'] ?? $employee->other_allowances ?? null,
            'notes' => $data['notes'] ?? null,
        ]);
    }

    private function basePayload(array $data): array
    {
        $basic = (float) ($data['basic_salary'] ?? $data['salary'] ?? 0);
        $housing = round((float) ($data['housing_allowance'] ?? ($basic * 0.25)), 2);
        $transport = round((float) ($data['transport_allowance'] ?? ($basic * 0.10)), 2);
        $other = round((float) ($data['other_allowance'] ?? 0), 2);

        return array_merge($data, [
            'date' => now()->format('d M Y'),
            'basic_salary' => $basic,
            'housing_allowance' => $housing,
            'transport_allowance' => $transport,
            'other_allowance' => $other,
            'gross_salary' => $basic + $housing + $transport + $other,
            'logo' => $this->assetDataUri('diamond-logo.png'),
            'seal' => $this->assetDataUri('companyseal.jpg'),
            'signature' => $this->assetDataUri('badrsign.png'),
            'contract_period' => $data['contract_period'] ?? 'Limited duration',
            'probation_period' => $data['probation_period'] ?? '3 months Renewable',
            'annual_vacation' => $data['annual_vacation'] ?? 'As per company policy',
            'city_of_origin' => $data['city_of_origin'] ?? 'Riyadh',
            'medical_insurance' => $data['medical_insurance'] ?? 'As per company policy',
            'reference' => 'HR-' . now()->format('Ymd') . '-' . Str::upper(Str::random(5)),
        ]);
    }

    private function assetDataUri(string $filename): ?string
    {
        $path = resource_path("hr-templates/assets/{$filename}");
        if (!is_file($path)) {
            return null;
        }

        $mime = str_ends_with(strtolower($filename), '.png') ? 'image/png' : 'image/jpeg';
        return "data:{$mime};base64," . base64_encode((string) file_get_contents($path));
    }
}
