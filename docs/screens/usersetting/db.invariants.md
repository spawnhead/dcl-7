# usersetting — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_USER_SETTING`
- Columns (type): `UST_ID` INTEGER NOT NULL; `UST_NAME` VARCHAR(100) NOT NULL; `UST_DESCRIPTION` VARCHAR(256); `UST_VALUE` VARCHAR(1000); `UST_TYPE` SMALLINT NOT NULL; `UST_ACTION` VARCHAR(100); `UST_VALUE_EXTENDED` VARCHAR(1000); `USR_ID` INTEGER NOT NULL
- NOT NULL: `UST_ID`, `UST_NAME`, `UST_TYPE`, `USR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_USER_SETTING_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

