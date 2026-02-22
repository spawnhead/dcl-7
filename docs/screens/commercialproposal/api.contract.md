# commercialproposal — Expected API contracts (legacy-inferred)

- `/AttachmentsAction.do?dispatch=download`
- `/BlanksListAction`
- `/CommercialProposalAction`
- `/CommercialProposalAction.do?dispatch=downloadAttachment`
- `/ContactPersonsListAction`
- `/ContractorsListAction`
- `/CurrenciesListAction`
- `/DeliveryConditionListAction`
- `/IncoTermsListAction`
- `/LogoImgsListAction`
- `/PurchasePurposesListAction`
- `/UsersListAction`
- `CommercialProposalPrintAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CPR_ID` INTEGER NOT NULL; `CPR_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CPR_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CPR_NUMBER` VARCHAR(20) NOT NULL.

