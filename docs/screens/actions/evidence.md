# actions — Evidence

## Happy path
1. Open `/ActionsAction.do`.
2. Verify grid is populated with actions (`act_system_name`, `act_name`, flags).
3. Click edit icon in a row.
4. Expected: transition to `/ActionAction.do?dispatch=edit&act_id=<id>`.

## Negative case
1. Trigger list load when `select-actions` fails (e.g., DB unavailable).
2. Expected: legacy error flow/page is shown (exact text UNKNOWN).

## Actual status in this cycle
- Static evidence collected from JSP + `ActionsAction` + Struts mappings + DDL.
- UNKNOWN: exact SQL and runtime error texts for `select-actions`.
