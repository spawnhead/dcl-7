# goodscirculation (slug: `goodscirculation`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/GoodsCirculation.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `by_contractor`
- `by_month`
- `by_quarter`
- `contractor`
- `contractorGoodsCirculation.name`
- `ctn_number`
- `date_begin`
- `date_end`
- `fullName`
- `grid`
- `includeWithNoCirculationAndWithRest`
- `lpsCountFormatted`
- `ordInProducerFormatted`
- `produceName`
- `restInLithuaniaFormatted`
- `restInMinskFormatted`
- `seller.name`
- `showContractor`
- `stf_name`
- `stuffCategory.name`
- `unit`

### Колонки/гриды (по JSP markup)
- `contractor`
- `ctn_number`
- `fullName`
- `lpsCountFormatted`
- `ordInProducerFormatted`
- `restInLithuaniaFormatted`
- `restInMinskFormatted`
- `stf_name`
- `unit`

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

