# N3a — Contract create (Создать договор) — Legacy Snapshot

> Spec pack для экрана создания договора. Доступ: Contracts list кнопка «Создать» → `/contracts/new`. Восстановлено из legacy кода (ContractAction, Contract.jsp, ContractForm, validation.xml).

## 1) Идентификация
- Legacy route: `/ContractAction.do?dispatch=input`.
- Tile/JSP: `.Contract` → `/jsp/Contract.jsp`.
- Modern route: `/contracts/new`.
- Struts Action: `net.sam.dcl.action.ContractAction` (`input`, `show`, `process`, `back`).
- Form: `net.sam.dcl.form.ContractForm`.
- Permissions: xml-permissions.xml:585 — admin, economist, lawyer.

## 2) UI-слепок формы (порядок полей 1:1)

### 2.1 Скрытые поля (для create не отображаются)
- `con_id`, `is_new_doc`, `con_executed`, `usr_date_create`, `usr_date_edit`, `createUser.usr_id`, `editUser.usr_id`.

### 2.2 Блок «Документ создал/сохранил»
- При `is_new_doc != true` (edit): Contract.create, Contract.edit + даты/пользователи (read-only).
- При create: блок скрыт (logic:notEqual).

### 2.3 Основные поля (create)
| Поле | Контрол | Обязательность | Валидация | Дефолт | readonly condition |
|------|---------|----------------|-----------|--------|-------------------|
| con_number | text, width 230px | required | maxlength 50 | "" | readOnlyIfNotAdminEconomistLawyer |
| con_date | date (DD.MM.YYYY) | required | mask, date | — | readOnlyIfNotAdminEconomistLawyer |
| con_reusable | checkbox value="1" | — | — | "" | readOnlyIfNotAdminEconomistLawyer |
| con_final_date | date | условно* | mask, date | "" | — |
| contractor | serverList ContractorsListAction + **кнопка «Добавить»** | required | — | empty | readOnlyIfOccupied |
| currency | serverList CurrenciesListAction selectOnly | required | — | empty | readOnlyIfOccupied |
| con_fax_copy | checkbox value="1" | — | — | "" | readOnlyIfNotAdminEconomistLawyer |
| con_original | checkbox value="1" | — | — | "" | readOnlyIfNotAdminEconomistLawyer |
| seller | serverList SellersListAction selectOnly | required | — | empty | readOnlyIfNotAdminEconomistLawyer |
| con_annul | checkbox value="1" | — | — | "" | readOnlyForAnnul |
| con_annul_date | date | — | mask, date | "" | readOnlyForAnnul |
| con_comment | textarea 600x75 | — | maxlength 5000 | "" | readOnlyIfNotAdminEconomistLawyer |

*con_final_date: JS validation — обязателен когда `!con_reusable && seller.id=="1"` (msg.contract.requiredConFinalDate). Validation.xml: mask, date (не required).

**Кнопка «Добавить» у контрагента:** рядом с полем contractor (Contract.jsp:78–80). dispatch=newContractor → forward ContractorAddActionContract.do?dispatch=create → экран создания контрагента (contractor.jsp). После сохранения → ContractAction.do?dispatch=retFromContractor → новый contractor.id подставляется в форму. Traceability: ContractAction.newContractor(), struts-config forward newContractor.

**Checkboxes взаимоисключающие:** con_fax_copy ⟂ con_original (JS conFaxCopyOnClick, conOriginalOnClick). Сохраняется как con_original: "" | "0" | "1" (0=факсовая копия, 1=оригинал).

### 2.4 Табличная часть «Спецификации»
- **Обязательно отображается** на форме (Contract.jsp:143–183). grid:table property="grid" key="spc_number".
- Колонки: spc_number, spc_date_formatted, spc_summ_formatted, spc_nds_rate_formatted, spc_summ_nds_formatted, spc_remainder, spc_executed (readonly), Edit, Delete, Attach.
- При create: grid пустой (0 строк), но блок и заголовок «Табличная часть» видны.
- Кнопка «Добавить Спецификацию» (button.addSpecification) в gridBottom → dispatch newSpecification → SpecificationAction.do?dispatch=insert (отдельный экран). Traceability: struts-config forward newSpecification.

### 2.5 Прикреплённые файлы
- **Обязательно отображается** на форме (Contract.jsp:205–241). Заголовок Contract.attachments, grid:table property="attachmentsGrid" key="idx".
- При create: grid пустой (0 строк), но блок и заголовок «Прикреплённые файлы» видны.
- Кнопка «Прикрепить» (button.attach) → dispatch deferredAttach (только showAttach=true: admin, economist, lawyer). Traceability: struts-config forward attach → DeferredAttachmentsAction.dispatch=init.

### 2.6 Кнопки
- «Отмена» → dispatch back → forward back → `/ContractsAction.do?dispatch=restore` (возврат в список).
- «Сохранить» → processClick() → submitDispatchForm("process") → ContractAction.process.

## 3) Lookups (legacy serverList)
- contractor: `/ContractorsListAction` (filter).
- currency: `/CurrenciesListAction` (selectOnly).
- seller: `/SellersListAction` (selectOnly).

## 4) Роли и readonly
- admin, economist, lawyer: formReadOnly=false, showAttach=true, readOnlyForAnnul по canAnnul.
- manager (без admin/economist/lawyer): formReadOnly=true.
- user_in_lithuania, logistic: formReadOnly=true.
- showAttachFiles: по seller (0,4,6,7) или !onlyUserInLithuania.
- readOnlyIfOccupied: con_occupied не пусто или formReadOnly.

## 5) После сохранения
- saveCommon → ContractDAO.insert (если con_id пусто) → back() → forward back → Contracts list.
- Контракт появляется в гриде списка (ContractsAction.restore).

## 6) Navigation (N3a1 / N3a2 / N3a3)
- **N3a1 Добавить у contractor:** клик → navigate `/contractors/new?returnTo=contract`. После save → redirect `/contracts/new?newContractorId={ctrId}`; Contract form refresh contractors + set contractor by id. Spec pack: [docs/screens/contractor_create/](../contractor_create/).
- **N3a2 Добавить Спецификацию:** клик → navigate `/contracts/draft/specifications/new` (при create) или `/contracts/:conId/specifications/new` (при edit). После save → return `/contracts/new`; grid +1 row. Spec pack: [docs/screens/contract_spec_create/](../contract_spec_create/).
- **N3a3 Прикрепить:** клик (showAttach) → navigate `/contracts/draft/attachments` (при create) или `/contracts/:conId/attachments` (при edit). Spec pack: [docs/screens/contract_attachments/](../contract_attachments/).
- Условия видимости: кнопка «Добавить» — readOnlyIfOccupied; «Добавить Спецификацию» — всегда при create; «Прикрепить» — showAttach (admin, economist, lawyer).

## 7) Traceability
- ContractAction.java: input, inputCommon, show, process, back, saveCommon.
- Contract.jsp: строки 11–281.
- ContractForm.java: все поля.
- validation.xml: /ContractAction:process (928–986).
- sql-resources.xml: contract-insert (831–847).
- application.properties: Contract.*, error.contract.*, msg.contract.*.
- Child spec packs: contractor_create (N3a1), contract_spec_create (N3a2), contract_attachments (N3a3).
