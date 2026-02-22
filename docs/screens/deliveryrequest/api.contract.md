# deliveryrequest — Expected API contracts (legacy-inferred)

- `/DeliveryRequestAction`
- `/UsersListAction`
- `DeliveryRequestPrintAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `DLR_ID` INTEGER NOT NULL; `DLR_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `DLR_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `DLR_PLACE_DATE` TIMESTAMP.

