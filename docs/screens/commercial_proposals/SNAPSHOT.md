# Commercial Proposals List Screen - SNAPSHOT

## Screen Identity
- **Screen Name**: Commercial Proposals List
- **Legacy JSP**: `src/main/webapp/jsp/CommercialProposals.jsp`
- **Struts Action**: `/CommercialProposalsAction`
- **Action Class**: `net.sam.dcl.action.CommercialProposalsAction`
- **Form Bean**: `net.sam.dcl.form.CommercialProposalsForm`
- **Mode**: List (grid with filters)

## Source Trace
| Aspect | Legacy Source |
|--------|---------------|
| Main JSP | `src/main/webapp/jsp/CommercialProposals.jsp` |
| Action | `src/main/java/net/sam/dcl/action/CommercialProposalsAction.java` |
| Struts Config | `struts-config.xml` - `/CommercialProposalsAction` mapping |

## Entry Points
1. **Main Menu**: Commercial Proposals menu item
2. **From Order**: After selecting CP for order import
3. **From Contractor**: View CPs for specific contractor

## Screen Layout

### 1. Filter Section

| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_number | Text | `form.cpr_number` | CP number filter (partial match) |
| department | ServerList (Department) | `form.department` | Department filter |
| contractor | ServerList (Contractor) | `form.contractor` | Contractor filter |
| user | ServerList (User) | `form.user` | Manager/user filter |
| stuffCategory | ServerList (StuffCategory) | `form.stuffCategory` | Product category filter |
| cpr_date_from | Date | `form.cpr_date_from` | Date range start |
| cpr_date_to | Date | `form.cpr_date_to` | Date range end |
| cpr_sum_from | Text | `form.cpr_sum_from` | Sum range start |
| cpr_sum_to | Text | `form.cpr_sum_to` | Sum range end |
| cpr_proposal_received_flag | Checkbox | `form.cpr_proposal_received_flag` | Accepted filter |
| cpr_proposal_declined | Checkbox | `form.cpr_proposal_declined` | Declined filter |

### 2. Filter Buttons
| Button | Action | Description |
|--------|--------|-------------|
| Filter | `filter()` | Apply filters and reload grid |
| Clear | `input()` | Clear all filters |

### 3. Grid Columns

| Column | Field | Type | Sortable | Notes |
|--------|-------|------|----------|-------|
| № | cpr_number | Link | Yes | Opens CP edit form |
| Date | cpr_date | Text | Yes | CP date |
| Contractor | cpr_contractor | Text | Yes | Contractor name |
| Sum | cprSumFormatted | Text | Yes | Total sum with currency |
| Currency | cpr_currency | Text | Yes | Currency code |
| Category | cpr_stf_name | Text | Yes | Stuff category |
| Reserved | reservedState | Text | No | Reservation status |
| Block | cpr_block | Checkbox | No | Block status |
| User | cpr_user | Text | Yes | Manager name |
| Department | cpr_department | Text | Yes | Department name |
| Check Price | cpr_check_price | Text | No | Price check indicator |

### 4. Grid Actions (Per Row)

| Action | Dispatch | Condition | Description |
|--------|----------|-----------|-------------|
| Edit | `edit` | Always | Open CP for editing |
| Clone | `cloneLikeNewVersion` or `cloneLikeOldVersion` | Always | Clone CP |
| Block | `block` | Unblocked | Toggle block status |
| Check Price | `checkPrice` | Admin/Economist | Price verification |
| Excel | `generateExcel` | Always | Export to Excel |

### 5. Grid Bulk Actions

| Action | Description |
|--------|-------------|
| Block Selected | Block multiple CPs |
| Unblock Selected | Unblock multiple CPs |

## Form Actions (Dispatch Methods)

| Action | Method | Forward | Description |
|--------|--------|---------|-------------|
| input | `input()` | form | Clear filters and show all |
| filter | `filter()` | form | Apply filters |
| edit | `edit()` | form | Open CP for editing |
| cloneLikeNewVersion | `cloneLikeNewVersion()` | form | Clone as new format |
| cloneLikeOldVersion | `cloneLikeOldVersion()` | form | Clone as old format |
| block | `block()` | form | Toggle block status |
| checkPrice | `checkPrice()` | form | Price check operation |
| generateExcel | `generateExcel()` | - | Export grid to Excel |

## Grid Features

### Sorting
- Click column header to sort
- Default sort: by date descending

### Pagination
- Page size: configurable (default 20)
- Navigation: First, Prev, Next, Last

### Selection
- Single row click: Opens edit
- Checkbox selection for bulk operations

### Row Styling
| Condition | CSS Class |
|-----------|-----------|
| Blocked CP | `blocked-row` |
| Accepted CP | `accepted-row` |
| Declined CP | `declined-row` |

## Business Rules

### Block Logic
- Blocked CP cannot be edited
- Block toggles between "1" and null/empty
- Block status shown as checkbox in grid

### Clone Options
1. **Clone as New Version**: Preserves produce links to DBO
2. **Clone as Old Version**: Converts to free-text produces

### Price Check
- Available for Admin/Economist roles
- Validates prices against current rates
- Shows warning if prices are outdated

## Role-Based Access

| Action | Admin | Economist | Manager | Logistic |
|--------|-------|-----------|---------|----------|
| View list | Y | Y | Y | Y |
| Filter | Y | Y | Y | Y |
| Edit | Y | Y | Y | N |
| Clone | Y | Y | Y | N |
| Block | Y | Y | N | N |
| Check Price | Y | Y | N | N |
| Export Excel | Y | Y | Y | Y |

## Related Screens
- **CommercialProposal.jsp** - Edit screen (via row click or Edit button)
- **Contractor Edit** - View contractor details
- **Order Edit** - Select CP for import

## Session State
- Filter values stored in session-scoped form
- Grid state (page, sort) maintained in request

## Messages
| Key | Condition |
|-----|-----------|
| `commercial_proposal.blocked` | CP blocked successfully |
| `commercial_proposal.unblocked` | CP unblocked successfully |
| `commercial_proposal.clone.success` | CP cloned successfully |
| `error.commercial_proposal.not_found` | CP not found |
