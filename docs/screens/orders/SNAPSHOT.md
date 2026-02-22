# Orders (legacy `/OrdersAction.do`) — SNAPSHOT

## Entry and dispatches used by list screen
- Entry: `/OrdersAction.do?dispatch=input`.
- List screen dispatches: `input`, `filter`, `reload`, `grid` (`NEXT_PAGE`/`PREV_PAGE`), `block`.
- Row navigations from grid: `/OrderAction.do?dispatch=edit`, `/OrderAction.do?dispatch=clone`.
- Create button: `/OrderAction.do?dispatch=input`.

## Filters (exact form properties)
- Hidden: `order_by`, `previousContractorFor.name`, `previousContract.con_number`.
- Text/date: `number`, `date_begin`, `date_end`, `sum_min_formatted`, `sum_max_formatted`, `ord_num_conf`.
- ServerList/text fallback chains:
  - `contractor.name` (`contractor.id`),
  - `contractor_for.name` (`contractor_for.id`),
  - `contract.con_number` (`contract.con_id`) with fallback text when `contractor_for` empty,
  - `specification.spc_number` (`specification.spc_id`) with fallback text when contract empty,
  - `user.userFullName` (`user.usr_id`),
  - `stuffCategory.name` (`stuffCategory.id`),
  - `department.name` (`department.id`),
  - `sellerForWho.name` (`sellerForWho.id`).
- Checkboxes: `executed`, `not_executed`, `ord_ready_for_deliv`, `ord_annul_not_show`, `state_a`, `state_3`, `state_b`, `state_exclamation`, `state_c`, `ord_show_movement`.

## Defaults (`dispatch=input`)
- Empty objects/strings for most filters.
- `not_executed="1"`, `ord_annul_not_show="1"`, `executed=""`, `ord_ready_for_deliv=""`.
- `order_by=" ord_ready_for_deliv descending, ord_date descending, ord_number descending"`.
- Role-dependent:
  - manager: prefilled `user` = current user,
  - declarant/economist: `ord_ready_for_deliv="1"`.

## Filter/apply/clear/page/sort behavior
- Clear button submits `dispatch=input` (re-initializes defaults).
- Apply button submits `dispatch=filter`; action forces:
  - `order_by=" ord_date descending"`,
  - grid page = 1.
- Pagination dispatch is `grid`; handlers map `NEXT_PAGE`/`PREV_PAGE` to `incPage()` / `decPage()` and run `internalFilter`.
- Sorting is server-side via `order_by` parameter in SQL `select-orders` (`order by {order_by}`).

## Client-side disable/readonly rules
- `executed` checked:
  - clears+disables `state_a`,`state_3`,`state_b`,`state_exclamation`,`state_c`,
  - also unchecks `not_executed` and `ord_ready_for_deliv`.
- `not_executed` click unchecks `executed` and reapplies state disable logic.
- Mutual exclusions:
  - `state_a` or `state_3` => disables `state_b`,`state_c`.
  - `state_b` => disables `state_a`,`state_3`,`state_c`.
  - `state_c` => disables `state_a`,`state_3`,`state_b`.
- Changing `contractor_for` clears contract+specification and submits `dispatch=reload`.
- Changing `contract` may clear specification and submits `dispatch=reload`.

## Grid (property=`grid`, PK=`ord_id`)
Columns in order:
1. `ord_number`
2. `ordDateFormatted`
3. `ord_contractor`
4. `ordSumFormatted`
5. `ord_contractor_for`
6. `ordCurrentStateFormatted` (+ `linkToSpec` image/tooltip)
7. `threeDayMsg`
8. warning icon (`attention.gif`, `showWarn`)
9. `ord_user`
10. `ord_department`
11. `ord_block` checkbox (`dispatch=block`)
12. clone icon (`/OrderAction.do?dispatch=clone`)
13. edit icon (`/OrderAction.do?dispatch=edit`)

## Row actions / visibility by role
- Block checkbox readonly for non-admin (`blockChecker`).
- Clone/Edit readonly when current user is `onlyManager` and row department (`dep_id`) differs from manager department (`editCloneChecker`).
- Warning icon shown only when `record.is_warn` non-empty.
- Crossed row style (`crossed-cell`) for annulled rows (`ord_annul="1"`).
