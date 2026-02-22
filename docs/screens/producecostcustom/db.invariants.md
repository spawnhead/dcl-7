# producecostcustom — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_PRODUCE_COST_CUSTOM`
- Columns (type): `PRC_ID` INTEGER NOT NULL; `LPC_PERCENT` DECIMAL(15; `LPC_SUMM` DECIMAL(15; `LPC_SUMM_ALLOCATION` DECIMAL(15
- NOT NULL: `PRC_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: `DCL_CUSTOM_CODE_FILTER`; `DCL_GET_CUSTOMER_FOR_DLR`; `MIGRATE_TO_CUSTOM_CODE_HISTORY`

