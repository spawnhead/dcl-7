# blank — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_BLANK`
- Columns (type): `BLN_ID` INTEGER NOT NULL; `BLN_TYPE` SMALLINT NOT NULL; `BLN_NAME` VARCHAR(150) NOT NULL; `LNG_ID` INTEGER NOT NULL; `BLN_CHARSET` VARCHAR(20) NOT NULL; `BLN_PREAMBLE` VARCHAR(1000); `BLN_NOTE` VARCHAR(1000); `BLN_USAGE` VARCHAR(1000)
- NOT NULL: `BLN_ID`, `BLN_TYPE`, `BLN_NAME`, `LNG_ID`, `BLN_CHARSET`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_BLANK_BI0`
- Stored Procedures: `DCL_BLANKS_LOAD`; `DCL_BLANK_INSERT`; `DCL_BLANK_LOAD`; `DCL_GET_BLANK_IMAGES_IN_STR`

### Table `DCL_BLANK_IMAGE`
- Columns (type): `BIM_ID` INTEGER NOT NULL; `BLN_ID` INTEGER NOT NULL; `BIM_NAME` VARCHAR(50) NOT NULL; `BIM_IMAGE` VARCHAR(32) NOT NULL
- NOT NULL: `BIM_ID`, `BLN_ID`, `BIM_NAME`, `BIM_IMAGE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_BLANK_IMAGE_BI0`
- Stored Procedures: `DCL_GET_BLANK_IMAGES_IN_STR`

