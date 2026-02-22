# contractor (slug: `contractor`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/contractor.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `acc_account`
- `acc_name`
- `country.name`
- `cps_block`
- `cps_contract_comment`
- `cps_fax`
- `cps_fire`
- `cps_mob_phone`
- `cps_name`
- `cps_on_reason`
- `cps_phone`
- `cps_position`
- `createUser.userFullName`
- `createUser.usr_name`
- `createUser.usr_surname`
- `ctr_add_info`
- `ctr_address`
- `ctr_bank_props`
- `ctr_building`
- `ctr_comment`
- `ctr_email`
- `ctr_fax`
- `ctr_full_name`
- `ctr_id`
- `ctr_index`
- `ctr_name`
- `ctr_okpo`
- `ctr_phone`
- `ctr_place`
- `ctr_region`
- `ctr_street`
- `ctr_unp`
- `currency.name`
- `editUser.userFullName`
- `editUser.usr_name`
- `editUser.usr_surname`
- `fillActivePanel`
- `gridAccounts`
- `gridContactPersons`
- `gridUsers`
- `is_new_doc`
- `lastNumber`
- `lastNumberAcc`
- `reputation.description`
- `user.userFullName`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `acc_name`
- `cps_block`
- `cps_contract_comment`
- `cps_fax`
- `cps_fire`
- `cps_mob_phone`
- `cps_name`
- `cps_on_reason`
- `cps_phone`
- `cps_position`

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
- Candidate mapped tables: `DCL_CONTRACTOR`, `DCL_CONTRACTOR_REQUEST`, `DCL_CONTRACTOR_USER`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

