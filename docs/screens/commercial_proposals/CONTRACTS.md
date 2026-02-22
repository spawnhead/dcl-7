# Commercial Proposals List Screen - API CONTRACTS

## Endpoints Overview

| Endpoint | Method | Dispatch | Description |
|----------|--------|----------|-------------|
| `/CommercialProposalsAction.do` | POST | input | Clear filters, show all |
| `/CommercialProposalsAction.do` | POST | filter | Apply filters |
| `/CommercialProposalsAction.do` | POST | edit | Open CP for editing |
| `/CommercialProposalsAction.do` | POST | cloneLikeNewVersion | Clone as new format |
| `/CommercialProposalsAction.do` | POST | cloneLikeOldVersion | Clone as old format |
| `/CommercialProposalsAction.do` | POST | block | Toggle block status |
| `/CommercialProposalsAction.do` | POST | checkPrice | Price check |
| `/CommercialProposalsAction.do` | POST | generateExcel | Export to Excel |

---

## 1. Load List (input)

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=input
```

### Response
- **Type**: HTML page with CommercialProposals.jsp
- **Grid**: All CPs (default sort by date desc)
- **Filters**: All cleared

---

## 2. Filter List

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=filter
cpr_number={number}
department.id={departmentId}
contractor.id={contractorId}
user.usr_id={userId}
stuffCategory.id={categoryId}
cpr_date_from={dd.MM.yyyy}
cpr_date_to={dd.MM.yyyy}
cpr_sum_from={amount}
cpr_sum_to={amount}
cpr_proposal_received_flag={1|empty}
cpr_proposal_declined={1|empty}
```

### Response
- **Type**: HTML page with filtered grid
- **Grid**: CPs matching filter criteria

---

## 3. Edit CP

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=edit
cpr_id={cprId}
```

### Response
- **Redirect**: CommercialProposal.jsp with CP data loaded

---

## 4. Clone as New Version

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=cloneLikeNewVersion
cpr_id={cprId}
```

### Response
- **Redirect**: CommercialProposal.jsp with cloned CP (new format)
- **Effect**: 
  - `cpr_id` cleared
  - `cpr_number` cleared
  - `cpr_date` = current date
  - Produces copied with DBO links preserved

---

## 5. Clone as Old Version

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=cloneLikeOldVersion
cpr_id={cprId}
```

### Response
- **Redirect**: CommercialProposal.jsp with cloned CP (old format)
- **Effect**:
  - `cpr_id` cleared
  - `cpr_number` cleared
  - `cpr_date` = current date
  - `cpr_old_version` = "1"
  - Produces converted to free-text (DBO links removed)

---

## 6. Toggle Block

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=block
cpr_id={cprId}
```

### Response
- **Type**: HTML page with updated grid
- **Effect**: `cpr_block` toggled between "1" and null

---

## 7. Check Price

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=checkPrice
cpr_id={cprId}
```

### Response
- **Type**: HTML page with price check results
- **Effect**: `cpr_check_price` field updated

---

## 8. Export to Excel

### Request
```
POST /CommercialProposalsAction.do
Content-Type: application/x-www-form-urlencoded

dispatch=generateExcel
```

### Response
- **Type**: application/vnd.ms-excel
- **File**: Commercial_Proposal_Table_Part.xls
- **Content**: Grid data in Excel format

---

## BLOCKED: Wire Format Not Confirmed

### Missing Network Capture
The exact HTTP request/response wire format has not been captured from a running legacy system.

### How to Verify
1. Start legacy application with debugging enabled
2. Open browser DevTools Network tab
3. Perform each operation (filter, edit, clone, block)
4. Export HAR file with full request/response bodies
5. Compare with this specification

### Specific Gaps
- [ ] Exact filter field names in POST body
- [ ] Grid pagination parameters
- [ ] Sort column/direction parameters
- [ ] Session cookie handling
- [ ] CSRF token (if any)
- [ ] Excel export format

### Required HAR Capture Points
1. `POST /CommercialProposalsAction.do?dispatch=input` - Initial load
2. `POST /CommercialProposalsAction.do?dispatch=filter` - Apply filters
3. `POST /CommercialProposalsAction.do?dispatch=edit` - Open CP
4. `POST /CommercialProposalsAction.do?dispatch=block` - Toggle block
5. `POST /CommercialProposalsAction.do?dispatch=generateExcel` - Export
