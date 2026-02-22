# montageadjustmenthistory (slug: `montageadjustmenthistory`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/MontageAdjustmentHistory.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `mad_date_from_formatted`
- `mad_el_road_rule_formatted`
- `mad_el_road_tariff_formatted`
- `mad_el_work_rule_adjustment_formatted`
- `mad_el_work_rule_montage_formatted`
- `mad_el_work_tariff_formatted`
- `mad_id`
- `mad_mech_road_rule_formatted`
- `mad_mech_road_tariff_formatted`
- `mad_mech_work_rule_adjustment_formatted`
- `mad_mech_work_rule_montage_formatted`
- `mad_mech_work_tariff_formatted`
- `madh_id`

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

