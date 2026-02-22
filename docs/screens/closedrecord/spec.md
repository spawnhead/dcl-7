# closedrecord (slug: `closedrecord`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ClosedRecord.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contract.con_date_formatted`
- `contract.con_id`
- `contract.con_number`
- `contract.currency.name`
- `contractor.id`
- `contractor.name`
- `ctc_id`
- `gridResult`
- `lcc_charges`
- `lcc_montage`
- `lcc_transport`
- `lcc_update_sum`
- `managers`
- `number`
- `pay_date`
- `pay_summ`
- `products`
- `selected_payment`
- `selected_shipping`
- `shippingNumberWithOriginal`
- `showDeleteMsg`
- `showForGroupDelivery`
- `shp_date`
- `shp_summ`
- `specification.spc_date`
- `specification.spc_group_delivery`
- `specification.spc_id`
- `specification.spc_number`
- `specification.spc_summ_formatted`
- `sum_out_nds_eur`

### Колонки/гриды (по JSP markup)
- `pay_date`
- `pay_summ`
- `selected_payment`
- `selected_shipping`
- `shippingNumberWithOriginal`
- `shp_date`
- `shp_summ`

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

