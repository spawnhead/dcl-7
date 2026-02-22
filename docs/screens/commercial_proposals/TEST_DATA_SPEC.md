# Commercial Proposals List Screen - TEST DATA SPECIFICATION

## Overview
This document specifies deterministic test data for Commercial Proposals List screen testing.
All data is designed for PostgreSQL target database.

---

## 1. Reference Data (Prerequisites)

Uses same reference data as Order Edit screen:
- Users (USR-TEST-001 through USR-TEST-005)
- Departments (DEP-001, DEP-002)
- Currencies (CUR-EUR, CUR-BYN, CUR-USD)
- Contractors (CNT-001, CNT-002, CNT-003)
- Contact Persons (CPS-001, CPS-002, CPS-003)
- Sellers (SLL-001, SLL-002)
- Stuff Categories (STC-001, STC-002, STC-003)
- Produces (PRD-001, PRD-002, PRD-003)
- IncoTerms (INC-EXW, INC-DDP, INC-FCA)
- Blanks (BLN-001, BLN-002)

---

## 2. Commercial Proposal Test Data

### 2.1 Basic CPs for List Display

```sql
-- CP 1: Unblocked, not accepted
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_block, cpr_old_version)
VALUES 
  ('CPR-001', 'BYM2602/0001-TMGR', '01.02.2026', 'CNT-001', 
   'CUR-EUR', 5000.00, 'USR-TEST-002', 
   'DEP-001', NULL, '');

-- CP 2: Blocked
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_block)
VALUES 
  ('CPR-002', 'BYM2602/0002-TMGR', '02.02.2026', 'CNT-002', 
   'CUR-EUR', 3000.00, 'USR-TEST-002', 
   'DEP-001', '1');

-- CP 3: Accepted
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_proposal_received_flag, 
                                    cpr_date_accept)
VALUES 
  ('CPR-003', 'BYM2602/0003-TMGR', '03.02.2026', 'CNT-001', 
   'CUR-EUR', 7500.00, 'USR-TEST-002', 
   'DEP-001', '1', '05.02.2026');

-- CP 4: Declined
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_proposal_declined)
VALUES 
  ('CPR-004', 'BYM2602/0004-TMGR', '04.02.2026', 'CNT-003', 
   'CUR-EUR', 2000.00, 'USR-TEST-002', 
   'DEP-001', '1');

-- CP 5: Old version format
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_old_version)
VALUES 
  ('CPR-005', 'BYM2601/0005-TLOG', '15.01.2026', 'CNT-002', 
   'CUR-BYN', 10000.00, 'USR-TEST-003', 
   'DEP-001', '1');

-- CP 6: Different department
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id)
VALUES 
  ('CPR-006', 'BYM2602/0006-TULT', '05.02.2026', 'CNT-001', 
   'CUR-USD', 1500.00, 'USR-TEST-005', 
   'DEP-002');

-- CP 7: Minsk store assemble
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_assemble_minsk_store)
VALUES 
  ('CPR-007', 'BYM2602/0007-TMGR', '06.02.2026', 'CNT-002', 
   'CUR-BYN', 8000.00, 'USR-TEST-002', 
   'DEP-001', '1');

-- CP 8: Free prices
INSERT INTO dcl_commercial_proposal (cpr_id, cpr_number, cpr_date, cpr_cnt_id, 
                                    cpr_currency_id, cpr_summ, cpr_user_id, 
                                    cpr_department_id, cpr_free_prices)
VALUES 
  ('CPR-008', 'BYM2602/0008-TECO', '07.02.2026', 'CNT-001', 
   'CUR-EUR', 4500.00, 'USR-TEST-004', 
   'DEP-001', '1');
```

### 2.2 CP Produces

```sql
-- CP 1 produces
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-001', 'CPR-001', 'PRD-001', 10, 500.00, '1'),
  ('LPC-002', 'CPR-001', 'PRD-002', 5, 200.00, '2');

-- CP 2 produces
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-003', 'CPR-002', 'PRD-003', 2, 1500.00, '1');

-- CP 3 produces
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpc_prd_id, 
                                            lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-004', 'CPR-003', 'PRD-001', 15, 500.00, '1');

-- CP 5 produces (old version - free text)
INSERT INTO dcl_commercial_proposal_produce (lpc_id, lpc_cpr_id, lpr_produce_name, 
                                            lpr_catalog_num, lpr_count, lpr_price_brutto, lpr_number)
VALUES 
  ('LPC-005', 'CPR-005', 'Custom Product A', 'CUST-001', 20, 500.00, '1');
```

