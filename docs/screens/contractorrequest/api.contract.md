# contractorrequest — Expected API contracts (legacy-inferred)

- `/ContactPersonsListAction`
- `/ContractorRequestAction`
- `/ContractorRequestAction.do?dispatch=downloadAttachment`
- `/ContractorRequestTypeListAction`
- `/ContractorsListAction`
- `/ContractsDepFromContractorListAction`
- `/EquipmentListAction`
- `/SellersListAction`
- `/StuffCategoriesListAction`
- `/UsersListAction`
- `ContractorRequestPrintActAction`
- `ContractorRequestPrintLetterRequestAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CRQ_ID` INTEGER NOT NULL; `CRQ_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CRQ_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CRQ_RECEIVE_DATE` DATE NOT NULL.

