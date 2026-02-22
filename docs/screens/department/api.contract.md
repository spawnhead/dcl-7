# department — Expected API contracts (legacy-inferred)

- UNKNOWN endpoints (requires struts-config + runtime trace).

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `DEP_ID` INTEGER NOT NULL; `DEP_NAME` VARCHAR(100) NOT NULL.

