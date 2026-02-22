# Actions (slug: `actions`) — Legacy Screen Spec

## 1) Вход в экран
- Меню: `menus.actions` -> `/ActionsAction.do`.
- Struts mapping: `/ActionsAction` с input `.Actions`.

## 2) Что видит пользователь
- Один scrollable grid `gridActions`.
- Колонки:
  1. `act_system_name`
  2. `act_name`
  3. `act_logging` (readonly checkbox)
  4. `act_check_access` (readonly checkbox)
  5. conditional link `Actions.check_access_text` -> `/ActionRolesAction.do?dispatch=show` (только когда `act_check_access=1`)
  6. edit icon -> `/ActionAction.do?dispatch=edit`

## 3) Действия
- Открытие списка: execute `ActionsAction` с загрузкой `DAOUtils.fillGrid(..., "select-actions", ...)`.
- Редактирование строки: переход на экран `action`.
- Управление ролями доступа: переход на экран `actionroles` (условно доступно по `act_check_access`).

## 4) Валидации/ошибки
- На list-экране явных form validations нет.
- Потенциальные ошибки связаны с загрузкой data source `select-actions` (UNKNOWN runtime тексты/коды).

## 5) Права доступа
- `xml-permissions`: `/ActionsAction.do,/ActionAction.do,/ActionRolesAction.do` — роль `admin`.

## 6) Связи с другими экранами
- `action` — карточка редактирования действия.
- `actionroles` — назначение ролей для выбранного действия.

## 7) API summary
См. `api.contract.md`.

## 8) DB invariants
См. `db.invariants.md`.

## 9) Unknowns
См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

