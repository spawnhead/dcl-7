# payments — Expected API contracts (legacy-inferred)

## List/filter screen
- **POST** `/PaymentsAction.do?dispatch=filter`
  - Purpose: применить фильтр и перезагрузить грид `Payments.jsp`.
  - Request fields: `contractor.name`, `contractor.id`, `currency.id`, `date_begin`, `date_end`, `sum_min_formatted`, `sum_max_formatted`, `block`, `closed_closed|closed_open|closed_all`, `pay_account`.
  - Response expectation: HTML page `.Payments` с таблицей `grid` и рассчитанными итогами `calculatedSums`.

- **POST** `/PaymentsAction.do?dispatch=input`
  - Purpose: очистить фильтр (инициализация формы) и показать список по default-параметрам.

## Row actions
- **GET/POST** `/PaymentAction.do?dispatch=edit&pay_id=<id>` — открыть редактирование платежа.
- **GET/POST** `/PaymentAction.do?dispatch=clone&pay_id=<id>` — открыть форму клона.
- **GET** `/PaymentAction.do?dispatch=input` — создать новый платёж.

## Validation semantics
- `date_begin/date_end` должны соответствовать date mask.
- `sum_min_formatted/sum_max_formatted` — currency format.
- `contractor.name` max length 200, `pay_account` max length 35.
- Ошибки валидации ожидаются как Struts field errors (семантически: invalid date/number/maxlength).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

