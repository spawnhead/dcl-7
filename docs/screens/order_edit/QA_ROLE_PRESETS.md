# Order Edit Screen - QA ROLE PRESETS

## Overview
This document defines QA test presets for different user roles on the Order Edit screen.
Each preset specifies the expected behavior and visible elements for that role.

---

## Role Definitions

| Role | Code | Description |
|------|------|-------------|
| Admin | `admin` | Full system access |
| Economist | `economist` | Financial operations access |
| Logistic | `logistic` | Logistics section access |
| Manager | `manager` | Sales management access |
| UserInLithuania | `user_lithuania` | Limited Lithuania office access |

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
| Produce Selection | Full Edit |
| Produces Grid | Full Edit |
| Logistic Section | Full Edit |
| Payment Conditions | Full Edit |
| Payments Grid | Full Edit |
| Pay Sums Grid | Full Edit |
| Additional Options | Full Edit |
| Covering Letter | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Button Visibility
| Button | Visible | Enabled (Unblocked) |
|--------|---------|---------------------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Select CP | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Executed Count | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can save order with empty produce (parent doc only)
- [x] Can edit `ord_annul` field
- [x] Can see admin-only fields
- [x] Can edit blocked order fields (via database)

### Test Checklist
- [ ] Create new order - all fields editable
- [ ] Edit existing order - all fields editable
- [ ] Save with empty produce - allowed
- [ ] Block/unblock order via annul
- [ ] View all sections in blocked order
- [ ] Add/edit/delete attachments
- [ ] Print order and letter
- [ ] All AJAX grids functional

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
| Produce Selection | Full Edit |
| Produces Grid | Full Edit |
| Logistic Section | Full Edit |
| Payment Conditions | Full Edit |
| Payments Grid | Full Edit |
| Pay Sums Grid | Full Edit |
| Additional Options | Full Edit |
| Covering Letter | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Button Visibility
| Button | Visible | Enabled (Unblocked) |
|--------|---------|---------------------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Select CP | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Executed Count | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can edit all financial fields
- [x] Can edit logistic section
- [x] Cannot save with empty produce (validation error)
- [x] Cannot edit `ord_annul` field

### Test Checklist
- [ ] Create new order - all fields editable
- [ ] Edit existing order - all fields editable
- [ ] Save with empty produce - NOT allowed
- [ ] Edit logistic dates
- [ ] Edit payment grids
- [ ] Add/edit/delete attachments
- [ ] Print order and letter

---

## Preset 3: Logistic User

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

#### Form Access
| Section | Access Level |
|---------|--------------|
| Header | Full Edit |
| Produce Selection | Readonly |
| Produces Grid | Readonly |
| Logistic Section | Full Edit |
| Payment Conditions | Full Edit |
| Payments Grid | Readonly |
| Pay Sums Grid | Readonly |
| Additional Options | Readonly (except delivery) |
| Covering Letter | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Button Visibility
| Button | Visible | Enabled (Unblocked) |
|--------|---------|---------------------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | No | - |
| Select CP | No | - |
| Import Excel | No | - |
| Upload Template | No | - |
| Executed Count | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can edit all logistic dates
- [x] Can edit `ord_arrive_in_lithuania`
- [x] Cannot edit produces grid
- [x] Cannot edit payment grids

### Test Checklist
- [ ] View order - produces readonly
- [ ] Edit logistic section - allowed
- [ ] Edit produces grid - NOT allowed
- [ ] Edit payment grids - NOT allowed
- [ ] Add attachment - allowed
- [ ] Print order and letter

---

## Preset 4: Manager User

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
| Produce Selection | Full Edit |
| Produces Grid | Full Edit |
| Logistic Section | Partial (sent_to_prod only) |
| Payment Conditions | Full Edit |
| Payments Grid | Full Edit |
| Pay Sums Grid | Full Edit |
| Additional Options | Full Edit |
| Covering Letter | Full Edit |
| Attachments | Full Edit |
| Print Parameters | Full Edit |

#### Logistic Section Detail
| Field | Access |
|-------|--------|
| ord_sent_to_prod_date | Edit |
| ord_received_conf_date | Readonly |
| ord_num_conf | Readonly |
| ord_date_conf | Readonly |
| ord_date_conf_all | Readonly |
| ord_conf_sent_date | Readonly |
| ord_ready_for_deliv_date | Readonly |
| ord_ready_for_deliv_date_all | Readonly |
| shippingDocType | Readonly |
| ord_shp_doc_number | Readonly |
| ord_ship_from_stock | Readonly |
| ord_arrive_in_lithuania | Readonly |
| ord_executed_date | Readonly |

