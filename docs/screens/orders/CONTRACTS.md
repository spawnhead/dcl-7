# Orders (legacy `/OrdersAction.do`) — CONTRACTS

## Struts mapping
- Action: `/OrdersAction` → `net.sam.dcl.action.OrdersAction`, form bean `Orders`, input `.Orders`, forward `form` → `.Orders`.

## Dispatch contracts

### 1) `dispatch=input`
- Method: GET/POST (screen entry uses GET).
- Path: `/OrdersAction.do?dispatch=input`.
- Response: HTML page (`Orders.jsp`) via `context.getMapping().getInputForward()`.
- Side effects: initializes all filter fields/defaults, then executes `internalFilter` and stores form in session (`StoreUtil.putSession`).

### 2) `dispatch=filter`
- Method: POST.
- Content-Type: `application/x-www-form-urlencoded`.
- Mandatory semantic params: filter form fields + `dispatch=filter`.
- Behavior:
  - `order_by` reset to ` ord_date descending`,
  - grid page reset to `1`,
  - SQL `select-orders` executed.

### 3) `dispatch=reload`
- Method: POST.
- Purpose: dependent selectors refresh (contractor_for/contract/specification chain).
- Behavior: copies posted fields into stored form and forwards `form` without `internalFilter`.

### 4) `dispatch=grid`
- Method: POST.
- Params:
  - `grid=NEXT_PAGE` or
  - `grid=PREV_PAGE`.
- Behavior: page inc/dec and `internalFilter`.

### 5) `dispatch=block`
- Method: POST.
- Params:
  - `ord_id` (row PK),
  - `block` (current row value from `scriptUrl="block=${record.ord_block}"`).
- Behavior: toggles `ord_block` (`""` ↔ `"1"`) and persists via `OrderDAO.saveBlock`.

## Filter payload field names (legacy form)
- Scalar: `number`, `date_begin`, `date_end`, `sum_min_formatted`, `sum_max_formatted`, `ord_num_conf`, `executed`, `not_executed`, `ord_ready_for_deliv`, `ord_annul_not_show`, `ord_show_movement`, `state_a`, `state_3`, `state_b`, `state_exclamation`, `state_c`, `order_by`.
- Nested:
  - `contractor.name`, `contractor.id`
  - `contractor_for.name`, `contractor_for.id`
  - `contract.con_number`, `contract.con_id`
  - `specification.spc_number`, `specification.spc_id`
  - `stuffCategory.name`, `stuffCategory.id`
  - `sellerForWho.name`, `sellerForWho.id`
  - `user.userFullName`, `user.usr_id`
  - `department.name`, `department.id`
  - helper hidden: `previousContractorFor.name`, `previousContract.con_number`.

## Grid identity/pagination/sort
- Grid property: `grid`.
- Grid PK: `ord_id`.
- Pagination params: `grid=NEXT_PAGE|PREV_PAGE`.
- Sort param: `order_by` inserted into SQL template `order by {order_by}`.

## Status codes/content-types
- Main dispatches (`input/filter/reload/grid/block`): HTML response, expected 200.
- No dedicated JSON contract on this screen.

## Network capture status
- Existing request examples are code-derived.
- To close parity at wire level, capture HAR on legacy host `http://localhost:8082` for: `input`, `filter`, `reload`, `grid` next/prev, `block` toggle.
