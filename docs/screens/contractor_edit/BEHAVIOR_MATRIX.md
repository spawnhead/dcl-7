# Contractor Edit — Behavior Matrix

> Матрица поведения экрана редактирования контрагента.

| # | Scenario | Role | Precondition | Action | Expected Result | Verify |
|---|----------|------|--------------|--------|-----------------|--------|
| 1 | Open edit from list | any | Contractor exists | Click Edit icon | GET `/api/contractors/{ctrId}/edit/open` 200, form populated, 5 tabs visible | Network 200, form fields filled |
| 2 | Open edit blocked contractor | any | `ctr_block=1` | Open edit | `formReadOnly=true`, all fields disabled, Save disabled | UI fields disabled |
| 3 | Open with specific tab | any | `?tab=contactPersons` | Navigate | «Контактные лица» tab active | Tab highlighted |
| 4 | Save valid changes | any | Form open, valid data | Click «Сохранить» | PUT 200, notification «Контрагент успешно сохранен», redirect to list | Network 200, toast visible, URL `/contractors` |
| 5 | Save — clear required field | any | `ctrName` cleared | Click «Сохранить» | PUT 400, validation error for `ctrName`, stay on page | Network 400, error message |
| 6 | Save — UNP duplicate | any | UNP exists for another contractor | Click «Сохранить» | PUT 400, error «Контрагент с таким УНП уже существует» | Network 400, error message |
| 7 | Save — account without currency | any | Default account row has `accAccount` but no `currency` | Click «Сохранить» | PUT 400, error about currency, switch to «Расчетные счета» tab | Network 400, tab switched |
| 8 | Cancel edit | any | Form modified | Click «Отмена» | Redirect to `/contractors`, no save, no notification | URL `/contractors`, data unchanged |
| 9 | Tab navigation | any | Form open | Click tabs | Content switches, data preserved | Tab content visible |
| 10 | Tab error badge | any | Validation error on tab | Click «Сохранить» | Badge on tab, switch to error tab | Badge visible, tab active |
| 11 | Contact Person — Add | any | «Контактные лица» tab | Click «Создать» | Modal opens, fill fields, add to grid | Modal, row in grid |
| 12 | Contact Person — Edit | any | Row exists | Click Edit icon | Modal opens with data, save updates grid | Modal, row updated |
| 13 | Contact Person — Fire toggle | any | Row exists | Click Fire checkbox | `cpsFire` toggles, icon changes | Checkbox state, icon |
| 14 | Contact Person — Block toggle | admin | Row exists | Click Block checkbox | `cpsBlock` toggles, icon changes | Checkbox state, icon |
| 15 | Contact Person — Block toggle | non-admin | Row exists | Click Block checkbox | Checkbox readonly, no change | Checkbox disabled |
| 16 | Account — Add | any | «Расчетные счета» tab | Click «Добавить» | New row added to grid | Row in grid |
| 17 | Account — Delete | any | > 3 rows | Click Delete | Row removed | Row removed from grid |
| 18 | Account — Delete hidden | any | ≤ 3 rows | View grid | Delete icon hidden | No delete icon |
| 19 | User — Add (admin) | admin | «Курируют» tab | Click «Добавить» | User lookup opens, any user can be added | Lookup, row in grid |
| 20 | User — Add (non-admin) | non-admin | «Курируют» tab | Click «Добавить» | Confirm dialog, only self can be added | Dialog, self in grid |
| 21 | User — Delete | admin | Row exists | Click Delete | Row removed | Row removed from grid |
| 22 | User — Delete hidden | non-admin | Any | View grid | Delete icon hidden | No delete icon |
| 23 | Reputation readonly | manager | `readOnlyReputation=true` | View field | Reputation field readonly | Field disabled |
| 24 | Comment readonly | manager | `readOnlyComment=true` | View field | Comment field readonly | Field disabled |
| 25 | Delete contractor | admin | `occupied=false` | Click Delete, confirm | DELETE 200, row removed, notification | Network 200, row gone |
| 26 | Delete contractor — occupied | any | `occupied=true` | View list | Delete icon hidden | No delete icon |
| 27 | Delete contractor — non-admin | non-admin | Any | View list | Delete icon hidden | No delete icon |
| 28 | Address auto-compute | any | «Главная» tab | Modify address fields | `ctrAddress` updates automatically | Field value |
| 29 | Return context | any | `returnTo=contract` | Save or Cancel | Redirect to `/contracts/new` | URL `/contracts/new` |
| 30 | Not found | any | Invalid `ctrId` | Navigate | GET 404, error message, redirect | Network 404, error visible |

## Role Legend
- **any**: All authenticated users
- **admin**: User with admin role
- **non-admin**: User without admin role
- **manager**: User with `onlyManager` or `onlyOtherUserInMinsk` role

## Status Indicators
- **Network 200/400/404**: HTTP response code in DevTools Network tab
- **Toast visible**: message.success/error appears
- **Badge visible**: Tab shows error count badge
- **Field disabled**: Input/Select is disabled state
- **Row in grid**: table shows the row
- **Icon visible/hidden**: Element presence in DOM
