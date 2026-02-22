# order — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_ORDER`
- Columns (type): `ORD_ID` INTEGER NOT NULL; `ORD_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `ORD_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `ORD_NUMBER` VARCHAR(15) NOT NULL; `ORD_DATE` DATE NOT NULL; `CTR_ID` INTEGER NOT NULL
- NOT NULL: `ORD_ID`, `ORD_CREATE_DATE`, `USR_ID_CREATE`, `ORD_EDIT_DATE`, `USR_ID_EDIT`, `ORD_NUMBER`, `ORD_DATE`, `CTR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_ORDER_BI0`; `DCL_ORDER_AI0`; `DCL_ORDER_BU0`; `DCL_ORDER_BD0`
- Stored Procedures: `DCL_GET_REST_INFO_FROM_ORDER`; `DCL_ORDERS_LOGISTICS`; `DCL_ORDERS_STATISTICS`; `DCL_ORDERS_UNEXECUTED`; `DCL_ORDER_FILTER`

