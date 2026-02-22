# contractorrequest — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CONTRACTOR_REQUEST`
- Columns (type): `CRQ_ID` INTEGER NOT NULL; `CRQ_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CRQ_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CRQ_RECEIVE_DATE` DATE NOT NULL; `CTR_ID` INTEGER NOT NULL; `CPS_ID` INTEGER
- NOT NULL: `CRQ_ID`, `CRQ_CREATE_DATE`, `USR_ID_CREATE`, `CRQ_EDIT_DATE`, `USR_ID_EDIT`, `CRQ_RECEIVE_DATE`, `CTR_ID`, `CRQ_REQUEST_TYPE_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CONTRACTOR_REQUEST_BI0`; `DCL_CONTRACTOR_REQUEST_BU0`; `DCL_CONTRACTOR_REQUEST_BD0`
- Stored Procedures: `DCL_CONTRACTOR_REQUEST_FILTER`; `DCL_CONTRACTOR_REQUEST_INSERT`; `DCL_CONTRACTOR_REQUEST_LOAD`; `DCL_DELIVERY_REQUEST_FILTER`; `DCL_DELIVERY_REQUEST_INSERT`

