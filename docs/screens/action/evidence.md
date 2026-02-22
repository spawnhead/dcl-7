# action — Evidence

## Happy path (minimal)
1. Open `/ActionsAction.do`.
2. Click edit icon in any row.
3. Update `act_name`, toggle `act_logging`/`act_check_access`, press Save.
4. Expected: redirect back to actions list; edited values are visible.

## Negative case (validation)
1. Submit `/ActionAction.do?dispatch=process` with empty `act_system_name`.
2. Expected: validation error (`required`) and form stays open.

## Actual status in this cycle
- Static evidence assembled from JSP + Action classes + validation + DDL.
- UNKNOWN: runtime payload/error text and list SQL details (`select-actions`) pending runtime/HAR verification.
