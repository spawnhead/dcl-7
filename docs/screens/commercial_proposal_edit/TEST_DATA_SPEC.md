# Commercial Proposal Edit Screen - TEST DATA SPECIFICATION

## Overview
This document specifies deterministic test data for Commercial Proposal Edit screen testing.
Uses same reference data as Commercial Proposals List screen.

---

## 1. CP Test Scenarios

### 1.1 Scenario: New CP (Empty)

**Purpose**: Test new CP creation form initialization

**Expected Form State**:
```json
{
  "is_new_doc": "true",
  "cpr_id": "",
  "cpr_number": "",
  "cpr_date": "12.02.2026",
  "cpr_final_date": "12.02.2026",
  "currency": {"id": "CUR-EUR", "name": "EUR"},
  "currencyTable": {"id": "CUR-EUR", "name": "EUR"},
  "cpr_course": 1,
  "cpr_nds": 20,
  "cpr_nds_by_string": "",
  "cpr_free_prices": "",
  "cpr_reverse_calc": "",
  "cpr_old_version": "",
  "cpr_assemble_minsk_store": "",
  "show_unit": "1",
  "cpr_all_transport": "1",
  "cpr_donot_calculate_netto": "1",
  "cpr_final_date_above": "1",
  "cpr_prepay_percent": "100",
  "user": {"usr_id": "USR-TEST-002"},
  "produces": [],
  "formReadOnly": false
}
```

### 1.2 Scenario: Edit Existing CP

**Test Data**:
```sql
-- Regular CP
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_currency_table_id, cpr_course,
                                    cpr_nds, cpr_summ, cpr_user_id, cpr_old_version)
VALUES 
  ('CPR-EDIT-001', 'BYM2602/0001-TMGR', '12.02.2026', 'CNT-001', 
   'CUR-EUR', 'CUR-EUR', 1, 20, 5000.00, 'USR-TEST-002', '');

-- CP produces
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-EDIT-001', 'CPR-EDIT-001', 'PRD-001', 10, 500.00, '1');
```

**Expected Form State**:
```json
{
  "is_new_doc": "",
  "cpr_id": "CPR-EDIT-001",
  "cpr_number": "BYM2602/0001-TMGR",
  "cpr_date": "12.02.2026",
  "contractor": {"id": "CNT-001", "name": "Test Contractor Alpha"},
  "currency": {"id": "CUR-EUR"},
  "cpr_course": 1,
  "produces": [
    {
      "number": "1",
      "produce": {"id": "PRD-001", "fullName": "Laptop Dell Inspiron 15"},
      "lpr_count": 10,
      "lpr_price_brutto": 500.00
    }
  ],
  "formReadOnly": false
}
```

### 1.3 Scenario: Minsk Store CP

**Test Data**:
```sql
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_currency_table_id, cpr_course,
                                    cpr_nds, cpr_summ, cpr_user_id, cpr_assemble_minsk_store,
                                    cpr_guaranty_in_month, cpr_prepay_percent, cpr_delay_days)
VALUES 
  ('CPR-MINSK-001', 'BYM2602/0002-TMGR', '12.02.2026', 'CNT-002', 
   'CUR-BYN', 'CUR-BYN', 1, 20, 8000.00, 'USR-TEST-002', '1',
   12, 50, 30);

-- Minsk store produces (from produce_cost_produce)
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_number, lpc_cost_one_by, lpc_price_list_by)
VALUES 
  ('LPC-MINSK-001', 'CPR-MINSK-001', 'PRD-001', 5, '1', 2000.00, 2500.00);
```

**Expected Form State**:
```json
{
  "cpr_id": "CPR-MINSK-001",
  "cpr_assemble_minsk_store": "1",
  "currency": {"id": "CUR-BYN"},
  "currencyTable": {"id": "CUR-BYN"},
  "cpr_course": 1,
  "priceCondition": {"id": "INC-DDP"},
  "deliveryCondition": {"id": "INC-DDP"},
  "cpr_nds_by_string": "1",
  "cpr_guaranty_in_month": "12",
  "cpr_prepay_percent": "50",
  "cpr_delay_days": "30",
  "readOnlyForAssembleMinsk": true
}
```

