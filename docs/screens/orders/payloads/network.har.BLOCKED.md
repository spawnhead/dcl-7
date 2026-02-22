# Orders list — network.har.BLOCKED

Status: **BLOCKED (HAR not attached)**.
Legacy endpoint is available on `http://localhost:8082`.

## Mandatory capture scenarios
1. Entry load: `/OrdersAction.do?dispatch=input`.
2. Apply filter: `/OrdersAction.do?dispatch=filter`.
3. Dependent reloads:
   - contractor_for change → `/OrdersAction.do?dispatch=reload`,
   - contract change → `/OrdersAction.do?dispatch=reload`.
4. Pager:
   - `/OrdersAction.do?dispatch=grid` with `grid=NEXT_PAGE`,
   - `/OrdersAction.do?dispatch=grid` with `grid=PREV_PAGE`.
5. Lock toggle:
   - `/OrdersAction.do?dispatch=block` with `ord_id` + `block`.
6. Row actions navigation:
   - `/OrderAction.do?dispatch=edit`, `/OrderAction.do?dispatch=clone`.

## Extract from HAR
- Request payload field names exactly as posted by browser.
- Response status/content-type.
- `order_by` and `grid` transport values.
- Any hidden anti-CSRF/session parameters if present.
