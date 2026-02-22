# shipping — Expected API contracts (legacy-inferred)

- `/ContractorsListAction`
- `/ContractsDepFromContractorListAction`
- `/CurrenciesListAction`
- `/ShippingAction`
- `/SpecificationsDepFromContractListAction`
- `/UsersListAction`
- `NoticeForShippingPrintAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `RFS_ID` INTEGER NOT NULL; `OPR_ID` INTEGER NOT NULL; `SDT_ID` INTEGER NOT NULL; `RFS_NUMBER` VARCHAR(60) NOT NULL; `RFS_COUNT` DECIMAL(15; `RFS_DATE` DATE NOT NULL.

