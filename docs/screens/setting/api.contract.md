# setting — Expected API contracts (legacy-inferred)

- `/${Setting.stn_action}`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `STN_ID` INTEGER NOT NULL; `STN_NAME` VARCHAR(100) NOT NULL; `STN_DESCRIPTION` VARCHAR(256); `STN_VALUE` VARCHAR(1000); `STN_TYPE` SMALLINT NOT NULL; `STN_ACTION` VARCHAR(100).

