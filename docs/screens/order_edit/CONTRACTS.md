# Order create/edit (legacy `/OrderAction.do`) — CONTRACTS

## Struts mappings (core)
- `/OrderAction` → `net.sam.dcl.action.OrderAction`, form `Order`, scope `session`, input `/OrderAction.do?dispatch=show`, forwards include `form`, `back`, produce/CP/import/upload routes, ajax grids.
- `/OrderProduceAction` → `net.sam.dcl.action.OrderProduceAction`, form `OrderProduce`, scope `session`.
- `/OrderExecutedProducesAction` provides executed matrix AJAX grid.

## Main dispatches on OrderAction
- Navigation/open: `input`, `edit`, `clone`, `show`, `back`.
- Save path: JS calls `ajaxCheckSave` then `process`.
- Print path: `print`, `printLetter`.
- Child dialogs/screens: `newContractor`, `newContactPerson`, `newContractorFor`, `newProduce`, `cloneProduce`, `editProduce`, `selectCP`, `importExcel`, `produceMovement`, `uploadTemplate`, `deferredAttach`.
- Return dispatches: `retFromProduceOperation`, `retFromContractor`, `retFromAttach`, `returnFromSelectCP`, `fromProduceMovement`.
- Grid row operation: `deleteProduce`, `changeViewNumber`.

## AJAX contracts

### Validation/status
- `dispatch=ajaxCheckSave`
  - Purpose: pre-save validation (empty table, drp coefficient check).
  - Response forward: `ajax`.
  - Payload: current form/session state; no dedicated JSON schema.

### CP/spec warning probes
- `dispatch=ajaxIsContractCopy` with param `contract-id`.
- `dispatch=ajaxIsSpecificationCopy` with param `specification-id`.
- Response: `ajax` forward; messages set via `StrutsUtil.setAjaxResponse`.

### Payments block
- `dispatch=ajaxOrderPaymentsGrid` → HTML fragment (`OrderPaymentsGrid.jsp`).
- `dispatch=ajaxAddToPaymentGrid` (adds row).
- `dispatch=ajaxRemoveFromPaymentGrid` with `id`.
- `dispatch=ajaxRecalculatePaymentGrid`.

### Pay sums block
- `dispatch=ajaxOrderPaySumsGrid` → HTML fragment (`OrderPaySumsGrid.jsp`).
- `dispatch=ajaxAddToPaySumGrid`.
- `dispatch=ajaxRemoveFromPaySumsGrid` with `id`.
- `dispatch=ajaxRecalcPaySumGrid`.

## Core form field names (selected critical)
- Identity/meta: `ord_id`, `is_new_doc`, `ord_number`, `ord_date`.
- Parties: `sellerForWho.id/name`, `contractor.id/name`, `contact_person.cps_id/cps_name`, `contractor_for.id/name`, `seller.id/name`.
- Link chain: `contract.con_id/con_number`, `specification.spc_id/spc_number`, `stuffCategory.id/name`, `currency.id/name`.
- Financial: `ord_donot_calculate_netto`, `ord_discount_all`, `ord_discount`, `ord_count_itog_flag`, `ord_add_reduction_flag`, `ord_add_reduction`, `ord_add_red_pre_pay_flag`, `ord_add_red_pre_pay`, `ord_include_nds`, `ord_nds_rate`, `ord_delivery_cost_by`, `ord_delivery_cost`.
- Logistics: `ord_sent_to_prod_date`, `ord_received_conf_date`, `ord_num_conf`, `ord_date_conf_all`, `ord_date_conf`, `ord_conf_sent_date`, `ord_ready_for_deliv_date_all`, `ord_ready_for_deliv_date`, `shippingDocType.id/name`, `ord_shp_doc_number`, `ord_ship_from_stock`, `ord_arrive_in_lithuania`, `ord_executed_date`, `ord_annul`.
- Signatures/print: `ord_logist_signature`, `ord_director_rb_signature`, `ord_chief_dep_signature`, `ord_manager_signature`, `show_unit`, `merge_positions`, `ord_print_scale`, `ord_letter_scale`.
- Attachments: `attachmentId`.

## Grid PKs/pagination
- Produces grid (`orderProducesGrid`) key: `number` (row logical key in form grid).
- Attachments grid key: `idx`.
- Payments/pay sums are list-index based (`orderPayments[<id>]`, `orderPaySums[<idSum>]`).
- Orders list pager params are on parent screen (`grid=NEXT_PAGE|PREV_PAGE`).

## Content-types / statuses
- Main dispatches return HTML page (200).
- AJAX grid dispatches return HTML fragment (200).
- `downloadAttachment` streams file via `attachmentService.download` (binary response, status depends on service result).

## Network HAR confirmation
- Legacy env provided on `http://localhost:8082`.
- Required capture set for parity closure:
  1) `input` new order,
  2) `ajaxCheckSave` + `process`,
  3) payments/pay sums add/remove/recalc,
  4) `ajaxIsContractCopy` and `ajaxIsSpecificationCopy`,
  5) attachment add/delete/download,
  6) external dispatch returns (`returnFromSelectCP`, `retFromProduceOperation`).
- Steps tracked in `payloads/network.har.BLOCKED.md`.
