# country — Expected API contracts (legacy-inferred)

- UNKNOWN endpoints (requires struts-config + runtime trace).

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CUT_ID` INTEGER NOT NULL; `CUT_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CUT_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CUT_NAME` VARCHAR(50) NOT NULL.

