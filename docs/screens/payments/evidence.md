# payments — Evidence

## Happy path (minimal)
1. Открыть `/PaymentsAction.do?dispatch=input`.
2. Нажать `Применить фильтр` без доп. ограничений (или с `closed_open=1` по умолчанию).
3. Ожидание: отображается грид платежей, внизу показываются `calculatedSums`, доступны row actions `clone/edit`.

### Repro data hints
- Таблица: `DCL_PAYMENT`
- Базовая запись: `PAY_DATE`, `PAY_SUMM`, `CUR_ID`, `CTR_ID` (optional).

## Negative case (validation)
1. Отправить filter с `date_begin=31.31.2025` либо невалидным `sum_min_formatted`.
2. Ожидание: форма возвращается с validation error (mask/date/currency).

## Actual status in this cycle
- UI/DB анализ выполнен статически по JSP + Struts config + validation + DDL.
- UNKNOWN: фактические runtime error payload/text (нужен HAR/ручной прогон legacy).
