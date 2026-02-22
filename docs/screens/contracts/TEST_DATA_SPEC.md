# N3 Contracts — Test data specification

## Цель
Обеспечить детерминированный тестовый набор для проверки Contracts list по периодам **2024/2025/2026** и всем ключевым фильтрам/ролям.

## 1) Минимальные справочники
1. `users`: минимум 8 пользователей
   - 1 admin, 2 economist, 3 manager (в 2 департаментах), 1 lawyer, 1 logistic.
2. `departments`: минимум 3 департамента
   - DEP-10 Sales, DEP-20 Export, DEP-30 Logistics.
3. `contractors`: минимум 12 контрагентов
   - 8 активных, 2 архивных, 2 похожих по имени (для проверки поиска).
4. `sellers`: минимум 4 продавца
   - 2 резидент, 2 нерезидент.
5. `currencies`: минимум 3
   - BYN, USD, EUR.

## 2) Contracts dataset
- Объем: **40–80 строк** (рекомендация 60).
- Распределение по годам:
  - 2024: 15–20
  - 2025: 20–25
  - 2026: 10–15
- Статусы:
  - executed (`con_executed=1`): ~40%
  - not executed (`con_executed=0`): ~60%
- `con_annul=1`: минимум 6 записей (для crossed-cell).
- `spc_count>0`: минимум 15 записей (delete hidden).
- `attach_idx`: покрыть значения 1..6.
- `dep_id_list`: для части строк исключить manager department (проверка edit lock).
- `oridinal_absent=1`: минимум 8 записей.

## 3) Маячки (обязательные якоря)
1. `CN-2025-001`, дата `02.02.2025`, USD, contractor `ALFA TRADE`, executed=1.
2. `CN-2025-014`, дата `15.07.2025`, EUR, annul=1.
3. `CN-2024-009`, дата `21.11.2024`, BYN, spc_count=0 (delete candidate).
4. `CN-2026-003`, дата `10.01.2026`, con_reminder populated.
5. `CN-2026-010`, дата `27.09.2026`, oridinal_absent=1.

## 4) Наборы для тестов
- Sorting tie set: 5 строк с одинаковой датой и разным номером.
- Pagination set: минимум 31 строка под одним фильтром (чтобы проверить page1/page2/page3).
- Empty result set: фильтр по несуществующему номеру `ZZZ-NOT-FOUND`.
- Role lock set: минимум 10 строк с `dep_id_list` ≠ manager dept.

## 5) Минимальный сценарий наполнения
1. Seed lookups (users/departments/contractors/sellers/currencies).
2. Insert 60 contracts с размеченными комбинациями полей.
3. Insert spec rows так, чтобы часть `spc_count=0`, часть `>0`.
4. Проверить, что выборка `select-contracts` возвращает записи 2024-2026.
