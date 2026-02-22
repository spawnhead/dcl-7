# timeboard — Expected API contracts (legacy-inferred)

- `/UsersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `TMB_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL; `TMB_DATE` DATE NOT NULL; `TMB_CHECKED` SMALLINT; `TMB_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL.

