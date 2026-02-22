# reputation — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_REPUTATION`
- Columns (type): `RPT_ID` INTEGER NOT NULL; `RPT_LEVEL` SMALLINT NOT NULL; `RPT_DESCRIPTION` VARCHAR(500) NOT NULL; `RPT_DEFAULT_IN_CTC` SMALLINT
- NOT NULL: `RPT_ID`, `RPT_LEVEL`, `RPT_DESCRIPTION`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_REPUTATION_BI0`; `DCL_REPUTATION_BU0`
- Stored Procedures: UNKNOWN/none matched by name.

