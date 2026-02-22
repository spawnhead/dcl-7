# customcodes — Expected API contracts (legacy-inferred)

- `/CustomCodeAction.do?dispatch=create`
- `/CustomCodeAction.do?dispatch=edit`
- `/CustomCodeFastCreateAction.do?dispatch=create`
- `/CustomCodeHistoryAction.do`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

