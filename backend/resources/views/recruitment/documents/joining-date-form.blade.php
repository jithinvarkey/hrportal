<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
  body { font-family: DejaVu Sans, Arial, sans-serif; font-size:12px; color:#111827; }
  h1 { text-align:center; font-size:18px; text-transform:uppercase; }
  table { width:100%; border-collapse:collapse; margin-top:20px; }
  td, th { border:1px solid #d1d5db; padding:9px; text-align:left; }
  th { background:#f3f4f6; width:35%; }
  .signature { width:150px; }
  .seal { width:170px; float:right; opacity:.9; }
</style>
</head>
<body>
  <h1>Joining Date Form</h1>
  <table>
    <tr><th>Employee Code</th><td>{{ $employee_code ?? '-' }}</td></tr>
    <tr><th>Employee Name</th><td>{{ $name }}</td></tr>
    <tr><th>Position</th><td>{{ $position ?: '-' }}</td></tr>
    <tr><th>Department</th><td>{{ $department ?: '-' }}</td></tr>
    <tr><th>Email</th><td>{{ $email ?: '-' }}</td></tr>
    <tr><th>Phone</th><td>{{ $phone ?: '-' }}</td></tr>
    <tr><th>Joining Date</th><td>{{ $joining_date ?: '-' }}</td></tr>
    <tr><th>Basic Salary</th><td>{{ number_format($basic_salary, 2) }} SAR</td></tr>
    <tr><th>Gross Salary</th><td>{{ number_format($gross_salary, 2) }} SAR</td></tr>
  </table>
  <table style="margin-top:40px"><tr>
    <td>Employee Signature<br><br>______________________</td>
    <td>HR Confirmation<br><br>______________________</td>
  </tr></table>
  <div style="margin-top:28px">
    @if($signature)<img class="signature" src="{{ $signature }}" alt="Signature">@endif
    @if($seal)<img class="seal" src="{{ $seal }}" alt="Company Seal">@endif
  </div>
</body>
</html>
