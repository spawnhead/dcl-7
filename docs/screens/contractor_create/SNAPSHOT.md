# N3a1 Contractor create (from Contract) — Legacy Snapshot (full 1:1)

> Дочерний экран Contract: кнопка «Добавить» у поля Контрагент. Источник истины: `contractor.jsp`, `ContractorAction`, `ContractorForm`, `validation.xml`, `struts-config.xml`, `xml-permissions.xml`.

## 1) Идентификация и навигация
- Вход из Contract: `ContractAction` forward `newContractor` → `/ContractorAddActionContract.do?dispatch=create`.
- Экран: tile `.contractor` → `/jsp/contractor.jsp`.
- Save: `Contractor(Add)ActionContract.do?dispatch=process`.
- Return: forward `back` → `/ContractAction.do?dispatch=retFromContractor`.
- Session handoff: `Contractor.currentContractorId` проставляется после успешного save.

## 2) Табы (порядок 1:1)
1. `mainPanel` — **Главная** (`Contractor.main`)
2. `usersContractor` — **Курируют** (`Contractor.users`)
3. `accountsContractor` — **Расчетные счета и банковские реквизиты** (`Contractor.accounts`)
4. `contactPersonsContractor` — **Контактные лица** (`Contractor.contactPersons`)
5. `commentContractor` — **Комментарии** (`Contractor.comment`)

## 3) Скрытые/служебные поля
`ctr_id`, `is_new_doc`, `usr_date_create`, `usr_date_edit`, `createUser.*`, `editUser.*`, `lastNumber`, `lastNumberAcc`.

## 4) Поля и правила

### 4.1 Tab «Главная»
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
- `ctr_unp` minlength 6, maxlength 15 + duplicate check в `process()` (`ContractorDAO.loadByUNP`).
- `ctr_okpo` maxlength 15.
- `reputation` serverList `/ReputationsListAction` + кнопка `dispatch=editReputation`; required в бизнес-логике (default from `ReputationDAO.loadDefaultForCtc`).

Readonly/роль:
- `readOnlyReputation=true` для `onlyManager`/`onlyOtherUserInMinsk`.
- `readOnlyComment=true` для `onlyManager`/`onlyOtherUserInMinsk`.
- `adminRole` управляет сценариями в tab «Курируют».

### 4.2 Tab «Курируют»
Grid `gridUsers`:
- user (`user.userFullName`, `user.usr_id`) via `/UsersListAction`.
- delete row (`dispatch=deleteRowFromUserGrid`) доступен только admin (`showDeleteUserForAdmin`).
- add row: JS `addUserClick()` → `dispatch=addRowInUserGrid`.

Правила:
- При create всегда 1 строка с текущим пользователем.
- Не-admin при add может добавить только себя (`ContractorAction.addRowInUserGrid`).

### 4.3 Tab «Расчетные счета и банковские реквизиты»
- `ctr_bank_props` textarea 400, maxlength 800.
- Grid `gridAccounts`: `acc_name`, `acc_account`, `currency(id/name via /CurrenciesListAction)`, delete row.
- add row: `dispatch=addRowInAccountGrid`.

Правила:
- При create создаются 3 строки по умолчанию: `ctr_account1`, `ctr_account2`, `ctr_account_val`.
- Для дефолтных строк: если заполнен `acc_account`, то currency обязательна.
- Для остальных строк: обязательны и `acc_account`, и currency.
- `acc_account` maxlength 35.
- Delete у счетов виден только когда строк > 3 (`show-delete-checker`).

### 4.4 Tab «Контактные лица»
Grid `gridContactPersons`:
- колонки: `cps_name`, `cps_position`, `cps_on_reason`, `cps_phone`, `cps_mob_phone`, `cps_fax`, `cps_email`, `cps_contract_comment`, `cps_fire`, `cps_block`, edit.
- `dispatch=fireContactPerson` и `dispatch=blockContactPerson`.
- `dispatch=editPersonInContractor`.
- `dispatch=addPersonInContractor` (кнопка «Создать»).
- Icon headers: fired = `brick.gif` (tooltip `tooltip.ContactPersons.fired`), blocked = `lock.gif` (tooltip `tooltip.ContactPersons.block_status`).
- Email column uses `mailto:` link.
- Block checkbox uses `blockChecker` (readonly for non-admin).

### 4.5 Tab «Комментарии»
- `ctr_comment` textarea 400x305, maxlength 5000, может быть readonly (`readOnlyComment`).

## 5) Кнопки формы
- «Отмена»: link dispatch `back`.
- «Сохранить»: submit `dispatch=process`.
  - Success feedback: **«Контрагент успешно сохранен»** (modern notification; legacy message not confirmed).

## 6) Create defaults
- `is_new_doc=true`.
- `activePanelName=mainPanel`.
- `lastNumber=1000`, `lastNumberAcc=1000`.
- gridUsers: текущий user.
- gridAccounts: 3 дефолтных строки.
- gridContactPersons: empty.

## 7) Spec gap vs dev gap (this task)
- **Spec gap (закрыт):** ранее в spec pack были неполно зафиксированы все 5 вкладок и роль/readonly правила для grid-кнопок.
- **Dev gap:** отсутствовал ранее (TASK-0006 уже закрыл кнопку «Добавить» и экран). В текущем пакете — только спецификация/трассируемость.

## 8) UNCONFIRMED
- Точный wire-format legacy multipart/x-www-form-urlencoded для nested grid полей — **UNCONFIRMED**.
- How to verify: `payloads/network.har.BLOCKED.md` (capture create/process + grid edits).
