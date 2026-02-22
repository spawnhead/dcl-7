# user — Expected API contracts (legacy-inferred)

- `/DepartmentsListAction`
- `/UserAction.do?dispatch=downloadAttachment`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `CPS_ID` INTEGER NOT NULL; `USR_ID` INTEGER NOT NULL.

