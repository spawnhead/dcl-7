# paysum — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.
<<<<<<< HEAD

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ORD_LIST_PAY_SUM`
- Columns (type): `OPS_ID` INTEGER NOT NULL; `ORD_ID` INTEGER NOT NULL; `OPS_SUM` DECIMAL(15; `OPS_DATE` DATE
- NOT NULL: `OPS_ID`, `ORD_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ORD_LIST_PAY_SUM_BI0`
- Stored Procedures: `DCL_GET_ROW_SUM`; `DCL_GET_ROW_SUMM_EUR`; `DCL_GET_ROW_SUMM_OUT_NDS`; `DCL_GET_SUM_OUT_NDS_EUR`; `DCL_GET_SUM_OUT_NDS_EUR_PART`

=======
>>>>>>> origin/main
