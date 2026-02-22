# specificationimport — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_SPECIFICATION_IMPORT`
- Columns (type): `SPI_ID` INTEGER NOT NULL; `SPI_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `SPI_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `SPI_NUMBER` VARCHAR(100) NOT NULL; `SPI_DATE` DATE NOT NULL; `SPI_COMMENT` VARCHAR(2000)
- NOT NULL: `SPI_ID`, `SPI_CREATE_DATE`, `USR_ID_CREATE`, `SPI_EDIT_DATE`, `USR_ID_EDIT`, `SPI_NUMBER`, `SPI_DATE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_SPECIFICATION_IMPORT_BI0`; `DCL_SPECIFICATION_IMPORT_BU0`
- Stored Procedures: `DCL_PRODUCE_IN_SPC_IMPORT`; `DCL_SPECIFICATION_IMPORT_FILTER`; `DCL_SPECIFICATION_IMPORT_INSERT`

