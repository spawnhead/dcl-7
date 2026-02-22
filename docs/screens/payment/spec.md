# payment (slug: `payment`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Payment.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractor.name`
- `createUser.userFullName`
- `createUser.usr_id`
- `currency.name`
- `editUser.userFullName`
- `editUser.usr_id`
- `is_new_doc`
- `payCourseFormatted`
- `payCourseNbrbDateFormatted`
- `payCourseNbrbFormatted`
- `pay_account`
- `pay_block`
- `pay_comment`
- `pay_course_nbrb_date`
- `pay_date`
- `pay_id`
- `pay_summ_eur_formatted`
- `pay_summ_eur_nbrb_formatted`
- `pay_summ_formatted`
- `pay_summ_nr_formatted`
- `usr_date_create`
- `usr_date_edit`

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
- Candidate mapped tables: `DCL_ORD_LIST_PAYMENT`, `DCL_PAYMENT`, `DCL_SPC_LIST_PAYMENT`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

