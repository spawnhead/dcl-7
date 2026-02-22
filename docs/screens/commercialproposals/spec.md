# commercialproposals (slug: `commercialproposals`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CommercialProposals.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractor.name`
- `cprSumFormatted`
- `cpr_block`
- `cpr_check_price`
- `cpr_contractor`
- `cpr_currency`
- `cpr_date_date`
- `cpr_department`
- `cpr_id`
- `cpr_number`
- `cpr_proposal_declined_in`
- `cpr_proposal_received_flag_in`
- `cpr_stf_name`
- `cpr_user`
- `date_begin`
- `date_end`
- `department.name`
- `grid`
- `number`
- `reservedState`
- `showCloneMsg`
- `stuffCategory.name`
- `sum_max_formatted`
- `sum_min_formatted`
- `user.usr_name`

### Колонки/гриды (по JSP markup)
- `cprSumFormatted`
- `cpr_block`
- `cpr_check_price`
- `cpr_contractor`
- `cpr_currency`
- `cpr_date_date`
- `cpr_department`
- `cpr_number`
- `cpr_stf_name`
- `cpr_user`
- `reservedState`

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

