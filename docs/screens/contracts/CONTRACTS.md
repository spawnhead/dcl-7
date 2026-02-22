# N3 Contracts — API Contracts for modern implementation

> Источник истины — legacy Contracts list flow. Legacy HTML form/dispatch маппится в REST-паттерн modern без изменения бизнес-семантики.

## 0) Navigation contracts (no API)
Кнопки «Импорт из КП» и «Создать» — pure navigation (SPA routes). Backend API не вызывается при клике.
- «Импорт из КП» → `/contracts/import-cp`. Spec: `docs/screens/contract_import_cp/SNAPSHOT.md` (N3b).
- «Создать» → `/contracts/new`. Spec: `docs/screens/contract_create/SNAPSHOT.md` (N3a).
- Traceability: Contracts.jsp:123–128, struts-config forward selectCP, xml-permissions.

## 1) Endpoint inventory (modern)

## 1.1 GET `/api/contracts/lookups`
Назначение: initial load lookup-данных для фильтров (`contractor`, `user`, `seller`) и дефолтных значений фильтра.

Response (200):
```json
{
  "defaults": {
    "number": "",
    "dateBegin": "",
    "dateEnd": "",
    "sumMin": null,
    "sumMax": null,
    "executed": false,
    "notExecuted": false,
    "oridinalAbsent": false,
    "contractor": null,
    "user": null,
    "seller": null
  },
  "lookups": {
    "contractors": [{ "id": "string", "name": "string" }],
    "users": [{ "id": "string", "name": "string" }],
    "sellers": [{ "id": "string", "name": "string" }]
  }
}
```

Traceability:
- Legacy server lists: `/ContractorsListAction`, `/UsersListAction`, `/SellersListAction` in `Contracts.jsp`.
- Reset defaults in `ContractsAction#input`.

VERIFIED (2026-02-12 legacy HAR capture):
- Legacy uses POST ContractsAction.do with dispatch=input|filter.
- Request body: number, contractor.id, contractor.name, date_begin, date_end, sum_min_formatted, sum_max_formatted, user.usr_id, user.usr_name, seller.id, seller.name, grid.page, grid.pk=con_id.
- Content-Type: application/x-www-form-urlencoded.
- Response: text/html full page (HTML).

UNCONFIRMED:
- Legacy serverList XHR wire-format (HTML/options vs JSON) — not observed; list uses server-side HTML.

## 1.2 POST `/api/contracts/data`
Назначение: получить страницу грида по фильтру (эквивалент `dispatch=filter` + `select-contracts`).

Request body:
```json
{
  "number": "string|null",
  "contractor": { "id": "string|null", "name": "string|null" },
  "dateBegin": "DD.MM.YYYY|string-empty",
  "dateEnd": "DD.MM.YYYY|string-empty",
  "sumMin": "number|null",
  "sumMax": "number|null",
  "user": { "id": "string|null", "name": "string|null" },
  "seller": { "id": "string|null", "name": "string|null" },
  "executed": true,
  "notExecuted": false,
  "oridinalAbsent": false,
  "page": 1,
  "pageSize": 15
}
```

Правила маппинга в legacy SQL params:
- `dateBegin/dateEnd` → `date_begin_date/date_end_date` (db format).
- `sumMin/sumMax` → `sum_min/sum_max`.
- `executed/notExecuted` → `con_executed` (`null|"1"|"0"`).
- `oridinalAbsent` → `oridinal_absent` (`"1"|null`).

Response (200):
```json
{
  "items": [
    {
      "conId": "string",
      "conNumber": "string",
      "conDate": "DD.MM.YYYY",
      "conContractor": "string",
      "conSumm": "string-formatted",
      "conCurrency": "string",
      "notes": "html|string",
      "conExecuted": "0|1|''",
      "conUser": "string",
      "conReminder": "html|string",
      "conAnnul": "0|1|''",
      "attachIdx": 1,
      "spcCount": 0,
      "usrIdList": "1;2;",
      "depIdList": "10;"
    }
  ],
  "page": 1,
  "pageSize": 15,
  "hasNextPage": true,
  "sort": [
    { "field": "con_reminder", "direction": "DESC" },
    { "field": "con_date", "direction": "DESC" },
    { "field": "con_number", "direction": "DESC" }
  ]
}
```

Traceability:
- `ContractsAction#filter` / `#internalFilter`.
- `DAOUtils.fillGrid(..., "select-contracts", ...)`.
- SQL entry `select-contracts` in `sql-resources.xml`.
- Response fields from `ContractsForm.Contract` getters.

## 1.3 POST `/api/contracts/page`
Назначение: pager next/prev (эквивалент `grid NEXT_PAGE/PREV_PAGE`).

Request body:
```json
{ "direction": "next|prev", "currentPage": 1, "filterState": {"...":"same as /data"} }
```

Response: same schema as `/api/contracts/data`.

Traceability:
- `ContractsAction#processBefore` handlers for `PageableDataHolder.NEXT_PAGE/PREV_PAGE`.

## 1.4 POST `/api/contracts/cleanAll`
Назначение: reset фильтра и возврат 1-й страницы (эквивалент `dispatch=input`).

Request body: `{}`.

Response:
```json
{
  "defaults": {"...":"same as lookups.defaults"},
  "grid": {"...":"same as /data"}
}
```

Traceability:
- `ContractsAction#input` + `internalFilter`.

## 1.5 GET `/api/contracts/export`
Статус: **NOT SUPPORTED BY LEGACY LIST SCREEN**.
- На `Contracts.jsp` нет export-кнопки/dispatch.
- В `ContractsAction` нет export handler.
- В `sql-resources.xml` рядом с list-flow нет export query.

## 2) Validation / Error contract
- Legacy validation для `/ContractsAction:filter`:
  - `date_begin`, `date_end` — `mask,date`;
  - `sum_min_formatted`, `sum_max_formatted` — `currency`;
  - `contractor.name`, `number`, `user.usr_name` — `maxlength`.
- Legacy обычно рендерит errors в HTML (не JSON).

Для modern API (чтобы сохранить поведение без silent fail):
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "fields": [
      {"name":"dateBegin","message":"Неверный формат даты"}
    ]
  }
}
```

UNCONFIRMED:
- Точный legacy формат HTTP-кода/текста при validation fail (часто 200 + html error).
- HOW TO VERIFY:
  1) В legacy ввести невалидную дату (например `32.13.2025`).
  2) Нажать «Применить фильтр».
  3) Снять статус/response.
  4) Зафиксировать точный текст сообщений и расположение в DOM.
