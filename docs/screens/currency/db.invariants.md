# currency — DB invariants (enforced only)

- Screen-specific enforced DB invariants: UNKNOWN in this cycle.
- Verification plan:
  1. Map screen route -> action/DAO/procedure.
  2. Trace touched tables/procedures in `db/Lintera_dcl-5_schema.ddl`.
  3. Record only PK/UK/FK/NOT NULL/triggers/procedures that enforce rules.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

### Table `DCL_CURRENCY`
- Columns (type): `CUR_ID` INTEGER NOT NULL; `CUR_NAME` VARCHAR(10) NOT NULL; `CUR_NO_ROUND` SMALLINT; `CUR_SORT_ORDER` SMALLINT
- NOT NULL: `CUR_ID`, `CUR_NAME`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CURRENCY_BIO`
- Stored Procedures: `DCL_CURRENCY_RATE_FOR_DATE`; `DCL_CURRENCY_RATE_MIN_DATE`

### Table `DCL_CURRENCY_RATE`
- Columns (type): `CRT_ID` INTEGER NOT NULL; `CUR_ID` INTEGER NOT NULL; `CRT_DATE` DATE NOT NULL; `CRT_RATE` DECIMAL(15
- NOT NULL: `CRT_ID`, `CUR_ID`, `CRT_DATE`
- Foreign Keys: UNKNOWN/none detected in direct parse for this table.
- Check Constraints: UNKNOWN/none detected.
- Trigger Logic: `DCL_CURRENCY_RATE_BI0`
- Stored Procedures: `DCL_CURRENCIES_RATES_FOR_DATE`; `DCL_CURRENCY_RATE_FOR_DATE`; `DCL_CURRENCY_RATE_MIN_DATE`; `MIGRATE_TO_CUSTOM_CODE_HISTORY`

