# producecost — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_PRODUCE_COST`
- Columns (type): `PRC_ID` INTEGER NOT NULL; `PRC_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `PRC_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `PRC_NUMBER` VARCHAR(50) NOT NULL; `PRC_DATE` DATE NOT NULL; `RUT_ID` INTEGER NOT NULL
- NOT NULL: `PRC_ID`, `PRC_CREATE_DATE`, `USR_ID_CREATE`, `PRC_EDIT_DATE`, `USR_ID_EDIT`, `PRC_NUMBER`, `PRC_DATE`, `RUT_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_PRODUCE_COST_BI0`; `DCL_PRODUCE_COST_BU0`
- Stored Procedures: `DCL_PRODUCE_COST_FILTER`; `DCL_PRODUCE_COST_INSERT`; `DCL_PRODUCE_COST_REPORT`; `DCL_PRODUCE_COST_REPORT_SUM`

### Table `DCL_PRODUCE_COST_CUSTOM`
- Columns (type): `PRC_ID` INTEGER NOT NULL; `LPC_PERCENT` DECIMAL(15; `LPC_SUMM` DECIMAL(15; `LPC_SUMM_ALLOCATION` DECIMAL(15
- NOT NULL: `PRC_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: `DCL_CUSTOM_CODE_FILTER`; `DCL_GET_CUSTOMER_FOR_DLR`; `MIGRATE_TO_CUSTOM_CODE_HISTORY`

