# routes — Expected API contracts (legacy-inferred)

- `/RouteAction.do?dispatch=edit`
- `/RouteAction.do?dispatch=input`
- `/RoutesAction.do?dispatch=delete`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

