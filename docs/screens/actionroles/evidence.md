# actionroles — Evidence

## Happy path
1. Open `/ActionRolesAction.do?dispatch=show&act_id=<id>` from Actions grid.
2. Select one role in left grid (`selected_ids_in`) and click moveRight (`dispatch=add`).
3. Expected: role appears in right grid after refresh.

## Negative/no-op case
1. Open screen and click moveRight (`dispatch=add`) with no checkboxes selected.
2. Expected: no DB update call; page refreshes with unchanged grids.

## Actual status in this cycle
- Static proof from JSP + `ActionRolesAction` + `ActionRolesForm` + DDL.
- UNKNOWN: exact SQL text for `select-action-roles-*` and `add/delete-action-roles*` queries.
