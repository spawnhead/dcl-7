# customcode (slug: `customcode`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CustomCode.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `createUser.userFullName`
- `createUserMain.userFullName`
- `cus_code`
- `cus_code_old`
- `cus_description`
- `cus_id`
- `cus_instant`
- `cus_percent`
- `editUser.userFullName`
- `editUserMain.userFullName`
- `hide_percent`
- `newCus`
- `readonly_code`
- `showCreateEditUsers`
- `usr_date_create_formatted`
- `usr_date_create_main_formatted`
- `usr_date_edit_formatted`
- `usr_date_edit_main_formatted`

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
- Candidate mapped tables: `DCL_CUSTOM_CODE`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

