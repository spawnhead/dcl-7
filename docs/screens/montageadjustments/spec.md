# montageadjustments (slug: `montageadjustments`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/MontageAdjustments.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `grid`
- `mad_complexity`
- `mad_date_from_formatted`
- `mad_machine_type`
- `mad_road_rule`
- `mad_road_sum`
- `mad_road_tariff`
- `mad_total`
- `mad_work_rule_adjustment`
- `mad_work_rule_montage`
- `mad_work_sum`
- `mad_work_tariff`
- `mad_work_type`
- `number`
- `showTable`
- `stuffCategory.name`

### Колонки/гриды (по JSP markup)
- `mad_complexity`
- `mad_date_from_formatted`
- `mad_machine_type`
- `mad_road_rule`
- `mad_road_sum`
- `mad_road_tariff`
- `mad_total`
- `mad_work_rule_adjustment`
- `mad_work_rule_montage`
- `mad_work_sum`
- `mad_work_tariff`
- `mad_work_type`
- `number`

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

