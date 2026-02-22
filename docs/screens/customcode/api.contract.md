# customcode — Expected API contracts (legacy-inferred)

- UNKNOWN endpoints (requires struts-config + runtime trace).

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CUS_ID` INTEGER NOT NULL; `CUS_CODE` VARCHAR(10) NOT NULL; `CUS_DESCRIPTION` VARCHAR(500); `CUS_PERCENT` DECIMAL(15; `CUS_INSTANT` TIMESTAMP NOT NULL; `CUS_CREATE_DATE` TIMESTAMP.

