# outgoingletter — Expected API contracts (legacy-inferred)

- `/ContactPersonsListAction`
- `/ContractorsListAction`
- `/OutgoingLetterAction.do?dispatch=downloadAttachment`
- `/SellersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `OTL_ID` INTEGER NOT NULL; `OTL_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `OTL_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `OTL_NUMBER` VARCHAR(15) NOT NULL.

