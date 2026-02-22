# actionroles — Expected API contracts (legacy-inferred)

- **GET/POST** `/ActionRolesAction.do?dispatch=show&act_id=<id>`
  - Purpose: load dual-list role assignment UI for action.
  - Response: HTML `.ActionRoles` with `gridOut` + `gridIn`.

- **POST** `/ActionRolesAction.do?dispatch=add`
  - Request fields: `act_id`, `selected_ids_in[]`.
  - Behavior: assign selected available roles to action.

- **POST** `/ActionRolesAction.do?dispatch=delete`
  - Request fields: `act_id`, `selected_ids_out[]`.
  - Behavior: unassign selected roles from action.

- **POST** `/ActionRolesAction.do?dispatch=addAll`
  - Request fields: `act_id`.
  - Behavior: assign all available roles.

- **POST** `/ActionRolesAction.do?dispatch=deleteAll`
  - Request fields: `act_id`.
  - Behavior: remove all assigned roles.

Error semantics:
- Empty selection for `add/delete` is a no-op (screen refresh without update call).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

