# nomenclature — Expected API contracts (legacy-inferred)

- `/AttachmentsAction.do?dispatch=download`
- `/CustomCodesListAction`
- `/NomenclatureAction`
- `/NomenclatureAction.do?dispatch=downloadDoubleValues`
- `/ProduceMovementForNomenclatureAction.do?dispatch=input`
- `/StuffCategoriesListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

