# commercialproposalproduce (slug: `commercialproposalproduce`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CommercialProposalProduce.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `cpr_old_version`
- `customCodeFormatted`
- `custom_code.code`
- `custom_code.custom_percent_formatted`
- `custom_code.percentFormatted`
- `donot_calculate_netto`
- `emptyProduce`
- `enterCustomCode`
- `haveProduceButEmptyCusCode`
- `lpr_catalog_num`
- `lpr_coeficient`
- `lpr_comment`
- `lpr_count`
- `lpr_discount`
- `lpr_price_brutto`
- `lpr_price_netto`
- `lpr_produce_name`
- `lpr_sale_price`
- `number`
- `numberBefore`
- `produce.fullName`
- `reverseCalc`
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

