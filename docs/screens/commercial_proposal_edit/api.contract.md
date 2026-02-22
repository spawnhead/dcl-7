# commercial_proposal_edit — Expected API contracts (legacy-inferred)

- UNKNOWN in normalized pass; derive from screen forms/actions and existing docs (TEST_DATA_SPEC.md; SNAPSHOT.md; CONTRACTS.md; BEHAVIOR_MATRIX.md).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CPR_ID` INTEGER NOT NULL; `CPR_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `CPR_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `CPR_NUMBER` VARCHAR(20) NOT NULL.

