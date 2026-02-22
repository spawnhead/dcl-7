# users — Expected API contracts (legacy-inferred)

- `/DepartmentsListAction`
- `/UserAction.do?dispatch=create`
- `/UserAction.do?dispatch=edit`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).
<<<<<<< HEAD

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `UST_ID` INTEGER NOT NULL; `UST_NAME` VARCHAR(100) NOT NULL; `UST_DESCRIPTION` VARCHAR(256); `UST_VALUE` VARCHAR(1000); `UST_TYPE` SMALLINT NOT NULL; `UST_ACTION` VARCHAR(100).

=======
>>>>>>> origin/main
