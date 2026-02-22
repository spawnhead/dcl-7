# conditionforcontract (slug: `conditionforcontract`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ConditionForContract.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `annulUser.userFullName`
- `annulUser.usr_id`
- `attachmentsGrid`
- `catalogNumberForStuffCategory`
- `ccp_cost_formatted`
- `ccp_count_formatted`
- `ccp_nds_cost_formatted`
- `ccp_nds_formatted`
- `ccp_nds_rate_formatted`
- `ccp_price_formatted`
- `cfcAnnulDateFormatted`
- `cfc_annul`
- `cfc_check_price`
- `cfc_check_price_date`
- `cfc_comment`
- `cfc_con_date`
- `cfc_con_number_txt`
- `cfc_count_delivery`
- `cfc_custom_point`
- `cfc_date_con_to`
- `cfc_delivery_cond`
- `cfc_delivery_count1`
- `cfc_delivery_count2`
- `cfc_doc_type1`
- `cfc_doc_type2`
- `cfc_execute`
- `cfc_guarantee_cond`
- `cfc_id`
- `cfc_montage_cond`
- `cfc_need_invoice`
- `cfc_pay_cond`
- `cfc_place`
- `cfc_spc_date`
- `cfc_spc_number_txt`
- `cfc_spc_numbers`
- `conFinalDate`
- `contactPerson.cps_email`
- `contactPerson.cps_fax`
- `contactPerson.cps_mob_phone`
- `contactPerson.cps_name`
- `contactPerson.cps_phone`
- `contactPerson.cps_position`
- `contactPersonSign.cps_name`
- `contactPersonSign.cps_on_reason`
- `contactPersonSign.cps_position`
- `contract.annulStr`
- `contract.numberWithDateAndReusable`
- `contractNumberWithDate`
- `contractor.address`
- `contractor.bank_props`
- `contractor.email`
- `contractor.fax`
- `contractor.fullname`
- `contractor.id`
- `contractor.name`
- `contractor.phone`
- `cpr_number_date`
- `createUser.userFullName`
- `createUser.usr_id`
- `currency.name`
- `editUser.userFullName`
- `editUser.usr_id`
- `executeUser.userFullName`
- `executeUser.usr_id`
- `formReadOnly`
- `grid`
- `is_new_doc`
- `number`
- `number1C`
- `placeUser.userFullName`
- `placeUser.usr_id`
- `print`
- `printScale`
- `produceFullName`
- `purchasePurpose.name`
- `seller.id`
- `seller.name`
- `showDownload`
- `showFields`
- `showForAdmin`

### Колонки/гриды (по JSP markup)
- `catalogNumberForStuffCategory`
- `ccp_cost_formatted`
- `ccp_count_formatted`
- `ccp_nds_cost_formatted`
- `ccp_nds_formatted`
- `ccp_nds_rate_formatted`
- `ccp_price_formatted`
- `cpr_number_date`
- `number`
- `number1C`
- `produceFullName`
- `stuffCategory.name`
- `unitName`

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

