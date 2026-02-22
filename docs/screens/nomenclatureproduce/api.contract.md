# nomenclatureproduce — Expected API contracts (legacy-inferred)

- `/BlanksListAction`
- `/NomenclatureProduceAction`
- `/NomenclatureProduceAction.do?dispatch=downloadAttachment`
- `/NomenclatureProduceCustomCodeHistoryAction.do?dispatch=show`
- `/NomenclatureProducePrintAction`
- `/Number1CHistoryAction.do?dispatch=show`
- `/UnitsListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

