# purpose — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_PURCHASE_PURPOSE`
- Columns (type): `PPS_ID` INTEGER NOT NULL; `PPS_NAME` VARCHAR(200) NOT NULL
- NOT NULL: `PPS_ID`, `PPS_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_PURCHASE_PURPOSE_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

### Table `DCL_PURPOSE`
- Columns (type): `PRS_ID` INTEGER NOT NULL; `PRS_NAME` VARCHAR(200) NOT NULL
- NOT NULL: `PRS_ID`, `PRS_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_PURPOSE_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

