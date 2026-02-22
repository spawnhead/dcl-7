# order — Expected API contracts (legacy-inferred)

- `/AttachmentsAction.do?dispatch=download`
- `/BlanksListAction`
- `/ContactPersonsListAction`
- `/ContractorsListAction`
- `/ContractsDepFromContractorListAction`
- `/CurrenciesListAction`
- `/IncoTermsListAction`
- `/OrderAction`
- `/OrderAction.do?dispatch=downloadAttachment`
- `/SellersListAction`
- `/ShippingDocTypesListAction`
- `/SpecificationsDepFromContractListAction`
- `/StuffCategoriesListAction`
- `/UsersListAction`
- `CoveringLetterForOrderPrintAction`
- `OrderPrintAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `ORD_ID` INTEGER NOT NULL; `ORD_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `ORD_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `ORD_NUMBER` VARCHAR(15) NOT NULL.

