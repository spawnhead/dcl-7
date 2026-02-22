# nomenclatureproduce (slug: `nomenclatureproduce`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/NomenclatureProduce.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `attachmentsGrid`
- `blank.bln_name`
- `customCode.code`
- `number1C`
- `printScale`
- `printTo`
- `produce.addParams`
- `produce.block`
- `produce.blockDateFormatted`
- `produce.blockUser`
- `produce.blockUser.userFullName`
- `produce.createDateFormatted`
- `produce.createUser`
- `produce.createUser.userFullName`
- `produce.editDateFormatted`
- `produce.editUser`
- `produce.editUser.userFullName`
- `produce.material`
- `produce.params`
- `produce.principle`
- `produce.purpose`
- `produce.specification`
- `produce.type`
- `unit.name`
- `warning`
- `warningCyrillicChars`
- `warningDigitChars`
- `warningIncorrectFirstWord`
- `warningLinesCount`

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

