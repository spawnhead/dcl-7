# paysum — Expected API contracts (legacy-inferred)

- `/ContractsDepFromContractorListAction`
- `/PaySumAction`
- `/SpecificationsDepFromContractListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `OPS_ID` INTEGER NOT NULL; `ORD_ID` INTEGER NOT NULL; `OPS_SUM` DECIMAL(15; `OPS_DATE` DATE.

