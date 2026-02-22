# Order Edit Screen - TEST DATA SPECIFICATION

## Overview
This document specifies deterministic test data for Order Edit screen testing.
All data is designed for PostgreSQL target database.

---

## 1. Reference Data (Prerequisites)

### 1.1 Users

```sql
-- Admin user (full access)
INSERT INTO dcl_user (usr_id, usr_name, usr_code, usr_password, usr_role, usr_department_id)
VALUES 
  ('USR-TEST-001', 'Test Admin', 'TADM', 'hashed_pwd', 'admin', 'DEP-001'),
  ('USR-TEST-002', 'Test Manager', 'TMGR', 'hashed_pwd', 'manager', 'DEP-001'),
  ('USR-TEST-003', 'Test Logistic', 'TLOG', 'hashed_pwd', 'logistic', 'DEP-001'),
  ('USR-TEST-004', 'Test Economist', 'TECO', 'hashed_pwd', 'economist', 'DEP-001'),
  ('USR-TEST-005', 'Test User Lithuania', 'TULT', 'hashed_pwd', 'user_lithuania', 'DEP-002');

-- Director/Logist defaults (from config)
INSERT INTO dcl_user (usr_id, usr_name, usr_code, usr_password, usr_role)
VALUES 
  ('USR-DIR-001', 'Default Director', 'DIR', 'hashed_pwd', 'director'),
  ('USR-LOG-001', 'Default Logist', 'LOG', 'hashed_pwd', 'logistic'),
  ('USR-DIRRB-001', 'Default Director RB', 'DIRRB', 'hashed_pwd', 'director_rb');
```

### 1.2 Departments

```sql
INSERT INTO dcl_department (dep_id, dep_name)
VALUES 
  ('DEP-001', 'Head Office'),
  ('DEP-002', 'Lithuania Office');
```

### 1.3 Currencies

```sql
INSERT INTO dcl_currency (cur_id, cur_name, cur_code, no_round)
VALUES 
  ('CUR-EUR', 'Euro', 'EUR', false),
  ('CUR-BYN', 'Belarusian Ruble', 'BYN', false),
  ('CUR-USD', 'US Dollar', 'USD', false);

-- Currency rates
INSERT INTO dcl_currency_rate (crt_id, crt_currency_id, crt_rate, crt_date)
VALUES 
  ('CRT-001', 'CUR-EUR', 3.25, '2026-02-01'),
  ('CRT-002', 'CUR-EUR', 3.27, '2026-02-10'),
  ('CRT-003', 'CUR-USD', 3.10, '2026-02-01');
```

### 1.4 Contractors

```sql
INSERT INTO dcl_contractor (cnt_id, cnt_name, cnt_full_name, cnt_reputation_id)
VALUES 
  ('CNT-001', 'Test Contractor Alpha', 'Test Contractor Alpha LLC', 'REP-001'),
  ('CNT-002', 'Test Contractor Beta', 'Test Contractor Beta JSC', 'REP-002'),
  ('CNT-003', 'Test Contractor For', 'Test Contractor For LLC', 'REP-001');

-- Contact persons
INSERT INTO dcl_contact_person (cps_id, cps_cnt_id, cps_name, cps_position)
VALUES 
  ('CPS-001', 'CNT-001', 'Ivan Petrov', 'Manager'),
  ('CPS-002', 'CNT-001', 'Elena Sidorova', 'Director'),
  ('CPS-003', 'CNT-002', 'Petr Ivanov', 'Logistic');
```

### 1.5 Sellers

```sql
INSERT INTO dcl_seller (sll_id, sll_name, sll_prefix_for_order)
VALUES 
  ('SLL-001', 'DCL Minsk', 'DCL'),
  ('SLL-002', 'SAM Vilnius', 'SAM');
```

### 1.6 Stuff Categories

```sql
INSERT INTO dcl_stuff_category (stc_id, stc_name)
VALUES 
  ('STC-001', 'Electronics'),
  ('STC-002', 'Furniture'),
  ('STC-003', 'Equipment');
```

### 1.7 Produces (Products)

