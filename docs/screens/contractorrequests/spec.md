# contractorrequests (slug: `contractorrequests`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/ContractorRequests.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractor.name`
- `crqNotDeliver`
- `crq_contractor`
- `crq_deliver`
- `crq_equipment`
- `crq_number`
- `crq_receive_date_formatted`
- `crq_request_type`
- `crq_seller`
- `crq_serial_number`
- `crq_ticket_number`
- `grid`
- `number`
- `requestType.name`
- `seller.name`
- `stuffCategory.name`

### Колонки/гриды (по JSP markup)
- `crq_contractor`
- `crq_deliver`
- `crq_equipment`
- `crq_number`
- `crq_receive_date_formatted`
- `crq_request_type`
- `crq_seller`
- `crq_serial_number`
- `crq_ticket_number`

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

