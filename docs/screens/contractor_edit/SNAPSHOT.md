# Contractor Edit (References → Контрагенты → Edit) — Legacy Snapshot (full 1:1)

> Экран редактирования контрагента. Вход: из списка Contractors (edit icon) или из связанных потоков. Источник истины: `contractor.jsp`, `ContractorAction`, `ContractorForm`, `validation.xml`, `struts-config.xml`, `xml-permissions.xml`.

## 1) Идентификация и навигация
- Вход из Contractors list: `/ContractorAction.do?dispatch=edit&ctr_id_journal={ctrId}` → modern `/contractors/{ctrId}/edit`.
- Вход для Contact Persons: `/ContractorAction.do?dispatch=editContactPersons&ctr_id_journal={ctrId}` → modern `/contractors/{ctrId}/edit?tab=contactPersons`.
- Экран: tile `.contractor` → `/jsp/contractor.jsp`.
- Save: `ContractorAction.do?dispatch=process`.
- Return: forward `back` → `/ContractorsAction.do` (contractors list).
- Session handoff: `Contractor.currentContractorId` обновляется после успешного save.

## 2) Табы (порядок 1:1, идентичен create)
1. `mainPanel` — **Главная** (`Contractor.main`)
2. `usersContractor` — **Курируют** (`Contractor.users`)
3. `accountsContractor` — **Расчетные счета и банковские реквизиты** (`Contractor.accounts`)
4. `contactPersonsContractor` — **Контактные лица** (`Contractor.contactPersons`)
5. `commentContractor` — **Комментарии** (`Contractor.comment`)

## 3) Скрытые/служебные поля
`ctr_id`, `is_new_doc=false`, `usr_date_create`, `usr_date_edit`, `createUser.*`, `editUser.*`, `lastNumber`, `lastNumberAcc`.

## 4) Отличия от create (edit-specific)

### 4.1 Header: информация о создании/редактировании
При `is_new_doc=false` (редактирование) отображается:
```
Создано: {usr_date_create} {createUser.userFullName}
Изменено: {usr_date_edit} {editUser.userFullName}
```
(строки 22–37 в contractor.jsp)

### 4.2 Form read-only при blocked contractor
Если `ctr_block="1"`, форма становится полностью read-only (`formReadOnly=true`).
(строки 215–222 в ContractorAction.java)

### 4.3 UNP duplicate check при edit
При редактировании UNP проверяется на дубликат, **исключая текущий контрагент**:
```java
if (null != contractor && !contractor.getId().equalsIgnoreCase(form.getCtr_id()))
```
(строки 314–320 в ContractorAction.java)

### 4.4 Grids загружаются из БД
- `gridUsers` — из `select-contractor_users`.
- `gridAccounts` — из `select-accounts`.
- `gridContactPersons` — из `select-contact-persons` + `select-contact_person_users`.

## 5) Поля и правила (те же, что в create)

### 5.1 Tab «Главная»
- `ctr_name` text 400 — **required**, maxlength 200.
- `ctr_full_name` text 400 — **required**, maxlength 300.
- `country` (`country.id/name`) serverList `/CountriesListAction` + кнопка `dispatch=addCountry`.
- `ctr_address` readonly, вычисляется из `ctr_index/region/place/street/building/add_info` (JS `onAddressChanged`).
- `ctr_index` maxlength 20.
- `ctr_region` maxlength 50.
- `ctr_place` maxlength 50.
- `ctr_street` maxlength 50.
- `ctr_building` maxlength 20.
- `ctr_add_info` maxlength 1000.
- `ctr_phone` maxlength 100.
- `ctr_fax` maxlength 100.
- `ctr_email` maxlength 40 + email validator.
- `ctr_unp` minlength 6, maxlength 15 + duplicate check (исключая текущий ctr_id).
- `ctr_okpo` maxlength 15.
- `reputation` serverList `/ReputationsListAction` + кнопка `dispatch=editReputation`; required в бизнес-логике.

