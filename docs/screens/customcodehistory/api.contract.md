# customcodehistory — Expected API contracts (legacy-inferred)

- `/CustomCodeFromHistoryAction.do`
- `/CustomCodeFromHistoryAction.do?dispatch=edit`
- `/CustomCodesAction.do?dispatch=execute`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

