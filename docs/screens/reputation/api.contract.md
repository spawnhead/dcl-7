# reputation — Expected API contracts (legacy-inferred)

- `/NumbersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `RPT_ID` INTEGER NOT NULL; `RPT_LEVEL` SMALLINT NOT NULL; `RPT_DESCRIPTION` VARCHAR(500) NOT NULL; `RPT_DEFAULT_IN_CTC` SMALLINT.

