# montageadjustment — Expected API contracts (legacy-inferred)

- `/ComplexityCategoryListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `MAD_ID` INTEGER NOT NULL; `STF_ID` INTEGER NOT NULL; `MAD_MACHINE_TYPE` VARCHAR(1000) NOT NULL; `MAD_COMPLEXITY` VARCHAR(10) NOT NULL; `MAD_ANNUL` SMALLINT.

