# contractor_create — Expected API contracts (legacy-inferred)

- UNKNOWN in normalized pass; derive from screen forms/actions and existing docs (TEST_DATA_SPEC.md; SNAPSHOT.md; ACCEPTANCE.md; CONTRACTS.md; BEHAVIOR_MATRIX.md).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CTR_ID` INTEGER NOT NULL; `CTR_NAME` VARCHAR(200) NOT NULL; `CTR_EMAIL` VARCHAR(40); `CTR_BANK_PROPS` VARCHAR(800); `CTR_UNP` VARCHAR(15); `CTR_FULL_NAME` VARCHAR(300).

