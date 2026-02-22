# N3a1 Contractor create — Contracts (Dev-ready, parity-oriented)

> Legacy reference: `ContractorAddActionContract.do?dispatch=create/process`, `ContractorAction`, `contractor.jsp`.

## 1) Open
### GET `/api/contractors/create/open?returnTo=contract`
Returns full form state:
- `tabs` metadata (5 tabs, fixed order).
- form defaults from create scenario.
- lookups: countries, reputations, users, currencies.
- role flags: `adminRole`, `readOnlyReputation`, `readOnlyComment`, checkers for grid actions.

Minimal required defaults parity:
- `gridUsers` contains current user.
- `gridAccounts` contains 3 default rows.
- `gridContactPersons` empty.
- `activeTab=mainPanel`.

## 2) Save
### POST `/api/contractors/create/save`
- Content-Type: `application/json; charset=UTF-8`.
- Saves contractor + users + accounts + contact persons.
- On success sets return payload with created `ctrId` and `returnTo` context.

Validation parity:
- `ctrName` required, max 200.
- `ctrFullName` required, max 300.
- `country.id` required.
- `ctrEmail` max 40 + email format.
- `ctrUnp` min 6 max 15 + duplicate check.
- `ctrComment` max 5000.
- Account rules from legacy `process()`:
  - default rows: if `accAccount` filled then `currency.id` required.
  - custom rows: both `accAccount` and `currency.id` required.
  - `accAccount` max 35.

Expected success:
```json
{ "ctrId": "...", "returnTo": "contract", "redirectTo": "/contracts/new" }
```

Client feedback requirement (modern parity):
- On success show notification **«Контрагент успешно сохранен»**.

## 3) Auxiliary operations (child endpoints implied by tabs)
If modern UI supports per-tab async ops, these must preserve legacy semantics:
- Add/remove user row.
- Add/remove account row.
- Toggle contact person `fire`/`block`.
- Navigate to contact person create/edit and back.

If implemented client-side before final save: keep identical validation outcome as legacy `process()`.

## 4) Legacy action map
- `create` → build defaults.
- `input` → resolve readonly/show checker flags.
- `addRowInUserGrid`, `deleteRowFromUserGrid`.
- `addRowInAccountGrid`, `deleteRowFromAccountGrid`.
- `fireContactPerson`, `blockContactPerson`.
- `addCountry`, `fromAddCountry`.
- `editReputation`, `fromEditReputation`.
- `addPersonInContractor`, `editPersonInContractor`, `fromContactPerson`.
- `process` → insert/update + save child lists + set `currentContractorId`.

## 5) UNCONFIRMED / BLOCKED
- Exact legacy POST param names for nested grids (x-www-form-urlencoded) — UNCONFIRMED.
- HAR capture instructions: `payloads/network.har.BLOCKED.md`.
