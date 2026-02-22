# Contractor Edit — API Contracts (Dev-ready, parity-oriented)

> Legacy reference: `ContractorAction.do?dispatch=edit/process`, `ContractorAction`, `contractor.jsp`.

## 0) Navigation
- Entry from Contractors list: click Edit icon → `/contractors/{ctrId}/edit`.
- Entry for Contact Persons tab: `/contractors/{ctrId}/edit?tab=contactPersons`.
- Return after Save/Cancel: `/contractors` (or `returnTo` if passed).

## 1) Open
### GET `/api/contractors/{ctrId}/edit/open`

Returns full form state for editing existing contractor.

Path params:
- `ctrId` (required) — ID контрагента.

Query params:
- `returnTo` (optional) — контекст возврата (`contractors` | `contract`).
- `tab` (optional) — активная вкладка при открытии (`mainPanel` | `usersContractor` | `accountsContractor` | `contactPersonsContractor` | `commentContractor`).

Response (200):
```json
{
  "ctrId": "string",
  "isNewDoc": false,
  "ctrName": "string",
  "ctrFullName": "string",
  "country": { "id": "string", "name": "string" },
  "ctrIndex": "string",
  "ctrRegion": "string",
  "ctrPlace": "string",
  "ctrStreet": "string",
  "ctrBuilding": "string",
  "ctrAddInfo": "string",
  "ctrAddress": "string (computed readonly)",
  "ctrPhone": "string",
  "ctrFax": "string",
  "ctrEmail": "string",
  "ctrUnp": "string",
  "ctrOkpo": "string",
  "ctrBankProps": "string",
  "ctrComment": "string",
  "reputation": { "id": "string", "description": "string" },
  "ctrBlock": "0|1",
  "formReadOnly": false,
  "usrDateCreate": "string (DD.MM.YYYY)",
  "usrDateEdit": "string (DD.MM.YYYY)",
  "createUser": { "usrId": "string", "userFullName": "string" },
  "editUser": { "usrId": "string", "userFullName": "string" },
  "gridUsers": [
    { "number": "1", "user": { "usrId": "string", "userFullName": "string" } }
  ],
  "gridAccounts": [
    { "number": "1", "accName": "string", "accAccount": "string", "currency": { "id": "string", "name": "string" } }
  ],
  "gridContactPersons": [
    {
      "number": "1",
      "cpsId": "string",
      "cpsName": "string",
      "cpsPosition": "string",
      "cpsOnReason": "string",
      "cpsPhone": "string",
      "cpsMobPhone": "string",
      "cpsFax": "string",
      "cpsEmail": "string",
      "cpsContractComment": "string",
      "cpsFire": "0|1",
      "cpsBlock": "0|1"
    }
  ],
  "activeTab": "mainPanel",
  "returnTo": "contractors",
  "lookups": {
    "countries": [{ "id": "string", "name": "string" }],
    "reputations": [{ "id": "string", "description": "string" }],
    "users": [{ "id": "string", "name": "string" }],
    "currencies": [{ "id": "string", "name": "string" }]
  },
  "roleFlags": {
    "adminRole": true,
    "readOnlyReputation": false,
    "readOnlyComment": false,
    "canDelete": true,
    "occupied": false
  }
}
```

Traceability: `ContractorAction#edit`, `ContractorAction#editCommon`, `contractor-load`, `select-contractor_users`, `select-accounts`, `select-contact-persons`.

**VERIFIED (2026-02-12 legacy HAR):** GET ContractorAction.do?dispatch=edit&ctr_id={id}&__lock_name__=Contractor&__lock_id__={id} — 200, HTML form.

**Error (404):** Contractor not found.
```json
{ "error": "CONTRACTOR_NOT_FOUND", "message": "Контрагент не найден" }
```

## 2) Save
### PUT `/api/contractors/{ctrId}/edit/save`

- Content-Type: `application/json; charset=UTF-8`.
- Updates contractor + users + accounts + contact persons.
- On success returns redirect info.

Path params:
- `ctrId` (required) — ID контрагента.

