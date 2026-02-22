# DEV_BYPASS (spec)

Цель: дать предсказуемый способ тестировать API/UI без legacy login, сохранив модель `CurrentUser` и проверку ролей для паритета.

## 1) Scope

- Работает **только** в профиле `dev`.
- Не является UI login-экраном.
- Используется только для локальной/CI разработки и воспроизводимых скрин-тестов.

## 2) Request headers contract

### `X-Dev-User`
- Тип: `string`
- Default: `"dev"`
- Семантика: логическое имя текущего пользователя в dev bypass.

### `X-Dev-Roles`
- Тип: `string` (comma-separated)
- Default: `"admin"`
- Поддерживаемые значения (legacy role names):
  - `admin`, `manager`, `declarant`, `economist`, `lawyer`, `user_in_lithuania`, `other_user_in_Minsk`, `staff_of_service`, `logistic`.

### Optional (рекомендуемые расширения для parity)
- `X-Dev-Department-Id` (default `-1`)
- `X-Dev-Department-Name` (default `"Все"`)
- `X-Dev-Chief-Department` (`0|1`, default `0`)

> Эти 3 поля нужны для manager/chief_dep поведения Margin без ручной правки БД.

## 3) Runtime behavior

1. Если active profile != `dev`:
   - все `X-Dev-*` заголовки игнорируются;
   - bypass выключен.

2. Если active profile = `dev`:
   - если заголовки отсутствуют → подставляются defaults;
   - если заголовки есть → парсятся и формируют `CurrentUser` на запрос;
   - невалидные роли в `X-Dev-Roles` отбрасываются; если после фильтра пусто → fallback на `admin`.

3. При включенном bypass backend считает пользователя аутентифицированным для authorization-проверок.

4. Legacy/production login flow не трогаем в этой итерации.

## 4) `/api/me` contract (обязательный)

`GET /api/me` всегда возвращает текущий resolved user (из bypass в dev).

Пример ответа:
```json
{
  "id": "dev",
  "name": "dev",
  "roles": ["admin"],
  "department": {
    "id": "-1",
    "name": "Все"
  },
  "chiefDepartment": false,
  "authMode": "DEV_BYPASS"
}
```

## 5) Acceptance criteria

1. В `dev` без заголовков:
   - `/api/me` => `dev/admin`.
2. В `dev` с `X-Dev-Roles: manager` + `X-Dev-Chief-Department: 1`:
   - `/api/me` отражает manager/chief_dept=true.
3. В non-dev профиле:
   - заголовки не влияют на user context.

## 6) Security guardrails

- Bypass включается только флагом профиля (`dev`).
- В логах старта приложения обязателен явный маркер: `DEV_BYPASS_ENABLED=true/false`.
- Для non-dev старт с `DEV_BYPASS_ENABLED=true` должен считаться misconfiguration (ошибка старта или hard warning + disabled).

## 7) Решение по roadmap

- **Сейчас:** вводим `CurrentUser` + `DEV_BYPASS` + `/api/me`.
- **Откладываем:** полноценный UI login и session auth flow.
- Это зафиксировано осознанно ради быстрого цикла разработки и проверяемого 1:1 поведения экрана Margin.

## 8) UNCONFIRMED

1. **UNCONFIRMED:** требуются ли дополнительные поля current user (например `responsPerson`) для других экранов вне Margin.
   **Проверка:** при подключении следующего экрана сверять legacy form constraints и SQL параметры list/filter процедур.
