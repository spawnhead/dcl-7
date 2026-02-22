# shippingreport (slug: `shippingreport`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ShippingReport.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `con_date_formatted`
- `con_number`
- `contractor.name`
- `country`
- `ctn_number`
- `currency`
- `date_begin`
- `date_end`
- `department`
- `department.name`
- `grid`
- `include_all`
- `include_closed`
- `include_opened`
- `itog_by_produce`
- `itog_by_product`
- `itog_by_shp`
- `itog_by_user`
- `lps_count_formatted`
- `lps_custom_formatted`
- `lps_sum_transport_formatted`
- `lps_summ_out_nds_eur_formatted`
- `lps_summ_out_nds_formatted`
- `lps_summ_zak_formatted`
- `manager`
- `not_include_zero`
- `onlyTotal`
- `produce_full_name`
- `readOnlyForManager`
- `showForChiefDep`
- `showLegend`
- `showShpNumDate`
- `shp_contractor`
- `shp_date_formatted`
- `shp_number`
- `spc_date_formatted`
- `spc_number`
- `spc_summ_formatted`
- `stf_name`
- `sumPlusNdsFormatted`
- `user.userFullName`
- `view_contract`
- `view_contractor`
- `view_country`
- `view_department`
- `view_department_left`
- `view_produce`
- `view_stuff_category`
- `view_summ`
- `view_summ_eur`
- `view_summ_without_nds`
- `view_user`
- `view_user_left`

### Колонки/гриды (по JSP markup)
- `con_date_formatted`
- `con_number`
- `country`
- `ctn_number`
- `currency`
- `department`
- `lps_count_formatted`
- `lps_custom_formatted`
- `lps_sum_transport_formatted`
- `lps_summ_out_nds_eur_formatted`
- `lps_summ_out_nds_formatted`
- `lps_summ_zak_formatted`
- `manager`
- `produce_full_name`
- `shp_contractor`
- `shp_date_formatted`
- `shp_number`
- `spc_date_formatted`
- `spc_number`
- `spc_summ_formatted`
- `stf_name`
- `sumPlusNdsFormatted`

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

