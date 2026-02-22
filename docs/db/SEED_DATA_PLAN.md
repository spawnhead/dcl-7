# SEED_DATA_PLAN (dev, reproducible, Margin-first)

Цель: любой агент поднимает систему и получает одинаковый dataset для экрана `Отчеты → Маржа` без ручного ввода.

## 1) Data mode policy

- `FAKE_SEEDED` — есть dev seed marker + обязательные таблицы имеют минимум записей.
- `REAL` — marker отсутствует, но данные в доменных таблицах есть (подключена реальная БД/дамп).
- `EMPTY` — нет marker и нет минимального доменного набора.

## Marker для `FAKE_SEEDED`

Рекомендуемый вариант (простой и детерминированный):
- таблица: `DCL_SETTING`
- запись:
  - `STN_ID = 900001`
  - `STN_NAME = 'DEV_SEED_VERSION'`
  - `STN_VALUE = 'margin-v1'`
  - `STN_TYPE = 1`

`/api/dev/status` определяет `dataMode=FAKE_SEEDED`, если запись с `STN_NAME='DEV_SEED_VERSION'` найдена и `STN_VALUE` начинается с `margin-`.

---

## 2) Что нужно для Margin по контрактам

По `CONTRACTS/ACCEPTANCE` требуются:
1. lookups:
   - users, departments, contractors, stuff categories, routes;
2. grid data после Generate:
   - как минимум 1-2 строки из результата `dcl_margin(...)` в выбранном диапазоне дат;
3. role/access данные:
   - чтобы current user имел роль, открывающую Margin.

## 3) Таблицы seed и минимальные объемы

Ниже — **минимум для воспроизводимого запуска** (без рандома).

### 3.1 Security/current user

1. `DCL_ROLE` — 9 записей (legacy catalogue id=1..9).
2. `DCL_USER` — 4 записи:
   - `1001 dev_admin` (`dep_id=2001`, `usr_chief_dep=0`)
   - `1002 dev_manager` (`dep_id=2001`, `usr_chief_dep=0`)
   - `1003 dev_manager_chief` (`dep_id=2001`, `usr_chief_dep=1`)
   - `1004 dev_economist` (`dep_id=2002`, `usr_chief_dep=0`)
3. `DCL_USER_LANGUAGE` — по 1 записи на каждого user с `LNG_ID=1` (surname/name для отображения в lookup).
4. `DCL_USER_ROLE`:
   - (1001,1), (1002,2), (1003,2), (1004,4)

### 3.2 Lookups/filter selectors

1. `DCL_DEPARTMENT` — 2 записи:
   - `2001='Отдел продаж (DEV)'`
   - `2002='Экономический отдел (DEV)'`
2. `DCL_ROUTE` — 2 записи:
   - `3001='Минск→РБ (DEV)'`
   - `3002='Минск→EU (DEV)'`
3. `DCL_STUFF_CATEGORY` — 2 записи:
   - `4001='Упаковочное оборудование (DEV)'`
   - `4002='Конвейеры (DEV)'`
4. `DCL_CONTRACTOR` — 2 записи (включая обязательные поля `RPT_ID`, `CUT_ID`):
   - `5001='ООО ТестКонтрагент-1'`
   - `5002='ООО ТестКонтрагент-2'`

### 3.3 Domain chain для `dcl_margin(...)`

Чтобы `Generate` вернул grid rows, seed нужен по всей join-цепочке процедуры `DCL_MARGIN`:

