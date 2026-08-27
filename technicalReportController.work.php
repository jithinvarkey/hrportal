<?php

namespace App\Http\Controllers\Report;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Auth;
use App\Http\Classes\RequestFiltter;
use App\Http\Classes\FinanceFiltter;
use Session;
use Excel;
use App\Http\Classes\Convertionratio;

class technicalReportController extends Controller {

    private $filepath;

    public function __construct() {
        $this->filepath = storage_path('app/userexport/');
    }

    /**
     *
     * @return type
     */
    public function corporatepipelineReport() {
        Session::forget('pendingtechfilter_' . Auth::user()->id);
        Session::forget('policyrenewalfilter_0_' . Auth::user()->id);
        Session::forget('policyrenewalfilter_60_' . Auth::user()->id);
        Session::forget('policyrenewalfilter_90_' . Auth::user()->id);
        Session::forget('policyrenewalfilter_120_' . Auth::user()->id);
        Session::forget('underissauncefilter_' . Auth::user()->id);
        Session::forget('pendingclientfilter_' . Auth::user()->id);
        Session::forget('postpolicyfilter_' . Auth::user()->id);

        return view('Reports/coporatepipeline');
    }

    /**
     *
     * @param Request $request
     * @return type
     */
    public function corporatepipelineFilter(Request $request) {

        //pending with tech
        $filterObj = new RequestFiltter();
        $filterObj->officeflag = Auth::user()->getOfficeFlag();
        $filteredResult = $filterObj->getTechnicalRequest($request);

        //renewal
        //$renewalDetails = $filterObj->getRenewalDetails($request);
        $renewalDetails = array();

        //under issuance
        $underissuanceResult = $filterObj->getUnderIssuanceRequest($request);

        //lost request details
        $lostissuanceResult = $filterObj->getLostIssuanceRequest($request);

        //Pending with client or sales

        $pendingClientResult = $filterObj->getPendingClientRequest($request);

        //Pending with client or sales
        //$postedPolicyResult = $filterObj->getPolicyuploadRequest($request);
        $postedPolicyResult = array();

        return view('Reports/coporatepipeline', array('pendingwithtechDetails' => $filteredResult, 'underissuanceDetails' => $underissuanceResult, 'renewalDetails' => $renewalDetails, 'lostrequestDetails' => $lostissuanceResult, 'pendingrequestDetails' => $pendingClientResult, 'postedPoliciesDetails' => $postedPolicyResult));
    }

    /**
     *
     * @param type $premiumValue
     * @return string
     */
    private function findClientSegment($premiumValue) {
        $segment = '';
        if ($premiumValue <= 500000) {
            $segment = "Small";
        } elseif ($premiumValue <= 3000000) {
            $segment = "Medium";
        } elseif ($premiumValue <= 6000000) {
            $segment = "Large";
        } elseif ($premiumValue > 6000000) {
            $segment = "Key Account";
        }
        return $segment;
    }

    /**
     * Resolve crm_main_table.assigned_by user IDs without issuing one query
     * per exported request.
     */
    private function assignedByNames($results) {
        $assignedByIds = collect($results)
                ->pluck('assigned_by')
                ->filter()
                ->unique()
                ->values()
                ->all();

        if (empty($assignedByIds)) {
            return array();
        }

        return DB::table('users')
                ->whereIn('id', $assignedByIds)
                ->pluck('name', 'id')
                ->toArray();
    }

