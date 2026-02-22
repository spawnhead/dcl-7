# Orders (legacy `/OrdersAction.do`) — BEHAVIOR_MATRIX

| Topic | Legacy behavior |
|---|---|
| Default state | `input` sets `not_executed=1`, `ord_annul_not_show=1`, default sort `ord_ready_for_deliv desc, ord_date desc, ord_number desc`. |
| Role defaults | manager → `user` prefilled; declarant/economist → `ord_ready_for_deliv=1`. |
| Apply filter | `filter` always resets `order_by` to `ord_date descending`, page to 1. |
| Pagination | `grid=NEXT_PAGE/PREV_PAGE` handled in `processBefore`; server-side page increment/decrement then `internalFilter`. |
| Executed/not executed | `ord_executed` is derived tri-state in form: both checked or both unchecked => `null`; only executed => `1`; only not_executed => `0`. |
| JS mutual exclusions | `executed` disables+clears state flags; `state_a/state_3`, `state_b`, `state_c` mutually disable each other as coded. |
| Dependent filters | Contractor-for change clears contract/specification and posts `reload`; contract change updates specification and posts `reload`. |
| Block control | Row lock checkbox posts `dispatch=block`; non-admin cannot toggle (`blockChecker`). |
| Edit/clone gate | For `onlyManager`: clone/edit readonly when record department != current manager department. |
| Visual styles | Annulled rows (`ord_annul=1`) get `crossed-cell`; warning icon shown only when `is_warn` filled. |
| Create visibility | Bottom Create button wrapped in `ctrl:notShowIfSelectMode`. |
