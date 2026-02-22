# payments — DB invariants (enforced only)

## Invariant 1 — PK and required columns for payment
- Statement: `DCL_PAYMENT.PAY_ID` обязателен и уникален (PK); `PAY_DATE`, `PAY_SUMM`, `CUR_ID` обязательны (`NOT NULL`).
- Enforced by: table DDL `DCL_PAYMENT`, constraint `PK_DCL_PAYMENT`.
- Minimal SQL check:
```sql
INSERT INTO DCL_PAYMENT (PAY_ID, PAY_CREATE_DATE, USR_ID_CREATE, PAY_EDIT_DATE, USR_ID_EDIT, PAY_SUMM, CUR_ID)
VALUES (999999, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, 1, 10.00, 1);
-- expected: fail (PAY_DATE is required)
```

## Invariant 2 — Audit auto-fill on insert/update
- Statement: при INSERT/UPDATE автоматически проставляются `pay_edit_date` и `usr_id_edit`; при INSERT также `pay_create_date` и `usr_id_create`; при отсутствии id генерируется `PAY_ID`.
- Enforced by: triggers `DCL_PAYMENT_BI0`, `DCL_PAYMENT_BU0` + generator `GEN_DCL_PAYMENT_ID`.
- Minimal SQL check:
```sql
INSERT INTO DCL_PAYMENT (PAY_DATE, PAY_SUMM, CUR_ID) VALUES (CURRENT_DATE, 1.00, 1);
-- expected: PAY_ID auto-generated; audit columns auto-populated by trigger
```

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

- Relevant table mapping: UNKNOWN (manual mapping required).
- Foreign Keys: UNKNOWN.
- Check Constraints: UNKNOWN.
- Trigger Logic: UNKNOWN.
- Stored Procedures: UNKNOWN.

