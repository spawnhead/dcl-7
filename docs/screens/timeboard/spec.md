# timeboard (slug: `timeboard`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Timeboard.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `checkedUser.userFullName`
- `contractorRequest.contractor.name`
- `contractorRequest.crqNumberDeliver`
- `contractorRequest.crq_equipment`
- `contractorRequest.requestType.nameById`
- `createUser.userFullName`
- `editUser.userFullName`
- `formReadOnly`
- `gridWorks`
- `is_new_doc`
- `saveReadOnly`
- `selectLine`
- `showCheckedUser`
- `tbw_comment`
- `tbw_date_formatted`
- `tbw_day_of_week`
- `tbw_from`
- `tbw_hours_all_out`
- `tbw_hours_total_out`
- `tbw_hours_update_formatted`
- `tbw_to`
- `tmb_checked`
- `tmb_checked_date`
- `tmb_checked_old`
- `tmb_date_formatted`
- `tmb_id`
- `user.userFullName`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `contractorRequest.contractor.name`
- `contractorRequest.crqNumberDeliver`
- `contractorRequest.crq_equipment`
- `contractorRequest.requestType.nameById`
- `selectLine`
- `tbw_comment`
- `tbw_date_formatted`
- `tbw_day_of_week`
- `tbw_from`
- `tbw_hours_all_out`
- `tbw_hours_total_out`
- `tbw_hours_update_formatted`
- `tbw_to`

## 3) Действия
- См. `api.contract.md` (ожидаемые endpoint based on JSP links/forms).

## 4) Валидации и ошибки
- UNKNOWN: требуется сверка `validation.xml` и runtime HAR.

## 5) DB invariants
- См. `db.invariants.md`.

## 6) Unknowns
- См. `questions.md`.
<<<<<<< HEAD

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: `DCL_TIMEBOARD`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

=======
>>>>>>> origin/main
