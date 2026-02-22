# payments — Review

## Verdict
READY (documentation draft suitable for migration planning with explicit UNKNOWNs).

## Completed
- Зафиксированы входы/фильтры/грид/actions из `Payments.jsp`.
- Зафиксированы validation constraints из `validation.xml`.
- Зафиксированы enforced DB invariants из DDL (PK/NOT NULL/triggers/generator).
- Сформирован ожидаемый API contract для list/edit/clone/create операций.

## Remaining
- Подтвердить SQL `select-payments` и фактические runtime payload/errors через legacy HAR/log capture.

## SQL Review Gate (Patch 0.5+)
- [x] SQL Schema verified (table/column candidates noted).
- [x] Triggers/constraints/procedures reviewed at naming/association level.
- [ ] Full action->DAO->SQL runtime trace completed (if still UNKNOWN in `questions.md`).

