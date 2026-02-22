# instruction — Expected API contracts (legacy-inferred)

- `/InstructionAction.do?dispatch=downloadAttachment`
- `/InstructionTypesListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `INS_ID` INTEGER NOT NULL; `INS_CREATE_DATE` TIMESTAMP NOT NULL; `USR_ID_CREATE` INTEGER NOT NULL; `INS_EDIT_DATE` TIMESTAMP NOT NULL; `USR_ID_EDIT` INTEGER NOT NULL; `IST_ID` INTEGER NOT NULL.

