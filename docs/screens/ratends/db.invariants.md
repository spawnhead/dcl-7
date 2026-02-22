# ratends — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_RATE_NDS`
- Columns (type): `RTN_ID` INTEGER NOT NULL; `RTN_DATE_FROM` DATE NOT NULL; `RTN_PERCENT` DECIMAL(15
- NOT NULL: `RTN_ID`, `RTN_DATE_FROM`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_RATE_NDS_BI0`
- Stored Procedures: `DCL_GET_ROW_SUMM_OUT_NDS`; `DCL_GET_SUM_OUT_NDS_EUR`; `DCL_GET_SUM_OUT_NDS_EUR_PART`

