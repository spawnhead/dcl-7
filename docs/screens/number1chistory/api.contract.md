# number1chistory — Expected API contracts (legacy-inferred)

- `/Number1CFromHistoryAction.do?dispatch=create`
- `/Number1CFromHistoryAction.do?dispatch=edit`
- `NomenclatureProduceAction.do?dispatch=edit&id=${Number1CHistory.prd_id}`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

