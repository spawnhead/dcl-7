# Contractors list — Test data specification

## 1) Минимальные справочники
- `users`: 4+ (admin, manager, economist, lawyer).
- `departments`: 2+.
- `contractors`: 20+ строк.

## 2) Contractors dataset
- Объём: 20–30 строк.
- `ctr_block`: 2–3 заблокированных.
- `occupied`: 2–3 занятых (для show-delete-checker).
- Разнообразие по полям: name, full_name, address, email, unp.

## 3) Маячки
1. Contractor с `ctr_name=ALFA` — для filter by name.
2. Contractor с `ctr_unp=123456789` — для filter by UNP.
3. Contractor `occupied=true` — delete hidden для admin.
4. Contractor `ctr_block=1` — blocked row.

## 4) Pagination
- Минимум 20 строк под пустым фильтром — проверить next page.

## 5) UNCONFIRMED
- Точный seed для dcl_contractor_filter_full — после анализа DDL.
