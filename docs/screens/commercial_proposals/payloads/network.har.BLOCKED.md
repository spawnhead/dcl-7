# Commercial Proposals List Screen - Network Payloads (BLOCKED)

## Status: BLOCKED

The exact HTTP request/response wire format has not been captured from a running legacy system.

---

## Missing Network Captures

### Required HAR Captures

| # | Operation | URL | Status |
|---|-----------|-----|--------|
| 1 | Initial load | `POST /CommercialProposalsAction.do?dispatch=input` | NOT CAPTURED |
| 2 | Apply filters | `POST /CommercialProposalsAction.do?dispatch=filter` | NOT CAPTURED |
| 3 | Edit CP | `POST /CommercialProposalsAction.do?dispatch=edit` | NOT CAPTURED |
| 4 | Clone (new) | `POST /CommercialProposalsAction.do?dispatch=cloneLikeNewVersion` | NOT CAPTURED |
| 5 | Clone (old) | `POST /CommercialProposalsAction.do?dispatch=cloneLikeOldVersion` | NOT CAPTURED |
| 6 | Block | `POST /CommercialProposalsAction.do?dispatch=block` | NOT CAPTURED |
| 7 | Check price | `POST /CommercialProposalsAction.do?dispatch=checkPrice` | NOT CAPTURED |
| 8 | Export Excel | `POST /CommercialProposalsAction.do?dispatch=generateExcel` | NOT CAPTURED |

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
- `cp-list-initial.har`
- `cp-list-filter.har`
- `cp-list-edit.har`
- `cp-list-clone.har`
- `cp-list-block.har`
- `cp-list-export.har`

---

## Specific Gaps to Address

### 1. Filter Parameter Names
**Unknown**: Exact filter field names in POST body

**How to verify**:
1. Set multiple filter values
2. Click Filter button
3. Check Request Payload in Network tab

**Expected format** (based on JSP analysis):
```
dispatch=filter
cpr_number=BYM
department.id=DEP-001
contractor.id=CNT-001
user.usr_id=USR-TEST-002
stuffCategory.id=STC-001
cpr_date_from=01.02.2026
cpr_date_to=28.02.2026
cpr_sum_from=1000
cpr_sum_to=10000
cpr_proposal_received_flag=1
cpr_proposal_declined=
```

### 2. Pagination Parameters
**Unknown**: How pagination is handled

**How to verify**:
1. Load list with more than page size
2. Click next page
3. Check request parameters

**Expected parameters**:
```
page=2
pageSize=20
```

### 3. Sort Parameters
**Unknown**: How sorting is communicated

**How to verify**:
1. Click column header to sort
2. Check request parameters

**Expected parameters**:
```
sortColumn=cpr_date
sortDirection=DESC
```

### 4. Excel Export Format
**Unknown**: Excel file structure

**How to verify**:
1. Click Export Excel
2. Save downloaded file
3. Analyze structure

---

## Expected Payload Structure (Based on Code Analysis)

### Filter Request (Estimated)
```
POST /CommercialProposalsAction.do HTTP/1.1
Content-Type: application/x-www-form-urlencoded

dispatch=filter
cpr_number=BYM
department.id=DEP-001
contractor.id=CNT-001
user.usr_id=USR-TEST-002
stuffCategory.id=STC-001
cpr_date_from=01.02.2026
cpr_date_to=28.02.2026
cpr_sum_from=1000
cpr_sum_to=10000
cpr_proposal_received_flag=1
```

### Block Request (Estimated)
```
POST /CommercialProposalsAction.do HTTP/1.1
Content-Type: application/x-www-form-urlencoded

dispatch=block
cpr_id=CPR-001
```

---

## Verification Checklist

- [ ] Capture all list operations
- [ ] Document filter parameter names
- [ ] Document pagination parameters
- [ ] Document sort parameters
- [ ] Document Excel export format
- [ ] Compare estimated payloads with actual
- [ ] Update CONTRACTS.md with verified data
- [ ] Create actual payload JSON files
