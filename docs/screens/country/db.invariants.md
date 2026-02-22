# country — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_COUNTRY`
- Columns (type): `CUT_ID` INTEGER NOT NULL; `CUT_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CUT_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CUT_NAME` VARCHAR(50) NOT NULL
- NOT NULL: `CUT_ID`, `CUT_CREATE_DATE`, `USR_ID_CREATE`, `CUT_EDIT_DATE`, `USR_ID_EDIT`, `CUT_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_COUNTRY_BI0`; `DCL_COUNTRY_BU0`
- Stored Procedures: `DCL_COUNTRY_INSERT`

