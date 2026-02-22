# producecost — Expected API contracts (legacy-inferred)

- `/RoutesListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `PRC_ID` INTEGER NOT NULL; `PRC_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `PRC_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `PRC_NUMBER` VARCHAR(50) NOT NULL.

