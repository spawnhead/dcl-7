# assemble — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ASSEMBLE`
- Columns (type): `ASM_ID` INTEGER NOT NULL; `ASM_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `ASM_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `ASM_NUMBER` VARCHAR(20) NOT NULL; `ASM_DATE` DATE NOT NULL; `ASM_BLOCK` SMALLINT
- NOT NULL: `ASM_ID`, `ASM_CREATE_DATE`, `USR_ID_CREATE`, `ASM_EDIT_DATE`, `USR_ID_EDIT`, `ASM_NUMBER`, `ASM_DATE`, `PRD_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ASSEMBLE_BI0`; `DCL_ASSEMBLE_BU0`
- Stored Procedures: `DCL_ASSEMBLE_FILTER`; `DCL_ASSEMBLE_INSERT`; `DCL_ASSEMBLE_LOAD`

