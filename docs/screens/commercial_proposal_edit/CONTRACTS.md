# Commercial Proposal Edit Screen - API CONTRACTS

## Endpoints Overview

| Endpoint | Method | Dispatch | Description |
|----------|--------|----------|-------------|
| `/CommercialProposalAction.do` | POST | input | Create new CP form |
| `/CommercialProposalAction.do` | POST | edit | Load existing CP |
| `/CommercialProposalAction.do` | POST | cloneLikeNewVersion | Clone (new format) |
| `/CommercialProposalAction.do` | POST | cloneLikeOldVersion | Clone (old format) |
| `/CommercialProposalAction.do` | POST | process | Save CP |
| `/CommercialProposalAction.do` | POST | reload | Refresh form |
| `/CommercialProposalAction.do` | POST | print | Save and print |
| `/CommercialProposalAction.do` | POST | printInvoice | Print invoice |
| `/CommercialProposalAction.do` | POST | printContract | Print contract |
| `/CommercialProposalAction.do` | POST | importExcel | Import from Excel |
| `/CommercialProposalAction.do` | POST | uploadTemplate | Upload template |

---

## AJAX Endpoints

| Endpoint | Method | Parameters | Description |
|----------|--------|------------|-------------|
| `/CommercialProposalAction.do` | POST | dispatch=ajaxProducesCommercialProposalGrid | Get produces grid |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxDeleteAllProducesCommercialProposalGrid | Clear all produces |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxRemoveFromCommercialProposalGrid&number={n} | Remove produce |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxProducesForAssembleMinskGrid | Minsk store grid |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxDeleteAllProducesForAssembleMinskGrid | Clear Minsk produces |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxRemoveFromProducesForAssembleMinskGrid&number={n} | Remove Minsk produce |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeSalePriceForAssembleMinskGrid&priceId={id}&salePrice={price} | Change price |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeNDSByString&ndsByString={true/false} | Toggle NDS mode |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeFreePrices&freePrices={true/false} | Toggle free prices |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeReverseCalc&reverseCalc={true/false} | Toggle reverse calc |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeCalculate&calculateNtto={true/false} | Toggle netto calc |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeCourse&course={value} | Change course |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeNDS&nds={value} | Change NDS rate |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxChangeCurrency&currencyId={id} | Change currency |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxRecalcCommercialProposalGrid | Recalculate grid |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxRecalcForAssembleMinskGrid | Recalculate Minsk |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxGetTotal | Get total sum |
| `/CommercialProposalAction.do` | POST | dispatch=ajaxGetReputation&contractor-id={id} | Get reputation |

---

## 1. Create New CP (input)

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=input
```

### Response
- **Type**: HTML page redirect to CommercialProposal.jsp
- **Form Initialization**:
  - `cpr_date` = current date
  - `cpr_final_date` = current date
  - `is_new_doc` = "true"
  - `cpr_nds` = from NDS rate for date
  - `currency` = from config `defaultCPCurrency`
  - `currencyTable` = from config `defaultCPTableCurrency`
  - `cpr_course` = 1
  - `cpr_old_version` = ""
  - `cpr_assemble_minsk_store` = ""
  - `cpr_reverse_calc` = ""
  - `show_unit` = "1"
  - `cpr_all_transport` = "1"
  - `cpr_donot_calculate_netto` = "1"
  - `cpr_final_date_above` = "1"
  - `cpr_prepay_percent` = "100"
  - `user` = current user

---

## 2. Edit Existing CP (edit)

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=edit
cpr_id={cprId}
```

### Response
- **Type**: HTML page with CommercialProposal.jsp
- **Form Populated**: All fields from database
- **Additional Loads**:
  - CP produces with calculations
  - Transport lines
  - Attachments list

---

