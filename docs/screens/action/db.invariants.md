# action — DB invariants (enforced only)

## Invariant 1 — Action identity and required system name
- Statement: `DCL_ACTION.ACT_ID` is primary key; `ACT_SYSTEM_NAME` is mandatory.
- Enforced by: table `DCL_ACTION`, PK `PK_DCL_ACTION`, `NOT NULL` on `ACT_SYSTEM_NAME`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION (ACT_ID, ACT_NAME) VALUES (999999, 'Test');
-- expected: fail (ACT_SYSTEM_NAME is required)
```

## Invariant 2 — Auto-generation of ACT_ID
- Statement: on insert, `ACT_ID` is generated when missing.
- Enforced by: trigger `DCL_ACTION_BI0` + generator `GEN_DCL_ACTION_ID`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION (ACT_SYSTEM_NAME, ACT_NAME, ACT_LOGGING, ACT_CHECK_ACCESS)
VALUES ('/TestAction.do', 'Test action', 1, 1);
-- expected: ACT_ID generated automatically
```

## Invariant 3 — Role binding uniqueness
- Statement: one role can be linked to action only once.
- Enforced by: composite PK `PK_DCL_ACTION_ROLE (ACT_ID, ROL_ID)` on `DCL_ACTION_ROLE`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION_ROLE (ACT_ID, ROL_ID) VALUES (1, 1);
INSERT INTO DCL_ACTION_ROLE (ACT_ID, ROL_ID) VALUES (1, 1);
-- expected: second insert fails (duplicate PK)
```

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ACTION`
- Columns (type): `ACT_ID` INTEGER NOT NULL; `ACT_NAME` VARCHAR(100); `ACT_SYSTEM_NAME` VARCHAR(100) NOT NULL; `ACT_LOGGING` SMALLINT; `ACT_CHECK_ACCESS` SMALLINT
- NOT NULL: `ACT_ID`, `ACT_SYSTEM_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ACTION_BI0`
- Stored Procedures: `DCL_USER_ACTIONS`

### Table `DCL_ACTION_ROLE`
- Columns (type): `ACT_ID` INTEGER NOT NULL; `ROL_ID` INTEGER NOT NULL
- NOT NULL: `ACT_ID`, `ROL_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: UNKNOWN/none matched by name.

