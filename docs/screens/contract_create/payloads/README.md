# N3a Contract create — Payloads

Примеры request/response для open/create. Восстановлены из legacy ContractAction, ContractForm, validation.xml.

---

## open-response.json
Ответ GET /api/contracts/create/open (или эквивалент).

## save-request.json
Тело POST /api/contracts/create/save при валидном create.

## save-request-invalid.json
Пример невалидного запроса (пустой contractor).

## save-response.json
Ответ 200 при успешном save.

## save-response-validation-error.json
Ответ 400 при validation error.