    /**
     *
     */
    public function pipelineExport() {
        $request = array();
        $filterObj = new RequestFiltter();
        $filteredResult = $filterObj->getTechnicalRequest($request, true);
//        $renewalArray = $this->renewalReport();

        $underInsuranceArray = $this->underInsuanceReport();
        //lost request details
        $lostissuanceResult = $this->getLostIssuanceRequest($request, true);

        //Pending with client or sales

        $pendingClientResult = $this->getPendingClientRequest($request, true);

        //Pending with client or sales
        $assignedByNames = $this->assignedByNames($filteredResult);

        $requestArray[] = array('Request No', 'Client segmant', 'Type', 'BOR Type', 'Timed BOR', 'Channel', 'Salesperson', 'Assigned By', 'Product', 'Client', 'No of objects', 'Expected premium', 'Status', 'Requirement', 'Date of submission', 'Date of approach', 'Date of last action', 'Expiry date', 'Inception date', 'Current insurer', 'Do we have the renewal', 'Assigned person', 'Latest comment', 'Technical SLA (days)', 'Sales SLA (days)', 'Total SLA (days)', 'Quote count', 'Average quote amount');

        foreach ($filteredResult as $result) {

            $technicalsla = ($result->technicalsla != '' && $result->technicalsla != null) ? $result->technicalsla : 0;
            $salessla = ($result->salessla != '' && $result->salessla != null) ? $result->salessla : 0;
            $totalsla = $technicalsla + $salessla;

            $requestArray [] = array(
                'Request No' => $result->crm_request_id,
                'Client segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Type' => ($result->type == 1) ? 'New' : 'Renewal',
                'BOR Type' => $result->bor_status,
                'Timed BOR' => ($result->time_flag == 1) ? 'Yes' : 'No',
                'Channel' => $result->channel,
                'Salesperson' => $result->agent,
                'Assigned By' => isset($assignedByNames[$result->assigned_by]) ? $assignedByNames[$result->assigned_by] : '',
                'Product' => $result->lineofbusinesstitle,
                'Client' => $result->customerName,
                'No of objects' => $result->no_of_objects,
                'Expected premium' => number_format($result->expect_premium, 2),
                'Status' => $result->statusString,
                'Requirement' => '',
                'Date of submission' => ($result->technical_reporting_date != '') ? date('d-m-Y', strtotime($result->technical_reporting_date)) : '',
                'Date of approach' => ($result->date_of_technical_approach != '') ? date('d-m-Y', strtotime($result->date_of_technical_approach)) : '',
                'Date of last action' => ($result->lastUpdated != '') ? date('d-m-Y', strtotime($result->lastUpdated)) : '',
                'Expiry date' => ($result->expiryDate != '') ? date('d-m-Y', strtotime($result->expiryDate)) : '',
                'Inception date' => ($result->inceptiondate != '') ? date('d-m-Y', strtotime($result->inceptiondate)) : '',
                'Current insurer' => ($result->insurer_name != '') ? $result->insurer_name : '',
                'Do we have the renewal' => ($result->renewal_status > 0) ? 'Yes' : 'No',
                'Assigned person' => $result->assignedperson,
                'Latest comment' => $result->latestComment,
                'Technical SLA (days)' => $technicalsla,
                'Sales SLA (days)' => $salessla,
                'Total SLA (days)' => $totalsla,
                'Quote count' => $result->quoteCount,
                'Average quote amount' => $result->averageQuoteAmount
            );
        }





        $filename = 'corporate_pipelinereport' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($requestArray, $underInsuranceArray, $lostissuanceResult, $pendingClientResult) {
            //Pending with tech sheet creation area
            $excel->setTitle('Corporate pipeline report');
            $excel->sheet('Pending with tech', function ($sheet) use ($requestArray) {
                $sheet->fromArray($requestArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
            //Under issuance sheet creation area
            $excel->sheet('Under Issuance', function ($sheet) use ($underInsuranceArray) {
                $sheet->fromArray($underInsuranceArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
            //policy posted
            //Pending with client or sales
            $excel->sheet('Pending with sales & client', function ($sheet) use ($pendingClientResult) {
                $sheet->fromArray($pendingClientResult, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });

            //Lost request
            $excel->sheet('Lost', function ($sheet) use ($lostissuanceResult) {
                $sheet->fromArray($lostissuanceResult, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(5, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     * Renewal report creation array generation area
     * @return type
     */
    private function renewalReport($difference = 0) {
        $filterObj = new RequestFiltter();
        $request = array();
        //$renewalDetails = $filterObj->getRenewalDetails($request, $difference, true);

        $renewalDetails = $filterObj->getRenewalreqDetails($request, $difference, true);
        $maxSalespersonCount = DB::table('policies as p')->join('policy_salesperson as ps', 'ps.policy_id', '=', 'p.id')->select(DB::raw("count(ps.salesperson_id) as maxCount"))->groupBy('ps.policy_id')->orderBy('maxCount', 'desc')->first();

        $requestArray[] = array('Client segmant', 'Request No', 'Channel', 'Agent', 'Status', 'Lost comment', 'LOB', 'Product', 'Client', 'Notes', 'BOR', 'LR', 'Renewal', 'Active list', 'OS Balance', 'Current Policy', 'Current Insurer', 'Current Premium',  'Current commission(%)', 'Current commission amount' , 'Expiry date', 'Renewal date', 'Remaining days', 'Assigned to', 'Policy no', 'Policy type', 'Insurer', 'Inception date', 'End date', 'Issue date', 'Gross amount', 'Additional fee', 'Vat', 'Total amount', 'Commission', 'Commission amount');

        for ($i = 1; $i <= $maxSalespersonCount->maxCount; $i++) {
            array_push($requestArray[0], 'Saleperson_' . $i, 'Sale commission_' . $i, 'Commission amount_' . $i);
        }
        $loopCount = 1;
        foreach ($renewalDetails as $result) {

            $requestArray [$loopCount] = array(
                'Client segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Request No' => $result->crm_request_id,
                'Channel' => $result->channel,
                'Agent' => $result->agent,
                'Status' => $result->statusString,
                'Lost comment' => ($result->requeststataus == 10) ? $result->comments : 'NA',
                'LOB' => $result->lineofbusinesstitle,
                'Product' => $result->product_name,
                'Client' => $result->customerName,
                'Notes' => $result->information,
                'BOR' => '',
                'LR' => '',
                'Renewal' => ($result->renewal_status > 0) ? 'YES' : 'NO',
                'Active list' => ($result->datediff > 0) ? 'YES' : 'NO',
                'OS Balance' => '',
                'Current Policy' => ($result->oldpolicynumber != '') ? $result->oldpolicynumber : '',
                'Current insurer' => ($result->oldinsurer != '') ? $result->oldinsurer : '',
                'Current Premium' => ($result->oldgrossamount != '') ? number_format(round(floatval($result->oldgrossamount+$result->endorsementamount), 2), 2) : '',
                'Current commission(%)' => (!empty($result->oldcommission)) ? $result->oldcommission:'',
                'Current commission amount' => (!empty($result->oldcommission)) ? ((($result->oldgrossamount+$result->endorsementamount)/100)*$result->oldcommission):'',
                'Expiry date' => ($result->oldexpirydate != '') ? date('d-m-Y', strtotime($result->oldexpirydate)) : '',
                'Renewal date' => ($result->oldexpirydate != '') ? date('d-m-Y', strtotime('-1 day', strtotime($result->oldexpirydate))) : '',
                'Remaining days' => $result->datediff,
                'Assigned to' => $result->assignedTo,
                'Policy no' => $result->policy_number,
                'Policy type' => ($result->policy_number != '') ? $result->lobdata : '',
                'Insurer' => $result->insurer_name,
                'Inception date' => ($result->start_date != '') ? date('d-m-Y', strtotime($result->start_date)) : '',
                'End date' => ($result->end_date != '') ? date('d-m-Y', strtotime($result->end_date)) : '',
                'Issue date' => ($result->issue_date != '') ? date('d-m-Y', strtotime($result->issue_date)) : '',
                'Gross amount' => number_format(round(floatval($result->gross_amount), 2), 2),
                'Additional fee' => number_format(round(floatval($result->additional_amount), 2), 2),
                'Vat' => number_format(round(floatval($result->vat_amount), 2), 2),
                'Total amount' => number_format(round(floatval($result->gross_amount + $result->additional_amount + $result->vat_amount), 2), 2),
                'Commission' => $result->commision,
                'Commission amount' => number_format(round(floatval($result->gross_amount * ($result->commision / 100)), 2), 2),
            );
            $key = 1;
            $salepersonDetailArray = json_decode($result->salesperson, true);
            if ($result->salesperson != '' && count($salepersonDetailArray) > 0) {

                foreach ($salepersonDetailArray as $salepersons) {
                    $salescommision = ($result->gross_amount * ($result->commision / 100)) * ($salepersons['commission'] / 100);
                    $requestArray[$loopCount]['Saleperson_' . $key] = $salepersons['name'];
                    $requestArray[$loopCount]['Sale commission_' . $key] = $salepersons['commission'];
                    $requestArray[$loopCount]['Commission amount_' . $key] = number_format(round(floatval($salescommision), 2), 2);
                    $key++;
                }
            }


            $loopCount++;
        }

        return $requestArray;
    }

    /**
     * UnderIssuance report creation array generation area
     */
    private function underInsuanceReport() {
        //under issuance
        $filterObj = new RequestFiltter();
        $request = array();
        $underissuanceResult = $filterObj->getUnderIssuanceRequest($request, true);
        $assignedByNames = $this->assignedByNames($underissuanceResult);
        $requestArray[] = array('Request No', 'Client segmant', 'Type', 'BOR Type', 'Timed BOR', 'Channel', 'Salesperson', 'Assigned By', 'LOB', 'Client', 'Inception date', 'Date of last action', 'Current Premium', 'Assigned person', 'Latest comment', 'Technical SLA (days)', 'Sales SLA (days)', 'Total SLA (days)', 'Quote count', 'Average quote amount');
        foreach ($underissuanceResult as $result) {
            $technicalsla = ($result->technicalsla != '' && $result->technicalsla != null) ? $result->technicalsla : 0;
            $salessla = ($result->salessla != '' && $result->salessla != null) ? $result->salessla : 0;
            $totalsla = $technicalsla + $salessla;
            $requestArray [] = array(
                'Request No' => $result->crm_request_id,
                'Client segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Type' => ($result->type == 1) ? 'New' : 'Renewal',
                'BOR Type' => $result->bor_status,
                'Timed BOR' => ($result->time_flag == 1) ? 'Yes' : 'No',
                'Channel' => $result->channel,
                'Salesperson' => $result->agent,
                'Assigned By' => isset($assignedByNames[$result->assigned_by]) ? $assignedByNames[$result->assigned_by] : '',
                'LOB' => $result->lineofbusinesstitle,
                'Client' => $result->customerName,
                'Inception date' => ($result->inceptiondate != '') ? date('d-m-Y', strtotime($result->inceptiondate)) : '',
                'Date of last action' => ($result->lastUpdated != '') ? date('d-m-Y', strtotime($result->lastUpdated)) : '',
                'Current Premium' => ($result->selectedquote != '') ? number_format($result->selectedquote, 2) : number_format($result->expect_premium, 2),
                'Assigned person' => $result->assignedperson,
                'Latest comment' => $result->latestComment,
                'Technical SLA (days)' => $technicalsla,
                'Sales SLA (days)' => $salessla,
                'Total SLA (days)' => $totalsla,
                'Quote count' => $result->quoteCount,
                'Average quote amount' => $result->averageQuoteAmount
            );
        }
        return $requestArray;
    }

    /**
     *
     * @return type
     */
    public function productionReport() {
        Session::forget('productionfilter_' . Auth::user()->id);
        Session::forget('clientsegmantfilter_' . Auth::user()->id);
        Session::forget('endorsementsegmantfilter_' . Auth::user()->id);

        return view('Reports/production');
    }

    /**
     *
     * @param Request $request
     * @return type
     */
    public function productionFilter(Request $request) {

        //pending with tech
        $filterObj = new RequestFiltter();
        $filteredResult = $filterObj->getProductionDetails($request);
        //renewal

        $segmantDetails = $filterObj->getClientSegmantDetails($request);

        $endorsementsegmantDetails = $filterObj->getEndorsementSegmantDetails($request);

        return view('Reports/production', array('productionDetails' => $filteredResult, 'clientsegmantDetails' => $segmantDetails, 'endorsementDetails' => $endorsementsegmantDetails));
    }

    /**
     * To export the production details
     */
    public function productionExport() {

        $productionDetails = $this->productionDetails();

        $segmantArray = $this->segmantDetails();
        $endorsementsegmant = $this->endorsementDetails();
        $filename = 'production_report' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($productionDetails, $segmantArray, $endorsementsegmant) {
            //Pending with tech sheet creation area
            $excel->setTitle('Production report');
            $excel->sheet('Production', function ($sheet) use ($productionDetails) {
                $sheet->fromArray($productionDetails, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
            //Endorsement segmant

            $excel->sheet('Endorsement segmant', function ($sheet) use ($endorsementsegmant) {
                $sheet->fromArray($endorsementsegmant, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });

            //Under issuance sheet creation area
            $excel->sheet('Client segmant', function ($sheet) use ($segmantArray) {
                $sheet->fromArray($segmantArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(6, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     *
     */
    private function productionDetails() {
        $request = array();
        $filterObj = new RequestFiltter();
        $filteredResult = $filterObj->getProductionDetails($request, true);

        $requestArray[] = array('Policy Segment', 'Client Segmant', 'LOB', 'Product', 'Channel', 'Agent Name', 'Type', 'Sub Type', 'Year Of inception', 'Month of inception', 'Type of client', 'Client', 'Insurer', 'Policy #', 'Q', 'CANCELATION', 'Date of issuance', 'Date of inception', 'Date of Expiry', 'Renewals', 'Total SI /AGG', 'Number of fleet / Members', 'Premium', 'Fees', 'VAT 5%', 'Total Premium', 'Commission %', 'Commission');
        foreach ($filteredResult as $result) {

            $requestArray [] = array(
                'Policy Segment' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Client Segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'LOB' => $result->lineofbusinesstitle,
                'Product' => $result->product_name,
                'Channel' => $result->channel,
                'Agent' => $result->agent,
                'Type' => ($result->renewal_status > 0) ? 'YES' : 'NO',
                'Sub Type' => '',
                'Year Of inception' => ($result->inceptiondate != '') ? date('Y', strtotime($result->inceptiondate)) : '',
                'Month of inception' => ($result->inceptiondate != '') ? date('M', strtotime($result->inceptiondate)) : '',
                'Type of client' => $result->customer_group,
                'Client' => $result->customerName,
                'Insurer' => $result->insurer_name,
                'Policy #' => $result->policy_number,
                'Q' => 'Q1',
                'CANCELATION' => '',
                'Date of issuance' => ($result->issue_date != '') ? date('d-m-Y', strtotime($result->issue_date)) : '',
                'Date of inception' => ($result->inceptiondate != '') ? date('d-m-Y', strtotime($result->inceptiondate)) : '',
                'Date of Expiry' => ($result->expirydate != '') ? date('d-m-Y', strtotime($result->expirydate)) : '',
                'Renewals' => ($result->expirydate != '') ? date('d-m-Y', strtotime('-1 day', strtotime($result->expirydate))) : '',
                'Total SI /AGG' => floatval($result->insured_sum),
                'Number of fleet / Members' => $result->no_of_members,
                'Premium' => $result->total_premium,
                'Fees' => $result->additional_amount,
                'VAT 5%' => $result->vat_amount,
                'Total Premium' => $result->total_premium + $result->additional_amount + $result->vat_amount,
                'Commission %' => floatval($result->commision),
                'Commission' => floatval(($result->total_premium * $result->commision) / 100)
            );
        }

        return $requestArray;
    }

    /**
     *
     * @return type
     */
    private function segmantDetails() {
        $request = array();
        $filterObj = new RequestFiltter();
        $segmantDetails = $filterObj->getClientSegmantDetails($request, true);
        $requestArray[] = array('Client', 'Sum of premium', 'Segmant');
        foreach ($segmantDetails as $result) {

            $requestArray [] = array(
                'Client' => $result->customerName,
                'Sum of premium' => $result->premiumAmount,
                'Segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
            );
        }

        return $requestArray;
    }

    /**
     *
     * @return type
     */
    private function endorsementDetails() {
        $request = array();
        $filterObj = new RequestFiltter();
        $segmantDetails = $filterObj->getEndorsementSegmantDetails($request, true);

        $requestArray[] = array('Client', 'Insurer', 'Policy', 'Endorsement number', 'Endorsement type', 'Issue date', 'Date of inception', 'End date', 'Amount', 'Vat amount', 'Endorsement count');
        foreach ($segmantDetails as $result) {

            $requestArray [] = array(
                'Client' => $result->customerName,
                'Insurer' => $result->insurer_name,
                'Policy #' => $result->policy_number,
                'Endorsement number' => $result->endorsement_number,
                'Endorsement type' => $result->typeString,
                'Issue date' => ($result->issue_date != '') ? date('d-m-Y', strtotime($result->issue_date)) : '',
                'Date of inception' => ($result->endorsementStartDate != '') ? date('d-m-Y', strtotime($result->endorsementStartDate)) : '',
                'End date' => ($result->end_date != '') ? date('d-m-Y', strtotime($result->end_date)) : '',
                'Amount' => $result->amount,
                'Vat amount' => $result->vatAmount,
                'Endorsement count' => $result->endorsement_count
            );
        }

        return $requestArray;
    }

    /**
     * Display renewal details generating page
     * @return type
     */
    public function allrenewalReport() {

        Session::forget('policyrenewalfilter_0_' . Auth::user()->id);
//        Session::forget('policyrenewalfilter_60_' . Auth::user()->id);
//        Session::forget('policyrenewalfilter_90_' . Auth::user()->id);
//        Session::forget('policyrenewalfilter_120_' . Auth::user()->id);

        return view('Reports/renewalreportall');
    }

    /**
     *
     * @param Request $request
     * @return type
     */
    public function renewalFilter(Request $request) {

        $filterObj = new RequestFiltter();
        $renewalDetails60 = $filterObj->getRenewalreqDetails($request, 0);

//        $renewalDetails90 = $filterObj->getRenewalDetails($request, 90);
//
//        $renewalDetails120 = $filterObj->getRenewalDetails($request, 120);


        return view('Reports/renewalreport', array('renewalDetails60' => $renewalDetails60));
    }

    /**
     * To export renewal details
     */
    public function renewalDaysExport() {
        $request = array();
        $renewalDetails60 = $this->renewalReport(0);
//        $renewalDetails90 = $this->renewalReport(90);
//        $renewalDetails120 = $this->renewalReport(120);

        $filename = 'renewalreport' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($renewalDetails60) {
            //Pending with tech sheet creation area
            $excel->setTitle('Renewal report');
            //Renewal sheet creation area
            $excel->sheet('Renewal', function ($sheet) use ($renewalDetails60) {
                $sheet->fromArray($renewalDetails60, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {
                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });

//            $excel->sheet('Under 90', function($sheet) use ($renewalDetails90) {
//                $sheet->fromArray($renewalDetails90, null, 'A1', false, false);
//                $sheet->setPageMargin(array(
//                    0.25, 0.30, 0.25, 0.30
//                ));
//                $sheet->row(1, function($row) {
//
//                    // call cell manipulation methods
//                    $row->setBackground('#4F5467');
//                    $row->setFontColor('#ffffff');
//                    $row->setFontSize(16);
//                    $row->setFontWeight('bold');
//                });
//            });
            //Renewal sheet creation area
//            $excel->sheet('Under 120', function($sheet) use ($renewalDetails120) {
//                $sheet->fromArray($renewalDetails120, null, 'A1', false, false);
//                $sheet->setPageMargin(array(
//                    0.25, 0.30, 0.25, 0.30
//                ));
//                $sheet->row(1, function($row) {
//
//                    // call cell manipulation methods
//                    $row->setBackground('#4F5467');
//                    $row->setFontColor('#ffffff');
//                    $row->setFontSize(16);
//                    $row->setFontWeight('bold');
//                });
//            });
        })->store('xlsx', $this->filepath);

        exportLogentry(18, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     * To export renewal details
     */
    public function renewalExport() {
        $request = array();
        $filterObj = new RequestFiltter();
        $renewalArray = $this->renewalReport();

        $filename = 'renewalreport' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($renewalArray) {
            //Pending with tech sheet creation area
            $excel->setTitle('Renewal report');
            //Renewal sheet creation area
            $excel->sheet('Renewal', function ($sheet) use ($renewalArray) {
                $sheet->fromArray($renewalArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {
                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(19, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     * To display quote report generating page
     * @return type
     */
    public function quoteReport() {

        Session::forget('quotefilter_' . Auth::user()->id);

        return view('Reports/quotereport');
    }

    /**
     * To filter quote details
     * @param Request $request
     * @return type
     */
    public function quoteFilter(Request $request) {
        $filterObj = new RequestFiltter();
        $quoteDetails = $filterObj->getQuoteDetails($request);
        return view('Reports/quotereport', array('quoteDetails' => $quoteDetails));
    }

    /**
     * To export quote details of quotes
     */
    public function quoteExport() {
        $request = array();
        $filterObj = new RequestFiltter();
        $request = array();
        $quotesDetails[] = array('Client', 'LOB', 'Channel', 'AGENT', 'DATE OF SUBMISSION', 'DATE OF APPROCHMENT', 'DATE OF RECEIVING QUOTATION-REMARKS', 'DATE OF SENT TO CLIENT-SALES', 'DURATION TAKEN BY MARKET (DAYS)', 'DURATION TAKEN BY TECHNICAL (DAYS)', 'Insurer', 'COMPARISON', 'Status');
        $quoteArray = $filterObj->getQuoteDetails($request, true);

        foreach ($quoteArray as $result) {
            $quotesDetails[] = array(
                'Client' => $result->customerName,
                'LOB' => $result->lineofbusinesstitle,
                'Channel' => $result->channel,
                'AGENT' => $result->agent,
                'DATE OF SUBMISSION' => ($result->technical_reporting_date != '') ? date('d-m-Y', strtotime($result->technical_reporting_date)) : '',
                'DATE OF APPROCHMENT' => ($result->submissionDate != '') ? date('d-m-Y', strtotime($result->submissionDate)) : '',
                'DATE OF RECEIVING QUOTATION-REMARKS' => $result->additional_desc,
                'DATE OF SENT TO CLIENT-SALES' => ($result->updated_at != '') ? date('d-m-Y', strtotime($result->updated_at)) : '',
                'DURATION TAKEN BY MARKET (DAYS)' => $result->salesdaydiff,
                'DURATION TAKEN BY TECHNICAL (DAYS)' => $result->technicaldaydiff,
                'Insurer' => $result->insurer_name,
                'COMPARISON' => ($result->comparisonDoc != '') ? 'Yes' : 'No',
                'Status' => $result->qstatus,
            );
        }


        $filename = 'quotereport' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($quotesDetails) {
            //Pending with tech sheet creation area
            $excel->setTitle('Quote report');
            //Renewal sheet creation area
            $excel->sheet('Quotes', function ($sheet) use ($quotesDetails) {
                $sheet->fromArray($quotesDetails, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {
                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(8, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     *
     * @param array $request
     * @return type
     */
    public function getLostIssuanceRequest($request) {
        $filterObj = new RequestFiltter();
        $request = array();
        $underissuanceResult = $filterObj->getLostIssuanceRequest($request, true);
        $assignedByNames = $this->assignedByNames($underissuanceResult);
        $requestArray[] = array('Request No', 'Client segmant', 'Type', 'BOR Type', 'Timed BOR', 'Channel', 'Agent', 'Assigned By', 'LOB', 'Client', 'Policy number', 'Inception date', 'Expiry date', 'Date of last action', 'Current Premium', 'Tech owner', 'Lost comment', 'Latest comment', 'Technical SLA (days)', 'Sales SLA (days)', 'Total SLA (days)', 'Quote count', 'Average quote amount');
        foreach ($underissuanceResult as $result) {
            $technicalsla = ($result->technicalsla != '' && $result->technicalsla != null) ? $result->technicalsla : 0;
            $salessla = ($result->salessla != '' && $result->salessla != null) ? $result->salessla : 0;
            $totalsla = $technicalsla + $salessla;
            $requestArray [] = array(
                'Request No' => $result->crm_request_id,
                'Client segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Type' => ($result->type == 1) ? 'New' : 'Renewal',
                'BOR Type' => $result->bor_status,
                'Timed BOR' => ($result->time_flag == 1) ? 'Yes' : 'No',
                'Channel' => $result->channel,
                'Agent' => $result->agent,
                'Assigned By' => isset($assignedByNames[$result->assigned_by]) ? $assignedByNames[$result->assigned_by] : '',
                'LOB' => $result->lineofbusinesstitle,
                'Client' => $result->customerName,
                'Policy number' => ($result->policy_number != '') ? $result->policy_number : '',
                'Inception date' => ($result->inceptiondate != '') ? date('d-m-Y', strtotime($result->inceptiondate)) : '',
                'Expiry date' => ($result->expiryDate != '') ? date('d-m-Y', strtotime($result->expiryDate)) : '',
                'Date of last action' => ($result->lastUpdated != '') ? date('d-m-Y', strtotime($result->lastUpdated)) : '',
                'Current Premium' => number_format($result->premiumAmount, 2),
                'Tech owner' => $result->handler,
                'Lost comment' => $result->comments,
                'Latest comment' => $result->latestComment,
                'Technical SLA (days)' => $technicalsla,
                'Sales SLA (days)' => $salessla,
                'Total SLA (days)' => $totalsla,
                'Quote count' => $result->quoteCount,
                'Average quote amount' => $result->averageQuoteAmount
            );
        }

        return $requestArray;
    }

    /**
     * 
     * @param array $request
     * @return type
     */
    private function getPendingClientRequest($request) {
        $filterObj = new RequestFiltter();
        $request = array();
        $pendingissuanceResult = $filterObj->getPendingClientRequest($request, true);
        $assignedByNames = $this->assignedByNames($pendingissuanceResult);
        $requestArray[] = array('Request No', 'Client segmant', 'Type', 'BOR Type', 'Timed BOR', 'Channel', 'Salesperson', 'Assigned By', 'LOB', 'Client', 'No of objects', 'Expected premium', 'Status', 'Inception date', 'Date of last action', 'Current Premium', 'Assigned person', 'Latest comment', 'Technical SLA (days)', 'Sales SLA (days)', 'Total SLA (days)', 'Quote count', 'Average quote amount');
        foreach ($pendingissuanceResult as $result) {
            $technicalsla = ($result->technicalsla != '' && $result->technicalsla != null) ? $result->technicalsla : 0;
            $salessla = ($result->salessla != '' && $result->salessla != null) ? $result->salessla : 0;
            $totalsla = $technicalsla + $salessla;
            $requestArray [] = array(
                'Request No' => $result->crm_request_id,
                'Client segmant' => ($result->premiumAmount > 0) ? $this->findClientSegment($result->premiumAmount) : 'Small',
                'Type' => ($result->type == 1) ? 'New' : 'Renewal',
                'BOR Type' => $result->bor_status,
                'Timed BOR' => ($result->time_flag == 1) ? 'Yes' : 'No',
                'Channel' => $result->channel,
                'Salesperson' => $result->agent,
                'Assigned By' => isset($assignedByNames[$result->assigned_by]) ? $assignedByNames[$result->assigned_by] : '',
                'LOB' => $result->lineofbusinesstitle,
                'Client' => $result->customerName,
                'No of objects' => $result->no_of_objects,
                'Expected premium' => $result->expect_premium,
                'Status' => $result->statusString,
                'Inception date' => ($result->inceptiondate != '') ? date('d-m-Y', strtotime($result->inceptiondate)) : '',
                'Date of last action' => ($result->lastUpdated != '') ? date('d-m-Y', strtotime($result->lastUpdated)) : '',
                'Current Premium' => number_format($result->premiumAmount, 2),
                'Assigned person' => $result->assignedperson,
                'Latest comment' => $result->latestComment,
                'Technical SLA (days)' => $technicalsla,
                'Sales SLA (days)' => $salessla,
                'Total SLA (days)' => $totalsla,
                'Quote count' => $result->quoteCount,
                'Average quote amount' => $result->averageQuoteAmount
            );
        }


        return $requestArray;
    }

    public function allpolicyList() {
        Session::forget('allpolicyreport_' . Auth::user()->id);
        return view('Reports/allpolicyfilter');
    }

    /**
     * 
     * @param Request $request
     * @return type
     */
    public function policyFilter(Request $request) {

        $filterObj = new FinanceFiltter();
        $form = array();
        ini_set('memory_limit', '-1');
        ini_set('max_execution_time', 0);
        $form['inceptionStart'] = $request->get('ins_startDate');
        $form['inceptionEnd'] = $request->get('ins_endDate');

        $form['customerId'] = $request->get('customerId');

        $form['startdate'] = ($request->has('startdate')) ? $request->get('startdate') : '';
        $form['enddate'] = ($request->has('enddate')) ? $request->get('enddate') : '';

        $form['issuestartdate'] = ($request->has('ins_issueDate_start')) ? $request->get('ins_issueDate_start') : '';
        $form['issueenddate'] = ($request->has('ins_issuedate_end')) ? $request->get('ins_issuedate_end') : '';

        $form['inceptioncheck'] = ($request->has('inceptioncheck')) ? $request->get('inceptioncheck') : '';
        $form['duedatecheck'] = ($request->has('duedatecheck')) ? $request->get('duedatecheck') : '';

        $form['issuedatecheck'] = ($request->has('issuedatecheck')) ? $request->get('issuedatecheck') : '';

        if ($form['customerId'] > 0) {
            $customerDetails = DB::table('customers')->where('id', $form['customerId'])->select('name')->first();
            $form['customerName'] = $customerDetails->name;
        }

        if ($request->get('search') == '') {
            $form['customerId'] = 0;
        }

        $filteredResult = $filterObj->getPolicydetails($request, 'allpolicyreport_');

        $data = array("policyDetails" => $filteredResult, 'formData' => $form);

        return view('Reports/allpolicyfilter', $data);
    }

    /**
     * 
     */
    public function policyExport() {

        $filterObj = new FinanceFiltter();
        $request = array();
        $filteredResult = $filterObj->getPolicydetails($request, 'allpolicyreport_', true);
        $maxSalespersonCount = DB::table('policies as p')->join('policy_salesperson as ps', 'ps.policy_id', '=', 'p.id')->select(DB::raw("count(ps.salesperson_id) as maxCount"))->groupBy('ps.policy_id')->orderBy('maxCount', 'desc')->first();
        $requestArray[] = array('Policy no:', 'LOB', 'Product', 'Customer', 'Insurer', 'Inception date', 'End date', 'Issue date', 'Number of objects'   , 'Gross amount', 'Policy fees', 'Vat', 'Commission', 'Installment number', 'Diamond commmission', 'Renewal status', 'CRM Number', 'Previous policy', 'BOR Type', 'Timed BOR', 'Sales type', 'Assigned by','Account handler','Policy admin','Special condition flag' , 'Conditions' , 'Ex-gratia');
        for ($i = 1; $i <= $maxSalespersonCount->maxCount; $i++) {
            array_push($requestArray[0], 'Saleperson_' . $i, 'Sale commission_' . $i, 'Commission amount_' . $i);
        }
        ini_set('memory_limit', '-1');
        ini_set('max_execution_time', 0);
//dd($filteredResult);
        $salesPersons = DB::table('users')->distinct()->where('department', '=', 'sales')->orderBy('name')->select('id')->get();
        $salesPersonArray = [];
        foreach ($salesPersons as $person) {
            $salesPersonArray[$person->id] = $person->id;
        }
        $loopCount = 1;

        foreach ($filteredResult as $result) {
            $commission = ($result->commision > 0) ? $result->commision : 0;
            $diamondcommission = ($result->gross_amount * $result->commision) / 100;

            $requestArray [$loopCount] = array(
                'Policy no:' => $result->policy_number,
                'LOB' => $result->policyType,
                'Product' => $result->productName,
                'Customer' => $result->customerName,
                'Insurer' => $result->insurer_name,
                'Inception date' => date('d-m-Y', strtotime($result->inceptiondate)),
                'End date' => date('d-m-Y', strtotime($result->expirydate)),
                'Issue date' => date('d-m-Y', strtotime($result->policyissuedate)),
                'Number of objects' => $result->no_of_members,
                'Gross amount' => number_format(round(floatval($result->gross_amount), 2), 2),
                'Policy fees' => number_format(round(floatval($result->additional_amount), 2), 2),
                'Vat' => number_format(round(floatval($result->vat_amount), 2), 2),
                'Commission' => $result->commision,
                'Installment number' => $result->installmentcount,
                'Diamond commmission' => number_format($diamondcommission, 2),
                'Renewal status' => ($result->previous_policy_id != '') ? 'Renewal' : 'New',
                'CRM Number' => $result->crnumber,
                'Previous policy' => ($result->previous_policy_id != '') ? $result->previouspolicy : '',
                'BOR Type' => $result->bortype,
                'Timed BOR' => ($result->timedflag == 1) ? "Yes" : "No",
                'Sales type' => in_array($result->salesPersonId, $salesPersonArray) ? 'Sales' : 'Direct',
                'Assigned by' => $result->assignedby,
                'Account handler'=>$result->customerrelationofficer,
                'Policy admin' =>$result->policyadmin,
                 'Special condition flag' =>($result->special_condition_flag == 1) ? "Yes" : "No",
                 'Conditions' =>$result->special_conditions,
                 'Ex-gratia' =>number_format(round(floatval($result->ex_gratia), 2), 2)
            );
            $salepersonDetailArray = json_decode($result->salesPerson, true);

            $key = 1;
            if ($result->salesPerson != '' && count($salepersonDetailArray) > 0) {
                foreach ($salepersonDetailArray as $salepersons) {
                    $salescommission = ($diamondcommission * $salepersons['commission']) / 100;
                    $requestArray[$loopCount]['Saleperson_' . $key] = $salepersons['name'];
                    $requestArray[$loopCount]['Sale commission_' . $key] = ($salepersons['ctype'] == '0') ? $salepersons['commission'] : 'Fixed amount';
                    $requestArray[$loopCount]['Commission amount_' . $key] = number_format(round(floatval($salescommission), 2), 2);
                    $key++;
                }
            }

            $loopCount++;
        }

        $filename = 'policydetails_' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($requestArray) {
            $excel->setTitle('Policy details');
            $excel->sheet('Policies', function ($sheet) use ($requestArray) {
                $sheet->fromArray($requestArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));

                $sheet->row(1, function ($row) {
                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(7, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     * 
     * @return type
     */
    public function conversionRequest() {
        $quoteSqlObj = DB::table('crm_main_table as r')
                ->join('crm_status as cs', 'cs.sort_order', '=', 'r.status')
                ->leftJoin('crm_task_table as t', 'r.id', '=', 't.crm_main_id')
                ->leftJoin('crm_request_table as rt', 'r.id', '=', 'rt.crm_id')
                ->leftJoin('customers as c', 'c.id', '=', 'r.customer_id')
                ->orderBy('c.updated_at', 'desc')
                ->select('cs.title as statusString', 'r.*', 'r.id as mainId', 'c.name as customerName', 't.*', 'rt.*', DB::raw("(case r.status when '0' then 'New' when '1' then 'New' when '2' then 'Technical review' when '3' then 'Document approved' when '4' then 'Quote upload'  when '5' then 'Revise quotation'  when '6' then 'Firm order recieved'  when '7' then 'Policy upload'  when '8' then 'Reject'  when '9' then 'Completed' when '10' then 'Lost' when '11' then 'Pending with sales' else 'Pending with client' end) AS oldstatusString"), DB::raw('DATEDIFF(r.created_date,r.updated_date) as daydiff'));

        if (in_array('ROLE_SALES_MANAGER', Auth::user()->roles) || in_array('ROLE_TECHNICAL_MANAGER', Auth::user()->roles)) {
            
        } else if (in_array('ROLE_SALES', Auth::user()->roles) || in_array('ROLE_TECHNICAL', Auth::user()->roles)) {
            $quoteSqlObj->where('r.user_id', Auth::user()->id)->orWhere('r.assigned_to', Auth::user()->id);
        } else {
            
        }
        $quoteRequest = $quoteSqlObj->get();
        $statusArray = ['New' => json_encode([0, 1]), 'Pending with technical department' => json_encode([2, 3]), 'quote uploaded' => '4', 'revise quotation' => '5', 'firm order recieved' => '6', 'policy uploaded' => '7', 'reject' => '8', 'completed' => '9', 'lost' => '10', 'Pending with sales' => '11', 'Pending with client' => '12', 'Under issuance' => '13'];
        Session::forget('conversionrequestFilterCondition_' . Auth::user()->id);
        $data = array('statusArray' => $statusArray, "requestData" => $quoteRequest);

        return view('Reports/conversionrequest', $data);
    }

    /**
     * 
     * @param Request $request
     * @return type
     */
    public function conversionFilter(Request $request) {

        $filterObj = new RequestFiltter();
        $filteredResult = $filterObj->getConversionRequest($request);
        //'open', 'under process', 'technical review', 'approved submissions', 'quote uploaded', 'revise quotation', 'request policy', 'policy uploaded', 'reject', 'completed', 'lost', 'pending with sales', 'pending with client','under issuance'
        $statusArray = ['New' => json_encode([0, 1]), 'Pending with technical department' => json_encode([2, 3]), 'quote uploaded' => '4', 'revise quotation' => '5', 'firm order recieved' => '6', 'policy uploaded' => '7', 'reject' => '8', 'completed' => '9', 'lost' => '10', 'Pending with sales' => '11', 'Pending with client' => '12', 'Under issuance' => '13'];
        $data = array('statusArray' => $statusArray, "requestData" => $filteredResult);

        return view('Reports/conversionrequest', $data);
    }

    /**
     * Function to export conversion ratio report
     */
    public function conversionRequestExport() {

        $filterObj = new RequestFiltter();
        $request = array();
        $filteredResult = $filterObj->getConversionRequest($request, true);
        $insurerDetails = DB::table('insurer_details')->distinct()->where('status', '1')->orderBy('id')->select('insurer_name', 'id')->get();
        $insurerArray = collect($insurerDetails)->groupBy('id')->toArray();

        $heading = array('Request No', 'Customer name', 'Product', 'Description', 'Sale person', 'Assigned person', 'Type', 'Status', 'BOR Type', 'Timed BOR', 'No.of object', 'Expected premium', 'Reject reason', 'Created date', 'Updated date', 'Created person', 'Time taken');
        array_push($heading, 'Technical SLA (days)');
        array_push($heading, 'Sales SLA (days)');
        array_push($heading, 'Total SLA (days)');
        array_push($heading, 'Quote count');
        array_push($heading, 'Average quote amount');
        foreach ($insurerDetails as $insurer) {
            array_push($heading, $insurer->insurer_name);
        }

        array_push($heading, 'Insurer');
        array_push($heading, 'Policy No.');
        array_push($heading, 'Gross premium');
        

        $requestArray[] = $heading;

        foreach ($filteredResult as $key => $result) {
            $iCount = $key + 1;
            $quoteDetails = $this->quoteDetails($result->mainId, $insurerDetails);
            $technicalsla = ($result->technicalsla != '' && $result->technicalsla != null) ? $result->technicalsla : 0;
            $salessla = ($result->salessla != '' && $result->salessla != null) ? $result->salessla : 0;
            $totalsla = $technicalsla + $salessla;

            $requestArray [$iCount] = array('Request No' => $result->crm_request_id,
                'Customer name' => $result->customerName,
                'Product' => $result->lob,
                'Description' => ($result->type == 0) ? $result->subject : $result->description,
                'Sale person' => $result->salesperson,
                'Assigned person' => $result->assignperson,
                'Type' => $result->typeString,
                'Status' => $result->statusString,
                'BOR Type' => $result->bor_status,
                'Timed BOR' => ($result->time_flag == 1) ? 'Yes' : 'No',
                'No.of object' => ($result->no_of_objects > 0) ? $result->no_of_objects : 0,
                'Expected premium' => $result->expect_premium,
                'Reject reason' => $result->reject_reason,
                'Created date' => date('d-m-Y', strtotime($result->created_date)),
                'Updated date' => date('d-m-Y', strtotime($result->updated_date)),
                'Created person' => $result->createdperson,
                'Time taken' => ($result->daydiff > 0) ? $result->daydiff : '0',
                'Technical SLA (days)' => $technicalsla,
                'Sales SLA (days)' => $salessla,
                'Total SLA (days)' => $totalsla,
                'Quote count' => $result->quoteCount,
                'Average quote amount' => $result->averageQuoteAmount
            );
            foreach ($insurerDetails as $insurer) {
                $requestArray [$iCount][$insurer->insurer_name] = number_format(round(floatval($quoteDetails[$insurer->id]), 2), 2);
            }
            $secureStatus = ($result->requestStatus == 7 || $result->requestStatus == 9) ? true : false;
            $lostStatus = ($result->requestStatus == 10) ? true : false;

            if ($secureStatus && isset($insurerArray[$result->selectedQuote])) {
                $requestArray [$iCount]['Insurer'] = $insurerArray[$result->selectedQuote][0]->insurer_name;
            } else {
                $requestArray [$iCount]['Insurer'] = '';
            }
            $requestArray [$iCount]['Policy No.'] = ($result->policy_number != null) ? $result->policy_number : '';
            $requestArray [$iCount]['Gross premium'] = ($result->gross_amount != null) ? $result->gross_amount : '';
        }
        $filename = 'Conversionreport_' . date('YmdHis') . "_" . Auth::user()->id;
        Excel::create($filename, function ($excel) use ($requestArray) {
            $excel->setTitle('Sales request data');
            $excel->sheet('Report', function ($sheet) use ($requestArray) {
                $sheet->fromArray($requestArray, null, 'A1', false, false);
                $sheet->setPageMargin(array(
                    0.25, 0.30, 0.25, 0.30
                ));
                $sheet->row(1, function ($row) {

                    // call cell manipulation methods
                    $row->setBackground('#4F5467');
                    $row->setFontColor('#ffffff');
                    $row->setFontSize(16);
                    $row->setFontWeight('bold');
                });
            });
        })->store('xlsx', $this->filepath);

        exportLogentry(9, $filename . ".xlsx");

        return response()->download(storage_path('app/userexport/' . $filename . ".xlsx"))->deleteFileAfterSend(false);
    }

    /**
     * Function to collect the minimum quote value of each insurer of the crm request
     * @param type $crmId
     * @param type $insurerDetails
     * @return int
     */
    private function quoteDetails($crmId, $insurerDetails) {

        $quotes = DB::table('quote')->where('crm_id', $crmId)->select('company_id', DB::raw("min(quote_amount) as minQuote"))->groupBy('company_id')->get();
        $quoteDetailArray = [];
        $quoteArray = [];

        if ($quotes) {
            $quoteDetailArray = collect($quotes)->groupBy('company_id')->toArray();
        }

        foreach ($insurerDetails as $insurer) {
            if (isset($quoteDetailArray[$insurer->id])) {
                $quoteArray[$insurer->id] = round(floatval($quoteDetailArray[$insurer->id][0]->minQuote), 2);
            } else {
                $quoteArray[$insurer->id] = 0;
            }
        }

        return $quoteArray;
    }

    /**
     * 
     * @return type
     */
    public function conversionratioDetails() {

        $form = array();
        return view('Reports/convertionratio', array('formData' => $form));
    }

    /**
     * 
     * @param Request $request
     * @return type
     */
    public function conversionratioFilter(Request $request) {

        //Document Approved
        //Pending with Sales
        // Pending with Client
        //Policy uploaded
        // Lost

        $form = array();
        ini_set('memory_limit', '-1');
        ini_set('max_execution_time', 0);
        $form['startdate'] = ($request->has('startdate')) ? $request->get('startdate') : '';
        $form['enddate'] = ($request->has('enddate')) ? $request->get('enddate') : '';

        $form['inceptioncheck'] = ($request->has('inceptioncheck')) ? $request->get('inceptioncheck') : '';

        $convertionratio = new Convertionratio();
        $filename = $convertionratio->generateReport($form);

        return response()->download($filename)->deleteFileAfterSend();
    }
}
