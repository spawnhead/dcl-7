# montageadjustment — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_MONTAGE_ADJUSTMENT`
- Columns (type): `MAD_ID` INTEGER NOT NULL; `STF_ID` INTEGER NOT NULL; `MAD_MACHINE_TYPE` VARCHAR(1000) NOT NULL; `MAD_COMPLEXITY` VARCHAR(10) NOT NULL; `MAD_ANNUL` SMALLINT
- NOT NULL: `MAD_ID`, `STF_ID`, `MAD_MACHINE_TYPE`, `MAD_COMPLEXITY`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_MONTAGE_ADJUSTMENT_BIO`
- Stored Procedures: `DCL_MONTAGE_ADJUSTMENT_INSERT`

### Table `DCL_MONTAGE_ADJUSTMENT_H`
- Columns (type): `MADH_ID` INTEGER NOT NULL; `MAD_ID` INTEGER NOT NULL; `MAD_DATE_FROM` DATE NOT NULL; `MAD_MECH_WORK_TARIFF` DECIMAL(15; `MAD_MECH_WORK_RULE_MONTAGE` DECIMAL(15; `MAD_MECH_WORK_RULE_ADJUSTMENT` DECIMAL(15; `MAD_MECH_ROAD_TARIFF` DECIMAL(15; `MAD_MECH_ROAD_RULE` DECIMAL(15
- NOT NULL: `MADH_ID`, `MAD_ID`, `MAD_DATE_FROM`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_MONTAGE_ADJUSTMENT_H_BIO`; `DCL_MONTAGE_ADJUSTMENT_H_BU0`
- Stored Procedures: `CHECKUSERMESSAGESONDELETE`; `DCL_GET_CHILD_CATEGORIES`; `DCL_GET_MANAGERS_BY_SHP_ID`; `DCL_GET_MANAGER_LIST_BY_SHP_ID`; `DCL_GET_OCCUPIED_SHP_POS`

