# timeboard — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_TIMEBOARD`
- Columns (type): `TMB_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL; `TMB_DATE` DATE NOT NULL; `TMB_CHECKED` SMALLINT; `TMB_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `TMB_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL
- NOT NULL: `TMB_ID`, `USR_ID`, `TMB_DATE`, `TMB_CREATE_DATE`, `USR_ID_CREATE`, `TMB_EDIT_DATE`, `USR_ID_EDIT`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_TIMEBOARD_BI0`; `DCL_TIMEBOARD_BU0`
- Stored Procedures: `DCL_TIMEBOARD_FILTER`; `DCL_TIMEBOARD_INSERT`; `DCL_TIMEBOARD_LOAD`; `DCL_TIMEBOARD_LOAD_CHECK_IDX`

