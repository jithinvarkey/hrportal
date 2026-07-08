<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
  @page { margin: 24px 30px 34px; }
  body {
    font-family: DejaVu Sans, Arial, sans-serif;
    font-size: 10.5px;
    color: #111;
    line-height: 1.28;
  }
  .header { text-align: left; margin: 0 0 14px 8px; }
  .logo { width: 210px; max-height: 52px; }
  .offer-table,
  .acceptance-table,
  .footer-table {
    width: 100%;
    border-collapse: collapse;
  }
  .offer-table td,
  .acceptance-table td {
    border: 0;
    padding: 4px 6px;
    vertical-align: middle;
  }
  .no-border td { border: 0; }
  .title {
    font-size: 14px;
    font-weight: bold;
    text-align: center;
  }
  .label { font-weight: bold; width: 18%; }
  .value { width: 32%; }
  .arabic {
    direction: rtl;
    text-align: right;
    font-family: DejaVu Sans, Arial, sans-serif;
  }
  .arabic-label {
    direction: rtl;
    text-align: right;
    font-weight: bold;
    width: 18%;
  }
  .center { text-align: center; }
  .section-title { font-weight: bold; text-decoration: underline; }
  .amount { white-space: nowrap; }
  .paragraph {
    min-height: 50px;
    text-align: justify;
  }
  .signature-img { width: 125px; max-height: 52px; }
  .seal-img { width: 145px; max-height: 95px; float: right; }
  .checkbox { font-family: DejaVu Sans, Arial, sans-serif; font-size: 13px; }
  .footer-note {
    font-size: 8.7px;
    line-height: 1.2;
    color: #111;
  }
</style>
</head>
<body>
@php
  $fmt = fn($amount) => number_format((float) $amount, 2);
  $positionText = $position ?: 'Employee';
  $candidateName = $name ?: 'Candidate';
  $offerDate = \Carbon\Carbon::parse(now())->format('d/m/Y');
@endphp

<div class="header">
  @if($logo)
    <img class="logo" src="{{ $logo }}" alt="Diamond Insurance Broker">
  @endif
</div>

