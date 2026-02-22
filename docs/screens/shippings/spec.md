# shippings (slug: `shippings`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Shippings.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `closed_all`
- `closed_closed`
- `closed_open`
- `contractor.name`
- `currency.name`
- `date_begin`
- `date_end`
- `grid`
- `number`
- `seller.name`
- `shp_block`
- `shp_contractor`
- `shp_currency`
- `shp_date_date`
- `shp_expiration`
- `shp_number`
- `shp_summ_plus_nds_formatted`
- `sum_max_formatted`
- `sum_min_formatted`

### Колонки/гриды (по JSP markup)
- `shp_block`
- `shp_contractor`
- `shp_currency`
- `shp_date_date`
- `shp_expiration`
- `shp_number`
- `shp_summ_plus_nds_formatted`

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