---

## 3. Test Scenarios

### 3.1 Scenario: Display All CPs

**Purpose**: Test initial list load

**Expected Grid State**:
```json
{
  "totalRows": 8,
  "columns": ["Number", "Date", "Contractor", "Sum", "Currency", "Category", "Reserved", "Block", "User", "Department"],
  "rows": [
    {"cpr_number": "BYM2602/0008-TECO", "cpr_date": "07.02.2026", "cpr_contractor": "Test Contractor Alpha", "cpr_summ": "4 500,00", "cpr_currency": "EUR"},
    {"cpr_number": "BYM2602/0007-TMGR", "cpr_date": "06.02.2026", "cpr_contractor": "Test Contractor Beta", "cpr_summ": "8 000,00", "cpr_currency": "BYN"},
    {"cpr_number": "BYM2602/0006-TULT", "cpr_date": "05.02.2026", "cpr_contractor": "Test Contractor Alpha", "cpr_summ": "1 500,00", "cpr_currency": "USD"},
    {"cpr_number": "BYM2602/0004-TMGR", "cpr_date": "04.02.2026", "cpr_contractor": "Test Contractor For", "cpr_summ": "2 000,00", "cpr_currency": "EUR"},
    {"cpr_number": "BYM2602/0003-TMGR", "cpr_date": "03.02.2026", "cpr_contractor": "Test Contractor Alpha", "cpr_summ": "7 500,00", "cpr_currency": "EUR"},
    {"cpr_number": "BYM2602/0002-TMGR", "cpr_date": "02.02.2026", "cpr_contractor": "Test Contractor Beta", "cpr_summ": "3 000,00", "cpr_currency": "EUR"},
    {"cpr_number": "BYM2602/0001-TMGR", "cpr_date": "01.02.2026", "cpr_contractor": "Test Contractor Alpha", "cpr_summ": "5 000,00", "cpr_currency": "EUR"},
    {"cpr_number": "BYM2601/0005-TLOG", "cpr_date": "15.01.2026", "cpr_contractor": "Test Contractor Beta", "cpr_summ": "10 000,00", "cpr_currency": "BYN"}
  ]
}
```

### 3.2 Scenario: Filter by Contractor

**Input**: contractor.id = CNT-001

**Expected Grid State**:
```json
{
  "totalRows": 4,
  "rows": [
    {"cpr_number": "BYM2602/0008-TECO", "cpr_contractor": "Test Contractor Alpha"},
    {"cpr_number": "BYM2602/0006-TULT", "cpr_contractor": "Test Contractor Alpha"},
    {"cpr_number": "BYM2602/0003-TMGR", "cpr_contractor": "Test Contractor Alpha"},
    {"cpr_number": "BYM2602/0001-TMGR", "cpr_contractor": "Test Contractor Alpha"}
  ]
}
```

### 3.3 Scenario: Filter by Date Range

**Input**: cpr_date_from = 01.02.2026, cpr_date_to = 05.02.2026

**Expected Grid State**:
```json
{
  "totalRows": 5,
  "rows": [
    {"cpr_number": "BYM2602/0006-TULT", "cpr_date": "05.02.2026"},
    {"cpr_number": "BYM2602/0004-TMGR", "cpr_date": "04.02.2026"},
    {"cpr_number": "BYM2602/0003-TMGR", "cpr_date": "03.02.2026"},
    {"cpr_number": "BYM2602/0002-TMGR", "cpr_date": "02.02.2026"},
    {"cpr_number": "BYM2602/0001-TMGR", "cpr_date": "01.02.2026"}
  ]
}
```

### 3.4 Scenario: Filter by Accepted Status

**Input**: cpr_proposal_received_flag = 1

**Expected Grid State**:
```json
{
  "totalRows": 1,
  "rows": [
    {"cpr_number": "BYM2602/0003-TMGR", "cpr_proposal_received_flag": "1"}
  ]
}
```

### 3.5 Scenario: Filter by Declined Status

**Input**: cpr_proposal_declined = 1

**Expected Grid State**:
```json
{
  "totalRows": 1,
  "rows": [
    {"cpr_number": "BYM2602/0004-TMGR", "cpr_proposal_declined": "1"}
  ]
}
```

### 3.6 Scenario: Filter by Sum Range

**Input**: cpr_sum_from = 3000, cpr_sum_to = 8000

