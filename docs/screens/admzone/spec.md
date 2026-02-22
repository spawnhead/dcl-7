# Adm Zone (slug: `admzone`) — Legacy Screen Spec

## 1) Вход в экран
- Меню: `menus.adm_zone` -> `/AdmZone.do`.
- Struts mapping: `/AdmZone` (`ForwardAction`) -> tile `.AdmZone`.

## 2) Что видит пользователь
- Статический warning-текст для администратора (risk warning).
- Кнопка `adm_zone.start-shutdown-button` -> `/PrepareAppToShutdown`.
- Кнопка `adm_zone.fix-attachments` -> `/FixAttachments.do` с confirm `askUser="fixAttach"`.
- Текстовые пояснения рядом с обеими кнопками (`adm_zone.start-shutdown-text`, `adm_zone.start-fix-attach`).

## 3) Действия и side effects
### 3.1 PrepareAppToShutdown
- Endpoint: `/PrepareAppToShutdown`.
- Side effect:
  - `App.loginDisabled = true` (отключает новые логины).
  - Итерирует активные пользовательские сессии и устанавливает в сессию message `adm_zone.close-window`.
- После выполнения возвращает input forward (`/AdmZone.do`).

### 3.2 FixAttachments
- Endpoint: `/FixAttachments.do`.
- Side effect (maintenance):
  - Проверяет attachment records и файлы.
  - Удаляет записи attachment, если файл отсутствует/битый (по правилам в `FixAttachmentsAction`).
  - Для файлов на диске без записи в БД перемещает их в `lost_in_base`.
  - Заполняет `request.message` отчетом и возвращает maintenance view.

## 4) Валидации/ошибки
- Field-level validators на этом экране отсутствуют.
- Для `FixAttachments` действует confirm-dialog (`askUser`).
- Ошибки выполнения (filesystem/DB/session iteration) обрабатываются общим legacy error flow; точные payload/text UNKNOWN.

## 5) Права доступа
- Экран расположен в admin zone меню (`id.adm_zone`).
- Для конкретных action endpoint требуется отдельная runtime-проверка в permissions/config (см. UNKNOWN).

## 6) Связи с другими экранами
- `fixattachments` maintenance view (`.FixAttachments`) через `/FixAttachments.do`.
- Возврат на `admzone` после `/PrepareAppToShutdown`.

## 7) API summary
См. `api.contract.md`.

## 8) DB invariants
См. `db.invariants.md`.

## 9) Unknowns
См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

