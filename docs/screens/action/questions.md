# action — Questions / UNKNOWN

1. UNKNOWN: SQL definition for `select-actions` dataset used by list screen (`ActionsAction`).
   - How to verify: find SQL map resource for `select-actions` and confirm sort order / filters.
2. UNKNOWN: runtime behavior when `act_system_name` is edited via crafted request (UI marks field readonly).
   - How to verify: submit POST `/ActionAction.do?dispatch=process` with modified `act_system_name` and inspect DB update policy.
