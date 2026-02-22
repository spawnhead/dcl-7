# QA Parity Report - Reports -> Margin

## Summary
- Overall status: **FAIL**
- Blockers count: **3**
- Non-blocking diffs count: **2**

## Blockers (must fix for 1:1 parity)

1) **[ACCEPTANCE §3 Parity MUST / §1 View columns]** — Column visibility toggles (view_*) not wired to grid.
   - **Expected:** view_* checkboxes in UI; grid column visibility driven by view flags (from session/response).
   - **Actual:** No view_* checkboxes in UI; grid shows all 28 columns; response.view is not applied to column visibility.
   - **Evidence:**
     - UI: `modern/ui/src/features/margin/MarginPage.tsx` — no state or checkboxes for view_*; columnDefs are static; no use of `gridQuery.data?.view` to set column visibility (e.g. no columnApi.setColumnsVisible / colDef.hide).
     - Backend: `modern/backend/.../margin/api/ViewFlagsDto.java`, `MarginService.java` (mapView, SessionState) — view accepted and returned; UI does not consume or send it.

2) **[ACCEPTANCE §1 Options / §2 Behavior; BEHAVIOR_MATRIX Toggle onlyTotal]** — onlyTotal dependency rules not implemented.
   - **Expected:** (a) onlyTotal auto-unchecks when no selector is chosen; (b) when user checks onlyTotal, itog_by_spec is unchecked.
   - **Actual:** onlyTotal is a simple checkbox; no auto-uncheck when hasOneSelector is false; no side-effect on itog_by_spec when onlyTotal is checked.
   - **Evidence:**
     - UI: `modern/ui/src/features/margin/MarginPage.tsx` — lines ~361–362: `<Checkbox checked={onlyTotal} onChange={(e) => setOnlyTotal(e.target.checked)}>Выводить только итоги</Checkbox>`; no logic for the two rules above.

3) **[ACCEPTANCE §2 Reset (Clear all)]** — Clear all does not clear option get_not_block.
   - **Expected:** Filters and options cleared (including get_not_block).
   - **Actual:** cleanAll mutation clears dates, selectors, aspects, onlyTotal, itogBySpec, itogByUser, itogByProduct but does not clear getNotBlock.
   - **Evidence:**
     - UI: `modern/ui/src/features/margin/MarginPage.tsx` — cleanAllMutation onSuccess (lines ~116–134): no `setGetNotBlock(false)`.

## Non-blocking diffs (allowed only if documented as Key decision)

1) **[CONTRACTS Margin Generate body schema]** — Generate request uses `user: { id, name }` (and same for department, contractor, stuffCategory, route) instead of legacy form names `user.usr_id`, `user.userFullName`.
   - **Evidence:** Backend `MarginGenerateRequest.java` (LookupItemDto id, name); CONTRACTS.md describes legacy URL-encoded form with usr_id/userFullName. Semantic parity; field names differ.

2) **[CONTRACTS Users Lookup]** — Backend does not support optional query param `dep_id` (for chief dep).
   - **Evidence:** `MarginController.java` getUsers(filter, have_all) only; CONTRACTS mark dep_id as UNCONFIRMED.

## UNCONFIRMED (could not verify)

1) **Exact error messages** — "Сервер вернул страницу вместо JSON…" and "Нет прав на доступ к данным" appear in code (`MarginPage.tsx` ~67, ~70); cannot confirm they match legacy without live HTML response capture.
2) **BEHAVIOR_MATRIX scenarios (Initial load, Generate, Clear all, Change selector, Pagination, Sort, Export, Error)** — Network requests and UI state changes not verified (no run + HAR); static check only.
3) **Lookup filter-on-type** — CONTRACTS say optional `filter` for Users/Contractors/StuffCategories; UI calls lookups with `have_all=true` only (no filter param). Legacy serverList behavior UNCONFIRMED; would need HAR to confirm when filter is sent.

## Coverage
- ACCEPTANCE items checked: 18/22 (UI Elements + Behavior + Parity MUST; view_* and onlyTotal/Clear-all details are partial).
- MATRIX scenarios verified: 0/12 (static only; dynamic verification not performed).
