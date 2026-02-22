# goodsrestinminsk (slug: `goodsrestinminsk`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/GoodsRestInMinsk.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `canEditDepartment`
- `comment`
- `con_spc`
- `ctn_number`
- `ctr_name`
- `debt_currency`
- `debt_summ_formatted`
- `dep_name`
- `departmentShow`
- `fullName`
- `goods_on_storage`
- `grid`
- `have_date_to`
- `less_3_month_formatted`
- `less_3_month_to_formatted`
- `lpc_1c_number`
- `lpc_cost_one_by_formatted`
- `lpc_count_formatted`
- `lpc_count_free_formatted`
- `lpc_count_free_to_formatted`
- `lpc_price_list_by_formatted`
- `month_3_6_formatted`
- `month_3_6_to_formatted`
- `month_6_9_formatted`
- `month_6_9_to_formatted`
- `month_9_12_formatted`
- `month_9_12_to_formatted`
- `more_12_month_formatted`
- `more_12_month_to_formatted`
- `onlyTotal`
- `order_for`
- `prc_date_formatted`
- `prc_number`
- `purpose`
- `purpose.id`
- `shipping_goods`
- `shp_date_formatted`
- `stf_name`
- `stuffCategoryShow`
- `unit`
- `userShow`
- `usr_name`
- `usr_shipping`
- `view_1c_number`
- `view_comment`
- `view_cost_one_by`
- `view_debt`
- `view_lpc_count`
- `view_order_for`
- `view_prc_date`
- `view_prc_number`
- `view_price_list_by`
- `view_purpose`
- `view_sums`
- `view_usr_shipping`

### Колонки/гриды (по JSP markup)
- `comment`
- `con_spc`
- `ctn_number`
- `ctr_name`
- `debt_currency`
- `debt_summ_formatted`
- `dep_name`
- `fullName`
- `less_3_month_formatted`
- `less_3_month_to_formatted`
- `lpc_1c_number`
- `lpc_cost_one_by_formatted`
- `lpc_count_formatted`
- `lpc_count_free_formatted`
- `lpc_count_free_to_formatted`
- `lpc_price_list_by_formatted`
- `month_3_6_formatted`
- `month_3_6_to_formatted`
- `month_6_9_formatted`
- `month_6_9_to_formatted`
- `month_9_12_formatted`
- `month_9_12_to_formatted`
- `more_12_month_formatted`
- `more_12_month_to_formatted`
- `order_for`
- `prc_date_formatted`
- `prc_number`
- `purpose`
- `shp_date_formatted`
- `stf_name`
- `unit`
- `usr_name`
- `usr_shipping`

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

