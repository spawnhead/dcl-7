# blank — Expected API contracts (legacy-inferred)

- `/BlankTypesListAction`
- `/HeadImgsListAction`
- `/LanguagesListAction`
- `/SellersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `BLN_ID` INTEGER NOT NULL; `BLN_TYPE` SMALLINT NOT NULL; `BLN_NAME` VARCHAR(150) NOT NULL; `LNG_ID` INTEGER NOT NULL; `BLN_CHARSET` VARCHAR(20) NOT NULL; `BLN_PREAMBLE` VARCHAR(1000).