### 1.4 Scenario: Old Version CP

**Test Data**:
```sql
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, cpr_old_version)
VALUES 
  ('CPR-OLD-001', 'BYM2601/0001-TLOG', '15.01.2026', 'CNT-001', 
   'CUR-EUR', 3000.00, 'USR-TEST-003', '1');

-- Old version produces (free text)
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpr_produce_name, 
                                            lpr_catalog_num, lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-OLD-001', 'CPR-OLD-001', 'Custom Product XYZ', 'CUST-XYZ-001', 3, 1000.00, '1');
```

**Expected Form State**:
```json
{
  "cpr_id": "CPR-OLD-001",
  "cpr_old_version": "1",
  "produces": [
    {
      "number": "1",
      "lpr_produce_name": "Custom Product XYZ",
      "lpr_catalog_num": "CUST-XYZ-001",
      "produce": null,
      "lpr_count": 3,
      "lpr_price_brutto": 1000.00
    }
  ]
}
```

---

## 2. Validation Test Scenarios

### 2.1 Course Validation

| Test | Input | Expected Error |
|------|-------|----------------|
| Empty course | cpr_course = "" | error.commercial.course |
| Zero course | cpr_course = 0 | error.commercial.course |

### 2.2 Date Validation

| Test | Input | Expected Error |
|------|-------|----------------|
| Final before CP date | cpr_date = 12.02, cpr_final_date = 01.02 | error.commercial.final_date |
| Accept before CP date | cpr_date = 12.02, cpr_date_accept = 01.02 | error.commercial.date_accept |
| Accepted but no date | cpr_proposal_received_flag = "1", cpr_date_accept = "" | error.commercial.accepted |

### 2.3 Tender Validation

| Test | Input | Expected Error |
|------|-------|----------------|
| Tender editable but empty | cpr_tender_number_editable = "1", cpr_tender_number = "" | error.commercial.tender |

### 2.4 Produce Validation

| Test | Input | Expected Error |
|------|-------|----------------|
| Empty produce (not old) | produces[0].produce = null, cpr_old_version = "" | error.commercial.cpr_null_produce |
| Empty produce (old version) | produces[0].produce = null, cpr_old_version = "1" | No error |

### 2.5 DDP Validation

| Test | Input | Expected Error |
|------|-------|----------------|
| DDP without custom code | deliveryCondition = DDP, code = "" | error.commercial.DDP |
| DDP Minsk store | deliveryCondition = DDP, cpr_assemble_minsk_store = "1", code = "" | No error |

### 2.6 Reservation Validation (Minsk)

| Test | Input | Expected Error |
|------|-------|----------------|
| Count exceeds rest | lpr_count = 100, rest_lpc_count = 50 | error.commercial.cpr_reserved_error |
| No reservation flag | cpr_no_reservation = "1" | No validation |

---

## 3. Print Invoice Test Scenarios

### 3.1 Case 1: Foreign Currency Table

**Test Data**:
```sql
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_currency_table_id, cpr_course,
                                    cpr_nds_by_string, cpr_user_id)
VALUES 
  ('CPR-INV-001', 'BYM2602/0003-TECO', '12.02.2026', 'CNT-001', 
   'CUR-BYN', 'CUR-EUR', 3.50, '1', 'USR-TEST-004');

-- Produce with coefficient >= 1.15
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_coeficient)
VALUES 
  ('LPC-INV-001', 'CPR-INV-001', 'PRD-001', 10, 500.00, 1.20);
```

**Expected**: Print Invoice button visible

### 3.2 Case 2: BYN Currency Table

**Test Data**:
```sql
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_currency_table_id, cpr_course,
                                    cpr_nds_by_string, cpr_user_id)
VALUES 
  ('CPR-INV-002', 'BYM2602/0004-TECO', '12.02.2026', 'CNT-001', 
   'CUR-BYN', 'CUR-BYN', 1, '1', 'USR-TEST-004');

-- Produce with coefficient >= 1.25
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_coeficient)
VALUES 
  ('LPC-INV-002', 'CPR-INV-002', 'PRD-001', 10, 500.00, 1.30);
```

