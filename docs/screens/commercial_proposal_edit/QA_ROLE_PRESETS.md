# Commercial Proposal Edit Screen - QA ROLE PRESETS

## Overview
This document defines QA test presets for different user roles on the Commercial Proposal Edit screen.

---

## Role Definitions

| Role | Code | Description |
|------|------|-------------|
| Admin | `admin` | Full system access |
| Economist | `economist` | Financial operations access |
| Manager | `manager` | Sales management access |

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

#### Form Access
| Section | Access Level |
|---------|--------------|
| Header | Full Edit |
| Currency | Full Edit |
| Mode Flags | Full Edit |
| Produces Grid | Full Edit |
| Price/Delivery | Full Edit |
| Minsk Specific | Full Edit |
| Additional Info | Full Edit |
| Status | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Button Visibility
| Button | Visible | Enabled |
|--------|---------|---------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Invoice | Yes* | Yes* |
| Print Contract | Yes* | Yes* |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Add Attachment | Yes | Yes |

*Print Invoice/Contract: Only if conditions met

#### Special Capabilities
- [x] Can edit all fields
- [x] Can print invoice (if conditions met)
- [x] Can see admin-only fields
- [x] Can toggle no_reservation in Minsk mode

### Test Checklist
- [ ] Create new CP - all fields editable
- [ ] Edit existing CP - all fields editable
- [ ] Toggle Minsk store mode
- [ ] Toggle Old version mode
- [ ] Add/edit/delete produces
- [ ] Print CP
- [ ] Print Invoice (if conditions met)
- [ ] Print Contract (if conditions met)
- [ ] Add attachments

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

#### Form Access
| Section | Access Level |
|---------|--------------|
| Header | Full Edit |
| Currency | Full Edit |
| Mode Flags | Full Edit |
| Produces Grid | Full Edit |
| Price/Delivery | Full Edit |
| Minsk Specific | Full Edit |
| Additional Info | Full Edit |
| Status | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Button Visibility
| Button | Visible | Enabled |
|--------|---------|---------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Invoice | Yes* | Yes* |
| Print Contract | Yes* | Yes* |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can edit all fields
- [x] Can print invoice (if conditions met)
- [x] Can toggle no_reservation in Minsk mode

### Test Checklist
- [ ] Create new CP - all fields editable
- [ ] Edit existing CP - all fields editable
- [ ] Print Invoice (if conditions met)
- [ ] Add attachments

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

#### Form Access
| Section | Access Level |
|---------|--------------|
| Header | Full Edit |
| Currency | Full Edit |
| Mode Flags | Full Edit |
| Produces Grid | Full Edit |
| Price/Delivery | Full Edit |
| Minsk Specific | Full Edit |
| Additional Info | Full Edit |
| Status | Partial Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Status Section Detail
| Field | Access |
|-------|--------|
| cpr_date_accept | Edit |
| cpr_proposal_received_flag | Edit |
| cpr_proposal_declined | Edit |
| cpr_tender_number | Edit |
| cpr_tender_number_editable | Edit |
| cpr_block | **Readonly** |

#### Button Visibility
| Button | Visible | Enabled |
|--------|---------|---------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Invoice | **No** | - |
| Print Contract | **No** | - |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can edit most fields
- [x] Cannot block/unblock CP
- [x] Cannot print invoice/contract
- [x] Can toggle no_reservation if creator or same dept

### Test Checklist
- [ ] Create new CP - all fields editable
- [ ] Edit existing CP - most fields editable
- [ ] Block field - NOT editable
- [ ] Print Invoice button - NOT visible
- [ ] Add attachments

---

## Minsk Store Mode Access Matrix

| Field | Admin | Economist | Manager (Creator) | Manager (Other) |
|-------|-------|-----------|-------------------|-----------------|
| cpr_no_reservation | Edit | Edit | Edit | Readonly |
| All locked fields | Readonly | Readonly | Readonly | Readonly |

---

## Print Invoice Access Matrix

| Condition | Admin | Economist | Manager |
|-----------|-------|-----------|---------|
| currencyTable != BYN, currency = BYN, coef >= 1.15, course >= recommended | Yes | Yes | No |
| currencyTable = BYN, currency = BYN, coef >= 1.25, course = 1 | Yes | Yes | No |
| cpr_nds_by_string = "1" required | Yes | Yes | N/A |

---

## Blocked CP Behavior

When `cpr_block = "1"`:

| Role | Form Mode | Editable Fields |
|------|-----------|-----------------|
| Admin | Readonly | None (print only) |
| Economist | Readonly | None (print only) |
| Manager | Readonly | None (print only) |

---

## Test Execution Matrix

| Test Case | Admin | Economist | Manager |
|-----------|-------|-----------|---------|
| Create new CP | Y | Y | Y |
| Edit header | Y | Y | Y |
| Edit currency | Y | Y | Y |
| Toggle Minsk mode | Y | Y | Y |
| Toggle Old version | Y | Y | Y |
| Add produce | Y | Y | Y |
| Edit produce | Y | Y | Y |
| Delete produce | Y | Y | Y |
| Import Excel | Y | Y | Y |
| Edit status | Y | Y | Y |
| Block CP | Y | Y | N |
| Print CP | Y | Y | Y |
| Print Invoice | Y* | Y* | N |
| Print Contract | Y* | Y* | N |
| Add attachment | Y | Y | Y |
| Toggle no_reservation (Minsk) | Y | Y | Y** |

*If conditions met
**If creator or same department

---

## QA Sign-Off Template

| Role | Tester | Date | Status | Notes |
|------|--------|------|--------|-------|
| Admin | | | [ ] Pass / [ ] Fail | |
| Economist | | | [ ] Pass / [ ] Fail | |
| Manager | | | [ ] Pass / [ ] Fail | |
