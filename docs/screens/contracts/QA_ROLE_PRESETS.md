# N3 Contracts — QA role presets (dev headers)

> Пресеты в формате dev-bypass заголовков для modern backend.

## 1) admin
- `X-Dev-User: admin.contracts`
- `X-Dev-Roles: admin`
- `X-Dev-Department-Id: 10`
- `X-Dev-Department-Name: Sales`
- `X-Dev-Chief-Department: true`

Ожидаемое поведение:
- Доступ к экрану есть.
- Видны create/edit/delete (delete только если `spc_count=0`).
- Нет manager department lock.

## 2) manager
- `X-Dev-User: manager.contracts`
- `X-Dev-Roles: manager`
- `X-Dev-Department-Id: 20`
- `X-Dev-Department-Name: Export`
- `X-Dev-Chief-Department: false`

Ожидаемое поведение:
- Доступ к экрану есть.
- Create — нет (legacy разрешает input только admin/economist/lawyer).
- Edit только для строк, где `dep_id_list` содержит `20;`.
- Delete недоступен.

## 3) manager_chief
- `X-Dev-User: manager.chief.contracts`
- `X-Dev-Roles: manager`
- `X-Dev-Department-Id: 20`
- `X-Dev-Department-Name: Export`
- `X-Dev-Chief-Department: true`

Ожидаемое поведение:
- Как у manager (в legacy checker использует только department inclusion; флаг chief не расширяет права в текущей версии кода).

## 4) economist
- `X-Dev-User: economist.contracts`
- `X-Dev-Roles: economist`
- `X-Dev-Department-Id: 30`
- `X-Dev-Department-Name: Finance`
- `X-Dev-Chief-Department: false`

Ожидаемое поведение:
- Доступ к экрану есть.
- Create и edit доступны по роли.
- Delete недоступен (не admin).
