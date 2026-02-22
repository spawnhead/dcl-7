# Payments (slug: `payments`) — Legacy Screen Spec

## 1) Вход в экран
- Основной маршрут: `/PaymentsAction.do?dispatch=input` (инициализация фильтра и загрузка списка).
- Применение фильтра: `/PaymentsAction.do?dispatch=filter` (submit формы).
- Переходы из грида:
  - edit: `/PaymentAction.do?dispatch=edit`
  - clone: `/PaymentAction.do?dispatch=clone`
- Создание: кнопка `Создать` ведёт на `/PaymentAction.do?dispatch=input`.

## 2) Что видит пользователь
### 2.1 Filter section
Поля:
- Contractor (`contractor.name` + hidden `contractor.id`, serverList `/ContractorsListAction`).
- Currency (`currency.name` + `currency.id`, serverList `/CurrenciesListAction`).
- Date range: `date_begin`, `date_end`.
- Sum range: `sum_min_formatted`, `sum_max_formatted`.
- `block` (checkbox).
- Mutual-exclusive status checkboxes: `closed_closed`, `closed_open`, `closed_all` (JS-гарантия выбора одного).
- `pay_account` (text).
- Actions: `Очистить фильтр` (dispatch=input), `Применить фильтр` (dispatch=filter).

### 2.2 Grid section
Колонки:
1. Date (`pay_date_formatted`)
2. Contractor (`pay_contractor`)
3. Account (`pay_account`)
4. Sum (`pay_summ_formatted`)
5. Currency (`pay_currency`)
6. Course (`payCourseFormatted`)
7. Sum EUR (`pay_summ_eur_formatted`)
8. NBRB course (`payCourseNbrbFormatted`)
9. Sum EUR NBRB (`pay_summ_eur_nbrb_formatted`)
10. Block status (`pay_block`, readonly checkbox)
11. Clone action
12. Edit action
13. Comment icon (показывается только при `hasComment=true`).

Bottom area:
- Итоги `calculatedSums` (агрегация по валютам из grid rows).
- Кнопка `Создать`.

## 3) Валидации и ошибки
- `date_begin`, `date_end`: date mask + date validation.
- `sum_min_formatted`, `sum_max_formatted`: currency validator.
- `contractor.name`: maxlength 200.
- `pay_account`: maxlength 35.
- UI rule: status-чекбоксы взаимоисключающие и хотя бы один должен остаться выбранным (client JS).

## 4) Бизнес-правила / статусы
- По умолчанию в `input()` включается `closed_open=1`; остальное очищается.
- `input()` может проставить default date range по `Config.dayCountDeductPayments`; иначе даты пустые.
- В `filter()` при `closed_open=1` принудительно очищаются `closed_closed` и `closed_all`.

## 5) Связи с другими экранами
- `Payment` (карточка платежа create/edit/clone).
- Contractor selector (`ContractorsListAction`).
- Currency selector (`CurrenciesListAction`).

## 6) API summary
См. `api.contract.md` (legacy expected endpoints).

## 7) DB invariants
См. `db.invariants.md` (только enforced правила из DDL/trigger/generator).

## 8) Unknowns
См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

