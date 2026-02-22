# ordersstatistics (slug: `ordersstatistics`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/OrdersStatistics.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractor.name`
- `contractor_for.name`
- `cur_name`
- `date_begin`
- `date_end`
- `department.name`
- `grid`
- `ord_summ_executed_before_formatted`
- `ord_summ_executed_formatted`
- `ord_summ_formatted`
- `ord_summ_part_executed_formatted`
- `ord_summ_sent_to_prod_formatted`
- `stf_name`
- `stuffCategory.name`

### Колонки/гриды (по JSP markup)
- `cur_name`
- `ord_summ_executed_before_formatted`
- `ord_summ_executed_formatted`
- `ord_summ_formatted`
- `ord_summ_part_executed_formatted`
- `ord_summ_sent_to_prod_formatted`
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

