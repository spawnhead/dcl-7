# order_edit — Expected API contracts (legacy-inferred)

- UNKNOWN in normalized pass; derive from screen forms/actions and existing docs (TEST_DATA_SPEC.md; SNAPSHOT.md; ACCEPTANCE.md; CONTRACTS.md; BEHAVIOR_MATRIX.md).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `ORD_ID` INTEGER NOT NULL; `ORD_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `ORD_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `ORD_NUMBER` VARCHAR(15) NOT NULL.