<table class="offer-table">
  <tr>
    <td class="title" colspan="2">Job Offer</td>
    <td class="title arabic" colspan="2">عرض عمل</td>
  </tr>
  <tr>
    <td colspan="2"><strong>Date:</strong> {{ $offerDate }}</td>
    <td colspan="2" class="arabic"><strong>التاريخ:</strong> {{ $offerDate }}</td>
  </tr>
  <tr>
    <td colspan="2"><strong>Mr/Ms.</strong> {{ $candidateName }}</td>
    <td colspan="2" class="arabic"><strong>الأستاذ/ة:</strong> {{ $candidateName }}</td>
  </tr>
  <tr>
    <td colspan="2" class="paragraph">
      On behalf of the Company's management, it is our pleasure to offer you a position as
      <strong>{{ $positionText }}</strong>@if($department) in <strong>{{ $department }}</strong>@endif.
    </td>
    <td colspan="2" class="paragraph arabic">
      نيابة عن إدارة الشركة، يسرنا التقدم لكم بعرض وظيفي للعمل لدينا بوظيفة:
      <strong>{{ $positionText }}</strong>@if($department) - <strong>{{ $department }}</strong>@endif.
    </td>
  </tr>
  <tr>
    <td colspan="2" class="section-title">The employment benefits for this position:</td>
    <td colspan="2" class="section-title arabic">المزايا والبدلات الوظيفية:</td>
  </tr>

  <tr>
    <td class="label">Contract Period</td>
    <td class="value">{{ $contract_period }}</td>
    <td class="arabic value">محدد المدة</td>
    <td class="arabic-label">مدة العقد</td>
  </tr>
  <tr>
    <td class="label">Probation Period</td>
    <td class="value">{{ $probation_period }}</td>
    <td class="arabic value">3 أشهر قابلة للتجديد</td>
    <td class="arabic-label">فترة التجربة</td>
  </tr>
  <tr>
    <td class="label">Gross Salary</td>
    <td class="value amount">{{ $fmt($gross_salary) }} SAR only.</td>
    <td class="arabic value amount">{{ $fmt($gross_salary) }} ريال سعودي فقط لا غير</td>
    <td class="arabic-label">إجمالي الراتب</td>
  </tr>
  <tr>
    <td class="label">Basic Salary</td>
    <td class="value amount">{{ $fmt($basic_salary) }} SAR</td>
    <td class="arabic value amount">{{ $fmt($basic_salary) }} ريال سعودي</td>
    <td class="arabic-label">الراتب الأساسي</td>
  </tr>
  <tr>
    <td class="label">Housing Allowance</td>
    <td class="value amount">{{ $fmt($housing_allowance) }} SAR</td>
    <td class="arabic value amount">{{ $fmt($housing_allowance) }} ريال سعودي</td>
    <td class="arabic-label">بدل السكن</td>
  </tr>
  <tr>
    <td class="label">Transport Allowance</td>
    <td class="value amount">{{ $fmt($transport_allowance) }} SAR</td>
    <td class="arabic value amount">{{ $fmt($transport_allowance) }} ريال سعودي</td>
    <td class="arabic-label">بدل النقل</td>
  </tr>
  @if(($other_allowance ?? 0) > 0)
    <tr>
      <td class="label">Other Allowance</td>
      <td class="value amount">{{ $fmt($other_allowance) }} SAR</td>
      <td class="arabic value amount">{{ $fmt($other_allowance) }} ريال سعودي</td>
      <td class="arabic-label">بدلات أخرى</td>
    </tr>
  @endif
  <tr>
    <td class="label">Annual Vacation</td>
    <td class="value">{{ $annual_vacation }}</td>
    <td class="arabic value">حسب سياسة الشركة</td>
    <td class="arabic-label">الإجازة السنوية</td>
  </tr>
  <tr>
    <td class="label">City of Origin</td>
    <td class="value">{{ $city_of_origin }}</td>
    <td class="arabic value">الرياض</td>
    <td class="arabic-label">مدينة التعاقد</td>
  </tr>
  <tr>
    <td class="label">Medical Insurance</td>
    <td class="value">{{ $medical_insurance }}</td>
    <td class="arabic value">حسب سياسة الشركة</td>
    <td class="arabic-label">التأمين الطبي</td>
  </tr>

  <tr>
    <td colspan="2" class="paragraph">
      You will be eligible for all benefits offered to employees as per HR policy.
      Contracting is conditional to the necessary governmental approvals, if any.
    </td>
    <td colspan="2" class="paragraph arabic">
      وسوف تستحق جميع المنافع الأخرى التي تقدم لموظفي الشركة حسب لائحة وسياسة الموارد البشرية.
      التعاقد مشروط للموافقات الحكومية اللازمة إذا لزم الأمر.
    </td>
  </tr>
  <tr>
    <td colspan="2">We look forward to your acceptance to join our team.</td>
    <td colspan="2" class="arabic">نتطلع لقبولك العرض أعلاه، ويسعدنا انضمامك لفريق الشركة.</td>
  </tr>
  <tr>
    <td colspan="2" class="center">
      @if($signature)
        <img class="signature-img" src="{{ $signature }}" alt="Signature"><br>
      @endif
      <strong>Human Resources</strong>
    </td>
    <td colspan="2" class="center arabic">
      @if($seal)
        <img class="seal-img" src="{{ $seal }}" alt="Company Seal">
      @endif
      <strong>إدارة الموارد البشرية</strong>
    </td>
  </tr>
</table>

<table class="acceptance-table" style="margin-top: 8px;">
  <tr>
    <td style="width: 18%;"><strong>Offer Above is:</strong></td>
    <td class="center checkbox">Not Accepted غير مقبول &#9744;</td>
    <td class="center checkbox">Accepted مقبول &#9744;</td>
    <td class="arabic"><strong>العرض أعلاه:</strong></td>
  </tr>
  <tr>
    <td>If accepted, please specify the joining date:</td>
    <td class="center">/ &nbsp;&nbsp;&nbsp;&nbsp; /</td>
    <td colspan="2" class="arabic">في حال الموافقة يرجى تحديد تاريخ المباشرة:</td>
  </tr>
  <tr>
    <td>Name:</td>
    <td></td>
    <td></td>
    <td class="arabic">الاسم:</td>
  </tr>
  <tr>
    <td>Signature:</td>
    <td></td>
    <td></td>
    <td class="arabic">التوقيع:</td>
  </tr>
</table>

<table class="footer-table" style="margin-top: 8px;">
  <tr>
    <td class="footer-note">
      This offer is valid for 7 calendar days from the signature date.<br>
      Release letter from previous employer must be submitted prior to joining date.<br>
      This offer is cancelled if the candidate does not report to work by the joining date unless otherwise agreed by the company.
    </td>
    <td class="footer-note arabic">
      هذا العرض صالح لسبعة أيام من تاريخ التوقيع.<br>
      يتوجب إحضار خطاب تنازل / إخلاء طرف من قبل جهة العمل السابقة قبل المباشرة.<br>
      يعتبر هذا العرض لاغياً إذا لم يباشر الموظف العمل في التاريخ المحدد أعلاه ما لم توافق الشركة على خلاف ذلك.
    </td>
  </tr>
</table>
</body>
</html>
