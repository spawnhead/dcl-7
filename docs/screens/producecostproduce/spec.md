# producecostproduce (slug: `producecostproduce`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ProduceCostProduce.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `apr_id`
- `asm_id`
- `department.name`
- `drp_id`
- `lpc_1c_number`
- `lpc_comment`
- `lpc_cost_one_by`
- `lpc_cost_one_ltl`
- `lpc_count`
- `lpc_id`
- `lpc_occupied`
- `lpc_percent_dcl_1_4`
- `lpc_price_list_by`
- `lpc_produce_name`
- `lpc_summ`
- `lpc_weight`
- `manager.userFullName`
- `number`
- `opr_id`
- `prc_date`
- `prc_id`
- `produce.name`
- `purpose.name`
- `readonliLikeImported`
- `sip_id`
- `stuffCategory.name`

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