```sql
INSERT INTO dcl_produce (prd_id, prd_name, prd_full_name, prd_stc_id, prd_unit_id)
VALUES 
  ('PRD-001', 'Laptop Dell', 'Laptop Dell Inspiron 15', 'STC-001', 'UNT-001'),
  ('PRD-002', 'Chair Office', 'Office Chair Ergonomic', 'STC-002', 'UNT-002'),
  ('PRD-003', 'Printer HP', 'HP LaserJet Pro Printer', 'STC-001', 'UNT-001');

-- Units
INSERT INTO dcl_unit (unt_id, unt_name, unt_short_name)
VALUES 
  ('UNT-001', 'Piece', 'pc'),
  ('UNT-002', 'Set', 'set');

-- Catalog numbers
INSERT INTO dcl_catalog_number (ctn_id, ctn_prd_id, ctn_number)
VALUES 
  ('CTN-001', 'PRD-001', 'DELL-INS-15-001'),
  ('CTN-002', 'PRD-002', 'CHR-ERG-002'),
  ('CTN-003', 'PRD-003', 'HP-LJ-PRO-003');
```

### 1.8 IncoTerms (Delivery Conditions)

```sql
INSERT INTO dcl_inco_term (inc_id, inc_name, inc_description)
VALUES 
  ('INC-EXW', 'EXW', 'Ex Works'),
  ('INC-DDP', 'DDP', 'Delivered Duty Paid'),
  ('INC-FCA', 'FCA', 'Free Carrier');
```

### 1.9 Blanks (Print Templates)

```sql
INSERT INTO dcl_blank (bln_id, bln_name, bln_img_name)
VALUES 
  ('BLN-001', 'Order Standard', 'order_standard.jasper'),
  ('BLN-002', 'Order Extended', 'order_extended.jasper');
```

### 1.10 Shipping Document Types

```sql
INSERT INTO dcl_shipping_doc_type (sdt_id, sdt_name)
VALUES 
  ('SDT-001', 'CMR'),
  ('SDT-002', 'TIR'),
  ('SDT-003', 'Invoice');
```

### 1.11 Contracts and Specifications

```sql
-- Contract
INSERT INTO dcl_contract (con_id, con_cnt_id, con_number, con_date, con_is_project, con_is_copy)
VALUES 
  ('CON-001', 'CNT-003', 'CTR-2026-001', '2026-01-15', false, false);

-- Specification
INSERT INTO dcl_specification (spc_id, spc_con_id, spc_number, spc_date, spc_is_project, spc_is_copy)
VALUES 
  ('SPC-001', 'CON-001', 'SPC-2026-001', '2026-02-01', false, false);
```

### 1.12 NDS Rates

```sql
INSERT INTO dcl_nds_rate (nds_id, nds_percent, nds_date_start)
VALUES 
  ('NDS-001', 20, '2020-01-01');
```

---

## 2. Order Test Scenarios

### 2.1 Scenario: New Order (Empty)

**Purpose**: Test new order creation form initialization

**Setup**: No order data needed

**Expected Form State**:
```json
{
  "is_new_doc": "true",
  "ord_id": "",
  "ord_number": "",
  "ord_date": "12.02.2026",
  "director": {"usr_id": "USR-DIR-001"},
  "logist": {"usr_id": "USR-LOG-001"},
  "director_rb": {"usr_id": "USR-DIRRB-001"},
  "manager": {"usr_id": "USR-TEST-002"},
  "currency": {"id": "CUR-EUR"},
  "ord_donot_calculate_netto": "1",
  "ord_in_one_spec": "1",
  "merge_positions": "1",
  "ord_logist_signature": "1",
  "ord_director_rb_signature": "1",
  "ord_chief_dep_signature": "1",
  "ord_manager_signature": "1",
  "orderPayments": [
    {"orp_percent": 100, "orp_sum": 0, "orp_date": ""}
  ],
  "orderPaySums": [
    {"ops_sum": 0, "ops_date": ""}
  ],
  "produces": [],
  "formReadOnly": false
}
```

### 2.2 Scenario: Edit Existing Order

**Purpose**: Test loading and editing existing order

**Test Data**:
```sql
-- Order
INSERT INTO dcl_order (ord_id, ord_number, ord_date, ord_cnt_id, ord_sll_for_who_id, 
                       ord_currency_id, ord_block, ord_summ, ord_create_user_id)
VALUES 
  ('ORD-001', 'DCL-2602/0001-TMGR', '12.02.2026', 'CNT-001', 'SLL-001', 
   'CUR-EUR', NULL, 1500.00, 'USR-TEST-002');

-- Order produces
INSERT INTO dcl_order_produce (opr_id, opr_ord_id, opr_prd_id, opr_count, 
                               opr_price_brutto, opr_price_netto, opr_discount, opr_number)
VALUES 
  ('OPR-001', 'ORD-001', 'PRD-001', 5, 300.00, 250.00, 0, '1'),
  ('OPR-002', 'ORD-001', 'PRD-002', 10, 100.00, 83.33, 0, '2');

-- Order payments
INSERT INTO dcl_order_payment (orp_id, orp_ord_id, orp_percent, orp_sum, orp_date)
VALUES 
  ('ORP-001', 'ORD-001', 50, 750.00, '15.02.2026'),
  ('ORP-002', 'ORD-001', 50, 750.00, '28.02.2026');

-- Order pay sums
INSERT INTO dcl_order_pay_sum (ops_id, ops_ord_id, ops_sum, ops_date)
VALUES 
  ('OPS-001', 'ORD-001', 1500.00, '28.02.2026');
```

