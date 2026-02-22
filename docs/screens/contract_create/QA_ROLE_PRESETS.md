# N3a Contract create — QA Role Presets

Пресеты для проверки ролей create. Роли admin, economist, lawyer — **can create**. Manager, user_in_lithuania, logistic — **cannot create** (кнопка «Создать» на списке скрыта).

---

## Preset: admin
- **X-Dev-User:** `dev_admin`
- **X-Dev-Roles:** `admin`
- **Ожидание:** /contracts/new доступен, форма редактируемая, Save/Отмена работают.

## Preset: economist
- **X-Dev-User:** `dev_economist`
- **X-Dev-Roles:** `economist`
- **Ожидание:** /contracts/new доступен, форма редактируемая.

## Preset: lawyer
- **X-Dev-User:** `dev_lawyer`
- **X-Dev-Roles:** `lawyer`
- **Ожидание:** /contracts/new доступен, форма редактируемая.

## Preset: manager

- **X-Dev-User:** `dev_manager`
- **X-Dev-Roles:** `manager`
- **Ожидание:** /contracts — кнопка «Создать» **скрыта** или disabled. Прямой переход на /contracts/new — 403 или redirect.

## Traceability
- xml-permissions.xml:585 — /ContractAction.do?dispatch=input: admin, economist, lawyer.
