# Reports → Margin: Parity Acceptance Checklist

> Source: `docs/screens/margin/SNAPSHOT.md` + payload examples in `docs/screens/margin/payloads/*.json`. Items marked **UNCONFIRMED** require live capture (HAR + screenshots).

## 1) UI Elements

### Filters (type, default, validation, dependencies)
- Date range
  - `date_begin` (date picker) — required for Generate/Excel enablement. **UNCONFIRMED** exact validation rules.
  - `date_end` (date picker) — required for Generate/Excel enablement. **UNCONFIRMED** exact validation rules.
- Value selectors (serverList lookup inputs)
  - User (`user.userFullName`, `user.usr_id`) — lookup `/UsersListAction` with `filter` + `have_all`; optional `dep_id` for chief dep. **UNCONFIRMED** exact params.
  - Department (`department.name`, `department.id`) — lookup `/DepartmentsListAction` with `have_all`. **UNCONFIRMED**.
  - Contractor (`contractor.name`, `contractor.id`) — lookup `/ContractorsListAction` with `filter` + `have_all`. **UNCONFIRMED**.
  - Stuff Category (`stuffCategory.name`, `stuffCategory.id`) — lookup `/StuffCategoriesListAction` with `filter` + `have_all`. **UNCONFIRMED**.
  - Route (`route.name`, `route.id`) — lookup `/RoutesListAction` with `have_all`. **UNCONFIRMED**.
- Aspect checkboxes (mutually exclusive; single selection)
  - `user_aspect`, `department_aspect`, `contractor_aspect`, `stuff_category_aspect`, `route_aspect`.
- Options
  - `onlyTotal` — checkbox.
  - `itog_by_spec` — checkbox; enables `itog_by_user`.
  - `itog_by_user` — checkbox; enables `itog_by_product`.
  - `itog_by_product` — checkbox; only enabled if `itog_by_user` checked.
  - `get_not_block` — checkbox.
- View columns (checkboxes controlling column visibility)
  - `view_contractor`, `view_country`, `view_contract`, `view_stuff_category`, `view_shipping`, `view_payment`,
    `view_transport`, `view_transport_sum`, `view_custom`, `view_other_sum`, `view_montage_sum`,
    `view_montage_time`, `view_montage_cost`, `view_update_sum`, `view_summ_zak`, `view_koeff`,
    `view_user`, `view_department`.

### Buttons (enabled/disabled rules)
- Clear all — always enabled; posts `dispatch=cleanAll`. **UNCONFIRMED** request body.
- Generate — enabled only when both dates are set **and** at least one selector (user/department/contractor/stuff category/route) is set. **UNCONFIRMED** exact logic.
- Excel — same enablement as Generate; triggers iframe GET `dispatch=generateExcel`.

### Table (grid)
- Columns: match 28 listed in `SNAPSHOT.md` in the same order.
- Sorting: enabled for all columns (client-side).
- Filtering: floating filters; date filters on date columns.
- Row styles:
  - `itogLine` → bold row.
  - `spc_group_delivery` present → green background; if `haveUnblockedPrc` also true → gradient green+pink.
  - `haveUnblockedPrc` only → pink background.

### Summary / totals
- No separate summary panel; row-level totals rendered in grid. **UNCONFIRMED**.

### Export
- Excel: server download via `/MarginAction.do?dispatch=generateExcel` (iframe).
- CSV: client-side table export `margin_export.csv`.

## 2) Behavior Scenarios

### Initial load
- Expected network:
  - GET `/MarginAction.do?dispatch=input`
  - GET `/test/MarginReportGridStandalone.jsp`
  - GET `/MarginDevData.do?limit=200`
- Expected UI:
  - Filters visible; Generate/Excel disabled until date + selector set.
  - Grid loads with current Margin session (if any); limit default 200.

### Build/Refresh (Generate)
- Trigger: click Generate after valid filters.
- Expected network:
  - POST `/MarginAction.do?dispatch=generate` with form fields.
  - GET `/MarginDevData.do?limit=...` after reload.
- Expected UI:
  - Grid reloads with new data for selected filters.
  - Buttons remain enabled if criteria still met.
- **UNCONFIRMED**: exact form fields and server redirect behavior.

### Change each filter
- Value selector changes:
  - Selecting any selector clears the others and disables its own aspect checkbox.
  - Aspect checkbox mutual exclusion (only one checked at a time).
- Option dependencies:
  - `onlyTotal` auto-unchecks if no selector chosen; also unchecks `itog_by_spec`.
  - `itog_by_spec` enables `itog_by_user`; unchecking clears and disables it.
  - `itog_by_user` enables `itog_by_product`; unchecking clears and disables it.
- Expected network:
  - Lookups call respective `/...ListAction` endpoints as user types/selects.
- **UNCONFIRMED**: exact UI triggers and request payloads.

### Reset (Clear all)
- Trigger: click Clear all.
- Expected network:
  - POST `/MarginAction.do?dispatch=cleanAll`.
  - Grid refetch `/MarginDevData.do?limit=...` (on reload).
- Expected UI:
  - Filters cleared; grid empty or reset to session defaults. **UNCONFIRMED**.

### Pagination
- Page size control changes `paginationPageSize` (client-side only).
- “Грузить” control updates `limit` and triggers refetch `/MarginDevData.do?limit=...`.

### Sorting
- Client-side sorting on any column; no server sort params.

### Export
- Excel button triggers iframe GET `/MarginAction.do?dispatch=generateExcel` and downloads file.
- CSV export uses client export.

### Error / empty / loading
- Non-JSON response shows “Сервер вернул страницу вместо JSON…” and clears grid.
- “Нет прав на доступ к данным” shown when HTML hints permission denial.
- Generic API error message on fetch failure.
- **UNCONFIRMED**: exact error texts and conditions without live HAR.

## 3) Parity “MUST”
- MUST: Generate/Excel enablement rules (dates + at least one selector) match legacy.
- MUST: Selector mutual exclusivity and aspect checkbox rules match legacy.
- MUST: Option dependencies (`onlyTotal`/`itog_by_spec`/`itog_by_user`/`itog_by_product`) match legacy.
- MUST: Column visibility toggles (`view_*`) are wired to grid column visibility exactly.
- MUST: Grid column order, labels, formats, and sorting/filtering behaviors match legacy.
- MUST: Row styling (itogLine, spc_group_delivery, haveUnblockedPrc) matches legacy.
- MUST: Excel and CSV exports behave like legacy (trigger points, filename for CSV).
- MUST: Error/empty/loading states show legacy messages and behaviors.
