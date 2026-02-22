# actions — Expected API contracts (legacy-inferred)

- **GET/POST** `/ActionsAction.do`
  - Purpose: load actions registry grid.
  - Backend operation: `select-actions` dataset, bind to `gridActions`.
  - Response: HTML page `.Actions`.

- **GET/POST** `/ActionAction.do?dispatch=edit&act_id=<id>`
  - Purpose: open edit card for selected action.

- **GET/POST** `/ActionRolesAction.do?dispatch=show&act_id=<id>`
  - Purpose: open role-assignment screen (available only for rows with `act_check_access=1`).

Error semantics:
- DB/query failures on `select-actions` should return legacy error page flow (exact runtime payload/text UNKNOWN).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

