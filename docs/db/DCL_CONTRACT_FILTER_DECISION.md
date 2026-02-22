# DCL_CONTRACT_FILTER — решение по реализации

**Контекст:** Legacy Firebird использует процедуру `DCL_CONTRACT_FILTER` (selectable) для выборки строк списка договоров. В Postgres таблиц домена contracts раньше не было; экран работал на FAKE_SEEDED (ContractsFakeProvider).

**Источники:** `db/Lintera_dcl-5_schema.ddl` (procedure 2068–2098), `logs/db-parity-contracts-20260211-1200.md`, `docs/screens/contracts/CONTRACTS.md`.

---

## Варианты

| Вариант | Описание | Плюсы | Минусы |
|--------|----------|-------|--------|
| **A) Postgres FUNCTION** | `CREATE FUNCTION dcl_contract_filter(...) RETURNS SETOF ...` в миграции Flyway; тело по DDL (ALTER PROCEDURE) перенести в PL/pgSQL | Близко к legacy, одна точка истины | Сложная миграция, поддержка PL/pgSQL, дублирование таблиц/джойнов |
| **B) Application layer** | ContractsService + JPA/native query; фильтры, джойны, вычисления con_reminder, spc_count, attach_idx, usr_id_list, dep_id_list — в Java | Проще тестировать, гибкость, Modulith-совместимость | Логика разнесена, требуется маппинг DTO |

---

## Решение (2026-02-11)

**Выбрано: B) Application layer.**

### Обоснование

1. **Текущее состояние:** ContractsService уже реализует фильтрацию/пагинацию через ContractsFakeProvider. Логика фильтра (number, contractor, date range, sum, user, seller, executed/notExecuted, oridinalAbsent) уже в application layer.
2. **Контракт API:** POST /api/contracts/data и ответ по CONTRACTS.md/payloads не зависят от способа получения данных (процедура или репозиторий).
3. **Тестируемость:** Unit- и integration-тесты на Java проще, чем на PL/pgSQL.
4. **Миграции:** V12–V19 создают таблицы; не требуется миграция с CREATE FUNCTION.
5. **DCL_CON_MESSAGE, DCL_ATTACHMENT:** con_reminder и attach_idx могут быть реализованы в приложении (подзапросы/агрегаты) или позже — как Med priority в parity report.

### План перехода с FAKE на real DB

1. После применения V12–V19: таблицы dcl_department, dcl_language, dcl_seller, dcl_user, dcl_user_language, dcl_contractor, dcl_contract, dcl_con_list_spec существуют.
2. Добавить JPA-сущности и репозитории для этих таблиц.
3. Реализовать ContractsRepository с native/JPA-запросом, эквивалентным выборке DCL_CONTRACT_FILTER (джойны, фильтры, агрегаты spc_count, usr_id_list, dep_id_list).
4. При `dataMode != FAKE_SEEDED` (или при наличии записей в dcl_contract): ContractsService переключается на репозиторий вместо ContractsFakeProvider.
5. Сохранить контракт POST /api/contracts/data и форму ответа по CONTRACTS.md.

### Отложено

- **Postgres FUNCTION dcl_contract_filter:** не создаётся. При необходимости можно добавить позже (например, для отчётов или batch-обработки) отдельной миграцией.
- **con_reminder, attach_idx из DCL_CON_MESSAGE, DCL_ATTACHMENT:** Med priority; при появлении этих таблиц — расширить запрос/сервис.
