# payment — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ORD_LIST_PAYMENT`
- Columns (type): `ORP_ID` INTEGER NOT NULL; `ORD_ID` INTEGER NOT NULL; `ORP_PERCENT` DECIMAL(11; `ORP_SUM` DECIMAL(15; `ORP_DATE` DATE
- NOT NULL: `ORP_ID`, `ORD_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ORD_LIST_PAYMENT_BI0`
- Stored Procedures: `DCL_PAYMENT_FILTER`; `DCL_PAYMENT_INSERT`; `DCL_SAVE_PAYMENT_MESSAGES`

### Table `DCL_PAYMENT`
- Columns (type): `PAY_ID` INTEGER NOT NULL; `PAY_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `PAY_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `PAY_DATE` DATE NOT NULL; `PAY_ACCOUNT` VARCHAR(35); `PAY_SUMM` DECIMAL(15
- NOT NULL: `PAY_ID`, `PAY_CREATE_DATE`, `USR_ID_CREATE`, `PAY_EDIT_DATE`, `USR_ID_EDIT`, `PAY_DATE`, `CUR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_PAYMENT_BI0`; `DCL_PAYMENT_BU0`
- Stored Procedures: `DCL_PAYMENT_FILTER`; `DCL_PAYMENT_INSERT`; `DCL_SAVE_PAYMENT_MESSAGES`

### Table `DCL_SPC_LIST_PAYMENT`
- Columns (type): `SPP_ID` INTEGER NOT NULL; `SPC_ID` INTEGER NOT NULL; `SPP_PERCENT` DECIMAL(11; `SPP_SUM` DECIMAL(15; `SPP_DATE` DATE
- NOT NULL: `SPP_ID`, `SPC_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_SPC_LIST_PAYMENT_BI0`
- Stored Procedures: `DCL_PAYMENT_FILTER`; `DCL_PAYMENT_INSERT`; `DCL_SAVE_PAYMENT_MESSAGES`

