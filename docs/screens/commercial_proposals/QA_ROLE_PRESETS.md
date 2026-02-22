# Commercial Proposals List Screen - QA ROLE PRESETS

## Overview
This document defines QA test presets for different user roles on the Commercial Proposals List screen.

---

## Role Definitions

| Role | Code | Description |
|------|------|-------------|
| Admin | `admin` | Full system access |
| Economist | `economist` | Financial operations access |
| Manager | `manager` | Sales management access |
| Logistic | `logistic` | Logistics operations access |

---

## Preset 1: Admin User

### User Configuration
```json
{
  "usr_id": "USR-TEST-001",
  "usr_name": "Test Admin",
  "usr_code": "TADM",
  "usr_role": "admin",
  "department": {"id": "DEP-001", "name": "Head Office"}
}
```

### Expected Permissions

#### Grid Actions
| Action | Available | Notes |
|--------|-----------|-------|
| View CP list | Yes | All CPs visible |
| Filter | Yes | All filters available |
| Edit CP | Yes | Opens edit form |
| Clone (New Version) | Yes | Creates new CP |
| Clone (Old Version) | Yes | Creates old format CP |
| Block | Yes | Toggles block status |
| Unblock | Yes | Toggles block status |
| Check Price | Yes | Price validation |
| Export Excel | Yes | Downloads file |

#### Filter Access
| Filter | Access |
|--------|--------|
| Number | Edit |
| Department | Edit |
| Contractor | Edit |
| User | Edit |
| Category | Edit |
| Date Range | Edit |
| Sum Range | Edit |
| Accepted | Edit |
| Declined | Edit |

### Test Checklist
- [ ] View all CPs in list
- [ ] Apply various filters
- [ ] Edit any CP
- [ ] Clone CP (new version)
- [ ] Clone CP (old version)
- [ ] Block/unblock CP
- [ ] Check price
- [ ] Export to Excel

---

## Preset 2: Economist User

### User Configuration
```json
{
  "usr_id": "USR-TEST-004",
  "usr_name": "Test Economist",
  "usr_code": "TECO",
  "usr_role": "economist",
  "department": {"id": "DEP-001", "name": "Head Office"}
}
```

### Expected Permissions

#### Grid Actions
| Action | Available | Notes |
|--------|-----------|-------|
| View CP list | Yes | All CPs visible |
| Filter | Yes | All filters available |
| Edit CP | Yes | Opens edit form |
| Clone (New Version) | Yes | Creates new CP |
| Clone (Old Version) | Yes | Creates old format CP |
| Block | Yes | Toggles block status |
| Unblock | Yes | Toggles block status |
| Check Price | Yes | Price validation |
| Export Excel | Yes | Downloads file |

### Test Checklist
- [ ] View all CPs in list
- [ ] Apply various filters
- [ ] Edit any CP
- [ ] Clone CP
- [ ] Block/unblock CP
- [ ] Check price
- [ ] Export to Excel

---

## Preset 3: Manager User

### User Configuration
```json
{
  "usr_id": "USR-TEST-002",
  "usr_name": "Test Manager",
  "usr_code": "TMGR",
  "usr_role": "manager",
  "department": {"id": "DEP-001", "name": "Head Office"}
}
```

### Expected Permissions

#### Grid Actions
| Action | Available | Notes |
|--------|-----------|-------|
| View CP list | Yes | All CPs visible |
| Filter | Yes | All filters available |
| Edit CP | Yes | Opens edit form |
| Clone (New Version) | Yes | Creates new CP |
| Clone (Old Version) | Yes | Creates old format CP |
| Block | **No** | Button hidden/disabled |
| Unblock | **No** | Button hidden/disabled |
| Check Price | **No** | Button hidden/disabled |
| Export Excel | Yes | Downloads file |

### Test Checklist
- [ ] View all CPs in list
- [ ] Apply various filters
- [ ] Edit any CP
- [ ] Clone CP
- [ ] Block button NOT visible
- [ ] Check price NOT visible
- [ ] Export to Excel

---

## Preset 4: Logistic User

