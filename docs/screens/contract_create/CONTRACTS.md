# N3a Contract create — API Contracts

> Источник: legacy ContractAction (input, show, process), ContractForm, validation.xml, sql-resources contract-insert.

## 1) GET `/api/contracts/create/open` (initial load для create)

Назначение: загрузить форму создания (defaults, lookups для contractor/currency/seller).

Request: `GET /api/contracts/create/open` (или query param mode=create).

Response (200):
```json
{
  "defaults": {
    "conNumber": "",
    "conDate": "",
    "conReusable": false,
    "conFinalDate": "",
    "contractor": null,
    "currency": null,
    "conFaxCopy": false,
    "conOriginal": false,
    "seller": null,
    "conAnnul": false,
    "conAnnulDate": "",
    "conComment": "",
    "isNewDoc": true,
    "conExecuted": "0"
  },
  "lookups": {
    "contractors": [{ "id": "string", "name": "string" }],
    "currencies": [{ "id": "string", "name": "string" }],
    "sellers": [{ "id": "string", "name": "string" }]
  },
  "canCreate": true
}
```

Traceability: ContractAction.input → inputCommon → getCurrentFormFromBean(empty Contract) → show. Lookups: ContractorsListAction, CurrenciesListAction, SellersListAction.

## 2) POST `/api/contracts/create/save`

Назначение: сохранить новый договор (эквивалент dispatch=process).

Request body:
```json
{
  "conNumber": "string",
  "conDate": "DD.MM.YYYY",
  "conReusable": false,
  "conFinalDate": "DD.MM.YYYY|string-empty",
  "contractor": { "id": "string", "name": "string" },
  "currency": { "id": "string", "name": "string" },
  "conFaxCopy": false,
  "conOriginal": false,
  "seller": { "id": "string", "name": "string" },
  "conAnnul": false,
  "conAnnulDate": "DD.MM.YYYY|string-empty",
  "conComment": "string",
  "specifications": []
}
```

Validation (из validation.xml + saveCommon):
- conNumber: required, maxlength 50.
- conDate: required, DD.MM.YYYY.
- contractor.id: required.
- currency.id: required.
- seller.id: required.
- conFinalDate: если !conReusable && seller.id=="1" → required (JS msg.contract.requiredConFinalDate).
- conAnnulDate, conFinalDate: mask, date если не пусто.
- conComment: maxlength 5000.
- specifications: каждая неисполненная (spc_executed empty) должна иметь user.usr_id (error.contract.spc_user_empty).

Response (200):
```json
{
  "conId": "string",
  "redirectTo": "/contracts"
}
```

Response (400) validation error:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "fields": [
      { "name": "conNumber", "message": "Введите \"Номер\" договора" },
      { "name": "contractor.id", "message": "Выберите \"Контрагента\"" }
    ]
  }
}
```

Traceability: ContractAction.process → saveCommon → ContractDAO.insert → back.

**Payload encoding:** Payload files (`payloads/*.json`) must be UTF-8 encoded. When using curl with `--data-binary @file`, ensure the file is saved in UTF-8. Cyrillic in CP1251 causes `Invalid UTF-8` and 400.

## 3) Navigation (N3a1 / N3a2 / N3a3)
- **N3a1 «Добавить» у contractor:** navigate `/contractors/new?returnTo=contract`. Return: redirect `/contracts/new?newContractorId={ctrId}`; Contract form refresh contractors list + set contractor by id. Spec pack: docs/screens/contractor_create/.
- **N3a2 «Добавить Спецификацию»:** navigate `/contracts/draft/specifications/new`. Return: spec in Contract.grid (in-memory); redirect `/contracts/new`. Spec pack: docs/screens/contract_spec_create/.
- **N3a3 «Прикрепить»:** navigate `/contracts/draft/attachments`. Return: back → `/contracts/new`. Spec pack: docs/screens/contract_attachments/.
- **Refresh contractors после N3a1:** при return с newContractorId — Contract form вызывает GET /api/contracts/create/open или GET /api/lookups/contractors с refresh; подставляет contractor по id.

## 4) Lookups (отдельные или в open)

- Contractors: search/filter (legacy ContractorsListAction).
- Currencies: full list (CurrenciesListAction selectOnly).
- Sellers: full list (SellersListAction selectOnly).

Могут быть встроены в /open или вызываться отдельно при фокусе. Legacy: serverList при вводе.

## 5) UNCONFIRMED / How to verify

- Точный wire-формат legacy serverList (ContractorsListAction, CurrenciesListAction, SellersListAction): HTML options vs JSON.
- **HOW TO VERIFY:** открыть legacy `/ContractAction.do?dispatch=input`; в DevTools Network снять запросы при фокусе/поиске в contractor, currency, seller; зафиксировать URL и response.
