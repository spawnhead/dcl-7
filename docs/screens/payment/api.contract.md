# payment — Expected API contracts (legacy-inferred)

- `/ContractorsListAction`
- `/CurrenciesListAction`
- `/PaymentAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `ORP_ID` INTEGER NOT NULL; `ORD_ID` INTEGER NOT NULL; `ORP_PERCENT` DECIMAL(11; `ORP_SUM` DECIMAL(15; `ORP_DATE` DATE.

