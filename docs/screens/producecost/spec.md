# producecost (slug: `producecost`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ProduceCost.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `catalogNumberForStuffCategory`
- `createUser.userFullName`
- `createUser.usr_id`
- `department.name`
- `editUser.userFullName`
- `editUser.usr_id`
- `formReadOnly`
- `gridCustom`
- `gridProduces`
- `is_new_doc`
- `lpc_1c_number`
- `lpc_cost_one_by_formatted`
- `lpc_cost_one_formatted`
- `lpc_cost_one_ltl_formatted`
- `lpc_count_formatted`
- `lpc_custom_formatted`
- `lpc_percent_formatted`
- `lpc_price_list_by_formatted`
- `lpc_sum_transport_formatted`
- `lpc_summ_allocation_formatted`
- `lpc_summ_formatted`
- `lpc_weight_formatted`
- `manager.usr_code`
- `needRecalc`
- `prc_block`
- `prc_course_ltl_eur_formatted`
- `prc_date`
- `prc_id`
- `prc_number`
- `prc_sum_transport_formatted`
- `prc_weight_formatted`
- `produce.unit.name`
- `produce_name`
- `route.name`
- `stuffCategory.name`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `catalogNumberForStuffCategory`
- `department.name`
- `lpc_cost_one_formatted`
- `lpc_count_formatted`
- `lpc_custom_formatted`
- `lpc_percent_formatted`
- `lpc_sum_transport_formatted`
- `lpc_summ_allocation_formatted`
- `lpc_summ_formatted`
- `lpc_weight_formatted`
- `manager.usr_code`
- `produce.unit.name`
- `produce_name`
- `stuffCategory.name`

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
- Candidate mapped tables: `DCL_PRODUCE_COST`, `DCL_PRODUCE_COST_CUSTOM`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

