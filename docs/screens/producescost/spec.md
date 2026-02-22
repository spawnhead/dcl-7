# producescost (slug: `producescost`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ProducesCost.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `block_in_filter`
- `date_begin`
- `date_end`
- `grid`
- `number`
- `number_1c`
- `prc_block`
- `prc_date_date`
- `prc_number`
- `prc_route`
- `route.name`

### Колонки/гриды (по JSP markup)
- `prc_block`
- `prc_date_date`
- `prc_number`
- `prc_route`

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

