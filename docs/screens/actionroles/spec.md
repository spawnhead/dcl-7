# Action Roles (slug: `actionroles`) — Legacy Screen Spec

## 1) Вход в экран
- Из списка действий (`/ActionsAction.do`) по ссылке в колонке access для строк с `act_check_access=1`.
- URL: `/ActionRolesAction.do?dispatch=show&act_id=<id>`.
- Выход: кнопка `OK` -> `/ActionsAction.do`.

## 2) Что видит пользователь
- Заголовок с выбранным действием: `ActionRoles.selected1 <action.name> ActionRoles.selected2`.
- Две таблицы:
  - Left (`gridOut`): доступные роли (не назначенные действию).
  - Right (`gridIn`): выбранные роли (назначенные действию).
- В каждой таблице: checkbox выбора + колонка `rol_name`.
- Кнопки между таблицами:
  - `add` (moveRight)
  - `delete` (moveLeft)
  - `addAll` (moveRightAll)
  - `deleteAll` (moveLeftAll)

## 3) Действия и side effects
- `show`: загружает обе таблицы (`select-action-roles-out/in`) и объект action по `act_id`.
- `add`: если отмечены записи в `selected_ids_in`, выполняет update `add-action-roles`, затем refresh.
- `delete`: если отмечены записи в `selected_ids_out`, выполняет update `delete-action-roles`, затем refresh.
- `addAll`: выполняет update `add-action-roles-all`, затем refresh.
- `deleteAll`: выполняет update `delete-action-roles-all`, затем refresh.

## 4) Валидации/ошибки
- Явных form validators для `ActionRolesAction` нет.
- Защита от пустого выбора реализована в action-логике (для `add/delete` update не вызывается при пустом selected list).

## 5) Права доступа
- По `xml-permissions` экран/операции `/ActionsAction.do,/ActionAction.do,/ActionRolesAction.do` доступны роли `admin`.

## 6) Связи
- Источник: экран `actions`.
- Контекст: выбранное действие (`act_id`) из `action`/`actions`.

## 7) API summary
См. `api.contract.md`.

## 8) DB invariants
См. `db.invariants.md`.

## 9) Unknowns
См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

