# contract — Expected API contracts (legacy-inferred)

- `/ContractAction.do?dispatch=downloadAttachment`
- `/ContractorsListAction`
- `/CurrenciesListAction`
- `/SellersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CFC_ID` INTEGER NOT NULL; `CFC_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CFC_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CFC_PLACE` SMALLINT.

