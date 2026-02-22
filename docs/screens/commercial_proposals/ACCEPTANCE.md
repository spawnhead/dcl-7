# Commercial Proposals List Screen - ACCEPTANCE CRITERIA

## Overview
This document defines acceptance criteria for the Commercial Proposals List screen migration.
All criteria must pass for the screen to be considered "parity complete".

---

## AC-001: Screen Entry

### AC-001.1: Initial Load
**Given**: User navigates to Commercial Proposals
**When**: Screen loads
**Then**:
- [ ] Filter section is displayed with all filter fields
- [ ] Grid shows all CPs (paginated)
- [ ] Default sort is by date descending
- [ ] All filters are empty

### AC-001.2: From Menu
**Given**: User is on main menu
**When**: User clicks "Commercial Proposals" menu item
**Then**:
- [ ] CP list screen opens
- [ ] All CPs are displayed
- [ ] No filters applied

---

## AC-002: Filter Operations

### AC-002.1: Filter by Number
**Given**: CP list is displayed
**When**: User enters partial number in "Number" field and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs with matching number
- [ ] Filter value is preserved in field

### AC-002.2: Filter by Contractor
**Given**: CP list is displayed
**When**: User selects contractor and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs for selected contractor
- [ ] Contractor name displayed in field

### AC-002.3: Filter by Date Range
**Given**: CP list is displayed
**When**: User enters date range and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs within date range
- [ ] Dates formatted as dd.MM.yyyy

### AC-002.4: Filter by Sum Range
**Given**: CP list is displayed
**When**: User enters sum range and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs within sum range
- [ ] Sums formatted with decimal separator

### AC-002.5: Filter by Accepted Status
**Given**: CP list is displayed
**When**: User checks "Accepted" checkbox and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs with `cpr_proposal_received_flag = "1"`

### AC-002.6: Filter by Declined Status
**Given**: CP list is displayed
**When**: User checks "Declined" checkbox and clicks "Filter"
**Then**:
- [ ] Grid shows only CPs with `cpr_proposal_declined = "1"`

### AC-002.7: Combined Filters
**Given**: CP list is displayed
**When**: User sets multiple filter values and clicks "Filter"
**Then**:
- [ ] Grid shows CPs matching ALL filter criteria
- [ ] AND logic applied between filters

### AC-002.8: Clear Filters
**Given**: Filters are applied
**When**: User clicks "Clear" button
**Then**:
- [ ] All filter fields are cleared
- [ ] Grid shows all CPs
- [ ] Default sort restored

---

## AC-003: Grid Display

### AC-003.1: Column Display
**Given**: CP list is displayed
**When**: Grid renders
**Then**:
- [ ] All columns are visible
- [ ] Column headers match legacy labels
- [ ] Column widths are appropriate

### AC-003.2: Row Data
**Given**: CP list has data
**When**: Grid renders rows
**Then**:
- [ ] Number is clickable link
- [ ] Date is formatted as dd.MM.yyyy
- [ ] Sum includes currency symbol
- [ ] Block status shown as checkbox
- [ ] Reserved state displayed correctly

### AC-003.3: Pagination
**Given**: More CPs than page size
**When**: Grid renders
**Then**:
- [ ] Pagination controls visible
- [ ] Current page indicated
- [ ] Total count displayed
- [ ] Page size selector available

### AC-003.4: Sorting
**Given**: CP list is displayed
**When**: User clicks column header
**Then**:
- [ ] Grid sorts by that column
- [ ] Sort direction indicator shown
- [ ] Clicking again reverses sort

---

## AC-004: Row Actions

### AC-004.1: Edit CP
**Given**: CP list is displayed
**When**: User clicks on CP number or Edit button
**Then**:
- [ ] CP edit screen opens
- [ ] CP data is loaded
- [ ] Return to list on cancel/save

### AC-004.2: Clone as New Version
**Given**: CP row is selected
**When**: User clicks "Clone (New Version)"
**Then**:
- [ ] New CP created with same data
- [ ] DBO produce links preserved
- [ ] CP number is empty (generated on save)
- [ ] Date set to current date
- [ ] `cpr_old_version` is empty

### AC-004.3: Clone as Old Version
**Given**: CP row is selected
**When**: User clicks "Clone (Old Version)"
**Then**:
- [ ] New CP created with same data
- [ ] Produces converted to free-text
- [ ] CP number is empty
- [ ] Date set to current date
- [ ] `cpr_old_version` = "1"

