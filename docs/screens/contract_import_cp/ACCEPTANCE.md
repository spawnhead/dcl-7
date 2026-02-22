# N3b Contract import from CP — Acceptance criteria (1:1)

## Parity MUST (FAIL если не выполнено)
1. Экран открывается по `/contracts/import-cp` при клике «Импорт из КП» на Contracts list.
2. Отображается грид КП с фильтрами: number, department, date_begin/end, sum_min/max, user, contractor, stuffCategory, accepted, declined.
3. Колонки грида в порядке legacy: cpr_number, cpr_date, cpr_contractor, cprSumFormatted, cpr_currency, cpr_stf_name, reservedState, attachSqr, cpr_block, cpr_user, cpr_department, cpr_check_price.
4. В select mode: клик по строке → выбор КП → переход на Contract create form с данными из КП.
5. Кнопка «Отмена» в select mode → возврат (без выбора) → на Contracts list.
6. Apply filter → page=1, грид обновляется.
7. Clear filter → сброс, reload.

## Allowed diffs
- minsk_store: если по HAR не подтверждено влияние — передавать как query param, но не блокировать без него.

## Приёмочные сценарии

### 1) Open import-cp
- Trigger: клик «Импорт из КП» на /contracts.
- Expected: /contracts/import-cp, грид КП загружен, фильтры пустые, select mode (клик по строке = выбор).

### 2) Select CP
- Trigger: клик по строке КП.
- Expected: переход на /contracts/new, форма с данными из выбранного КП.

### 3) Cancel
- Trigger: клик «Отмена» в select mode.
- Expected: возврат на /contracts.

### 4) Apply filter
- Trigger: заполнить минимум 1 фильтр, Apply.
- Expected: page=1, грид обновлён.

### 5) Clear
- Trigger: Clear.
- Expected: сброс фильтров, reload.
