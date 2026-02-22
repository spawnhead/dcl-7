# contractorrequests — Expected API contracts (legacy-inferred)

- `/ContractorRequestAction.do?dispatch=clone`
- `/ContractorRequestAction.do?dispatch=edit`
- `/ContractorRequestAction.do?dispatch=input`
- `/ContractorRequestTypeListAction`
- `/ContractorsListAction`
- `/SellersListAction`
- `/StuffCategoriesListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

