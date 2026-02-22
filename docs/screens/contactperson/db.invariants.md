# contactperson — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CONTACT_PERSON`
- Columns (type): `CPS_ID` INTEGER NOT NULL; `CTR_ID` INTEGER NOT NULL; `CPS_NAME` VARCHAR(200) NOT NULL; `CPS_PHONE` VARCHAR(150); `CPS_FAX` VARCHAR(150); `CPS_BLOCK` SMALLINT; `CPS_POSITION` VARCHAR(150); `CPS_ON_REASON` VARCHAR(150)
- NOT NULL: `CPS_ID`, `CTR_ID`, `CPS_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CONTACT_PERSON_BI0`
- Stored Procedures: `DCL_CONTACT_PERSON_INSERT`

### Table `DCL_CONTACT_PERSON_USER`
- Columns (type): `CPS_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL
- NOT NULL: `CPS_ID`, `USR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: UNKNOWN/none detected.
- Stored Procedures: `CHECKUSERMESSAGESONDELETE`; `DCL_GET_USER_FOR_CONTRACT`; `DCL_SHIPPING_REPORT_USER`; `DCL_UPDATE_USER_BLOCK`; `DCL_USER_ACTIONS`

