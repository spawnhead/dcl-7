# currentworks (slug: `currentworks`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/CurrentWorks.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `conNumberDateFormatted`
- `contractor.name`
- `costProducesDatesFormatted`
- `crqCreateDateFormatted`
- `crq_contractor`
- `crq_equipment`
- `crq_number`
- `crq_request_type`
- `executedDatesFormatted`
- `grid`
- `manager`
- `ordDateFormatted`
- `ordSentToProdDateFormatted`
- `ordSumFormatted`
- `ord_number`
- `requestType.name`
- `shipNumbersDatesFormatted`
- `spiSendDatesFormatted`
- `stf_name`
- `stuffCategory.name`
- `user.usr_name`

### Колонки/гриды (по JSP markup)
- `conNumberDateFormatted`
- `costProducesDatesFormatted`
- `crqCreateDateFormatted`
- `crq_contractor`
- `crq_equipment`
- `crq_number`
- `crq_request_type`
- `executedDatesFormatted`
- `manager`
- `ordDateFormatted`
- `ordSentToProdDateFormatted`
- `ordSumFormatted`
- `ord_number`
- `shipNumbersDatesFormatted`
- `spiSendDatesFormatted`
- `stf_name`

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

