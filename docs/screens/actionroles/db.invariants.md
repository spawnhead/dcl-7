# actionroles — DB invariants (enforced only)

## Invariant 1 — unique action-role pair
- Statement: one `(ACT_ID, ROL_ID)` pair can exist only once.
- Enforced by: `DCL_ACTION_ROLE` primary key `PK_DCL_ACTION_ROLE (ACT_ID, ROL_ID)`.
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION_ROLE (ACT_ID, ROL_ID) VALUES (1, 1);
INSERT INTO DCL_ACTION_ROLE (ACT_ID, ROL_ID) VALUES (1, 1);
-- expected: second insert fails (duplicate PK)
```

## Invariant 2 — both keys are required
- Statement: `ACT_ID` and `ROL_ID` cannot be NULL.
- Enforced by: `DCL_ACTION_ROLE` table definition (`NOT NULL` columns).
- Minimal SQL check:
```sql
INSERT INTO DCL_ACTION_ROLE (ACT_ID, ROL_ID) VALUES (NULL, 1);
-- expected: fail (ACT_ID is required)
```

## Note
- In this dump, explicit FK constraints for `DCL_ACTION_ROLE -> DCL_ACTION/DCL_ROLE` are not declared; referential consistency may be application-managed.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

- Relevant table mapping: UNKNOWN (manual mapping required).
- Foreign Keys: UNKNOWN.
- Check Constraints: UNKNOWN.
- Trigger Logic: UNKNOWN.
- Stored Procedures: UNKNOWN.

