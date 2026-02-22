# Contracts payloads

Статус: **code-derived reconstruction (1:1 by legacy source), HAR не приложен**.

Источник реконструкции:
- `ContractsAction#input/filter/internalFilter/processBefore`
- `ContractsForm` + `JournalForm`
- `sql-resources.xml` entry `select-contracts`
- `Contracts.jsp` filter control names

## Файлы
- `initial-load.request.json` — initial open intent
- `initial-load.response.json` — defaults + first page
- `lookups.request.json` / `lookups.response.json` — filter lookup loading
- `grid-fetch.request.json` / `grid-fetch.response.json` — apply filter data fetch
- `export.*` — отсутствует, т.к. export на Contracts list в legacy не найден

## UNCONFIRMED
- wire-format legacy serverList lookup (возможно HTML fragment).
- точный raw-body Struts submit (x-www-form-urlencoded порядок полей).

## HOW TO VERIFY
1. Поднять legacy и открыть `/ContractsAction.do?dispatch=input`.
2. Снять HAR для initial/apply/clear/page-next.
3. Извлечь form payloadы и сравнить с JSON контрактами в этой папке.
4. При расхождении обновить JSON и отметить diff в `SNAPSHOT.md`.
