# Order create/edit (legacy `/OrderAction.do`) — SNAPSHOT

## Entry flows and dispatches
- Create: `/OrderAction.do?dispatch=input`.
- Edit: `/OrderAction.do?dispatch=edit` (with `ord_id`).
- Clone: `/OrderAction.do?dispatch=clone` (with `ord_id`).
- Main page dispatches from `Order.jsp`: `newContractor`, `newContactPerson`, `newContractorFor`, `selectCP`, `importExcel`, `newProduce`, `cloneProduce`, `editProduce`, `deleteProduce`, `changeViewNumber`, `produceMovement`, `uploadTemplate`, `deferredAttach`, `deleteAttachment`, `printLetter`, `print`, `back` (+ JS `process`).
- AJAX dispatches used on page: `ajaxCheckSave`, `ajaxIsContractCopy`, `ajaxIsSpecificationCopy`, `ajaxOrderPaymentsGrid`, `ajaxAddToPaymentGrid`, `ajaxRemoveFromPaymentGrid`, `ajaxRecalculatePaymentGrid`, `ajaxOrderPaySumsGrid`, `ajaxAddToPaySumGrid`, `ajaxRemoveFromPaySumsGrid`, `ajaxRecalcPaySumGrid`.

## Defaults and number generation
- `input` sets:
  - `ord_date` = current date,
  - `is_new_doc="true"`,
  - `ord_donot_calculate_netto="1"`,
  - `ord_in_one_spec="1"`,
  - `show_unit=""`, `merge_positions="1"`,
  - signature flags all = `"1"`,
  - `director`, `logist`, `director_rb` by config codes, `manager` = current user,
  - `currency` by message key `Order.default_currency`,
  - payments: one row `(100%,0,currency)`; pay sums: one row `(0,"")`.
- `ord_number` is readonly in UI. For new/clone, action sets it empty and DB insert uses `dcl_order_insert(:ord_number, ...)`; final numbering is generated/persisted during save flow in legacy DB-side logic.

## UI sections (1:1 from `Order.jsp`)
1. Header meta (create/edit timestamps/users for non-new docs).
2. Seller-for-who + number + contractor (+Add) + date + contact person (+Add) + blank + phones/fax/email.
3. Text blocks: `ord_concerning`, `ord_preamble`, readonly blank preamble.
4. In-one-spec area:
   - `ord_in_one_spec` checkbox,
   - seller, contractor_for (+Add), contract, specification, clean button.
5. Order-level toggles/financial parameters:
   - `ord_all_include_in_spec`, `ord_by_guaranty`, `stuffCategory`, `currency`,
   - `ord_donot_calculate_netto`, `ord_discount_all`, `ord_discount`,
   - `ord_count_itog_flag`, `ord_add_reduction_flag` + amount,
   - `ord_add_red_pre_pay_flag` + amount,
   - `ord_include_nds`, `ord_nds_rate`,
   - delivery cost fields: `ord_delivery_cost_by`, `ord_delivery_cost`.
6. Produces grid (`orderProducesGrid`) + bottom actions:
   - import CP, import Excel, add produce, save template/download template.
7. Signatures block:
   - director/logist/director_rb/chief_dep/manager + signature checkboxes.
8. Logistics block:
   - `ord_sent_to_prod_date`, `ord_received_conf_date`, `ord_num_conf`,
   - `ord_date_conf_all` + `ord_date_conf`, `ord_conf_sent_date`,
   - `ord_ready_for_deliv_date_all` + `ord_ready_for_deliv_date`,
   - `shippingDocType`, `ord_shp_doc_number`, `ord_ship_from_stock`, `ord_arrive_in_lithuania`,
   - `ord_executed_date`, `ord_comment`, `ord_annul`.
9. Attachments grid (`attachmentsGrid`): filename link (download), delete icon, Add button.
10. Payments AJAX block (`OrderPaymentsGrid.jsp`).
11. Pay sums AJAX block (`OrderPaySumsGrid.jsp`).
12. Covering letter comment (`ord_comment_covering_letter`).
13. Print params (`show_unit`, `merge_positions`, `ord_letter_scale`, `ord_print_scale`) + actions Print letter / Print / Cancel / Save.

## Role/read-only states
- `formReadOnly=true` when blocked (`ord_block=1`) or current user is only-user-in-Lithuania.
- `readOnlyIfNotLikeManager` edit permissions: admin/economist/logistic/manager and not `formReadOnly`.
- `readOnlyIfNotLikeLogist`: admin/economist/logistic and not `formReadOnly`.
- `readOnlyIfNotLikeLogistOrManager` (attachments/signatures): admin/economist/manager/logistic and not blocked.
- `readOnlyIfNotLikeLogistOrUIL` (`ord_arrive_in_lithuania`): admin/economist/logistic/user-in-Lithuania and not blocked.

## BLOCKED_FIELD (depends on external screens)
- `BLOCKED_FIELD: contractor.name` / `contractor.id`
  - `dependsOnScreen`: `/ContractorAddActionOrder.do?dispatch=create`
  - `How to verify in legacy`: open order on `8082`, click Add near contractor, create contractor, return (`retFromContractor`).
- `BLOCKED_FIELD: contact_person.cps_name` / `contact_person.cps_id`
  - `dependsOnScreen`: `/ContactPersonAddActionOrder.do?dispatch=create`
  - `How to verify in legacy`: select contractor, click Add contact, save, return.
- `BLOCKED_FIELD: contractor_for.name` / `contractor_for.id`
  - `dependsOnScreen`: `/ContractorAddActionOrder.do?dispatch=createForOrder`
  - `How to verify in legacy`: in in-one-spec block click Add near contractor_for.
- `BLOCKED_FIELD: produces import from CP`
  - `dependsOnScreen`: `/SelectCPOrderAction.do?dispatch=input` (+ CP list screen)
  - `How to verify in legacy`: click “importCommercialProposal”, pick CP, observe `returnFromSelectCP`.
- `BLOCKED_FIELD: produces import from Excel`
  - `dependsOnScreen`: `/OrderImportAction.do?dispatch=input`
  - `How to verify in legacy`: click import Excel and complete upload/import flow.
- `BLOCKED_FIELD: produce row internals`
  - `dependsOnScreen`: `/OrderProduceAction.do?dispatch=insert|edit|clone` (`OrderProduce.jsp`)
  - `How to verify in legacy`: open add/edit produce dialog, save back via `retFromProduceOperation`.
- `BLOCKED_FIELD: executed-by-date matrix`
  - `dependsOnScreen`: `/OrderExecutedProducesAction.do?dispatch=edit` (`OrderExecutedProducesGrid.jsp`)
  - `How to verify in legacy`: click execute icon in grid header and edit executed quantities by date.
- `BLOCKED_FIELD: produce movement details`
  - `dependsOnScreen`: `/ProduceMovementForOrderAction.do?dispatch=input`
  - `How to verify in legacy`: click produce name link in grid and return via `fromProduceMovement`.