### User Configuration
```json
{
  "usr_id": "USR-TEST-003",
  "usr_name": "Test Logistic",
  "usr_code": "TLOG",
  "usr_role": "logistic",
  "department": {"id": "DEP-001", "name": "Head Office"}
}
```

### Expected Permissions

#### Grid Actions
| Action | Available | Notes |
|--------|-----------|-------|
| View CP list | Yes | All CPs visible (readonly) |
| Filter | Yes | All filters available |
| Edit CP | **No** | Row click disabled |
| Clone (New Version) | **No** | Button hidden |
| Clone (Old Version) | **No** | Button hidden |
| Block | **No** | Button hidden |
| Unblock | **No** | Button hidden |
| Check Price | **No** | Button hidden |
| Export Excel | Yes | Downloads file |

### Test Checklist
- [ ] View all CPs in list
- [ ] Apply various filters
- [ ] Click on CP row - NOT allowed
- [ ] Edit button NOT visible
- [ ] Clone buttons NOT visible
- [ ] Block button NOT visible
- [ ] Export to Excel - allowed

---

## Action Visibility Matrix

| Action | Admin | Economist | Manager | Logistic |
|--------|-------|-----------|---------|----------|
| View List | Y | Y | Y | Y |
| Filter | Y | Y | Y | Y |
| Edit | Y | Y | Y | N |
| Clone (New) | Y | Y | Y | N |
| Clone (Old) | Y | Y | Y | N |
| Block | Y | Y | N | N |
| Unblock | Y | Y | N | N |
| Check Price | Y | Y | N | N |
| Export Excel | Y | Y | Y | Y |

---

## Row Interaction Matrix

| Interaction | Admin | Economist | Manager | Logistic |
|-------------|-------|-----------|---------|----------|
| Click number | Edit | Edit | Edit | No action |
| Click row | Edit | Edit | Edit | No action |
| Select checkbox | Yes | Yes | Yes | Yes |
| Bulk block | Yes | Yes | No | No |

---

## Filter Behavior (All Roles)

All roles have identical filter capabilities:

| Filter | Behavior |
|--------|----------|
| Number | Partial match, case-insensitive |
| Department | Dropdown selection |
| Contractor | ServerList autocomplete |
| User | ServerList autocomplete |
| Category | Dropdown selection |
| Date From | Date picker, >= comparison |
| Date To | Date picker, <= comparison |
| Sum From | Number input, >= comparison |
| Sum To | Number input, <= comparison |
| Accepted | Checkbox, = "1" filter |
| Declined | Checkbox, = "1" filter |

---

## Blocked CP Behavior

When viewing a blocked CP (`cpr_block = "1"`):

| Role | Can Edit | Can Clone | Can Unblock |
|------|----------|-----------|-------------|
| Admin | No (readonly) | Yes | Yes |
| Economist | No (readonly) | Yes | Yes |
| Manager | No (readonly) | Yes | No |
| Logistic | No (readonly) | No | No |

---

## Test Execution Matrix

| Test Case | Admin | Economist | Manager | Logistic |
|-----------|-------|-----------|---------|----------|
| Load list | Y | Y | Y | Y |
| Filter by contractor | Y | Y | Y | Y |
| Filter by date range | Y | Y | Y | Y |
| Filter by status | Y | Y | Y | Y |
| Clear filters | Y | Y | Y | Y |
| Edit CP | Y | Y | Y | N |
| Clone (new) | Y | Y | Y | N |
| Clone (old) | Y | Y | Y | N |
| Block CP | Y | Y | N | N |
| Unblock CP | Y | Y | N | N |
| Check price | Y | Y | N | N |
| Export Excel | Y | Y | Y | Y |

---

## QA Sign-Off Template

| Role | Tester | Date | Status | Notes |
|------|--------|------|--------|-------|
| Admin | | | [ ] Pass / [ ] Fail | |
| Economist | | | [ ] Pass / [ ] Fail | |
| Manager | | | [ ] Pass / [ ] Fail | |
| Logistic | | | [ ] Pass / [ ] Fail | |
