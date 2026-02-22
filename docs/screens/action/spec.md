# Action (slug: `action`) — Legacy Screen Spec

## 1) Screen entry
- Primary user path starts from actions list `/ActionsAction.do`, then row Edit opens `/ActionAction.do?dispatch=edit&act_id=<id>`.
- Direct submit endpoint: `/ActionAction.do?dispatch=process`.
- Cancel returns by Struts forward `back` to `/ActionsAction.do`.

## 2) What user sees
### 2.1 Edit card layout (`Action.jsp`)
Fields:
- `act_system_name` — readonly text field (system action path/name).
- `act_name` — editable text field (display name).
- `act_logging` — checkbox.
- `act_check_access` — checkbox.

Buttons:
- `Cancel` (`actionForward="back"`) -> list.
- `Save` (`dispatch="process"`) -> validates and persists.

### 2.2 Upstream list context (`Actions.jsp`)
Grid columns:
1. system name (`act_system_name`)
2. name (`act_name`)
3. logging (`act_logging`, readonly checkbox)
4. check access (`act_check_access`, readonly checkbox)
5. conditional link to role matrix (`/ActionRolesAction.do?dispatch=show`) only when `act_check_access=1`
6. edit icon (`/ActionAction.do?dispatch=edit`)

## 3) Validations and errors
- `/ActionAction:process`:
  - `act_system_name`: required, maxlength 100.
  - `act_name`: maxlength 100.
- Semantic errors: required/maxlength validation messages in Struts form validation.

## 4) Business rules / side effects
- Save flow stores form into session `Action` bean, persists via `ActionDAO.save`, then updates app-level `ControlActions` cache (`actions.putAction(action)`).
- Access-role link visibility depends on `act_check_access` value in list row.

## 5) Permissions
- `xml-permissions`: `/ActionsAction.do,/ActionAction.do,/ActionRolesAction.do` requires `admin` role.

## 6) Related screens
- `actions` (registry/list).
- `actionroles` (role assignment for selected action).

## 7) API summary
See `api.contract.md`.

## 8) DB invariants
See `db.invariants.md`.

## 9) Unknowns
See `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: `DCL_ACTION`, `DCL_ACTION_ROLE`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

