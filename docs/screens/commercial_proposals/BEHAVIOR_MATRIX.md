# Commercial Proposals List Screen - BEHAVIOR MATRIX

## Overview
This matrix documents all behavioral variations of the Commercial Proposals List screen.

---

## 1. Filter Behavior Matrix

### 1.1 Filter Field Types

| Field | Type | Match Type | Default |
|-------|------|------------|---------|
| cpr_number | Text | Partial (LIKE %value%) | Empty |
| department | ServerList | Exact match | Empty |
| contractor | ServerList | Exact match | Empty |
| user | ServerList | Exact match | Empty |
| stuffCategory | ServerList | Exact match | Empty |
| cpr_date_from | Date | >= comparison | Empty |
| cpr_date_to | Date | <= comparison | Empty |
| cpr_sum_from | Number | >= comparison | Empty |
| cpr_sum_to | Number | <= comparison | Empty |
| cpr_proposal_received_flag | Checkbox | = "1" | Unchecked |
| cpr_proposal_declined | Checkbox | = "1" | Unchecked |

### 1.2 Filter Combination Logic

| Filter Combination | Logic |
|--------------------|-------|
| Multiple filters | AND |
| Date range | from <= date <= to |
| Sum range | from <= sum <= to |
| Status checkboxes | OR (if both checked) |

---

## 2. Grid Column Matrix

| Column | Field | Sortable | Type | Format |
|--------|-------|----------|------|--------|
| Number | cpr_number | Yes | Link | Text |
| Date | cpr_date | Yes | Text | dd.MM.yyyy |
| Contractor | cpr_contractor | Yes | Text | Contractor name |
| Sum | cprSumFormatted | Yes | Text | # ##0,00 CUR |
| Currency | cpr_currency | Yes | Text | Currency code |
| Category | cpr_stf_name | Yes | Text | Category name |
| Reserved | reservedState | No | Text | Status text |
| Block | cpr_block | No | Checkbox | Boolean |
| User | cpr_user | Yes | Text | User name |
| Department | cpr_department | Yes | Text | Department name |
| Check Price | cpr_check_price | No | Text | Indicator |

---

## 3. Row Action Matrix

### 3.1 By CP State

| Action | Unblocked | Blocked | Accepted | Declined |
|--------|-----------|---------|----------|----------|
| Edit | Y | Y (readonly) | Y | Y |
| Clone (New) | Y | Y | Y | Y |
| Clone (Old) | Y | Y | Y | Y |
| Block | Y | N | Y | Y |
| Unblock | N | Y | N | N |
| Check Price | Y | Y | Y | Y |
| Export Excel | Y | Y | Y | Y |

### 3.2 By User Role

| Action | Admin | Economist | Manager | Logistic |
|--------|-------|-----------|---------|----------|
| View | Y | Y | Y | Y |
| Edit | Y | Y | Y | N |
| Clone (New) | Y | Y | Y | N |
| Clone (Old) | Y | Y | Y | N |
| Block/Unblock | Y | Y | N | N |
| Check Price | Y | Y | N | N |
| Export Excel | Y | Y | Y | Y |

---

## 4. Clone Behavior Matrix

### 4.1 Clone as New Version

| Source Field | Cloned Value | Notes |
|--------------|--------------|-------|
| cpr_id | empty | New ID on save |
| cpr_number | empty | Generated on save |
| cpr_date | current date | Reset |
| cpr_old_version | empty | New format |
| contractor | copied | Preserved |
| produces | copied | DBO links preserved |
| cpr_block | empty | Unblocked |
| cpr_proposal_received_flag | "0" | Reset |
| cpr_proposal_declined | "0" | Reset |
| cpr_date_accept | empty | Reset |
| attachments | not copied | Must re-attach |

### 4.2 Clone as Old Version

| Source Field | Cloned Value | Notes |
|--------------|--------------|-------|
| cpr_id | empty | New ID on save |
| cpr_number | empty | Generated on save |
| cpr_date | current date | Reset |
| cpr_old_version | "1" | Old format |
| contractor | copied | Preserved |
| produces | converted | Free-text (no DBO links) |
| produce.lpr_produce_name | from DBO name | Copied |
| produce.lpr_catalog_num | from DBO catalog | Copied |
| produce.produce | empty | Link removed |
| cpr_block | empty | Unblocked |
| cpr_proposal_received_flag | "0" | Reset |
| cpr_proposal_declined | "0" | Reset |

---

## 5. Block State Matrix

| Current State | Action | New State | Side Effects |
|---------------|--------|-----------|--------------|
| Unblocked (null) | Block | "1" | CP readonly |
| Blocked ("1") | Unblock | null | CP editable |

---

## 6. Row Styling Matrix

| Condition | CSS Class | Visual Effect |
|-----------|-----------|---------------|
| cpr_block = "1" | blocked-row | Gray background |
| cpr_proposal_received_flag = "1" | accepted-row | Green background |
| cpr_proposal_declined = "1" | declined-row | Red background |
| Default | normal-row | White background |

**Priority**: declined > accepted > blocked > normal

---

## 7. Sort Behavior Matrix

| Column | Default Direction | Data Type |
|--------|-------------------|-----------|
| cpr_number | ASC | Text |
| cpr_date | DESC (default) | Date |
| cpr_contractor | ASC | Text |
| cprSumFormatted | DESC | Number |
| cpr_currency | ASC | Text |
| cpr_stf_name | ASC | Text |
| cpr_user | ASC | Text |
| cpr_department | ASC | Text |

---

## 8. Pagination Matrix

| Parameter | Default | Options |
|-----------|---------|---------|
| Page Size | 20 | 10, 20, 50, 100 |
| Current Page | 1 | 1..N |
| Total Pages | Calculated | Based on count |

---

## 9. Export Behavior Matrix

| Export Field | Source | Format |
|--------------|--------|--------|
| Number | cpr_number | Text |
| Date | cpr_date | dd.MM.yyyy |
| Contractor | cpr_contractor | Text |
| Sum | cprSumFormatted | Number |
| Currency | cpr_currency | Text |
| Category | cpr_stf_name | Text |
| Reserved | reservedState | Text |
| Block | cpr_block | Yes/No |
| User | cpr_user | Text |
| Department | cpr_department | Text |

---

## 10. Error Handling Matrix

| Error Condition | Response | User Message |
|-----------------|----------|--------------|
| No results | Empty grid | "No results found" |
| Database error | Error page | "System error. Please try again." |
| Permission denied | Stay on page | "Access denied" |
| CP not found | List page | "CP not found" |
| Export failed | Stay on page | "Export failed. Please try again." |

---

## 11. Session State Matrix

| Key | Set By | Used By | Cleared By |
|-----|--------|---------|------------|
| CommercialProposalsForm | input, filter | Grid render | Session timeout |
| Filter values | filter | Grid query | input (clear) |
| Page number | pagination | Grid query | input (clear) |
| Sort column | sort click | Grid query | input (clear) |

---

## 12. Navigation Matrix

| From | Action | To |
|------|--------|-----|
| CP List | Click number | CP Edit |
| CP List | Edit button | CP Edit |
| CP List | Clone (New) | CP Edit (new) |
| CP List | Clone (Old) | CP Edit (new) |
| CP Edit | Save | CP List |
| CP Edit | Cancel | CP List |
| Order Edit | Select CP | CP List (select mode) |
| CP List (select) | Select row | Order Edit |
