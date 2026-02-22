# filespath — Expected API contracts (legacy-inferred)

- UNKNOWN endpoints (requires struts-config + runtime trace).

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `FLP_ID` INTEGER NOT NULL; `FLP_TABLE_NAME` VARCHAR(32) NOT NULL; `FLP_PATH` VARCHAR(1024) NOT NULL; `FLP_DESCRIPTION` VARCHAR(200).