Request:
```json
{
  "ctrId": "string",
  "ctrName": "string (required, max 200)",
  "ctrFullName": "string (required, max 300)",
  "country": { "id": "string (required)" },
  "ctrIndex": "string (max 20)",
  "ctrRegion": "string (max 50)",
  "ctrPlace": "string (max 50)",
  "ctrStreet": "string (max 50)",
  "ctrBuilding": "string (max 20)",
  "ctrAddInfo": "string (max 1000)",
  "ctrPhone": "string (max 100)",
  "ctrFax": "string (max 100)",
  "ctrEmail": "string (max 40, email format)",
  "ctrUnp": "string (min 6, max 15, unique except self)",
  "ctrOkpo": "string (max 15)",
  "ctrBankProps": "string (max 800)",
  "ctrComment": "string (max 5000)",
  "reputation": { "id": "string (required)" },
  "gridUsers": [
    { "number": "1", "user": { "usrId": "string" } }
  ],
  "gridAccounts": [
    { "number": "1", "accName": "string", "accAccount": "string", "currency": { "id": "string" } }
  ],
  "gridContactPersons": [
    {
      "cpsId": "string (if existing)",
      "cpsName": "string",
      "cpsPosition": "string",
      "cpsOnReason": "string",
      "cpsPhone": "string",
      "cpsMobPhone": "string",
      "cpsFax": "string",
      "cpsEmail": "string",
      "cpsContractComment": "string",
      "cpsFire": "0|1",
      "cpsBlock": "0|1"
    }
  ],
  "returnTo": "contractors"
}
```

Validation parity (from legacy `process()`):
- `ctrName` required, max 200.
- `ctrFullName` required, max 300.
- `country.id` required.
- `ctrEmail` max 40 + email format.
- `ctrUnp` min 6 max 15 + duplicate check **excluding current ctrId**.
- `ctrComment` max 5000.
- Account rules:
  - default rows (ctr_account1, ctr_account2, ctr_account_val): if `accAccount` filled then `currency.id` required.
  - custom rows: both `accAccount` and `currency.id` required.
  - `accAccount` max 35.

Response (200):
```json
{ "ctrId": "string", "returnTo": "contractors", "redirectTo": "/contractors" }
```

Response (400) — validation errors:
```json
{
  "errors": [
    { "field": "ctrName", "message": "Поле обязательно для заполнения" },
    { "field": "ctrUnp", "message": "Контрагент с таким УНП уже существует" }
  ],
  "activeTab": "mainPanel"
}
```

Client feedback requirement (modern parity):
- On success show notification **«Контрагент успешно сохранен»**.

Traceability: `ContractorAction#process`, `contractor-update`, `ContractorDAO.saveUsers`, `ContractorDAO.saveAccounts`, `ContractorDAO.saveContactPersons`.

## 3) Delete
### DELETE `/api/contractors/{ctrId}`

Delete contractor (admin-only, `occupied=false`).

Path params:
- `ctrId` (required) — ID контрагента.

Prerequisites:
- User has admin role.
- Contractor is not occupied (`isOccupied() == false`).

Response (200):
```json
{ "status": "OK" }
```

Response (403) — forbidden (not admin):
```json
{ "error": "FORBIDDEN", "message": "Недостаточно прав" }
```

Response (409) — conflict (occupied):
```json
{ "error": "CONTRACTOR_OCCUPIED", "message": "Контрагент используется в других записях" }
```

Traceability: `ContractorAction#delete`, `contractor-delete`, `show-delete-checker`.

**UNCONFIRMED:** legacy confirm text for delete.

## 4) Contact Person operations (inline in edit)

### POST `/api/contractors/{ctrId}/contact-persons`
Add new contact person to contractor.

### PUT `/api/contractors/{ctrId}/contact-persons/{cpsId}`
Update existing contact person.

### DELETE `/api/contractors/{ctrId}/contact-persons/{cpsId}`
Delete contact person.

### POST `/api/contractors/{ctrId}/contact-persons/{cpsId}/fire`
Toggle fire status.

### POST `/api/contractors/{ctrId}/contact-persons/{cpsId}/block`
Toggle block status (admin only).

Traceability: `ContractorAction#addPersonInContractor`, `ContractorAction#editPersonInContractor`, `ContractorAction#fireContactPerson`, `ContractorAction#blockContactPerson`.

## 5) Account operations (inline in edit)

### POST `/api/contractors/{ctrId}/accounts`
Add new account row.

### DELETE `/api/contractors/{ctrId}/accounts/{number}`
Delete account row (only if > 3 rows).

Traceability: `ContractorAction#addRowInAccountGrid`, `ContractorAction#deleteRowFromAccountGrid`.

## 6) User operations (inline in edit)

### POST `/api/contractors/{ctrId}/users`
Add user row (non-admin can only add self).

### DELETE `/api/contractors/{ctrId}/users/{number}`
Delete user row (admin only).

Traceability: `ContractorAction#addRowInUserGrid`, `ContractorAction#deleteRowFromUserGrid`.

## 7) UNCONFIRMED / BLOCKED
- Exact legacy POST param names for nested grids (x-www-form-urlencoded) — UNCONFIRMED.
- Delete Popconfirm text — UNCONFIRMED.
- HAR capture instructions: `payloads/network.har.BLOCKED.md`.
