# instruction (slug: `instruction`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Instruction.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `createUser.userFullName`
- `createUser.usr_id`
- `editUser.userFullName`
- `editUser.usr_id`
- `ins_concerning`
- `ins_date_from`
- `ins_date_sign`
- `ins_date_to`
- `ins_id`
- `ins_number`
- `is_new_doc`
- `showForAdmin`
- `type.name`
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
- Candidate mapped tables: `DCL_INSTRUCTION`, `DCL_INSTRUCTION_TYPE`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