### AC-004.4: Block CP
**Given**: Unblocked CP row
**When**: User clicks "Block" button
**Then**:
- [ ] CP is blocked (`cpr_block = "1"`)
- [ ] Grid refreshes
- [ ] Block checkbox shows checked

### AC-004.5: Unblock CP
**Given**: Blocked CP row
**When**: User clicks "Unblock" button
**Then**:
- [ ] CP is unblocked (`cpr_block = null`)
- [ ] Grid refreshes
- [ ] Block checkbox shows unchecked

### AC-004.6: Check Price
**Given**: CP row is selected (Admin/Economist only)
**When**: User clicks "Check Price" button
**Then**:
- [ ] Price validation runs
- [ ] `cpr_check_price` field updated
- [ ] Results displayed

### AC-004.7: Export to Excel
**Given**: CP list is displayed (filtered or not)
**When**: User clicks "Export Excel" button
**Then**:
- [ ] Excel file downloads
- [ ] File contains visible grid data
- [ ] Column headers match grid

---

## AC-005: Role-Based Access

### AC-005.1: Admin Role
**Given**: User has Admin role
**When**: Viewing CP list
**Then**:
- [ ] Can view all CPs
- [ ] Can edit any CP
- [ ] Can block/unblock
- [ ] Can check price
- [ ] Can export Excel

### AC-005.2: Economist Role
**Given**: User has Economist role
**When**: Viewing CP list
**Then**:
- [ ] Can view all CPs
- [ ] Can edit any CP
- [ ] Can block/unblock
- [ ] Can check price
- [ ] Can export Excel

### AC-005.3: Manager Role
**Given**: User has Manager role
**When**: Viewing CP list
**Then**:
- [ ] Can view all CPs
- [ ] Can edit CPs
- [ ] Cannot block/unblock
- [ ] Cannot check price
- [ ] Can export Excel

### AC-005.4: Logistic Role
**Given**: User has Logistic role
**When**: Viewing CP list
**Then**:
- [ ] Can view all CPs (readonly)
- [ ] Cannot edit CPs
- [ ] Cannot block/unblock
- [ ] Cannot check price
- [ ] Can export Excel

---

## AC-006: Row Styling

### AC-006.1: Blocked Row
**Given**: CP is blocked
**When**: Grid renders
**Then**:
- [ ] Row has blocked styling (gray/disabled)
- [ ] Block checkbox is checked

### AC-006.2: Accepted Row
**Given**: CP is accepted
**When**: Grid renders
**Then**:
- [ ] Row has accepted styling (green)
- [ ] Accepted date displayed

### AC-006.3: Declined Row
**Given**: CP is declined
**When**: Grid renders
**Then**:
- [ ] Row has declined styling (red)
- [ ] Declined status visible

---

## AC-007: Performance

### AC-007.1: Initial Load Time
**Given**: Database has 1000+ CPs
**When**: User opens CP list
**Then**:
- [ ] Screen renders in < 3 seconds
- [ ] First page displayed immediately

### AC-007.2: Filter Response
**Given**: Database has 1000+ CPs
**When**: User applies filter
**Then**:
- [ ] Results displayed in < 2 seconds

### AC-007.3: Export Performance
**Given**: Filtered list has 500+ CPs
**When**: User exports to Excel
**Then**:
- [ ] File generated in < 10 seconds

---

## AC-008: Error Handling

### AC-008.1: No Results
**Given**: Filter returns no CPs
**When**: Grid renders
**Then**:
- [ ] "No results found" message displayed
- [ ] Filter section remains visible

### AC-008.2: Database Error
**Given**: Database connection fails
**When**: User tries to load list
**Then**:
- [ ] Error message displayed
- [ ] User can retry

### AC-008.3: Export Error
**Given**: Export fails
**When**: User clicks Export
**Then**:
- [ ] Error message displayed
- [ ] User can retry

---

## Validation Messages

| Message Key | Condition |
|-------------|-----------|
| `commercial_proposal.blocked` | CP blocked successfully |
| `commercial_proposal.unblocked` | CP unblocked successfully |
| `commercial_proposal.clone.success` | CP cloned successfully |
| `error.commercial_proposal.not_found` | CP not found |
| `error.commercial_proposal.access_denied` | User lacks permission |

---

## Acceptance Sign-Off

| Role | Name | Date | Status |
|------|------|------|--------|
| BA | | | [ ] |
| QA | | | [ ] |
| Dev | | | [ ] |
| Product Owner | | | [ ] |
