# actionroles — Questions / UNKNOWN

1. UNKNOWN: точный SQL for `select-action-roles-out`, `select-action-roles-in`, `add-action-roles`, `delete-action-roles`, `add-action-roles-all`, `delete-action-roles-all`.
   - How to verify: locate SQL map/resources where DAOUtils keys are defined.
2. UNKNOWN: transaction behavior for addAll/deleteAll on large role sets (single statement vs looped updates).
   - How to verify: inspect SQL implementation and run trace with DB profiler/logging.
