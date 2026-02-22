# nomenclatureproducesmerge (slug: `nomenclatureproducesmerge`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/NomenclatureProducesMerge.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `leftAddParams`
- `leftMaterial`
- `leftNameDE`
- `leftNameDEValue`
- `leftNameEN`
- `leftNameENValue`
- `leftNameRU`
- `leftParams`
- `leftPrinciple`
- `leftPurporse`
- `leftSpecification`
- `leftType`
- `leftUnit`
- `newId`
- `oldId`
- `rightAddParams`
- `rightMaterial`
- `rightNameDE`
- `rightNameDEValue`
- `rightNameEN`
- `rightNameENValue`
- `rightNameRU`
- `rightParams`
- `rightPrinciple`
- `rightPurporse`
- `rightSpecification`
- `rightType`
- `rightUnit`
- `sourceProduce.addParams`
- `sourceProduce.material`
- `sourceProduce.name`
- `sourceProduce.params`
- `sourceProduce.principle`
- `sourceProduce.purpose`
- `sourceProduce.specification`
- `sourceProduce.type`
- `sourceUnit.name`
- `targetProduce.addParams`
- `targetProduce.material`
- `targetProduce.name`
- `targetProduce.params`
- `targetProduce.principle`
- `targetProduce.purpose`
- `targetProduce.specification`
- `targetProduce.type`
- `targetUnit.name`

### Колонки/гриды (по JSP markup)
- UNKNOWN

## 3) Действия
- См. `api.contract.md` (ожидаемые endpoint based on JSP links/forms).

## 4) Валидации и ошибки
- UNKNOWN: требуется сверка `validation.xml` и runtime HAR.

## 5) DB invariants
- См. `db.invariants.md`.

## 6) Unknowns
- См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