**Expected Form State**:
```json
{
  "is_new_doc": "",
  "ord_id": "ORD-001",
  "ord_number": "DCL-2602/0001-TMGR",
  "ord_date": "12.02.2026",
  "contractor": {"id": "CNT-001", "name": "Test Contractor Alpha"},
  "sellerForWho": {"id": "SLL-001", "name": "DCL Minsk"},
  "currency": {"id": "CUR-EUR", "name": "Euro"},
  "produces": [
    {
      "number": "1",
      "produce": {"id": "PRD-001", "fullName": "Laptop Dell Inspiron 15"},
      "opr_count": 5,
      "opr_price_brutto": 300.00,
      "opr_price_netto": 250.00,
      "opr_sum_brutto": 1500.00
    },
    {
      "number": "2",
      "produce": {"id": "PRD-002", "fullName": "Office Chair Ergonomic"},
      "opr_count": 10,
      "opr_price_brutto": 100.00,
      "opr_price_netto": 83.33,
      "opr_sum_brutto": 1000.00
    }
  ],
  "orderPayments": [
    {"orp_percent": 50, "orp_sum": 750.00, "orp_date": "15.02.2026"},
    {"orp_percent": 50, "orp_sum": 750.00, "orp_date": "28.02.2026"}
  ],
  "orderPaySums": [
    {"ops_sum": 1500.00, "ops_date": "28.02.2026"}
  ],
  "ord_summ": "2 500,00",
  "formReadOnly": false
}
```

### 2.3 Scenario: Blocked Order (Readonly)

**Purpose**: Test blocked order cannot be edited

**Test Data**:
```sql
INSERT INTO dcl_order (ord_id, ord_number, ord_date, ord_cnt_id, ord_sll_for_who_id, 
                       ord_currency_id, ord_block, ord_executed_date, ord_summ)
VALUES 
  ('ORD-002', 'DCL-2602/0002-TMGR', '01.02.2026', 'CNT-002', 'SLL-001', 
   'CUR-EUR', '1', '10.02.2026', 5000.00);

INSERT INTO dcl_order_produce (opr_id, opr_ord_id, opr_prd_id, opr_count, 
                               opr_count_executed, opr_price_brutto, opr_number)
VALUES 
  ('OPR-003', 'ORD-002', 'PRD-003', 2, 2, 2500.00, '1');
```

**Expected Form State**:
```json
{
  "ord_id": "ORD-002",
  "ord_block": "1",
  "ord_executed_date": "10.02.2026",
  "formReadOnly": true
}
```

### 2.4 Scenario: Annulled Order

**Purpose**: Test annulled order is blocked

**Test Data**:
```sql
INSERT INTO dcl_order (ord_id, ord_number, ord_date, ord_cnt_id, 
                       ord_currency_id, ord_block, ord_annul, ord_summ)
VALUES 
  ('ORD-003', 'DCL-2602/0003-TMGR', '05.02.2026', 'CNT-001', 
   'CUR-EUR', '1', '1', 0);
```

**Expected Form State**:
```json
{
  "ord_id": "ORD-003",
  "ord_block": "1",
  "ord_annul": "1",
  "formReadOnly": true
}
```

### 2.5 Scenario: Order with Logistic Dates

**Purpose**: Test logistic date sequence validation

**Test Data**:
```sql
INSERT INTO dcl_order (ord_id, ord_number, ord_date, ord_cnt_id, ord_currency_id,
                       ord_sent_to_prod_date, ord_received_conf_date, 
                       ord_conf_sent_date, ord_ready_for_deliv_date)
VALUES 
  ('ORD-004', 'DCL-2602/0004-TMGR', '01.02.2026', 'CNT-001', 'CUR-EUR',
   '02.02.2026', '05.02.2026', '06.02.2026', '10.02.2026');
```

