# blanks (slug: `blanks`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Blanks.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `bln_charset`
- `bln_images`
- `bln_language`
- `bln_name`
- `bln_note`
- `bln_preamble`
- `bln_type`
- `bln_usage_formatted`
- `gridBlanks`
- `printExample`
- `sln_name`

### Колонки/гриды (по JSP markup)
- `bln_charset`
- `bln_images`
- `bln_language`
- `bln_name`
- `bln_note`
- `bln_preamble`
- `bln_type`
- `bln_usage_formatted`
- `printExample`
- `sln_name`

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

