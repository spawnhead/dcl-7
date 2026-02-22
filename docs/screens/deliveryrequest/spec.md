# deliveryrequest (slug: `deliveryrequest`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/DeliveryRequest.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `addHide`
- `catalogNumberForStuffCategory`
- `createUser.userFullName`
- `createUser.usr_id`
- `customerContractSpec`
- `direction`
- `dlr_annul`
- `dlr_comment`
- `dlr_date`
- `dlr_executed`
- `dlr_executed_old`
- `dlr_fair_trade`
- `dlr_guarantee_repair`
- `dlr_id`
- `dlr_include_in_spec`
- `dlr_need_deliver`
- `dlr_number`
- `dlr_ord_not_form`
- `dlr_place_request_form`
- `dlr_place_request_save`
- `dlr_wherefrom`
- `drp_count`
- `drp_price_formatted`
- `drp_purpose`
- `editUser.userFullName`
- `editUser.usr_id`
- `fakeOne`
- `formReadOnly`
- `gridResult`
- `inDoc`
- `is_new_doc`
- `numDateOrdShowForFairTrade`
- `ord_number_date`
- `orderImportHide`
- `outDoc`
- `placeUser.userFullName`
- `placeUser.usr_id`
- `print`
- `printScale`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `produce.unit.name`
- `purpose.name`
- `receiveManager.userFullName`
- `receive_date_formatted`
- `showAnnul`
- `showSpecification`
- `specImportHide`
- `specificationNumbers`
- `spi_number_date`
- `stuffCategory.name`
- `unitName`
- `usr_date_create`
- `usr_date_edit`
- `usr_date_place`

### Колонки/гриды (по JSP markup)
- `catalogNumberForStuffCategory`
- `customerContractSpec`
- `drp_count`
- `drp_price_formatted`
- `drp_purpose`
- `ord_number_date`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `produce.unit.name`
- `purpose.name`
- `specificationNumbers`
- `spi_number_date`
- `stuffCategory.name`
- `unitName`

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
- Candidate mapped tables: `DCL_DELIVERY_REQUEST`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

