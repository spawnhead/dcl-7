# customcode — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CUSTOM_CODE`
- Columns (type): `CUS_ID` INTEGER NOT NULL; `CUS_CODE` VARCHAR(10) NOT NULL; `CUS_DESCRIPTION` VARCHAR(500); `CUS_PERCENT` DECIMAL(15; `CUS_INSTANT` TIMESTAMP NOT NULL; `CUS_CREATE_DATE` TIMESTAMP; `CUS_ID_CREATE` INTEGER; `CUS_EDIT_DATE` TIMESTAMP
- NOT NULL: `CUS_ID`, `CUS_CODE`, `CUS_INSTANT`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CUSTOM_CODE_BI0`; `DCL_CUSTOM_CODE_BU0`; `DCL_CUSTOM_CODE_AU0`
- Stored Procedures: `DCL_CUSTOM_CODE_FILTER`; `DCL_DECODE_ID_LIST`; `DCL_GET_DECODE_RESTS_IN_LIT`; `DCL_GET_DECODE_RESTS_IN_MINSK`; `MIGRATE_TO_CUSTOM_CODE_HISTORY`

