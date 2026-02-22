# Reports → Margin: Network Contracts

> Source: `docs/screens/margin/SNAPSHOT.md` + payload examples in `docs/screens/margin/payloads/*.json`. Legacy trace: `src/main/java/net/sam/dcl/action/MarginAction.java`, `MarginDevDataAction.java`, `src/main/webapp/jsp/Margin.jsp`.

## Margin Screen Load
- Method: GET
- Path: `/MarginAction.do?dispatch=input`
- Purpose: Render legacy Margin screen (filters + iframe placeholder).
- Auth/session notes: DefenderFilter + xml-permissions (see `docs/security/ROLE_MODEL.md`); no extra auth logic in `MarginAction.input()`.
- Request:
  - query params: none
  - body schema: n/a
  - sorting encoding: n/a
  - pagination encoding: n/a
  - filtering encoding: n/a
- Response:
  - rows schema: n/a (HTML page)
  - total / summary schema: n/a
  - errors schema: HTML error page (Struts/validation). **How to verify:** capture HAR on invalid session or denied URL; see "How to verify" at end of document.
- Example payloads:
  - `docs/screens/margin/payloads/initial-load.requests.json`

## Margin Grid Iframe Shell
- Method: GET
- Path: `/test/MarginReportGridStandalone.jsp`
- Purpose: Load table shell + JS for the Margin grid.
- Auth/session notes: Same as Margin screen (session required; JSP uses `response.encodeURL` for grid data URL).
- Request:
  - query params: none
  - body schema: n/a
  - sorting encoding: n/a
  - pagination encoding: n/a
  - filtering encoding: n/a
- Response:
  - rows schema: n/a (HTML/JS)
  - total / summary schema: n/a
  - errors schema: HTML error page. **How to verify:** same as Screen Load.
- Example payloads:
  - `docs/screens/margin/payloads/initial-load.requests.json`

## Margin Grid Data
- Method: GET
- Path: `/MarginDevData.do`
- Purpose: Fetch JSON data for the grid using server-side Margin session.
- Auth/session notes: Requires active session; no guest access (`MarginDevDataAction` reads `Margin` from session).
- Request:
  - query params:
    - `limit` (string/integer, optional, default `200`, max `1000`) — max rows to return. Legacy: `MarginDevDataAction.parseLimit()` def=200, max=1000; any integer 1..1000 allowed.
  - body schema: n/a
  - sorting encoding: none (client-side only; no sort params in request).
  - pagination encoding: none (client-side; server only applies `limit` to session list).
  - filtering encoding: none (server uses Margin session state from last `generate`).
- Response:
  - rows schema (JSON array `data[]`):
    - `ctr_name` (string)
    - `cut_name` (string)
    - `con_number_formatted` (string)
    - `con_date_formatted` (string, date formatted `dd.MM.yyyy`)
    - `spc_number_formatted` (string)
    - `spc_date_formatted` (string, date formatted `dd.MM.yyyy`)
    - `spc_summ_formatted` (string, formatted number)
    - `cur_name` (string)
    - `stf_name_show` (string)
    - `shp_number_show` (string)
    - `shp_date_show` (string, date formatted `dd.MM.yyyy`)
    - `pay_date_show` (string, date formatted `dd.MM.yyyy`)
    - `lps_summ_eur_formatted` (string, formatted number)
    - `lps_summ_formatted` (string, formatted number)
    - `lps_sum_transport_formatted` (string, formatted number)
    - `lcc_transport_formatted` (string, formatted number)
    - `lps_custom_formatted` (string, formatted number)
    - `lcc_charges_formatted` (string, formatted number)
    - `lcc_montage_formatted` (string, formatted number)
    - `lps_montage_time_formatted` (string, formatted number)
    - `montage_cost_formatted` (string, formatted number)
    - `lcc_update_sum_formatted` (string, formatted number)
    - `summ_formatted` (string, formatted number)
    - `summ_zak_formatted` (string, formatted number)
    - `margin_formatted` (string, formatted number)
    - `koeff_formatted` (string, formatted number)
    - `usr_name_show` (string)
    - `dep_name_show` (string)
    - `itogLine` (boolean)
    - `spc_group_delivery` (string)
    - `haveUnblockedPrc` (boolean)
  - total / summary schema:
    - `meta.rowsTotal` (number)
    - `meta.rowsReturned` (number)
    - `meta.limited` (boolean)
  - view/visibility schema:
    - `view` object with boolean flags:
      - `view_contractor`, `view_country`, `view_contract`, `view_stuff_category`, `view_shipping`, `view_payment`,
        `view_transport`, `view_transport_sum`, `view_custom`, `view_other_sum`, `view_montage_sum`,
        `view_montage_time`, `view_montage_cost`, `view_update_sum`, `view_summ_zak`, `view_koeff`,
        `view_user`, `view_department`
  - errors schema:
    - On exception: HTTP 200, body `{"error":"<message>"}` (legacy: `MarginDevDataAction.toJsonError()`). No HTML from this endpoint when JSON is written.
