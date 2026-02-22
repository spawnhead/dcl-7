# Contractor Edit — Acceptance Criteria

> Экран редактирования контрагента. Вход: `/contractors/{ctrId}/edit`.

## 1) Open Edit Screen
**Given:** User navigates to Contractors list (`/contractors`).
**When:** User clicks Edit icon on a contractor row.
**Then:**
- Page navigates to `/contractors/{ctrId}/edit`.
- GET `/api/contractors/{ctrId}/edit/open` returns 200.
- Form displays all 5 tabs (Главная, Курируют, Расчетные счета, Контактные лица, Комментарии).
- Form fields are populated with existing contractor data.
- Header shows «Создано» and «Изменено» info.
- If contractor is blocked (`ctr_block=1`), form is read-only.

## 2) Edit Valid Data
**Given:** Edit screen is open with existing contractor data.
**When:** User modifies valid fields (e.g., `ctrPhone`, `ctrEmail`) and clicks «Сохранить».
**Then:**
- PUT `/api/contractors/{ctrId}/edit/save` returns 200.
- Success notification **«Контрагент успешно сохранен»** is displayed.
- Page redirects to `/contractors` (or `returnTo` context).
- Updated data is visible in contractors list.

## 3) Edit Invalid Data — Required Fields
**Given:** Edit screen is open.
**When:** User clears required field `ctrName` and clicks «Сохранить».
**Then:**
- PUT `/api/contractors/{ctrId}/edit/save` returns 400.
- Validation error message is displayed for `ctrName`.
- Form stays on the same page.
- Tab with error shows badge indicator.

## 4) Edit Invalid Data — UNP Duplicate
**Given:** Edit screen is open for contractor A with UNP "123456".
**When:** User changes UNP to "789012" which already exists for contractor B, and clicks «Сохранить».
**Then:**
- PUT `/api/contractors/{ctrId}/edit/save` returns 400.
- Error message: «Контрагент с таким УНП уже существует».
- Form stays on the same page.

## 5) Edit Invalid Data — Account Validation
**Given:** Edit screen is open on «Расчетные счета» tab.
**When:** User fills `accAccount` for default row but leaves `currency` empty, and clicks «Сохранить».
**Then:**
- PUT `/api/contractors/{ctrId}/edit/save` returns 400.
- Error message about empty currency.
- Active tab switches to «Расчетные счета».

## 6) Cancel Edit
**Given:** Edit screen is open with modified data.
**When:** User clicks «Отмена».
**Then:**
- Page navigates to `/contractors` (or `returnTo` context).
- No changes are saved.
- No success notification.

## 7) Tab Navigation
**Given:** Edit screen is open.
**When:** User clicks on different tabs.
**Then:**
- Tab content switches without page reload.
- Active tab is highlighted.
- Form data is preserved across tab switches.

## 8) Tab Error Badge
**Given:** Edit screen has validation errors on «Расчетные счета» tab.
**When:** User clicks «Сохранить».
**Then:**
- «Расчетные счета» tab shows error badge.
- Form switches to the tab with first error.
- Error message is displayed.

## 9) Contact Persons CRUD
**Given:** Edit screen is open on «Контактные лица» tab.
**When:**
- User clicks «Создать» → Contact Person create modal opens.
- User clicks Edit icon on row → Contact Person edit modal opens.
- User toggles Fire checkbox → `cpsFire` toggles.
- User toggles Block checkbox (admin only) → `cpsBlock` toggles.
**Then:**
- Changes are reflected in the grid.
- Changes are persisted on Save.

## 10) Accounts CRUD
**Given:** Edit screen is open on «Расчетные счета» tab.
**When:**
- User clicks «Добавить» → new account row is added.
- User fills account and currency.
- User clicks Delete (only if > 3 rows) → row is removed.
**Then:**
- Changes are reflected in the grid.
- Changes are persisted on Save.

## 11) Users CRUD
**Given:** Edit screen is open on «Курируют» tab.
**When:**
- User clicks «Добавить» → new user row is added.
  - Non-admin user can only add themselves (with confirm dialog).
  - Admin can add any user.
- Admin clicks Delete → user row is removed.
**Then:**
- Changes are reflected in the grid.
- Changes are persisted on Save.

## 12) Blocked Contractor — Read-only
**Given:** Contractor has `ctr_block=1`.
**When:** User opens edit screen.
**Then:**
- `formReadOnly=true` in response.
- All form fields are disabled/read-only.
- «Сохранить» button is disabled.
- «Отмена» button is enabled.

## 13) Delete Contractor — Admin
**Given:**
- User has admin role.
- Contractor is not occupied (`isOccupied() == false`).
**When:** User clicks Delete icon on contractors list row and confirms.
**Then:**
- DELETE `/api/contractors/{ctrId}` returns 200.
- Contractor is removed from the list.
- Success notification is displayed.

## 14) Delete Contractor — Occupied
**Given:** Contractor is occupied (has related contracts/orders).
**When:** User views contractors list.
**Then:**
- Delete icon is hidden for this contractor.
- Edit icon is visible.

## 15) Delete Contractor — Non-admin
**Given:** User does not have admin role.
**When:** User views contractors list.
**Then:**
- Delete icon is hidden for all contractors.

## 16) Role-based Field Restrictions
**Given:** User has `onlyManager` or `onlyOtherUserInMinsk` role.
**When:** User opens edit screen.
**Then:**
- `readOnlyReputation=true` — reputation field is read-only.
- `readOnlyComment=true` — comment field is read-only.
- Other fields are editable.

## 17) Address Auto-computation
**Given:** Edit screen is open on «Главная» tab.
**When:** User modifies any address component field (`ctrIndex`, `ctrRegion`, `ctrPlace`, `ctrStreet`, `ctrBuilding`, `ctrAddInfo`).
**Then:**
- `ctrAddress` field is automatically updated with computed value.
- Format: `{index}, {region}, {place}, {street}, {building}, {addInfo}`.

## 18) Open with Specific Tab
**Given:** User navigates to `/contractors/{ctrId}/edit?tab=contactPersons`.
**When:** Page loads.
**Then:**
- «Контактные лица» tab is active on open.

## 19) Return Context
**Given:** Edit screen was opened with `returnTo=contract`.
**When:** User clicks «Сохранить» or «Отмена».
**Then:**
- Page redirects to `/contracts/new` (contract create context).

## 20) Not Found
**Given:** Contractor with given `ctrId` does not exist.
**When:** User navigates to `/contractors/{ctrId}/edit`.
**Then:**
- GET `/api/contractors/{ctrId}/edit/open` returns 404.
- Error message «Контрагент не найден» is displayed.
- User is redirected to `/contractors` (or shown error page).
