# actions — DB invariants (enforced only)

## Invariant 1 — primary key and required system name
- Statement: each action has unique `ACT_ID`; `ACT_SYSTEM_NAME` is mandatory.
- Enforced by: table `DCL_ACTION`, PK `PK_DCL_ACTION`, NOT NULL on `ACT_SYSTEM_NAME`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION (ACT_ID, ACT_NAME) VALUES (999998, 'Missing system name');
-- expected: fail (ACT_SYSTEM_NAME required)
```

## Invariant 2 — automatic ACT_ID generation
- Statement: if `ACT_ID` is not provided, DB generates it.
- Enforced by: trigger `DCL_ACTION_BI0` + generator `GEN_DCL_ACTION_ID`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION (ACT_SYSTEM_NAME, ACT_NAME, ACT_LOGGING, ACT_CHECK_ACCESS)
VALUES ('/TmpAction.do', 'Tmp action', 0, 1);
-- expected: ACT_ID assigned automatically
```

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

- Relevant table mapping: UNKNOWN (manual mapping required).
- Foreign Keys: UNKNOWN.
- Check Constraints: UNKNOWN.
- Trigger Logic: UNKNOWN.
- Stored Procedures: UNKNOWN.

