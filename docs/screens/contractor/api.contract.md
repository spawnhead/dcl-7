# contractor — Expected API contracts (legacy-inferred)

- `/CountriesListAction`
- `/CurrenciesListAction`
- `/ReputationsListAction`
- `/UsersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CTR_ID` INTEGER NOT NULL; `CTR_NAME` VARCHAR(200) NOT NULL; `CTR_EMAIL` VARCHAR(40); `CTR_BANK_PROPS` VARCHAR(800); `CTR_UNP` VARCHAR(15); `CTR_FULL_NAME` VARCHAR(300).

