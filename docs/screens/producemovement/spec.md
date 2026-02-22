# producemovement (slug: `producemovement`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ProduceMovement.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `divide_into_chain`
- `grid`
- `ordDateFormatted`
- `ordNumberFormatted`
- `ordProduceCountExecutedFormatted`
- `ordProduceCountFormatted`
- `prcDateFormatted`
- `prcProduceCountAndRest`
- `prc_number`
- `produceFullName`
- `showLegend`
- `showLegendInput`
- `showLegendOrder`
- `showLegendTransit`
- `shpDateFormatted`
- `shpProduceCountFormatted`
- `shp_contractor`
- `shp_number`
- `trnDateFormatted`
- `trnNumberFormatted`
- `trnProduceCountAndRest`

### Колонки/гриды (по JSP markup)
- `ordDateFormatted`
- `ordNumberFormatted`
- `ordProduceCountExecutedFormatted`
- `ordProduceCountFormatted`
- `prcDateFormatted`
- `prcProduceCountAndRest`
- `prc_number`
- `shpDateFormatted`
- `shpProduceCountFormatted`
- `shp_contractor`
- `shp_number`
- `trnDateFormatted`
- `trnNumberFormatted`
- `trnProduceCountAndRest`

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

