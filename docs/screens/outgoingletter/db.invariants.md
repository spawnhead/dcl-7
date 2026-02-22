# outgoingletter — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_OUTGOING_LETTER`
- Columns (type): `OTL_ID` INTEGER NOT NULL; `OTL_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `OTL_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `OTL_NUMBER` VARCHAR(15) NOT NULL; `OTL_DATE` DATE NOT NULL; `CTR_ID` INTEGER NOT NULL
- NOT NULL: `OTL_ID`, `OTL_CREATE_DATE`, `USR_ID_CREATE`, `OTL_EDIT_DATE`, `USR_ID_EDIT`, `OTL_NUMBER`, `OTL_DATE`, `CTR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_OUTGOING_LETTER_BI0`; `DCL_OUTGOING_LETTER_BU0`; `DCL_OUTGOING_LETTER_BD0`
- Stored Procedures: `DCL_OUTGOING_LETTER_FILTER`; `DCL_OUTGOING_LETTER_INSERT`; `DCL_OUTGOING_LETTER_LOAD`

