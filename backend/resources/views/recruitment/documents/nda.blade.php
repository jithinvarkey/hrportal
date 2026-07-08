<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<style>
  body { font-family: DejaVu Sans, Arial, sans-serif; font-size: 12px; color:#111827; line-height:1.55; }
  h1 { text-align:center; font-size:18px; text-transform:uppercase; margin-bottom:20px; }
  .box { border:1px solid #d1d5db; padding:10px; margin:12px 0; }
  .signature { width:150px; }
  .seal { width:170px; float:right; opacity:.9; }
</style>
</head>
<body>
  <h1>Non-Disclosure Agreement</h1>
  <p>This Non-Disclosure Agreement is entered into on <strong>{{ $date }}</strong> between Diamond Insurance Broker and <strong>{{ $name }}</strong>, appointed/proposed for the position of <strong>{{ $position ?: 'Employee' }}</strong>.</p>
  <div class="box">
    <p>The employee agrees to keep all company, customer, financial, operational, technical, and business information confidential during and after employment.</p>
    <p>The employee shall not disclose, copy, misuse, transfer, or publish confidential information except as required for assigned duties and approved by the company.</p>
    <p>All documents, systems, files, and company property remain the property of Diamond Insurance Broker and must be returned upon request or separation.</p>
  </div>
  <p>This agreement is effective from the joining date <strong>{{ $joining_date ?: 'to be confirmed' }}</strong> and remains binding after the end of employment.</p>
  <table width="100%" style="margin-top:44px"><tr>
    <td width="50%">
      <strong>Employee Name:</strong> {{ $name }}<br>
      <strong>Signature:</strong> ______________________<br>
      <strong>Date:</strong> ______________________
    </td>
    <td width="50%">
      @if($signature)<img class="signature" src="{{ $signature }}" alt="Signature"><br>@endif
      <strong>For Diamond Insurance Broker</strong><br>
      @if($seal)<img class="seal" src="{{ $seal }}" alt="Company Seal">@endif
    </td>
  </tr></table>
</body>
</html>
