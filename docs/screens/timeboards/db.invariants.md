# timeboards — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

- Relevant table mapping: UNKNOWN (manual mapping required).
- Foreign Keys: UNKNOWN.
- Check Constraints: UNKNOWN.
- Trigger Logic: UNKNOWN.
- Stored Procedures: UNKNOWN.

