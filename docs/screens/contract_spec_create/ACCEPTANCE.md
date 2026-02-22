# N3a2 Contract specification create — Acceptance (full parity)

## A. Parity MUST
1. Экран содержит **2 вкладки**: Главная / Претензии.
2. Main tab включает поля, payment grid и attachments block как в legacy.
3. Complaint tab включает все 4 даты + комментарий.
4. Save проходит только при выполнении required + business validations.
5. При save новая спецификация возвращается в Contract grid (session flow).
6. Cancel/back не создает спецификацию.
7. Readonly/role behavior соответствует `SpecificationAction.input()`.

## B. Scenarios
### B1 Open
- Trigger: Contract form -> «Добавить спецификацию».
- Expect: 2 tabs, default payment row, currencyName inherited from contract.

### B2 Save valid
- Fill required fields + user (if not executed).
- Expect: success + return to contract + spec row visible.

### B3 Required validation
- Empty `spcNumber` or `spcDate` or `spcSumm` or `deliveryTerm.id`.
- Expect: validation errors, no insert.

### B4 Business validation (occupied)
- Simulate occupied spec with payed/shipped sum > spcSumm.
- Expect: corresponding business error(s), no save.

### B5 Complaint tab persistence
- Fill complaint dates/comment, save.
- Expect: values persist in returned contract spec row/edit form.

### B6 Attachments
- Add copy attachment and local attachment; delete one.
- Expect: grid updates and rollback on cancel.

### B7 Role/readOnly
- Manager-only / onlyLithuania / onlyLogistic should be readonly.
- Admin/economist/lawyer can edit per executed-status logic.

## C. Spec gap vs dev gap
- This update closes **spec gap** (full tab/field/flow coverage incl. complaint and async flows).
- Dev implementation should be checked against this acceptance matrix without assumptions.