- **Initial load:** On first open, session Margin is new/empty; response is `{ "data": [], "view": {}, "meta": { "rowsTotal": 0, "rowsReturned": 0, "limited": false } }`. Lookups may be called before any data request; data request without prior generate returns empty data.
- Example payloads:
  - `docs/screens/margin/payloads/grid-fetch.request.json`
  - `docs/screens/margin/payloads/grid-fetch.response.json`

## Margin Generate (Build Session)
- Method: POST
- Path: `/MarginAction.do?dispatch=generate`
- Purpose: Build Margin session dataset based on filters/options.
- Auth/session notes: Requires session; `MarginAction.generate()` calls `filter()` and writes Margin to session.
- Request:
  - query params: none
  - body schema (URL-encoded form; legacy `MarginForm` + `MarginAction.saveFormToBean()`):
    - `date_begin`, `date_end` (required by validation: `struts/validation.xml` form `/MarginAction:generate`)
    - `user.userFullName`, `user.usr_id` (string/id)
    - `department.name`, `department.id`
    - `contractor.name`, `contractor.id`
    - `stuffCategory.name`, `stuffCategory.id`
    - `route.name`, `route.id`
    - aspect: `user_aspect`, `department_aspect`, `contractor_aspect`, `stuff_category_aspect`, `route_aspect` (value `1` when checked)
    - options: `onlyTotal`, `itog_by_spec`, `itog_by_user`, `itog_by_product`, `get_not_block` (value `1` when checked)
    - view: `view_contractor`, `view_country`, `view_contract`, `view_stuff_category`, `view_shipping`, `view_payment`, `view_transport`, `view_transport_sum`, `view_custom`, `view_other_sum`, `view_montage_sum`, `view_montage_time`, `view_montage_cost`, `view_update_sum`, `view_summ_zak`, `view_koeff`, `view_user`, `view_department` (value `1` when checked)
  - filtering: all criteria in form body; server uses them in `select-margin-common` / `select-margin_proc-common` (procedure `dcl_margin`/`dcl_margin1`).
- Response:
  - HTML page (Struts input forward; re-render of Margin.jsp with updated session). Validation errors render on same page.
- Example payloads:
  - Capture HAR on POST with date_begin, date_end, one selector (e.g. department.id), and optional view_*.

## Margin Clear All
- Method: POST
- Path: `/MarginAction.do?dispatch=cleanAll`
- Purpose: Clear Margin session data (list cleared; form re-rendered).
- Auth/session notes: Requires session.
- Request:
  - query params: none
  - body schema: empty or current form state (legacy does not read body; `MarginAction.cleanAll()` calls `margin.cleanList()` then `filter()`).
  - sorting encoding: n/a
  - pagination encoding: n/a
  - filtering encoding: n/a
- Response:
  - HTML page (input forward). Grid refetch then returns empty data (session Margin list empty).
- Example payloads:
  - Capture HAR: POST with empty body or form; next GET `/MarginDevData.do` returns `data: []`.

## Margin Excel Export
- Method: GET
- Path: `/MarginAction.do?dispatch=generateExcel`
- Purpose: Download Excel report for current Margin session.
- Auth/session notes: Requires session; `MarginAction.generateExcel()` reads `Margin` from session, `margin.getExcelTable()`, writes via `Grid2Excel`.
- Request:
  - query params: none
  - body schema: n/a
  - filtering: server session only (no query/body params).
- Response:
  - Binary Excel download (Grid2Excel). No separate endpoint; same session data as grid.
- Errors: If session has no Margin or exception before write, response may be HTML or error page. **How to verify:** trigger Excel with empty session or after cleanAll; capture Content-Type and body in HAR.
- Example payloads:
  - `docs/screens/margin/payloads/export.request.json`

## Users Lookup
- Method: GET
- Path: `/UsersListAction`
- Purpose: Lookup users for filter control.
- Auth/session notes: Session required; list built from `select-users-filter` → `dcl_user_filter(:filter, :dep_id, :responsPersonInt)` (sql-resources.xml). Form: `UsersListForm` (dep_id, filter, have_all).
- Request:
  - query params:
    - `filter` (string, optional): search text; bound to SQL param. Sent when user types in serverList (Margin.jsp has `filter="filter"`).
    - `have_all` (boolean, default true): adds "All" option.
    - `dep_id` (string/id, optional): **only when chief dep**. Margin.jsp: when `showForChiefDep=true`, scriptUrl is `dep_id=${Margin.department.id}&have_all=true`; otherwise `have_all=true` only. When present, filters users by department.
  - body schema: n/a
  - filtering: query params only; `filter` sent on each keystroke in lookup input.
- Response:
  - rows schema: HTML table (serverList tag renders Map as table rows; key=usr_id, value=usr_name). **How to verify:** see "How to verify" (serverList response).
  - total / summary schema: n/a
  - errors schema: HTML error page.
- Example payloads:
  - `docs/screens/margin/payloads/lookups.request.json`
  - `docs/screens/margin/payloads/lookups.response.json`

