# shipping — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_READY_FOR_SHIPPING`
- Columns (type): `RFS_ID` INTEGER NOT NULL; `OPR_ID` INTEGER NOT NULL; `SDT_ID` INTEGER NOT NULL; `RFS_NUMBER` VARCHAR(60) NOT NULL; `RFS_COUNT` DECIMAL(15; `RFS_DATE` DATE NOT NULL; `RFS_WEIGHT` DECIMAL(15; `RFS_GABARIT` VARCHAR(300)
- NOT NULL: `RFS_ID`, `OPR_ID`, `SDT_ID`, `RFS_NUMBER`, `RFS_DATE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_READY_FOR_SHIPPING_BI0`
- Stored Procedures: `DCL_SHIPPING_FILTER`; `DCL_SHIPPING_GOODS`; `DCL_SHIPPING_INSERT`; `DCL_SHIPPING_REPORT`; `DCL_SHIPPING_REPORT_USER`

### Table `DCL_SHIPPING`
- Columns (type): `SHP_ID` INTEGER NOT NULL; `SHP_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `SHP_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `SHP_NUMBER` VARCHAR(50) NOT NULL; `SHP_DATE` DATE NOT NULL; `SPC_ID` INTEGER
- NOT NULL: `SHP_ID`, `SHP_CREATE_DATE`, `USR_ID_CREATE`, `SHP_EDIT_DATE`, `USR_ID_EDIT`, `SHP_NUMBER`, `SHP_DATE`, `CUR_ID`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_SHIPPING_BI0`; `DCL_SHIPPING_BU0`
- Stored Procedures: `DCL_SHIPPING_FILTER`; `DCL_SHIPPING_GOODS`; `DCL_SHIPPING_INSERT`; `DCL_SHIPPING_REPORT`; `DCL_SHIPPING_REPORT_USER`

