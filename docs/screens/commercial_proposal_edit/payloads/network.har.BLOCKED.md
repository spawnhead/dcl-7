# Commercial Proposal Edit Screen - Network Payloads (BLOCKED)

## Status: BLOCKED

The exact HTTP request/response wire format has not been captured from a running legacy system.

---

## Missing Network Captures

### Required HAR Captures

| # | Operation | URL | Status |
|---|-----------|-----|--------|
| 1 | Create new CP | `POST /CommercialProposalAction.do?dispatch=input` | NOT CAPTURED |
| 2 | Load existing CP | `POST /CommercialProposalAction.do?dispatch=edit` | NOT CAPTURED |
| 3 | Save CP | `POST /CommercialProposalAction.do?dispatch=process` | NOT CAPTURED |
| 4 | Reload form | `POST /CommercialProposalAction.do?dispatch=reload` | NOT CAPTURED |
| 5 | Print CP | `POST /CommercialProposalAction.do?dispatch=print` | NOT CAPTURED |
| 6 | Print Invoice | `POST /CommercialProposalAction.do?dispatch=printInvoice` | NOT CAPTURED |
| 7 | Print Contract | `POST /CommercialProposalAction.do?dispatch=printContract` | NOT CAPTURED |
| 8 | Add produce | `POST /CommercialProposalAction.do?dispatch=newProduce` | NOT CAPTURED |
| 9 | Edit produce | `POST /CommercialProposalAction.do?dispatch=editProduce` | NOT CAPTURED |
| 10 | Import Excel | `POST /CommercialProposalAction.do?dispatch=importExcel` | NOT CAPTURED |
| 11 | Upload template | `POST /CommercialProposalAction.do?dispatch=uploadTemplate` | NOT CAPTURED |

### Required AJAX Captures

| # | Operation | URL | Status |
|---|-----------|-----|--------|
| 1 | Produces grid | `POST /CommercialProposalAction.do?dispatch=ajaxProducesCommercialProposalGrid` | NOT CAPTURED |
| 2 | Clear produces | `POST /CommercialProposalAction.do?dispatch=ajaxDeleteAllProducesCommercialProposalGrid` | NOT CAPTURED |
| 3 | Remove produce | `POST /CommercialProposalAction.do?dispatch=ajaxRemoveFromCommercialProposalGrid` | NOT CAPTURED |
| 4 | Minsk grid | `POST /CommercialProposalAction.do?dispatch=ajaxProducesForAssembleMinskGrid` | NOT CAPTURED |
| 5 | Change price (Minsk) | `POST /CommercialProposalAction.do?dispatch=ajaxChangeSalePriceForAssembleMinskGrid` | NOT CAPTURED |
| 6 | Toggle NDS by string | `POST /CommercialProposalAction.do?dispatch=ajaxChangeNDSByString` | NOT CAPTURED |
| 7 | Toggle free prices | `POST /CommercialProposalAction.do?dispatch=ajaxChangeFreePrices` | NOT CAPTURED |
| 8 | Toggle reverse calc | `POST /CommercialProposalAction.do?dispatch=ajaxChangeReverseCalc` | NOT CAPTURED |
| 9 | Change course | `POST /CommercialProposalAction.do?dispatch=ajaxChangeCourse` | NOT CAPTURED |
| 10 | Change NDS | `POST /CommercialProposalAction.do?dispatch=ajaxChangeNDS` | NOT CAPTURED |
| 11 | Get total | `POST /CommercialProposalAction.do?dispatch=ajaxGetTotal` | NOT CAPTURED |
| 12 | Get reputation | `POST /CommercialProposalAction.do?dispatch=ajaxGetReputation` | NOT CAPTURED |

---

## How to Verify

### Step 1: Prepare Legacy Environment
1. Deploy legacy application locally or access development server
2. Ensure database has test data (see TEST_DATA_SPEC.md)
3. Enable browser DevTools (F12)

