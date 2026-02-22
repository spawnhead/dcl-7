# N3a2 Contract specification create — Legacy Snapshot (full 1:1)

> Дочерний экран Contract: «Добавить спецификацию». Источник истины: `Specification.jsp`, `SpecificationAction`, `SpecificationForm`, `validation.xml`, `struts-config.xml`, `xml-permissions.xml`.

## 1) Идентификация
- Вход: `ContractAction` forward `newSpecification` → `/SpecificationAction.do?dispatch=insert`.
- Экран: tile `.Specification` → `/jsp/Specification.jsp`.
- Save button вызывает `processClick()` → `dispatch=beforeSave`.
- Return: forward `back` → `/ContractAction.do?dispatch=retFromSpecificationOperation`.

## 2) Табы (порядок 1:1)
1. `mainPanel` — **Главная** (`Specification.main`)
2. `complaintSpecification` — **Претензии** (`Specification.complaint`)

## 3) Hidden/service fields
`is_new_doc`, `old_number`, `spc_id`, `spc_executed`, `spc_occupied`, `spc_occupied_in_pay_shp`, `payed_summ`, `spc_in_ctc`, `noRoundSum`, `ndsRate`.

## 4) Поля и правила

### 4.1 Tab «Главная»
- `user.userFullName/user.usr_id` serverList `/UsersListAction` (required by business rule if not executed).
- `spc_number` required, maxlength 50.
- `spc_date` required, date mask.
- `spc_summ` required currency.
- `spc_summ_nds` optional currency.
- `spc_delivery_cond` textarea 600x78, maxlength 5000.
- `deliveryTerm` serverList `/DeliveryTermTypesListAction`, required.
- `spc_additional_days_count` maxlength 3 + long, affects delivery date via ajax.
- mode checkboxes:
  - `spc_percent_or_sum_percent`
  - `spc_percent_or_sum_sum`
- `spc_delivery_percent` currency.
- `spc_delivery_sum` currency.
- `spc_delivery_date` date.
- `spc_add_pay_cond` textarea 600x78, maxlength 5000.
- `specificationPayments` editable grid (ajax load/add/remove/recalculate).
- flags: `spc_montage`, `spc_pay_after_montage`, `spc_fax_copy`, `spc_original`, `spc_group_delivery`, `spc_annul`, `spc_annul_date`.
- attachments block in main tab:
  - grid `attachmentsGrid` with download/delete,
  - copy-from-contract attachment (`copy_attachment_id/name`),
  - actions `deferredAttachCopy`, `deferredAttach`, `deleteAttachment`, `downloadAttachment`.

### 4.2 Tab «Претензии»
- `spc_letter1_date` date.
- `spc_letter2_date` date.
- `spc_letter3_date` date.
- `spc_complaint_in_court_date` date.
- `spc_comment` textarea 340x78, maxlength 5000.

## 5) Readonly/roles
From `SpecificationAction.input()`:
- admin/economist/lawyer: editable when not executed (partly admin-only when executed).
- manager-only / onlyUserInLithuania / onlyLogistic: `formReadOnly=true`.
- `spc_executed=1` => readonly.
- `showAttach` enabled only admin/economist/lawyer.
- `showAttachFiles` restricted for onlyUserInLithuania except seller `0` or `4`.

## 6) Create defaults (`insert`)
- Specification from `contract.getEmptySpecification()`.
- Attachment service created and bound.
- Payment grid reset to one row: `100%, 0, currencyName`.
- `is_new_doc=null`, `spc_executed=""`.

## 7) Save flow
1. `beforeSave`: map form -> bean, business checks:
   - if occupied, sum must be >= payed/shipped sums,
   - if not executed and user empty -> error.
2. `process`: rebuild payments list (drop zero-empty rows), `contract.insertSpecification(specification)` for new.
3. return `back` to Contract.

## 8) Spec gap vs dev gap (this task)
- **Spec gap (закрыт):** ранее было неполное покрытие вкладки «Претензии», attachments/ajax/payment и role/readOnly веток.
- **Dev gap:** не зафиксирован в этом цикле; задача Agent-Plan — расширение спецификации.

## 9) UNCONFIRMED
- Wire-format legacy AJAX payloads (payments/date/reminder/prices) и multipart вложений — UNCONFIRMED.
- How to verify: `payloads/network.har.BLOCKED.md`.
