# stuffcategory — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.
<<<<<<< HEAD

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_STUFF_CATEGORY`
- Columns (type): `STF_ID` INTEGER NOT NULL; `STF_NAME` VARCHAR(150) NOT NULL; `STF_SHOW_IN_MONTAGE` SMALLINT
- NOT NULL: `STF_ID`, `STF_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_STUFF_CATEGORY_BI0`
- Stored Procedures: `DCL_STUFF_CATEGORY_FILTER`

=======
>>>>>>> origin/main