Readonly/роль:
- `readOnlyReputation=true` для `onlyManager`/`onlyOtherUserInMinsk`.
- `readOnlyComment=true` для `onlyManager`/`onlyOtherUserInMinsk`.
- `adminRole` управляет сценариями в tab «Курируют».
- `formReadOnly=true` если `ctr_block="1"` (заблокированный контрагент).

### 5.2 Tab «Курируют»
Grid `gridUsers`:
- user (`user.userFullName`, `user.usr_id`) via `/UsersListAction`.
- delete row (`dispatch=deleteRowFromUserGrid`) доступен только admin (`showDeleteUserForAdmin`).
- add row: JS `addUserClick()` → `dispatch=addRowInUserGrid`.

Правила:
- При edit загружаются существующие users из БД.
- Не-admin при add может добавить только себя.

### 5.3 Tab «Расчетные счета и банковские реквизиты»
- `ctr_bank_props` textarea 400, maxlength 800.
- Grid `gridAccounts`: `acc_name`, `acc_account`, `currency(id/name via /CurrenciesListAction)`, delete row.
- add row: `dispatch=addRowInAccountGrid`.

Правила:
- При edit загружаются существующие accounts из БД.
- Для дефолтных строк: если заполнен `acc_account`, то currency обязательна.
- Для остальных строк: обязательны и `acc_account`, и currency.
- `acc_account` maxlength 35.
- Delete у счетов виден только когда строк > 3 (`show-delete-checker`).

### 5.4 Tab «Контактные лица»
Grid `gridContactPersons`:
- колонки: `cps_name`, `cps_position`, `cps_on_reason`, `cps_phone`, `cps_mob_phone`, `cps_fax`, `cps_email`, `cps_contract_comment`, `cps_fire`, `cps_block`, edit.
- `dispatch=fireContactPerson` и `dispatch=blockContactPerson`.
- `dispatch=editPersonInContractor`.
- `dispatch=addPersonInContractor` (кнопка «Создать»).
- Icon headers: fired = `brick.gif`, blocked = `lock.gif`.
- Email column uses `mailto:` link.
- Block checkbox uses `blockChecker` (readonly for non-admin).

### 5.5 Tab «Комментарии»
- `ctr_comment` textarea 400x305, maxlength 5000, может быть readonly (`readOnlyComment`).

## 6) Кнопки формы
- «Отмена»: link dispatch `back` → возврат на contractors list.
- «Сохранить»: submit `dispatch=process`.
  - Success feedback: **«Контрагент успешно сохранен»** (modern notification).
  - Redirect: на contractors list (или returnTo, если передан).

## 7) Delete (отдельный action)
- Delete доступен только если `!contractor.isOccupied()` (show-delete-checker).
- Legacy: `/ContractorAction.do?dispatch=delete&ctr_id_journal={ctrId}`.
- Modern: `DELETE /api/contractors/{ctrId}`.
- Popconfirm перед удалением (текст UNCONFIRMED).

## 8) Occupied check
- `contractor.isOccupied()` проверяет, связан ли контрагент с договорами, заказами или другими сущностями.
- Если occupied=true:
  - Delete скрыт.
  - Редактирование разрешено (кроме delete).

## 9) UNCONFIRMED
- Точный текст Popconfirm для delete — **UNCONFIRMED**. How to verify: удалить контрагента в legacy и зафиксировать текст.
- Точный wire-format legacy multipart/x-www-form-urlencoded для nested grid полей — **UNCONFIRMED**.
- How to verify: `payloads/network.har.BLOCKED.md` (capture edit/process + grid edits).

## 10) Traceability
- Struts Action: `net.sam.dcl.action.ContractorAction` (edit, editContactPersons, process, delete).
- Form: `net.sam.dcl.form.ContractorForm`.
- JSP: `src/main/webapp/jsp/contractor.jsp`.
- SQL: `contractor-load`, `contractor-update`, `contractor-delete`, `select-contractor_users`, `select-accounts`, `select-contact-persons`.
- Validation: `/ContractorAction:process`.
- Permissions: `xml-permissions.xml` `/ContractorAction.do`.
