# orderproduce (slug: `orderproduce`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/OrderProduce.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractOpr.con_id`
- `contractOpr.con_number`
- `contractorOpr.id`
- `contractorOpr.name`
- `course`
- `donot_calculate_netto`
- `drpPriceCoefficient`
- `drp_max_extra`
- `drp_price`
- `gridProductTerm`
- `gridReadyForShipping`
- `number`
- `opr_catalog_num`
- `opr_comment`
- `opr_count`
- `opr_count_executed`
- `opr_count_occupied`
- `opr_discount`
- `opr_id`
- `opr_occupied`
- `opr_price_brutto`
- `opr_price_netto`
- `opr_produce_name`
- `opr_use_prev_number`
- `ord_all_include_in_spec`
- `ord_by_guaranty`
- `ord_date_conf_all`
- `ord_discount_all`
- `ord_id`
- `ord_ready_for_deliv_date_all`
- `produce.name`
- `ptr_comment`
- `ptr_count_formatted`
- `ptr_date_formatted`
- `rfs_arrive_in_lithuania_formatted`
- `rfs_comment`
- `rfs_count_formatted`
- `rfs_date_formatted`
- `rfs_gabarit`
- `rfs_number`
- `rfs_ship_from_stock_formatted`
- `rfs_weight_formatted`
- `shippingDocType.name`
- `showMsg`
- `specificationOpr.spc_id`
- `specificationOpr.spc_number`
- `stf_id`

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

