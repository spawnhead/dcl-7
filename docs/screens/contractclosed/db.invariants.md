# contractclosed — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CONTRACT_CLOSED`
- Columns (type): `CTC_ID` INTEGER NOT NULL; `CTC_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CTC_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CTC_NUMBER` INTEGER NOT NULL; `CTC_DATE` DATE NOT NULL; `CTC_BLOCK` SMALLINT
- NOT NULL: `CTC_ID`, `CTC_CREATE_DATE`, `USR_ID_CREATE`, `CTC_EDIT_DATE`, `USR_ID_EDIT`, `CTC_NUMBER`, `CTC_DATE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CONTRACT_CLOSED_BI0`; `DCL_CONTRACT_CLOSED_BU0`
- Stored Procedures: `DCL_CLOSED_RECORD_INSERT`; `DCL_CONTRACTS_CLOSED_LOAD`; `DCL_CONTRACT_CLOSED_FILTER`; `DCL_CONTRACT_CLOSED_INSERT`; `DCL_DELETE_CONTRACT_CLOSED`

