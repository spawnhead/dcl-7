# seller — Expected API contracts (legacy-inferred)

- UNKNOWN endpoints (requires struts-config + runtime trace).

Error semantics: UNKNOWN (verify via legacy runtime/HAR).
<<<<<<< HEAD

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `SLN_ID` INTEGER NOT NULL; `SLN_NAME` VARCHAR(100) NOT NULL; `SLN_USED_IN_ORDER` SMALLINT; `SLN_PREFIX_FOR_ORDER` VARCHAR(10); `SLN_IS_RESIDENT` SMALLINT.

=======
>>>>>>> origin/main
