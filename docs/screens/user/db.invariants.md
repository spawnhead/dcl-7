# user — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CONTACT_PERSON_USER`
- Columns (type): `CPS_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL
- NOT NULL: `CPS_ID`, `USR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: `CHECKUSERMESSAGESONDELETE`; `DCL_GET_USER_FOR_CONTRACT`; `DCL_SHIPPING_REPORT_USER`; `DCL_UPDATE_USER_BLOCK`; `DCL_USER_ACTIONS`

### Table `DCL_CONTRACTOR_USER`
- Columns (type): `CTR_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL
- NOT NULL: `CTR_ID`, `USR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: `CHECKUSERMESSAGESONDELETE`; `DCL_GET_USER_FOR_CONTRACT`; `DCL_SHIPPING_REPORT_USER`; `DCL_UPDATE_USER_BLOCK`; `DCL_USER_ACTIONS`

### Table `DCL_USER`
- Columns (type): `USR_ID` INTEGER NOT NULL; `USR_CODE` VARCHAR(3); `USR_LOGIN` VARCHAR(8); `USR_PASSWD` VARCHAR(64); `DEP_ID` INTEGER; `USR_PHONE` VARCHAR(50); `USR_BLOCK` SMALLINT; `USR_RESPONS_PERSON` SMALLINT
- NOT NULL: `USR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_USER_BI0`
- Stored Procedures: `CHECKUSERMESSAGESONDELETE`; `DCL_GET_USER_FOR_CONTRACT`; `DCL_SHIPPING_REPORT_USER`; `DCL_UPDATE_USER_BLOCK`; `DCL_USER_ACTIONS`

### Table `DCL_USER_LANGUAGE`
- Columns (type): `USR_ID` INTEGER NOT NULL; `LNG_ID` INTEGER NOT NULL; `USR_SURNAME` VARCHAR(20); `USR_NAME` VARCHAR(20); `USR_POSITION` VARCHAR(60)
- NOT NULL: `USR_ID`, `LNG_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: UNKNOWN/none matched by name.

### Table `DCL_USER_LINK`
- Columns (type): `ULN_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL; `ULN_CREATE_DATE` TIMESTAMP NOT NULL; `ULN_URL` VARCHAR(64) NOT NULL; `ULN_PARAMETERS` VARCHAR(128) NOT NULL; `ULN_TEXT` VARCHAR(500); `ULN_MENU_ID` VARCHAR(50) NOT NULL
- NOT NULL: `ULN_ID`, `USR_ID`, `ULN_CREATE_DATE`, `ULN_URL`, `ULN_PARAMETERS`, `ULN_MENU_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_USER_LINK_BI0`
- Stored Procedures: UNKNOWN/none matched by name.

