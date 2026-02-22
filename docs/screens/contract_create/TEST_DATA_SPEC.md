# N3a Contract create — Test data specification

## Цель
Обеспечить детерминированный набор для проверки create flow: открытие формы, валидация, сохранение.

## 1) Минимальные справочники (совпадают с N3 Contracts list)
- **contractors**: минимум 5 (для select). Якорь: `ALFA TRADE` id известен.
- **currencies**: BYN, USD, EUR.
- **sellers**: минимум 4. **Якорь: seller id=1** — для проверки con_final_date required (JS: seller.id==1 && !con_reusable).
- **users**: admin, economist, lawyer (для canCreate).

## 2) Маячки для create
1. Contractor с id известным (для save request).
2. Currency BYN (id известен).
3. Seller id=1 — при !con_reusable обязателен con_final_date.
4. seller id≠1 — con_final_date не обязателен при con_reusable.

## 3) Сценарии данных
- **Valid create**: contractor ALFA TRADE, currency BYN, seller (любой), con_number "CN-TEST-001", con_date "11.02.2026".
- **Validation fail**: contractor empty, или con_number empty.
- **con_final_date required**: con_reusable=false, seller.id=1, con_final_date пусто → ожидать ошибку.
- **con_final_date optional**: con_reusable=true, или seller.id≠1.

## 4) Порядок seed
1. Справочники (contractors, currencies, sellers) — как в N3 Contracts TEST_DATA_SPEC.
2. Для create не нужны существующие contracts (create — insert).
