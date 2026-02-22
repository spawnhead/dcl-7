# commercialproposal (slug: `commercialproposal`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CommercialProposal.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `blank.bln_name`
- `calculate_netto`
- `charge`
- `consignee.name`
- `contactPerson.cps_fax`
- `contactPerson.cps_name`
- `contactPerson.cps_phone`
- `contactPersonCustomer.cps_name`
- `contactPersonSeller.cps_name`
- `contractor.name`
- `cpr_add_info`
- `cpr_all_transport`
- `cpr_assemble_minsk_store`
- `cpr_can_edit_invoice`
- `cpr_comment`
- `cpr_concerning`
- `cpr_concerning_invoice`
- `cpr_contract_scale`
- `cpr_country`
- `cpr_course_formatted`
- `cpr_date`
- `cpr_date_accept`
- `cpr_delay_days`
- `cpr_delivery_address`
- `cpr_delivery_count_day`
- `cpr_delivery_term`
- `cpr_delivery_term_invoice`
- `cpr_donot_calculate_netto`
- `cpr_executor_flag`
- `cpr_final_date`
- `cpr_final_date_above`
- `cpr_final_date_invoice`
- `cpr_free_prices`
- `cpr_guaranty_in_month`
- `cpr_id`
- `cpr_img_name`
- `cpr_invoice_scale`
- `cpr_nds_by_string`
- `cpr_nds_formatted`
- `cpr_no_reservation`
- `cpr_number`
- `cpr_old_version`
- `cpr_pay_condition`
- `cpr_pay_condition_invoice`
- `cpr_preamble`
- `cpr_prepay_percent`
- `cpr_prepay_sum`
- `cpr_print_scale`
- `cpr_proposal_declined`
- `cpr_proposal_received_flag`
- `cpr_provider_delivery`
- `cpr_provider_delivery_address`
- `cpr_reverse_calc`
- `cpr_sum_assembling_formatted`
- `cpr_sum_transport_formatted`
- `cpr_tender_number`
- `cpr_tender_number_editable`
- `createUser.userFullName`
- `createUser.usr_id`
- `currency.name`
- `currencyTable.name`
- `dateAcceptReadOnly`
- `deliveryCondition.nameExtended`
- `donot_calculate_netto`
- `editUser.userFullName`
- `editUser.usr_id`
- `executor.userFullName`
- `facsimile_flag`
- `formReadOnly`
- `gridCharges`
- `includeInPrice`
- `is_new_doc`
- `priceCondition.name`
- `priceCondition.nameExtended`
- `print`
- `printContract`
- `printInvoice`
- `printMode`
- `purchasePurpose.name`

### Колонки/гриды (по JSP markup)
- `charge`
- `includeInPrice`

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
- Candidate mapped tables: `DCL_COMMERCIAL_PROPOSAL`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

