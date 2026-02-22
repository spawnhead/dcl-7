# deliveryrequest — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_DELIVERY_REQUEST`
- Columns (type): `DLR_ID` INTEGER NOT NULL; `DLR_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `DLR_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `DLR_PLACE_DATE` TIMESTAMP; `USR_ID_PLACE` INTEGER; `DLR_NUMBER` VARCHAR(20) NOT NULL
- NOT NULL: `DLR_ID`, `DLR_CREATE_DATE`, `USR_ID_CREATE`, `DLR_EDIT_DATE`, `USR_ID_EDIT`, `DLR_NUMBER`, `DLR_DATE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_DELIVERY_REQUEST_BI0`; `DCL_DELIVERY_REQUEST_BU0`
- Stored Procedures: `DCL_CONTRACTOR_REQUEST_FILTER`; `DCL_CONTRACTOR_REQUEST_INSERT`; `DCL_CONTRACTOR_REQUEST_LOAD`; `DCL_DELIVERY_REQUEST_FILTER`; `DCL_DELIVERY_REQUEST_INSERT`

