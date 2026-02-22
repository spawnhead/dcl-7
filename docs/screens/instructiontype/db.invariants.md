# instructiontype — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_INSTRUCTION_TYPE`
- Columns (type): `IST_ID` INTEGER NOT NULL; `IST_NAME` VARCHAR(200) NOT NULL
- NOT NULL: `IST_ID`, `IST_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_INSTRUCTION_TYPE_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