#### Button Visibility
| Button | Visible | Enabled (Unblocked) |
|--------|---------|---------------------|
| Save | Yes | Yes |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | Yes | Yes |
| Select CP | Yes | Yes |
| Import Excel | Yes | Yes |
| Upload Template | Yes | Yes |
| Executed Count | Yes | Yes |
| Add Attachment | Yes | Yes |

#### Special Capabilities
- [x] Can edit produces grid
- [x] Can edit `ord_sent_to_prod_date`
- [x] Cannot edit other logistic dates
- [x] Can add attachments

### Test Checklist
- [ ] Create new order with produces
- [ ] Edit produces grid - allowed
- [ ] Edit ord_sent_to_prod_date - allowed
- [ ] Edit ord_received_conf_date - NOT allowed
- [ ] Add attachment - allowed
- [ ] Print order and letter

---

## Preset 5: UserInLithuania

### User Configuration
```json
{
  "usr_id": "USR-TEST-005",
  "usr_name": "Test User Lithuania",
  "usr_code": "TULT",
  "usr_role": "user_lithuania",
  "department": {"id": "DEP-002", "name": "Lithuania Office"}
}
```

### Expected Permissions

#### Form Access
| Section | Access Level |
|---------|--------------|
| Header | Readonly |
| Produce Selection | Readonly |
| Produces Grid | Readonly |
| Logistic Section | Partial (arrive_in_lithuania only) |
| Payment Conditions | Readonly |
| Payments Grid | Readonly |
| Pay Sums Grid | Readonly |
| Additional Options | Readonly |
| Covering Letter | Readonly |
| Attachments | Readonly |
| Print Parameters | Edit |

#### Logistic Section Detail
| Field | Access |
|-------|--------|
| ord_sent_to_prod_date | Readonly |
| ord_received_conf_date | Readonly |
| ord_num_conf | Readonly |
| ord_date_conf | Readonly |
| ord_date_conf_all | Readonly |
| ord_conf_sent_date | Readonly |
| ord_ready_for_deliv_date | Readonly |
| ord_ready_for_deliv_date_all | Readonly |
| shippingDocType | Readonly |
| ord_shp_doc_number | Readonly |
| ord_ship_from_stock | Readonly |
| ord_arrive_in_lithuania | **Edit** |
| ord_executed_date | Readonly |

#### Button Visibility
| Button | Visible | Enabled |
|--------|---------|---------|
| Save | No | - |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | No | - |
| Select CP | No | - |
| Import Excel | No | - |
| Upload Template | No | - |
| Executed Count | No | - |
| Add Attachment | No | - |

#### Special Capabilities
- [x] Can only view order (form readonly)
- [x] Can edit `ord_arrive_in_lithuania`
- [x] Can print order and letter
- [x] Can edit print parameters
- [x] Cannot add attachments

### Test Checklist
- [ ] View order - all fields readonly except arrive_in_lithuania
- [ ] Edit ord_arrive_in_lithuania - allowed
- [ ] Edit any other field - NOT allowed
- [ ] Add attachment - NOT allowed
- [ ] Print order - allowed
- [ ] Print letter - allowed

---

## Blocked Document Behavior (All Roles)

When `ord_block = "1"`:

| Role | Form Mode | Editable Fields |
|------|-----------|-----------------|
| Admin | Readonly | None (print only) |
| Economist | Readonly | None (print only) |
| Logistic | Readonly | None (print only) |
| Manager | Readonly | None (print only) |
| UserInLithuania | Readonly | None (print only) |

### Blocked Document Buttons

| Button | Visible | Enabled |
|--------|---------|---------|
| Save | No | - |
| Print | Yes | Yes |
| Print Letter | Yes | Yes |
| Cancel | Yes | Yes |
| Add Produce | No | - |
| Add Attachment | No | - |

---

## Test Execution Matrix

| Test Case | Admin | Economist | Logistic | Manager | UserInLithuania |
|-----------|-------|-----------|----------|---------|-----------------|
| Create new order | Y | Y | Y | Y | N |
| Edit header | Y | Y | Y | Y | N |
| Edit produces | Y | Y | N | Y | N |
| Edit logistic dates | Y | Y | Y | Partial | N |
| Edit ord_arrive_in_lithuania | Y | Y | Y | N | Y |
| Add attachment | Y | Y | Y | Y | N |
| Save with empty produce | Y | N | N | N | N |
| Edit blocked order | N | N | N | N | N |
| Print order | Y | Y | Y | Y | Y |
| Print letter | Y | Y | Y | Y | Y |

---

## QA Sign-Off Template

| Role | Tester | Date | Status | Notes |
|------|--------|------|--------|-------|
| Admin | | | [ ] Pass / [ ] Fail | |
| Economist | | | [ ] Pass / [ ] Fail | |
| Logistic | | | [ ] Pass / [ ] Fail | |
| Manager | | | [ ] Pass / [ ] Fail | |
| UserInLithuania | | | [ ] Pass / [ ] Fail | |
