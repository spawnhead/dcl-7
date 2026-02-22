# role — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ACTION_ROLE`
- Columns (type): `ACT_ID` INTEGER NOT NULL; `ROL_ID` INTEGER NOT NULL
- NOT NULL: `ACT_ID`, `ROL_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: UNKNOWN/none matched by name.

### Table `DCL_ROLE`
- Columns (type): `ROL_ID` INTEGER NOT NULL; `ROL_NAME` VARCHAR(32) NOT NULL
- NOT NULL: `ROL_ID`, `ROL_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ROLE_BIO`
- Stored Procedures: UNKNOWN/none matched by name.

### Table `DCL_USER_ROLE`
- Columns (type): `USR_ID` INTEGER NOT NULL; `ROL_ID` INTEGER NOT NULL
- NOT NULL: `USR_ID`, `ROL_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: UNKNOWN/none matched by name.

