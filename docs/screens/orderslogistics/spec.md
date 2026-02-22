# orderslogistics (slug: `orderslogistics`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/OrdersLogistics.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `by_product`
- `comment`
- `conf_date`
- `contractor_contact_person`
- `date_begin`
- `date_end`
- `grid`
- `include_empty_dates`
- `ord_conf_num`
- `shp_doc_type_num`
- `view_weight`
- `weight_formatted`

### Колонки/гриды (по JSP markup)
- `comment`
- `conf_date`
- `contractor_contact_person`
- `ord_conf_num`
- `shp_doc_type_num`
- `weight_formatted`

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

