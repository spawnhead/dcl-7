# equipmentlist (slug: `equipmentlist`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/EquipmentList.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `con_date`
- `con_number`
- `con_seller`
- `con_seller_id`
- `crq_equipment`
- `crq_number`
- `ctn_number`
- `fullList`
- `list`
- `lps_enter_in_use_date`
- `lps_id`
- `lps_occupied`
- `lps_serial_num`
- `lps_usr_fullname`
- `lps_usr_id`
- `lps_year_out`
- `mad_complexity`
- `shp_date`
- `spc_date`
- `spc_number`
- `stf_name`

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