## Departments Lookup
- Method: GET
- Path: `/DepartmentsListAction`
- Purpose: Lookup departments for filter control.
- Auth/session notes: Session required; query `select-departments` (DepartmentsListAction).
- Request:
  - query params: `have_all` (boolean, default true)
  - body schema: n/a
  - filtering: query params only
- Response:
  - rows schema: HTML table (serverList; key=dep_id, value=dep_name). **How to verify:** see "How to verify" at end.
- Example payloads:
  - `docs/screens/margin/payloads/lookups.request.json`
  - `docs/screens/margin/payloads/lookups.response.json`

## Contractors Lookup
- Method: GET
- Path: `/ContractorsListAction`
- Purpose: Lookup contractors for filter control.
- Auth/session notes: Session required; filter supported (ContractorsListAction + filter query).
- Request:
  - query params: `filter` (optional), `have_all` (default true)
  - body schema: n/a
  - filtering: `filter` sent when user types (Margin.jsp `filter="filter"`).
- Response:
  - rows schema: HTML table (serverList). **How to verify:** see "How to verify" at end.
- Example payloads:
  - `docs/screens/margin/payloads/lookups.request.json`
  - `docs/screens/margin/payloads/lookups.response.json`

## Stuff Categories Lookup
- Method: GET
- Path: `/StuffCategoriesListAction`
- Purpose: Lookup stuff categories for filter control.
- Auth/session notes: Session required; query `select-stuff_categories-filter` (StuffCategoriesListAction).
- Request:
  - query params: `filter` (optional), `have_all` (default true)
  - body schema: n/a
  - filtering: query params only
- Response:
  - rows schema: HTML table (serverList). **How to verify:** see "How to verify" at end.
- Example payloads:
  - `docs/screens/margin/payloads/lookups.request.json`
  - `docs/screens/margin/payloads/lookups.response.json`

## Routes Lookup
- Method: GET
- Path: `/RoutesListAction`
- Purpose: Lookup routes for filter control.
- Auth/session notes: Session required; query `select-routes` (RoutesListAction).
- Request:
  - query params: `have_all` (default true)
  - body schema: n/a
  - filtering: query params only
- Response:
  - rows schema: HTML table (serverList). **How to verify:** see "How to verify" at end.
- Example payloads:
  - `docs/screens/margin/payloads/lookups.request.json`
  - `docs/screens/margin/payloads/lookups.response.json`

---

## How to verify (UNCONFIRMED / live checks)

Use these steps when a contract point could not be fully confirmed from code or when exact text/format must be captured.

1. **Screen load / Iframe / error pages (exact HTML shape)**  
   - Open legacy app, log in as manager or admin, go to Reports → Margin.  
   - In HAR: capture GET `/MarginAction.do?dispatch=input` and GET `/test/MarginReportGridStandalone.jsp`.  
   - For errors: log out and open `/MarginAction.do?dispatch=input` (expect redirect/login or 403 HTML). Save response body and Content-Type.

2. **Generate request (exact form field list and response)**  
   - Set date_begin, date_end, one selector (e.g. department), click Generate.  
   - In HAR: find POST `/MarginAction.do?dispatch=generate`, copy request body (URL-encoded).  
   - Confirm presence of date_begin, date_end, at least one of department.id, user.usr_id, contractor.id, stuffCategory.id, route.id, and optional view_* / onlyTotal / get_not_block.  
   - Response: same URL, 200, Content-Type text/html; document is Margin.jsp re-render.

3. **CleanAll (grid after clear)**  
   - After Generate, click Clear all. In HAR: POST `dispatch=cleanAll`, then GET `/MarginDevData.do`.  
   - Confirm response `data: []` and meta.rowsTotal = 0.

4. **Export Excel (error case)**  
   - After cleanAll (or in new session without generate), click Excel. In HAR: GET `dispatch=generateExcel`.  
   - If error: capture status, Content-Type, and first 500 chars of body (HTML vs JSON).

5. **Users lookup dep_id**  
   - Log in as dev_manager_chief (chiefDepartment=1, departmentId=2001). Open Margin.  
   - In Network: open Users dropdown or type in user filter. Confirm GET `/UsersListAction.do` includes query param `dep_id=2001` (or current department id).  
   - Log in as admin; confirm same lookup has no `dep_id` or dep_id empty.

6. **serverList filter-on-type**  
   - In Margin, focus User or Contractor selector and type 2–3 characters.  
   - In HAR: each request to `/UsersListAction.do` or `/ContractorsListAction.do` must include `filter=<typed text>`.  
   - Confirm response rows are filtered (e.g. only users/contractors matching text).

7. **Initial empty grid**  
   - New session or after cleanAll; open Margin without clicking Generate.  
   - In HAR: GET `/MarginDevData.do?limit=200` must return 200 and JSON with `data: []`, `view: {}` or default view, `meta.rowsTotal: 0`.  
   - No prior POST generate required for this request to be allowed.

8. **Grid data error shape (non-JSON)**  
   - Simulate: e.g. break session or return HTML from MarginDevData in legacy.  
   - Confirm legacy UI shows an error message and grid clears; capture exact error string from UI or response.
