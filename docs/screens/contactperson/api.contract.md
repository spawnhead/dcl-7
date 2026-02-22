# contactperson — Expected API contracts (legacy-inferred)

- `/UsersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CPS_ID` INTEGER NOT NULL; `CTR_ID` INTEGER NOT NULL; `CPS_NAME` VARCHAR(200) NOT NULL; `CPS_PHONE` VARCHAR(150); `CPS_FAX` VARCHAR(150); `CPS_BLOCK` SMALLINT.

