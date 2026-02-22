# producesforassembleminsk (slug: `producesforassembleminsk`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ProducesForAssembleMinsk.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `countReservedFormatted`
- `ctn_number`
- `gridLeft`
- `gridRight`
- `lpc_1c_number`
- `name_filter`
- `number_1c`
- `position.count_formatted`
- `position.ctn_number`
- `position.produce.fullName`
- `prc_date_min`
- `produce.fullName`
- `route.name`
- `selected_id`
- `shipped_count_formatted`

### Колонки/гриды (по JSP markup)
- `countReservedFormatted`
- `ctn_number`
- `lpc_1c_number`
- `position.count_formatted`
- `position.ctn_number`
- `position.produce.fullName`
- `produce.fullName`
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

