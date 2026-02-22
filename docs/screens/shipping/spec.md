# shipping (slug: `shipping`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Shipping.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractNumberWithDate`
- `contractNumberWithDateWhere`
- `contractor.name`
- `contractorWhere.name`
- `createUser.userFullName`
- `currency.name`
- `editUser.userFullName`
- `formReadOnly`
- `manager.userFullName`
- `noticeScale`
- `printNotice`
- `showBlockMsg`
- `showPayAfterMontage`
- `shp_block`
- `shp_closed`
- `shp_comment`
- `shp_complaint_in_court_date`
- `shp_date`
- `shp_date_create`
- `shp_date_edit`
- `shp_date_expiration`
- `shp_id`
- `shp_letter1_date`
- `shp_letter2_date`
- `shp_letter3_date`
- `shp_montage`
- `shp_montage_checkbox`
- `shp_notice_date`
- `shp_number`
- `shp_original`
- `shp_serial_num_year_out`
- `shp_serial_num_year_out_checkbox`
- `shp_sum_update_formatted`
- `shp_summ_plus_nds_formatted`
- `shp_summ_transport_formatted`
- `specification.spc_add_pay_cond`
- `specificationNumberWithDate`

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
<<<<<<< HEAD

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: `DCL_READY_FOR_SHIPPING`, `DCL_SHIPPING`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

=======
>>>>>>> origin/main
