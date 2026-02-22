# department — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_DEPARTMENT`
- Columns (type): `DEP_ID` INTEGER NOT NULL; `DEP_NAME` VARCHAR(100) NOT NULL
- NOT NULL: `DEP_ID`, `DEP_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_DEPARTMENT_BI0`
- Stored Procedures: `DCL_DEPARTMENT_FILTER`

