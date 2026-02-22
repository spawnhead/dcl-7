# calculationstate (slug: `calculationstate`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CalculationState.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractNumberWithDate`
- `contractorCalcState.id`
- `contractorCalcState.name`
- `currencyCalcState.name`
- `departmentCalcState.name`
- `earliest_doc_date`
- `include_all_specs`
- `isDebit`
- `notShowExpiredContractZeroBalance`
- `not_include_if_earliest`
- `not_include_zero`
- `not_show_annul`
- `readonlyEditCtrButton`
- `reportType.name`
- `sellerCalcState.name`
- `userCalcState.userFullName`
- `view_comment`
- `view_complaint`
- `view_delivery_cond`
- `view_expiration`
- `view_manager`
- `view_pay_cond`
- `view_stuff_category`

### Колонки/гриды (по JSP markup)
- UNKNOWN

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