### Step 2: Capture Network Traffic
1. Open Chrome/Firefox DevTools
2. Go to Network tab
3. Check "Preserve log"
4. Perform each operation listed above
5. Right-click → "Save all as HAR with content"

### Step 3: Export HAR Files
Save each capture with descriptive filename:
- `cp-edit-new.har`
- `cp-edit-load.har`
- `cp-edit-save.har`
- `cp-edit-produces-grid.har`
- `cp-edit-minsk-grid.har`
- etc.

---

## Specific Gaps to Address

### 1. Form Field Names
**Unknown**: Exact form field names in POST body

**Expected format** (based on JSP analysis):
```
dispatch=process
is_new_doc=true
cpr_date=12.02.2026
contractor.id=CNT-001
contactPerson.cps_id=CPS-001
blank.bln_id=BLN-001
currency.id=CUR-EUR
currencyTable.id=CUR-EUR
cpr_course=1
cpr_nds=20
cpr_nds_by_string=1
cpr_free_prices=
cpr_reverse_calc=
cpr_old_version=
cpr_assemble_minsk_store=
...
```

### 2. Multipart File Upload
**Unknown**: Structure for Excel import and template upload

**How to verify**:
1. Import Excel file
2. Check Content-Type: multipart/form-data
3. Note boundary and field names

### 3. AJAX Response HTML
**Unknown**: Exact HTML structure of grid responses

**How to verify**:
1. Trigger AJAX grid load
2. Check Response tab
3. Note table structure, classes, scripts

### 4. Print Response
**Unknown**: How print is triggered (redirect, new window, inline PDF)

**How to verify**:
1. Click Print button
2. Check response headers
3. Note Content-Type and Content-Disposition

---

## Expected Payload Structure (Based on Code Analysis)

### Save CP Request (Estimated)
```
POST /CommercialProposalAction.do HTTP/1.1
Content-Type: application/x-www-form-urlencoded

dispatch=process
is_new_doc=true
cpr_date=12.02.2026
contractor.id=CNT-001
contactPerson.cps_id=CPS-001
blank.bln_id=BLN-001
currency.id=CUR-EUR
currencyTable.id=CUR-EUR
cpr_course=1
cpr_nds=20
cpr_nds_by_string=1
cpr_free_prices=
cpr_reverse_calc=
cpr_donot_calculate_netto=1
cpr_old_version=
cpr_assemble_minsk_store=
cpr_no_reservation=
priceCondition.id=INC-EXW
deliveryCondition.id=INC-EXW
cpr_country=Belarus
cpr_pay_condition=Prepayment
cpr_delivery_address=Minsk
cpr_delivery_term=30 days
cpr_sum_transport=0
cpr_all_transport=1
cpr_sum_assembling=0
cpr_concerning=Quote
cpr_preamble=
cpr_add_info=
cpr_final_date=22.02.2026
user.usr_id=USR-TEST-002
executor.usr_id=
cpr_executor_flag=
purchasePurpose.id=
cpr_comment=
cpr_date_accept=
cpr_proposal_received_flag=
cpr_proposal_declined=
cpr_tender_number=
cpr_tender_number_editable=
facsimile_flag=
cpr_print_scale=100
cpr_contract_scale=100
cpr_invoice_scale=100
include_exps=
show_unit=1
printMode=
```

### AJAX Toggle Request (Estimated)
```
POST /CommercialProposalAction.do HTTP/1.1
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeNDSByString
ndsByString=true
```

### AJAX Response (Estimated)
```
HTTP/1.1 200 OK
Content-Type: text/plain;charset=UTF-8

(empty response)
```

---

## Verification Checklist

- [ ] Capture all main form operations
- [ ] Capture all AJAX operations
- [ ] Document form field names
- [ ] Document multipart upload structure
- [ ] Document AJAX response HTML
- [ ] Document print response format
- [ ] Compare estimated payloads with actual
- [ ] Update CONTRACTS.md with verified data
- [ ] Create actual payload JSON files
