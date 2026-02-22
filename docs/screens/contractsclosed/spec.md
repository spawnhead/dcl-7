# contractsclosed (slug: `contractsclosed`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ContractsClosed.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `admin`
- `con_number`
- `contract.con_number`
- `contractor.name`
- `ctc_block`
- `ctc_contractor`
- `ctc_date_date`
- `ctc_number`
- `date_begin`
- `date_end`
- `grid`
- `not_block`
- `selectedContractId`

### Колонки/гриды (по JSP markup)
- `con_number`
- `ctc_block`
- `ctc_contractor`
- `ctc_date_date`
- `ctc_number`
- `selectedContractId`

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