**Expected Grid State**:
```json
{
  "totalRows": 4,
  "rows": [
    {"cpr_number": "BYM2602/0007-TMGR", "cpr_summ": "8 000,00"},
    {"cpr_number": "BYM2602/0003-TMGR", "cpr_summ": "7 500,00"},
    {"cpr_number": "BYM2602/0001-TMGR", "cpr_summ": "5 000,00"},
    {"cpr_number": "BYM2602/0002-TMGR", "cpr_summ": "3 000,00"}
  ]
}
```

---

## 4. Clone Test Scenarios

### 4.1 Clone as New Version

**Source**: CPR-001

**Expected Cloned CP**:
```json
{
  "cpr_id": "",
  "cpr_number": "",
  "cpr_date": "12.02.2026",
  "contractor": {"id": "CNT-001"},
  "cpr_old_version": "",
  "cpr_block": "",
  "produces": [
    {"lpc_prd_id": "PRD-001", "lpr_count": 10, "lpr_price_brutto": 500.00},
    {"lpc_prd_id": "PRD-002", "lpr_count": 5, "lpr_price_brutto": 200.00}
  ]
}
```

### 4.2 Clone as Old Version

**Source**: CPR-001

**Expected Cloned CP**:
```json
{
  "cpr_id": "",
  "cpr_number": "",
  "cpr_date": "12.02.2026",
  "contractor": {"id": "CNT-001"},
  "cpr_old_version": "1",
  "cpr_block": "",
  "produces": [
    {"lpr_produce_name": "Laptop Dell Inspiron 15", "lpr_catalog_num": "DELL-INS-15-001", "lpr_count": 10, "lpr_price_brutto": 500.00, "lpc_prd_id": null},
    {"lpr_produce_name": "Office Chair Ergonomic", "lpr_catalog_num": "CHR-ERG-002", "lpr_count": 5, "lpr_price_brutto": 200.00, "lpc_prd_id": null}
  ]
}
```

---

## 5. Block/Unblock Test Scenarios

### 5.1 Block CP

**Source**: CPR-001 (unblocked)

**Action**: Block

**Expected State**:
```json
{
  "cpr_id": "CPR-001",
  "cpr_block": "1"
}
```

### 5.2 Unblock CP

**Source**: CPR-002 (blocked)

**Action**: Unblock

**Expected State**:
```json
{
  "cpr_id": "CPR-002",
  "cpr_block": null
}
```

---

## 6. Role-Based Test Scenarios

### 6.1 Admin User

**User**: USR-TEST-001 (Admin)

| Test | Expected Result |
|------|-----------------|
| View all CPs | All 8 CPs visible |
| Edit any CP | Allowed |
| Block/Unblock | Allowed |
| Check Price | Allowed |
| Export Excel | Allowed |

### 6.2 Manager User

**User**: USR-TEST-002 (Manager)

| Test | Expected Result |
|------|-----------------|
| View all CPs | All 8 CPs visible |
| Edit CP | Allowed |
| Block/Unblock | NOT allowed |
| Check Price | NOT allowed |
| Export Excel | Allowed |

### 6.3 Logistic User

**User**: USR-TEST-003 (Logistic)

| Test | Expected Result |
|------|-----------------|
| View all CPs | All 8 CPs visible |
| Edit CP | NOT allowed |
| Block/Unblock | NOT allowed |
| Check Price | NOT allowed |
| Export Excel | Allowed |

---

## 7. Row Styling Test

| CP ID | Condition | Expected CSS Class |
|-------|-----------|-------------------|
| CPR-001 | Default | normal-row |
| CPR-002 | Blocked | blocked-row |
| CPR-003 | Accepted | accepted-row |
| CPR-004 | Declined | declined-row |

---

## 8. Cleanup Script

```sql
-- Cleanup test data
DELETE FROM dcl_commercial_proposal_produce WHERE lpc_cpr_id LIKE 'CPR-%';
DELETE FROM dcl_commercial_proposal WHERE cpr_id LIKE 'CPR-%';
```

---

## 9. Test Execution Order

1. **Setup**: Run reference data (if not exists)
2. **Setup**: Run CP test data (Section 2)
3. **Test 3.1**: Display all CPs
4. **Test 3.2**: Filter by contractor
5. **Test 3.3**: Filter by date range
6. **Test 3.4**: Filter by accepted
7. **Test 3.5**: Filter by declined
8. **Test 3.6**: Filter by sum range
9. **Test 4.1**: Clone as new version
10. **Test 4.2**: Clone as old version
11. **Test 5.1**: Block CP
12. **Test 5.2**: Unblock CP
13. **Test 6.x**: Role-based tests
14. **Test 7**: Row styling
15. **Cleanup**: Run cleanup script
