# specification (slug: `specification`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Specification.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `copy_attachment_name`
- `currencyName`
- `deliveryTerm.name`
- `is_new_doc`
- `ndsRate`
- `noRoundSum`
- `old_number`
- `original`
- `originalFileName`
- `payed_date_formatted`
- `payed_summ`
- `readOnlySaveButton`
- `showAttach`
- `showAttachFiles`
- `spc_add_pay_cond`
- `spc_additional_days_count`
- `spc_annul`
- `spc_annul_date`
- `spc_comment`
- `spc_complaint_in_court_date`
- `spc_date`
- `spc_delivery_cond`
- `spc_delivery_date`
- `spc_delivery_percent`
- `spc_delivery_sum`
- `spc_executed`
- `spc_fax_copy`
- `spc_group_delivery`
- `spc_id`
- `spc_in_ctc`
- `spc_letter1_date`
- `spc_letter2_date`
- `spc_letter3_date`
- `spc_montage`
- `spc_number`
- `spc_occupied`
- `spc_occupied_in_pay_shp`
- `spc_original`
- `spc_pay_after_montage`
- `spc_percent_or_sum_percent`
- `spc_percent_or_sum_sum`
- `spc_summ`
- `spc_summ_nds`
- `user.userFullName`

### Колонки/гриды (по JSP markup)
- `originalFileName`

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
- Candidate mapped tables: `DCL_SPECIFICATION_IMPORT`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

=======
>>>>>>> origin/main
