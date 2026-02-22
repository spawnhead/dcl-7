# ordersunexecuted (slug: `ordersunexecuted`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/OrdersUnexecuted.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `ctn_number`
- `fullName`
- `grid`
- `ord_count_executed_formatted`
- `ord_count_formatted`
- `ord_count_unexecuted_formatted`
- `ord_date_formatted`
- `ord_number`
- `order_by_ctn_number`
- `order_by_date`
- `order_by_number`
- `order_by_produce_full_name`
- `order_by_stf_name`
- `stf_name`

### Колонки/гриды (по JSP markup)
- `ctn_number`
- `fullName`
- `ord_count_executed_formatted`
- `ord_count_formatted`
- `ord_count_unexecuted_formatted`
- `ord_date_formatted`
- `ord_number`
- `stf_name`

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

