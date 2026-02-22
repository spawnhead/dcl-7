# contractorrequest (slug: `contractorrequest`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ContractorRequest.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `actScale`
- `attachmentsGrid`
- `chief.userFullName`
- `commentFormatted`
- `con_date`
- `con_number`
- `con_seller`
- `con_seller_id`
- `contactPerson.cps_name`
- `contractForWorkNumberWithDate`
- `contractNumberWithDate`
- `contractor.name`
- `contractorOther.name`
- `createUser.userFullName`
- `createUser.usr_id`
- `crqSellerAgreementDateDialog`
- `crq_annul`
- `crq_city`
- `crq_comment`
- `crq_defect_act`
- `crq_deliver`
- `crq_enter_in_use_date`
- `crq_equipment`
- `crq_id`
- `crq_lintera_agreement_date`
- `crq_lintera_agreement_date_dialog`
- `crq_lintera_request_date`
- `crq_no_contract`
- `crq_number`
- `crq_operating_time`
- `crq_receive_date`
- `crq_reclamation_act`
- `crq_reclamation_date`
- `crq_serial_num`
- `crq_ticket_number`
- `crq_year_out`
- `ctn_number`
- `editUser.userFullName`
- `editUser.usr_id`
- `equipment.fullList`
- `formReadOnly`
- `gridStages`
- `is_new_doc`
- `letterScale`
- `lps_enter_in_use_date`
- `lps_id`
- `lps_serial_num`
- `lps_year_out`
- `mad_complexity`
- `manager.userFullName`
- `nameFormatted`
- `needDetailReturn`
- `needPrint`
- `printAct`
- `printEnumerationWork`
- `printLetterRequest`
- `printPNPTimeSheet`
- `printReclamationAct`
- `printSellerAgreement`
- `printSellerRequest`
- `produce.id`
- `produce.name`
- `requestType.name`
- `requestTypeIdCheck`
- `seller.name`
- `showContractEquipment`
- `showEquipmentFromProduce`
- `showForAdmin`
- `showForManager`
- `showPNP`
- `showService`
- `showServiceOrGuaranty`
- `shp_date`
- `spc_date`
- `spc_number`
- `specialist.userFullName`
- `stf_name`
- `stuffCategory.name`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `commentFormatted`
- `nameFormatted`
- `needPrint`

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
- Candidate mapped tables: `DCL_CONTRACTOR_REQUEST`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

