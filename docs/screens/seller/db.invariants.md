# seller — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_SELLER`
- Columns (type): `SLN_ID` INTEGER NOT NULL; `SLN_NAME` VARCHAR(100) NOT NULL; `SLN_USED_IN_ORDER` SMALLINT; `SLN_PREFIX_FOR_ORDER` VARCHAR(10); `SLN_IS_RESIDENT` SMALLINT
- NOT NULL: `SLN_ID`, `SLN_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_SELLER_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

