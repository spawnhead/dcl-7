# N3b Contract import from CP — API Contracts

> Источник: legacy SelectFromGridAction, CommercialProposalsAction, ContractAction.importCP. Legacy возвращает HTML; modern API — REST/JSON.

## 1) Entry flow (open)

**Legacy (VERIFIED 2026-02-12):** POST ContractsAction.do?dispatch=selectCP&minsk_store=1, body: contracts form (number, contractor.id, contractor.name, date_begin, date_end, ..., grid.page, grid.pk, ctrl, do). Response: HTML «Коммерческие предложения» grid.

**Modern:** `GET /api/contracts/import-cp/open?minskStore=1` или SPA route `/contracts/import-cp` + отдельный data fetch.

Response (200):
```json
{
  "defaults": {
    "number": "",
    "dateBegin": "",
    "dateEnd": "",
    "sumMin": null,
    "sumMax": null,
    "contractor": null,
    "user": null,
    "department": null,
    "stuffCategory": null,
    "cprProposalReceivedFlagIn": false,
    "cprProposalDeclinedIn": false
  },
  "lookups": {
    "departments": [],
    "users": [],
    "contractors": [],
    "stuffCategories": []
  },
  "minskStore": true
}
```

## 2) POST `/api/contracts/import-cp/data` (grid load)

Request:
```json
{
  "number": "",
  "contractor": { "id": null, "name": "" },
  "dateBegin": "",
  "dateEnd": "",
  "sumMin": null,
  "sumMax": null,
  "user": { "id": null, "name": "" },
  "department": { "id": null, "name": "" },
  "stuffCategory": { "id": null, "name": "" },
  "cprProposalReceivedFlagIn": false,
  "cprProposalDeclinedIn": false,
  "page": 1,
  "pageSize": 15,
  "minskStore": true
}
```

Response (200):
```json
{
  "items": [
    {
      "cprId": "string",
      "cprNumber": "string",
      "cprDate": "DD.MM.YYYY",
      "cprContractor": "string",
      "cprSumm": "string-formatted",
      "cprCurrency": "string",
      "cprStfName": "string",
      "reservedState": "string",
      "attachSqr": "green|red|null",
      "cprBlock": "0|1",
      "cprUser": "string",
      "cprDepartment": "string"
    }
  ],
  "page": 1,
  "pageSize": 15,
  "hasNextPage": true
}
```

Traceability: CommercialProposalsAction.internalFilter, DAOUtils.fillGrid(select-commercial_proposals), CommercialProposalsForm.CommercialProposal.

## 3) POST `/api/contracts/import-cp/select`

Request:
```json
{ "cprId": "string" }
```

Response (200):
```json
{
  "redirectTo": "/contracts/new",
  "conId": null
}
```

Или 302 redirect на `/contracts/new` с pre-filled данными из КП (ContractAction.importCP → Contract.importFromCP → inputCommon → show).

Backend: load CommercialProposal by cprId, Contract.importFromCP(commercialProposal), create new Contract in session, redirect to create form.

## 4) UNCONFIRMED / How to verify

- **minsk_store:** В select-commercial_proposals нет параметра. HOW TO VERIFY: legacy http://localhost:8082 — логин admin/vip2u1ig, Contracts → «Импорт из КП»; Network — проверить, передаётся ли minsk_store в request; сравнить грид с minsk_store=1 и без.
- **Legacy wire format:** HTML form POST. HOW TO VERIFY: HAR export после логина.
