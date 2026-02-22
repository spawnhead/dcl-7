# filespath — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_FILES_PATH`
- Columns (type): `FLP_ID` INTEGER NOT NULL; `FLP_TABLE_NAME` VARCHAR(32) NOT NULL; `FLP_PATH` VARCHAR(1024) NOT NULL; `FLP_DESCRIPTION` VARCHAR(200)
- NOT NULL: `FLP_ID`, `FLP_TABLE_NAME`, `FLP_PATH`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_FILES_PATH_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