**Validation Tests**:
| Invalid Date Change | Expected Error |
|---------------------|----------------|
| ord_received_conf_date < ord_sent_to_prod_date | error.order.ord_received_conf_date |
| ord_conf_sent_date < ord_received_conf_date | error.order.ord_conf_sent_date |
| ord_ready_for_deliv_date < ord_received_conf_date | error.order.ord_ready_for_deliv_date |

### 2.6 Scenario: Order with In-One-Spec

**Purpose**: Test in-one-spec validation

**Test Data**:
```sql
INSERT INTO dcl_order (ord_id, ord_number, ord_date, ord_cnt_id, ord_currency_id,
                       ord_in_one_spec, ord_cnt_for_id, ord_con_id, ord_spc_id)
VALUES 
  ('ORD-005', 'DCL-2602/0005-TMGR', '12.02.2026', 'CNT-001', 'CUR-EUR',
   '1', 'CNT-003', 'CON-001', 'SPC-001');
```

**Validation Tests**:
| Missing Field | Expected Error |
|---------------|----------------|
| ord_cnt_for_id empty | error.order.ord_in_one_spec |
| ord_con_id empty | error.order.ord_in_one_spec |
| ord_spc_id empty | error.order.ord_in_one_spec |

---

## 3. AJAX Grid Test Data

### 3.1 Payments Grid Test

**Initial State**:
```json
{
  "orderPayments": [
    {"orp_percent": 100, "orp_sum": 0, "orp_date": "", "orp_description": ""}
  ]
}
```

**After Add Row**:
```json
{
  "orderPayments": [
    {"orp_percent": 100, "orp_sum": 0, "orp_date": "", "orp_description": ""},
    {"orp_percent": 0, "orp_sum": 0, "orp_date": "", "orp_description": ""}
  ]
}
```

**After Edit (50/50 split)**:
```json
{
  "orderPayments": [
    {"orp_percent": 50, "orp_sum": 750.00, "orp_date": "15.02.2026", "orp_description": "50% - 750,00 EUR - 15.02.2026"},
    {"orp_percent": 50, "orp_sum": 750.00, "orp_date": "28.02.2026", "orp_description": "50% - 750,00 EUR - 28.02.2026"}
  ]
}
```

### 3.2 Pay Sums Grid Test

**Initial State**:
```json
{
  "orderPaySums": [
    {"ops_sum": 0, "ops_date": ""}
  ]
}
```

**After Add Row**:
```json
{
  "orderPaySums": [
    {"ops_sum": 0, "ops_date": ""},
    {"ops_sum": 0, "ops_date": ""}
  ]
}
```

**After Edit**:
```json
{
  "orderPaySums": [
    {"ops_sum": 1000.00, "ops_date": "15.02.2026"},
    {"ops_sum": 500.00, "ops_date": "28.02.2026"}
  ]
}
```

---

## 4. Role-Based Test Scenarios

### 4.1 Manager Role Tests

**User**: USR-TEST-002 (Manager)

| Test | Expected Result |
|------|-----------------|
| Edit header fields | Allowed |
| Edit logistic section | Only ord_sent_to_prod_date |
| Edit produces grid | Allowed |
| Add attachment | Allowed |
| Edit ord_arrive_in_lithuania | Not allowed |

### 4.2 Logistic Role Tests

**User**: USR-TEST-003 (Logistic)

| Test | Expected Result |
|------|-----------------|
| Edit header fields | Allowed |
| Edit logistic section | Allowed |
| Edit produces grid | Not allowed |
| Add attachment | Allowed |
| Edit ord_arrive_in_lithuania | Allowed |

### 4.3 UserInLithuania Role Tests

**User**: USR-TEST-005 (UserInLithuania)

| Test | Expected Result |
|------|-----------------|
| View order | Allowed |
| Edit any field | Not allowed (form readonly) |
| Print order | Allowed |
| Edit ord_arrive_in_lithuania | Allowed |
| Add attachment | Not allowed |

### 4.4 Admin Role Tests

**User**: USR-TEST-001 (Admin)

| Test | Expected Result |
|------|-----------------|
| Edit all fields | Allowed |
| Save with empty produce | Allowed (parent doc only) |
| Edit ord_annul | Allowed |
| View admin-only fields | Visible |

---

## 5. Number Generation Test

### 5.1 Test Cases

