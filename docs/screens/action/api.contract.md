# action — Expected API contracts (legacy-inferred)

## Entry/list navigation
- **GET/POST** `/ActionsAction.do`
  - Purpose: open actions registry and load `gridActions` (`select-actions`).

## Edit action card
- **GET/POST** `/ActionAction.do?dispatch=edit&act_id=<id>`
  - Purpose: load selected action into session + form and open `.Action` page.

- **POST** `/ActionAction.do?dispatch=process`
  - Purpose: save edited action fields and redirect to `/ActionsAction.do`.
  - Request fields: `act_id`, `act_system_name`, `act_name`, `act_logging`, `act_check_access`.
  - Validation semantics: `act_system_name` required + maxlength 100; `act_name` maxlength 100.
  - Side effects: persists through `ActionDAO.save`, updates in-memory `ControlActions` cache.

## Access roles link
- **GET/POST** `/ActionRolesAction.do?dispatch=show&act_id=<id>` (visible only when `act_check_access=1` in row).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Example SQL constraints (from primary candidate table): `ACT_ID` INTEGER NOT NULL; `ACT_NAME` VARCHAR(100); `ACT_SYSTEM_NAME` VARCHAR(100) NOT NULL; `ACT_LOGGING` SMALLINT; `ACT_CHECK_ACCESS` SMALLINT.

