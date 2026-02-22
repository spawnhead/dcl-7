# Contractors list — API Contracts

> Legacy: ContractorsAction, contractors.jsp, select-contractors, dcl_contractor_filter_full.

## 1) GET `/api/contractors/lookups`

Initial load: lookup-данные для фильтров (users, departments) и defaults.

Response (200):
```json
{
  "defaults": {
    "ctrName": "",
    "ctrFullName": "",
    "ctrAccount": "",
    "ctrAddress": "",
    "ctrEmail": "",
    "ctrUnp": "",
    "user": null,
    "department": null
  },
  "lookups": {
    "users": [{ "id": "string", "name": "string" }],
    "departments": [{ "id": "string", "name": "string" }]
  },
  "canCreate": true
}
```

Traceability: ContractorsAction#input, UsersListAction, DepartmentsListAction.

**UNCONFIRMED:** точный формат legacy serverList response.

## 2) POST `/api/contractors/data`

Получить страницу грида по фильтру.

Request:
```json
{
  "ctrName": "string|null",
  "ctrFullName": "string|null",
  "ctrAccount": "string|null",
  "ctrAddress": "string|null",
  "ctrEmail": "string|null",
  "ctrUnp": "string|null",
  "user": { "id": "string|null", "name": "string|null" },
  "department": { "id": "string|null", "name": "string|null" },
  "page": 1,
  "pageSize": 15
}
```

Response (200):
```json
{
  "items": [
    {
      "ctrId": "string",
      "ctrName": "string",
      "ctrFullName": "string",
      "ctrAddress": "string",
      "ctrPhone": "string",
      "ctrFax": "string",
      "ctrEmail": "string",
      "ctrBankProps": "string",
      "ctrBlock": "0|1|''",
      "occupied": false
    }
  ],
  "page": 1,
  "pageSize": 15,
  "hasNextPage": true
}
```

Traceability: ContractorsAction#internalFilter, select-contractors, ContractorsForm.Contractor.

**VERIFIED (2026-02-12 legacy HAR):** ContractorsAction.do?dispatch=filter — POST, body: ctr_name_journal, ctr_full_name_journal, ctr_account_journal, ctr_address_journal, user.usr_id, user.userFullName, department.id, department.name, ctr_email_journal, ctr_unp_journal, grid.page, grid.pk=ctr_id, printScale=100.

## 3) POST `/api/contractors/page`

Pager next/prev — same body as data, page incremented/decremented.

## 4) POST `/api/contractors/block`

Toggle block status for row.

Request:
```json
{
  "ctrId": "string",
  "block": "0|1"
}
```

Response: 200, then refetch data or return updated row.

Traceability: ContractorsAction#block, ContractorDAO.saveBlock.

**UNCONFIRMED:** legacy param names (ctr_id_journal, block).

## 5) DELETE `/api/contractors/{ctrId}`

Delete contractor (admin-only, `occupied=false`).

Request:
- Path param: `ctrId`.
- Client should show Popconfirm before call (text UNCONFIRMED; see SNAPSHOT §3.4).

Response (200):
```json
{ "status": "OK" }
```

Traceability: `contractors.jsp` → `/ContractorAction.do?dispatch=delete`, `show-delete-checker`.

**UNCONFIRMED:** legacy confirm text; legacy wire-format (GET vs POST).

## 6) Excel export

POST `/api/contractors/export/excel` — body = filter params, response = binary Excel.

Traceability: ContractorsAction#generateExcel, select-contractors-all, Grid2Excel.

**UNCONFIRMED:** out of scope v1; defer.

## 7) Navigation (no API)
- «Создать» → `/contractors/new`.
- Edit row → `/contractors/{id}/edit`.
- «Контактные лица» → TBD (child screen).