| Seller Prefix | Date | User Code | Expected Number |
|---------------|------|-----------|-----------------|
| DCL | 12.02.2026 | TADM | DCL-2602/0001-TADM |
| SAM | 15.03.2026 | TMGR | SAM-2603/0002-TMGR |
| DCL | 01.12.2026 | TLOG | DCL-2612/0003-TLOG |

**Sequence Generator**:
```sql
-- Initialize sequence
INSERT INTO dcl_generator (gen_name, gen_value)
VALUES ('get-num_order', 0);

-- After first order
-- gen_value = 1

-- After second order
-- gen_value = 2
```

---

## 6. Validation Test Matrix

### 6.1 Save Validation Tests

| Test ID | Scenario | Input | Expected Error |
|---------|----------|-------|----------------|
| V1 | In-one-spec without contractor_for | ord_in_one_spec=1, contractor_for empty | error.order.ord_in_one_spec |
| V2 | received_conf before sent_to_prod | sent=10.02, received=05.02 | error.order.ord_received_conf_date |
| V3 | conf_sent before received_conf | received=10.02, conf_sent=05.02 | error.order.ord_conf_sent_date |
| V4 | ready_for_deliv before received_conf | received=10.02, ready=05.02 | error.order.ord_ready_for_deliv_date |
| V5 | executed before ready_for_deliv | ready=10.02, executed=05.02 | error.order.ord_executed_date |
| V6 | Null produce (non-admin) | produce empty, user=manager | error.order.ord_null_produce |
| V7 | DRP price zero with all_include | all_include=1, drp_price=0 | error.order.null_drp_price |
| V8 | date_conf_all without date_conf | date_conf_all=1, date_conf empty | error.order.not_entered_date_conf |
| V9 | ready_all without required fields | ready_all=1, shippingDocType empty | error.order.not_entered_ready_for_deliv_fields |

---

## 7. Cleanup Script

```sql
-- Cleanup test data (run in reverse dependency order)
DELETE FROM dcl_order_pay_sum WHERE ops_ord_id LIKE 'ORD-%';
DELETE FROM dcl_order_payment WHERE orp_ord_id LIKE 'ORD-%';
DELETE FROM dcl_order_produce WHERE opr_ord_id LIKE 'ORD-%';
DELETE FROM dcl_order WHERE ord_id LIKE 'ORD-%';
DELETE FROM dcl_specification WHERE spc_id LIKE 'SPC-%';
DELETE FROM dcl_contract WHERE con_id LIKE 'CON-%';
DELETE FROM dcl_catalog_number WHERE ctn_id LIKE 'CTN-%';
DELETE FROM dcl_produce WHERE prd_id LIKE 'PRD-%';
DELETE FROM dcl_unit WHERE unt_id LIKE 'UNT-%';
DELETE FROM dcl_shipping_doc_type WHERE sdt_id LIKE 'SDT-%';
DELETE FROM dcl_blank WHERE bln_id LIKE 'BLN-%';
DELETE FROM dcl_inco_term WHERE inc_id LIKE 'INC-%';
DELETE FROM dcl_stuff_category WHERE stc_id LIKE 'STC-%';
DELETE FROM dcl_seller WHERE sll_id LIKE 'SLL-%';
DELETE FROM dcl_contact_person WHERE cps_id LIKE 'CPS-%';
DELETE FROM dcl_contractor WHERE cnt_id LIKE 'CNT-%';
DELETE FROM dcl_currency_rate WHERE crt_id LIKE 'CRT-%';
DELETE FROM dcl_currency WHERE cur_id LIKE 'CUR-%';
DELETE FROM dcl_department WHERE dep_id LIKE 'DEP-%';
DELETE FROM dcl_user WHERE usr_id LIKE 'USR-%';
DELETE FROM dcl_nds_rate WHERE nds_id LIKE 'NDS-%';
DELETE FROM dcl_generator WHERE gen_name = 'get-num_order';
```

---

## 8. Test Execution Order

1. **Setup**: Run reference data inserts (Section 1)
2. **Scenario 2.1**: Test new order form initialization
3. **Scenario 2.2**: Test edit existing order
4. **Scenario 2.3**: Test blocked order readonly
5. **Scenario 2.4**: Test annulled order readonly
6. **Scenario 2.5**: Test logistic date validation
7. **Scenario 2.6**: Test in-one-spec validation
8. **Section 3**: Test AJAX grids
9. **Section 4**: Test role-based access
10. **Section 5**: Test number generation
11. **Section 6**: Run validation tests
12. **Cleanup**: Run cleanup script (Section 7)