## 3. Save CP (process)

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=process
is_new_doc={true|empty}
cpr_id={id}
cpr_number={number}
cpr_date={dd.MM.yyyy}
contractor.id={contractorId}
contactPerson.cps_id={contactPersonId}
blank.bln_id={blankId}
currency.id={currencyId}
currencyTable.id={currencyTableId}
cpr_course={course}
cpr_nds={nds}
cpr_nds_by_string={1|empty}
cpr_free_prices={1|empty}
cpr_reverse_calc={1|empty}
cpr_donot_calculate_netto={1|empty}
cpr_old_version={1|empty}
cpr_assemble_minsk_store={1|empty}
cpr_no_reservation={1|empty}
priceCondition.id={incoTermId}
deliveryCondition.id={incoTermId}
cpr_country={country}
cpr_pay_condition={text}
cpr_delivery_address={address}
cpr_delivery_term={term}
cpr_sum_transport={sum}
cpr_all_transport={1|empty}
cpr_sum_assembling={sum}
cpr_concerning={text}
cpr_preamble={text}
cpr_add_info={text}
cpr_final_date={dd.MM.yyyy}
user.usr_id={userId}
executor.usr_id={executorId}
cpr_executor_flag={1|empty}
purchasePurpose.id={purposeId}
cpr_comment={comment}
cpr_date_accept={dd.MM.yyyy}
cpr_proposal_received_flag={1|empty}
cpr_proposal_declined={1|empty}
cpr_tender_number={number}
cpr_tender_number_editable={1|empty}
facsimile_flag={1|empty}
cpr_guaranty_in_month={months}
cpr_prepay_percent={percent}
cpr_prepay_sum={sum}
cpr_delay_days={days}
consignee.id={consigneeId}
contactPersonSeller.cps_id={sellerContactId}
contactPersonCustomer.cps_id={customerContactId}
cpr_provider_delivery={1|empty}
cpr_provider_delivery_address={address}
cpr_delivery_count_day={days}
cpr_print_scale={scale}
cpr_contract_scale={scale}
cpr_invoice_scale={scale}
include_exps={1|empty}
show_unit={1|empty}
printMode={print|printInvoice|printContract|empty}
```

### Response (Success)
- **Redirect**: `/CommercialProposalsAction.do` (back to list)

### Response (Validation Error)
- **Type**: HTML page with CommercialProposal.jsp
- **Errors**: Displayed via `<html:errors/>`

---

## 4. AJAX: Produces Grid

### Get Grid
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxProducesCommercialProposalGrid
```

**Response**: HTML fragment with produces grid

### Clear All Produces
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxDeleteAllProducesCommercialProposalGrid
```

**Response**: HTML fragment with empty grid

### Remove Produce
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxRemoveFromCommercialProposalGrid
number={rowNumber}
```

**Response**: HTML fragment with updated grid

---

## 5. AJAX: Minsk Store Grid

### Get Grid
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxProducesForAssembleMinskGrid
```

**Response**: HTML fragment with Minsk store grid

### Change Price
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeSalePriceForAssembleMinskGrid
priceId={rowIndex}
salePrice={priceValue}
```

**Response**: HTML fragment with recalculated grid

---

## 6. AJAX: Toggle Flags

### Toggle NDS By String
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeNDSByString
ndsByString=true
```

**Response**: Empty (text/plain)

### Toggle Free Prices
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeFreePrices
freePrices=true
```

**Response**: Empty (text/plain)

### Toggle Reverse Calc
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeReverseCalc
reverseCalc=true
```

**Response**: Empty (text/plain)

### Toggle Calculate Netto
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeCalculate
calculateNtto=true
```

**Response**: Empty (text/plain)

---

## 7. AJAX: Change Values

### Change Course
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeCourse
course={value}
```

**Response**: Empty (text/plain)

### Change NDS
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeNDS
nds={value}
```

**Response**: Empty (text/plain)

### Change Currency
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxChangeCurrency
currencyId={currencyId}
```

**Response**: Empty (text/plain)

---

## 8. AJAX: Get Total

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxGetTotal
```

### Response
- **Type**: `text/plain`
- **Value**: Total sum formatted as currency string

---

## 9. AJAX: Get Reputation

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=ajaxGetReputation
contractor-id={contractorId}
```

### Response
- **Type**: `text/plain`
- **Value**: "Reputation: {description}"

---

## 10. Import Excel

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=importExcel
```

### Response
- **Redirect**: Excel import screen

---

## 11. Upload Template

### Request
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=uploadTemplate
```

### Response
- **Redirect**: Template upload screen

---

## 12. Print Operations

### Print CP
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=print
```

**Response**: HTML page with print trigger

### Print Invoice
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=printInvoice
```

**Response**: HTML page with print trigger (requires purchasePurpose)

### Print Contract
```
POST /CommercialProposalAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=printContract
```

**Response**: HTML page with print trigger (requires purchasePurpose)

---

## BLOCKED: Wire Format Not Confirmed

### Missing Network Capture
The exact HTTP request/response wire format has not been captured from a running legacy system.

### How to Verify
1. Start legacy application with debugging enabled
2. Open browser DevTools Network tab
3. Perform each operation
4. Export HAR file with full request/response bodies

### Specific Gaps
- [ ] Exact form field names in POST body
- [ ] Multipart structure for file uploads
- [ ] AJAX response HTML structure
- [ ] Error message format
- [ ] Session cookie handling
- [ ] CSRF token (if any)

### Required HAR Capture Points
1. `POST /CommercialProposalAction.do?dispatch=input` - New CP form
2. `POST /CommercialProposalAction.do?dispatch=edit` - Load existing
3. `POST /CommercialProposalAction.do?dispatch=process` - Save
4. `POST /CommercialProposalAction.do?dispatch=ajaxProducesCommercialProposalGrid` - Produces AJAX
5. `POST /CommercialProposalAction.do?dispatch=ajaxProducesForAssembleMinskGrid` - Minsk AJAX
6. `POST /CommercialProposalAction.do?dispatch=importExcel` - Import
