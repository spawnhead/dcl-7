# specificationimport (slug: `specificationimport`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/SpecificationImport.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `catalogNumberForStuffCategory`
- `createUser.userFullName`
- `createUser.usr_id`
- `customCode`
- `custom_percent_formatted`
- `customer.name`
- `drp_price_formatted`
- `editUser.userFullName`
- `editUser.usr_id`
- `expiration`
- `gridSpec`
- `is_new_doc`
- `ord_number_date`
- `produce.fullName`
- `produce.unit.name`
- `purpose.name`
- `sip_cost_formatted`
- `sip_count_formatted`
- `sip_price_formatted`
- `sip_weight_formatted`
- `spi_arrive_from`
- `spi_comment`
- `spi_course`
- `spi_date`
- `spi_id`
- `spi_koeff`
- `spi_number`
- `stuffCategory.name`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `catalogNumberForStuffCategory`
- `customCode`
- `customer.name`
- `drp_price_formatted`
- `expiration`
- `ord_number_date`
- `produce.fullName`
- `produce.unit.name`
- `sip_cost_formatted`
- `sip_count_formatted`
- `stuffCategory.name`

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
- Candidate mapped tables: `DCL_SPECIFICATION_IMPORT`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

