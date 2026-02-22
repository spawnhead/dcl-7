# contract (slug: `contract`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Contract.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `conAnnulDateFormatted`
- `con_annul`
- `con_comment`
- `con_date_formatted`
- `con_executed`
- `con_fax_copy`
- `con_final_date_formatted`
- `con_id`
- `con_number`
- `con_original`
- `con_reusable`
- `contractor.name`
- `createUser.userFullName`
- `createUser.usr_id`
- `currency.name`
- `editUser.userFullName`
- `editUser.usr_id`
- `grid`
- `is_new_doc`
- `originalFileName`
- `seller.name`
- `showAttach`
- `showAttachFiles`
- `spc_date_formatted`
- `spc_executed`
- `spc_nds_rate_formatted`
- `spc_number`
- `spc_remainder`
- `spc_summ_formatted`
- `spc_summ_nds_formatted`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `originalFileName`
- `spc_date_formatted`
- `spc_executed`
- `spc_nds_rate_formatted`
- `spc_number`
- `spc_remainder`
- `spc_summ_formatted`
- `spc_summ_nds_formatted`

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
- Candidate mapped tables: `DCL_COND_FOR_CONTRACT`, `DCL_CONTRACT`, `DCL_CONTRACTOR`, `DCL_CONTRACTOR_REQUEST`, `DCL_CONTRACTOR_USER`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

