# Orders (legacy `/OrdersAction.do`) — ACCEPTANCE

## Presence parity
- [ ] All legacy filter controls from `Orders.jsp` exist (including hidden helpers and all state checkboxes).
- [ ] Grid has 13 legacy columns in the same semantic order, including lock/clone/edit columns.
- [ ] Bottom Create button is present only when not in select mode.
- [ ] Row warning icon and crossed-row style behave like legacy conditions.

## Behavior parity
- [ ] `dispatch=input` restores legacy defaults (`not_executed=1`, `ord_annul_not_show=1`, default sort chain).
- [ ] `dispatch=filter` resets sort to `ord_date descending` and page to 1.
- [ ] `dispatch=grid` uses `NEXT_PAGE`/`PREV_PAGE` only.
- [ ] Contractor-for and contract dependency chain triggers `dispatch=reload` with field clearing behavior.
- [ ] `executed`/`not_executed` + state checkbox JS disabling/mutual exclusions match legacy script.
- [ ] Lock checkbox posts `dispatch=block` with `ord_id` and `block`.

## Role/read-only parity
- [ ] Non-admin cannot toggle block checkbox.
- [ ] `onlyManager` cannot clone/edit rows of other departments.

## BLOCKED_FIELD policy
For this screen no explicit field is blocked by external screen dependency in legacy snapshot scope. If any new dependency is discovered, document as:
- `BLOCKED_FIELD: <field>`
- `dependsOnScreen: <legacy screen/action>`
- `How to verify in legacy: <step-by-step on 8082>`
