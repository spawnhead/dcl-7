# order (slug: `order`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Order.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `blank.bln_name`
- `blank.bln_note`
- `blank.bln_preamble`
- `calculate_netto`
- `catalogNumberForStuffCategory`
- `chief_dep.userFullName`
- `contact_person.cps_email`
- `contact_person.cps_fax`
- `contact_person.cps_name`
- `contact_person.cps_phone`
- `contract.con_id`
- `contract.con_number`
- `contract.seller.resident`
- `contractNumberWithDate`
- `contractor.email`
- `contractor.name`
- `contractor_for.name`
- `createUser.userFullName`
- `createUser.usr_id`
- `currency.name`
- `deliveryCondition.name`
- `deliveryCondition.nameExtended`
- `director.userFullName`
- `director_rb.userFullName`
- `donot_calculate_netto`
- `drp_price_formatted`
- `editUser.userFullName`
- `editUser.usr_id`
- `executedOrPartExecuted`
- `formReadOnly`
- `is_new_doc`
- `is_warn`
- `logist.userFullName`
- `manager.userFullName`
- `merge_positions`
- `noRoundSum`
- `opr_count_executed_formatted`
- `opr_count_formatted`
- `opr_discount_formatted`
- `opr_price_brutto_formatted`
- `opr_price_netto_formatted`
- `opr_summ_formatted`
- `opr_use_prev_number`
- `ord_add_info`
- `ord_add_red_pre_pay`
- `ord_add_red_pre_pay_flag`
- `ord_add_reduction`
- `ord_add_reduction_flag`
- `ord_addr`
- `ord_all_include_in_spec`
- `ord_annul`
- `ord_arrive_in_lithuania`
- `ord_by_guaranty`
- `ord_chief_dep_signature`
- `ord_comment`
- `ord_comment_covering_letter`
- `ord_concerning`
- `ord_conf_sent_date`
- `ord_count_itog_flag`
- `ord_date`
- `ord_date_conf`
- `ord_date_conf_all`
- `ord_delivery_cost`
- `ord_delivery_cost_by`
- `ord_delivery_cost_currency`
- `ord_delivery_term`
- `ord_director_rb_signature`
- `ord_discount`
- `ord_discount_all`
- `ord_donot_calculate_netto`
- `ord_executed_date`
- `ord_id`
- `ord_in_one_spec`
- `ord_include_nds`
- `ord_letter_scale`
- `ord_logist_signature`
- `ord_manager_signature`
- `ord_nds_rate`
- `ord_num_conf`

### Колонки/гриды (по JSP markup)
- `catalogNumberForStuffCategory`
- `drp_price_formatted`
- `opr_count_executed_formatted`
- `opr_count_formatted`
- `opr_discount_formatted`
- `opr_price_brutto_formatted`
- `opr_price_netto_formatted`
- `opr_summ_formatted`
- `opr_use_prev_number`
- `produce.addParams`
- `produce.params`
- `produce.type`
- `produce_name`
- `specificationNumbers`
- `viewNumber`

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
- Candidate mapped tables: `DCL_ORDER`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