**Expected**: Print Invoice button visible

---

## 4. Clone Test Scenarios

### 4.1 Clone as New Version

**Source**: CPR-EDIT-001

**Expected Cloned CP**:
```json
{
  "cpr_id": "",
  "cpr_number": "",
  "cpr_date": "12.02.2026",
  "cpr_old_version": "",
  "contractor": {"id": "CNT-001"},
  "produces": [
    {"lpc_prd_id": "PRD-001", "lpr_count": 10, "lpr_price_brutto": 500.00}
  ]
}
```

### 4.2 Clone as Old Version

**Source**: CPR-EDIT-001

**Expected Cloned CP**:
```json
{
  "cpr_id": "",
  "cpr_number": "",
  "cpr_date": "12.02.2026",
  "cpr_old_version": "1",
  "produces": [
    {
      "lpr_produce_name": "Laptop Dell Inspiron 15",
      "lpr_catalog_num": "DELL-INS-15-001",
      "lpc_prd_id": null,
      "lpr_count": 10,
      "lpr_price_brutto": 500.00
    }
  ]
}
```

---

## 5. AJAX Grid Test Data

### 5.1 Regular Produces Grid

**Initial State**:
```json
{
  "produces": [
    {"number": "1", "produce": {"id": "PRD-001"}, "lpr_count": 10, "lpr_price_brutto": 500.00}
  ]
}
```

**After Add**:
```json
{
  "produces": [
    {"number": "1", "produce": {"id": "PRD-001"}, "lpr_count": 10, "lpr_price_brutto": 500.00},
    {"number": "2", "produce": {"id": "PRD-002"}, "lpr_count": 5, "lpr_price_brutto": 200.00}
  ]
}
```

**After Delete (row 1)**:
```json
{
  "produces": [
    {"number": "1", "produce": {"id": "PRD-002"}, "lpr_count": 5, "lpr_price_brutto": 200.00}
  ]
}
```

### 5.2 Minsk Store Grid

**Initial State**:
```json
{
  "produces": [
    {"number": "1", "produce": {"id": "PRD-001"}, "lpr_count": 5, "sale_price_parking_trans_custom": 2500.00}
  ]
}
```

**After Price Change**:
```json
{
  "produces": [
    {"number": "1", "produce": {"id": "PRD-001"}, "lpr_count": 5, "sale_price_parking_trans_custom": 2800.00}
  ]
}
```

---

## 6. Role-Based Test Scenarios

### 6.1 Manager Role

**User**: USR-TEST-002 (Manager)

| Test | Expected Result |
|------|-----------------|
| Edit all fields | Allowed |
| Print CP | Allowed |
| Print Invoice | NOT allowed (unless conditions met) |
| Block CP | NOT allowed |

### 6.2 Admin/Economist Role

**User**: USR-TEST-004 (Economist)

| Test | Expected Result |
|------|-----------------|
| Edit all fields | Allowed |
| Print CP | Allowed |
| Print Invoice | Allowed (if conditions met) |
| Block CP | Allowed |

---

## 7. Cleanup Script

```sql
-- Cleanup test data
DELETE FROM dcl_commercial_proposal_produce WHERE lpc_cpr_id LIKE 'CPR-%';
DELETE FROM dcl_commercial_proposal WHERE cpr_id LIKE 'CPR-%';
```

---

## 8. Test Execution Order

1. **Setup**: Run reference data (if not exists)
2. **Test 1.1**: New CP form initialization
3. **Test 1.2**: Edit existing CP
4. **Test 1.3**: Minsk store CP
5. **Test 1.4**: Old version CP
6. **Test 2.x**: Validation tests
7. **Test 3.x**: Print invoice tests
8. **Test 4.x**: Clone tests
9. **Test 5.x**: AJAX grid tests
10. **Test 6.x**: Role-based tests
11. **Cleanup**: Run cleanup script
