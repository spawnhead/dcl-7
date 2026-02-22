# Margin: QA Role Presets (X-Dev-* заголовки)

Набор пресетов для проверки экрана «Отчеты → Маржа» с разными ролями без legacy login. Используются заголовки dev bypass (`docs/security/DEV_BYPASS.md`). Backend должен быть запущен с профилем `dev`.

---

## Preset: admin

**Назначение:** полный доступ к Margin, без ограничений manager (read-only фильтры, скрытие колонки «Прочее»).

| Заголовок | Значение |
|-----------|----------|
| `X-Dev-User` | `dev_admin` (или `admin`) |
| `X-Dev-Roles` | `admin` |
| `X-Dev-Department-Id` | `-1` или не передавать |
| `X-Dev-Department-Name` | `Все` или не передавать |
| `X-Dev-Chief-Department` | `0` или не передавать |

**Ожидание на Margin:**
- Меню «Отчеты → Маржа» доступно.
- Все фильтры редактируемые (не read-only).
- Колонка «Прочее» (`view_other_sum`) доступна и может быть включена.
- Users lookup без ограничения по департаменту (нет обязательного `dep_id` в запросе).

---

## Preset: manager

**Назначение:** менеджер без роли начальника отдела — ограничения manager (read-only фильтры, подстановка текущего пользователя, скрытие view_other_sum).

| Заголовок | Значение |
|-----------|----------|
| `X-Dev-User` | `dev_manager` |
| `X-Dev-Roles` | `manager` |
| `X-Dev-Department-Id` | `2001` (ID департамента из seed, например «Отдел продаж (DEV)») |
| `X-Dev-Department-Name` | `Отдел продаж (DEV)` |
| `X-Dev-Chief-Department` | `0` |

**Ожидание на Margin:**
- Доступ к экрану есть.
- Фильтры в состоянии read-only (или пользователь уже подставлен и не может сменить селекторы — по ROLE_MODEL).
- Колонка «Прочее» (`view_other_sum`) скрыта/выключена и не показывается.
- Users lookup вызывается **без** `dep_id` (т.к. chief_dep=0).

---

## Preset: manager_chief (chief department)

**Назначение:** менеджер — начальник отдела; фиксированный департамент в форме, Users lookup с фильтром по департаменту.

| Заголовок | Значение |
|-----------|----------|
| `X-Dev-User` | `dev_manager_chief` |
| `X-Dev-Roles` | `manager` |
| `X-Dev-Department-Id` | `2001` |
| `X-Dev-Department-Name` | `Отдел продаж (DEV)` |
| `X-Dev-Chief-Department` | `1` |

**Ожидание на Margin:**
- Доступ к экрану есть.
- В фильтре департамент зафиксирован (текущий отдел пользователя).
- Users lookup вызывается **с** `dep_id=2001` (или текущим ID департамента) — в списке только пользователи этого отдела.
- Остальные ограничения manager сохраняются (view_other_sum скрыта и т.д.).

---

## Preset: economist

**Назначение:** экономист — доступ как у admin по видимости колонок, без manager read-only.

| Заголовок | Значение |
|-----------|----------|
| `X-Dev-User` | `dev_economist` |
| `X-Dev-Roles` | `economist` |
| `X-Dev-Department-Id` | `2002` (другой отдел для разнообразия, например «Экономический отдел (DEV)») |
| `X-Dev-Department-Name` | `Экономический отдел (DEV)` |
| `X-Dev-Chief-Department` | `0` |

**Ожидание на Margin:**
- Меню и экран доступны.
- Фильтры редактируемые (не read-only).
- Колонка «Прочее» (`view_other_sum`) доступна.
- Поведение по данным и кнопкам совпадает с admin (отличия только при явной разнице в бизнес-логике по роли economist в legacy).

---

## Как использовать

1. Включить профиль `dev` при запуске backend.
2. В браузере или в клиенте (Postman / curl) при запросах к `/api/*` и к странице Margin выставлять указанные заголовки.
3. Для UI: если frontend передаёт заголовки из конфига или из «переключателя пользователя» на /dev — выбрать нужный preset и обновить страницу Margin.
4. Проверить сценарии из ACCEPTANCE и BEHAVIOR_MATRIX для каждого пресета (доступ, enablement Generate/Excel, вид колонок, Users lookup с/без dep_id).

Ссылки: `docs/security/ROLE_MODEL.md`, `docs/security/DEV_BYPASS.md`, `docs/screens/margin/ACCEPTANCE.md`, `docs/screens/margin/BEHAVIOR_MATRIX.md`.
