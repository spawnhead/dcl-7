# deliveryrequestproduce (slug: `deliveryrequestproduce`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/DeliveryRequestProduce.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `apr_id`
- `asm_id`
- `contractNumberWithDate`
- `course`
- `customer.name`
- `customerAssemble`
- `dlr_fair_trade`
- `dlr_guarantee_repair`
- `dlr_include_in_spec`
- `dlr_need_deliver`
- `drpPriceCoefficient`
- `drp_count`
- `drp_id`
- `drp_max_extra`
- `drp_occupied`
- `drp_price`
- `drp_purpose`
- `number`
- `opr_id`
- `opr_price_netto`
- `ordInfoAssemble`
- `ord_date`
- `ord_number`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `purpose.name`
- `readonliLikeImported`
- `receiveManager.userFullName`
- `receiveManager.usr_id`
- `receive_date`
- `showDrpPrice`
- `showMaxExtra`
- `sip_id`
- `specificationNumberWithDate`
- `spi_date`
- `spi_number`
- `stuffCategory.name`

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

