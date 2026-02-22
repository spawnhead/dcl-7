# deliveryrequestpositions (slug: `deliveryrequestpositions`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/DeliveryRequestPositions.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `count_formatted`
- `ctn_number`
- `gridLeft`
- `gridRight`
- `manager.userFullName`
- `name_filter`
- `needReload`
- `ord_number`
- `position.count_formatted`
- `position.ctn_number`
- `position.produce.addParams`
- `position.produce.name`
- `position.produce.params`
- `position.produce.type`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `selected_id`
- `shipped_count_formatted`
- `target`

### Колонки/гриды (по JSP markup)
- `count_formatted`
- `ctn_number`
- `position.count_formatted`
- `position.ctn_number`
- `position.produce.addParams`
- `position.produce.name`
- `position.produce.params`
- `position.produce.type`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `selected_id`

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

