# instruction — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_INSTRUCTION`
- Columns (type): `INS_ID` INTEGER NOT NULL; `INS_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `INS_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `IST_ID` INTEGER NOT NULL; `INS_NUMBER` VARCHAR(100); `INS_DATE_SIGN` DATE NOT NULL
- NOT NULL: `INS_ID`, `INS_CREATE_DATE`, `USR_ID_CREATE`, `INS_EDIT_DATE`, `USR_ID_EDIT`, `IST_ID`, `INS_DATE_SIGN`, `INS_DATE_FROM`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_INSTRUCTION_BI0`; `DCL_INSTRUCTION_BU0`; `DCL_INSTRUCTION_BD0`
- Stored Procedures: `DCL_INSTRUCTION_FILTER`; `DCL_INSTRUCTION_INSERT`; `DCL_INSTRUCTION_LOAD`

### Table `DCL_INSTRUCTION_TYPE`
- Columns (type): `IST_ID` INTEGER NOT NULL; `IST_NAME` VARCHAR(200) NOT NULL
- NOT NULL: `IST_ID`, `IST_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_INSTRUCTION_TYPE_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

