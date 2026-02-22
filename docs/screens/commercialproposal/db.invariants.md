# commercialproposal — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_COMMERCIAL_PROPOSAL`
- Columns (type): `CPR_ID` INTEGER NOT NULL; `CPR_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CPR_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CPR_NUMBER` VARCHAR(20) NOT NULL; `CPR_DATE` DATE NOT NULL; `CTR_ID` INTEGER NOT NULL
- NOT NULL: `CPR_ID`, `CPR_CREATE_DATE`, `USR_ID_CREATE`, `CPR_EDIT_DATE`, `USR_ID_EDIT`, `CPR_NUMBER`, `CPR_DATE`, `CTR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_COMMERCIAL_PROPOSAL_BI0`; `DCL_COMMERCIAL_PROPOSAL_AI0`; `DCL_COMMERCIAL_PROPOSAL_BU0`
- Stored Procedures: `DCL_COMMERCIAL_PROPOSAL_FILTER`; `DCL_COMMERCIAL_PROPOSAL_INSERT`

