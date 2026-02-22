# ROLE_MODEL (legacy → current dev target)

Цель: зафиксировать **минимально достаточную и проверяемую** модель ролей для паритета 1:1 по экрану `Отчеты → Маржа` и быстрого dev-цикла.

## 1) Source of truth (что реально проверяет legacy)

1. Глобальная проверка доступа идет через `DefenderFilter` + `PermissionChecker`:
   - если нет пользователя в сессии → редирект на login;
   - если пользователь есть, URL проверяется по `xml-permissions.xml` и role-id пользователя.
2. Маппинг role-name в permissions XML на числовые `role_id` жестко задан в `XMLPermissions`/`UserRoles`:
   - `admin=1`, `manager=2`, `declarant=3`, `economist=4`, `lawyer=5`, `user_in_lithuania=6`, `other_user_in_Minsk=7`, `staff_of_service=8`, `logistic=9`.
3. Для Margin важны **две группы прав**:
   - доступ к меню/странице/данным (`/Menu...id.margin`, `/MarginAction.do`, `/MarginDevData.do`);
   - внутренняя роль-поведенческая логика в `MarginAction` (read-only, скрытие колонки «Логистика», дефолты пользователя/департамента).

## 2) Role catalogue (из legacy)

| Role ID | XML name | Legacy semantic (коротко) | Влияние на Margin |
|---:|---|---|---|
| 1 | `admin` | Админ, полный доступ | Доступ есть; видит `view_other_sum`; не manager read-only.
| 2 | `manager` | Менеджер | Доступ к Margin есть; если **не admin/economist**: включается manager read-only, автоподстановка текущего user, для chief_dep — фиксация департамента.
| 3 | `declarant` | Декларант | Нет доступа к `id.margin`/`/MarginAction.do`.
| 4 | `economist` | Экономист | Доступ есть; снимает ограничения manager/read-only; видит `view_other_sum`.
| 5 | `lawyer` | Юрист | Нет доступа к Margin.
| 6 | `user_in_lithuania` | Пользователь Литва | Нет доступа к Margin.
| 7 | `other_user_in_Minsk` | Прочий пользователь Минск | Нет доступа к Margin.
| 8 | `staff_of_service` | Сервис/ремонт | Нет доступа к Margin.
| 9 | `logistic` | Логист | Нет доступа к Margin как экрану (но колонка «Логистика» в отчете относится не к этой роли, а к проверке admin/economist).

## 3) Margin-specific права и ограничения

## 3.1 Видимость меню (Reports / Margin)
- `Menu.do?current_menu_id=id.margin` разрешен только для `admin`, `economist`, `manager`.
- Соответственно, для dev-паритета меню «Отчеты → Маржа» показывать только этим ролям.

## 3.2 Доступ к экрану/данным
- `/MarginAction.do` разрешен только `admin`, `economist`, `manager`.
- `/MarginDevAction.do` и `/MarginDevData.do` разрешены тем же набором (в legacy это сделано явно отдельными записями).

## 3.3 Дефолты/ограничения current user внутри Margin

Если пользователь имеет `manager` и при этом **не** `admin` и **не** `economist`, то:
1. `readOnlyForManager = true` (основные фильтры становятся readonly в форме).
2. `form.user` = текущий пользователь.
3. Если `usr_chief_dep=1` → `showForChiefDep=true` и `form.department` фиксируется в департамент пользователя.
4. В filter-ветке (после input/generate): для всех, кто **не admin и не economist**, скрывается колонка `view_other_sum` и выставляется `logisticsReadOnly=true`.

Следствие: роль `manager` определяет UX-дефолты, а роли `admin/economist` снимают часть ограничений.

## 4) Minimum roles for dev now (чтобы пройти сценарии Margin)

## Обязательный минимум
- Базовый dev-user: **`admin`**.
  - Причина: гарантированный доступ к меню/экрану/данным и отсутствие manager-only ограничений.

## Рекомендуемый набор тест-пользователей для воспроизводимости
1. `dev_admin` → roles: `admin`
2. `dev_manager` → roles: `manager` + `usr_chief_dep=0`
3. `dev_manager_chief` → roles: `manager` + `usr_chief_dep=1` + валидный `dep_id`
4. `dev_economist` → roles: `economist`

Это минимальный практический набор для проверки:
- доступа к экрану,
- manager read-only поведения,
- chief department дефолтов,
- видимости `view_other_sum`.

## 5) Что помечено UNCONFIRMED (и как быстро проверить)

1. **UNCONFIRMED:** влияет ли `DCL_ACTION_ROLE`/`select-user-actions` на конкретные кнопки Margin (кроме URL gating через XML permissions).
   **Проверка:** логиниться пользователем с ролью `manager`, но без action-прав в `DCL_ACTION_ROLE`; сравнить доступность Generate/Excel и AJAX вызовов.

2. **UNCONFIRMED:** точный набор «разрешенных, но не используемых» ролей для подменю Reports в legacy может отличаться от фактического поведения из-за порядка prefix-match в `xml-permissions`.
   **Проверка:** снять live HAR при кликах меню Reports/Margin и сверить, какой URL реально проверяется первым.

3. **UNCONFIRMED:** есть ли дополнительные SQL-level ограничения выборки по пользователю/департаменту через data in `dcl_margin(...)` помимо фильтров формы.
   **Проверка:** на одном наборе данных сравнить выдачу `admin` vs `manager` при одинаковых фильтрах и фиксированном периоде.

## 6) Решение для текущего этапа

Для быстрого dev цикла фиксируем contract:
- Access decision для Margin = `role in {admin, economist, manager}`.
- CurrentUser модель должна включать:
  - `id`, `name`, `roles[]`, `departmentId`, `departmentName`, `chiefDepartment:boolean`.
- Логику manager/defaults переносим 1:1 (без упрощений).