1. `DCL_CONTRACT` — 2 записи (по одному договору на контрагента; `CUR_ID` заполнен).
2. `DCL_CON_LIST_SPEC` — 2 записи (`SPC_NDS_RATE`, `SPC_GROUP_DELIVERY` заполнены).
3. `DCL_SHIPPING` — 2 записи (`SHP_DATE` в фиксированном интервале, напр. `2024-01-15`, `2024-01-20`).
4. `DCL_PRC_LIST_PRODUCE` — 2 записи (связь с `STF_ID`, `USR_ID`, `DEP_ID`, `LPC_COST_ONE_BY`).
5. `DCL_SHP_LIST_PRODUCE` — 2 записи (связь shipping↔produce list; `LPS_SUMM_PLUS_NDS`).
6. `DCL_LPS_LIST_MANAGER` — 2 записи (каждая `LPS_ID` привязана к user, `LMN_PERCENT=100`).
7. `DCL_CONTRACT_CLOSED` — 2 записи (`CTC_DATE` внутри тестового диапазона; `CTC_BLOCK=1`).
8. `DCL_CTC_LIST` — 2 записи (связь `CTC_ID` + `SPC_ID`, суммы логистики/корректировок).
9. `DCL_CTC_SHP` — 2 записи (связь закрытия с shipping).
10. `DCL_PAYMENT` — 2 записи (`PAY_DATE`, `PAY_SUMM`, `CUR_ID`).
11. `DCL_PAY_LIST_SUMM` — 2 записи (связь payment↔spec↔lps).
12. `DCL_CTC_PAY` — 2 записи (связь закрытия с payment list).
13. `DCL_CURRENCY` — минимум 1 запись (`CUR_ID` используемый в contract/payment).
14. `DCL_PRODUCE_COST` — 2 записи (для связи `PRC_ID` → `RUT_ID`).

## Минимальный ожидаемый результат

После `Generate` с диапазоном `01.01.2024..31.01.2024` и любым из seeded фильтров:
- `rowsTotal >= 2`
- в данных присутствуют заполненные: `ctr_name`, `con_number_formatted`, `spc_number_formatted`, `usr_name_show`, `dep_name_show`, `margin_formatted`.

---

## 4) Обязательные поля и детерминизм

Правила:
1. Только фиксированные ID (без sequence/random).
2. Фиксированные даты (`2024-01-*`) и суммы.
3. Имена с префиксом `(DEV)` для быстрого визуального распознавания.
4. Seed идемпотентный: `MERGE`/`INSERT ... WHERE NOT EXISTS`.

## 5) Recommended implementation mechanism

- Flyway разделение:
  - baseline/schema: `db/migration` (обычные миграции)
  - dev-only seed: `db/dev`
- Подключение `db/dev` только в `dev` profile.
- Формат:
  - `R__dev_seed_margin_reference.sql` (repeatable справочники + users/roles)
  - `R__dev_seed_margin_domain.sql` (repeatable доменная цепочка margin)
  - `R__dev_seed_marker.sql` (marker в `DCL_SETTING`)

Почему repeatable:
- при правке seed не нужен ручной reset БД;
- агент всегда получает актуальный детерминированный набор.

---

## 5.1) Margin parity dataset

Для проверки экрана «Отчеты → Маржа» по ACCEPTANCE и BEHAVIOR_MATRIX используется детерминированный набор данных, описанный в:

- **`docs/screens/margin/TEST_DATA_SPEC.md`**

Минимальные требования к seed для Margin:

1. **Справочники (lookups):** users (4–5), departments (2–3), contractors (3–5), routes (2–3), stuff categories (2–3) с фиксированными ID и именами-маячками (например суффикс `(DEV)`).
2. **Роли:** минимум один пользователь admin, один manager, один manager_chief (usr_chief_dep=1), один economist для сценариев из `docs/screens/margin/QA_ROLE_PRESETS.md`.
3. **Margin data:** после Generate в диапазоне дат seed (например 2024-01-01 … 2024-01-31) должно возвращаться **25–40 строк**, с:
   - итоговыми строками (itogLine) и детализацией для onlyTotal / itog_by_spec / itog_by_user / itog_by_product;
   - строками с haveUnblockedPrc и spc_group_delivery для get_not_block и стилей строк;
   - разными значениями в колонках view_* (0, null, непусто), чтобы переключение видимости колонок было заметно.

Если доменная цепочка `dcl_margin` ещё не перенесена в Postgres, допускается временный источник данных (см. TEST_DATA_SPEC.md секция C); решение помечать как временное.

---

## 6) UNCONFIRMED и быстрые проверки

1. **UNCONFIRMED:** обязательность некоторых join-звеньев для `dcl_margin` может отличаться в edge cases (например, влияние `dcl_prc_list_produce.dep_id` и `ctc_block`).
   **Проверка:** выполнить прямой SQL `select count(*) from dcl_margin(...)` на seeded IDs и поочередно убирать звенья, фиксируя, что обнуляет выборку.

2. **UNCONFIRMED:** необходимость дополнительных справочников для форматированных полей (`*_formatted`) в legacy rendering path.
   **Проверка:** открыть `/MarginDevData.do` и убедиться, что нет `null`/пустых ключевых столбцов при базовом seed.
