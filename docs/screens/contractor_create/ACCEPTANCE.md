# N3a1 Contractor create — Acceptance (full parity)

## A. Parity MUST
1. Экран имеет **5 вкладок** в legacy-порядке: Главная / Курируют / Расчетные счета и банковские реквизиты / Контактные лица / Комментарии.
2. Open из Contract «Добавить» заполняет create defaults (current user + 3 default accounts).
3. Все main-поля и ограничения (required/maxlength/email/minlength) соблюдены.
4. UNP duplicate блокирует save с legacy-ошибкой.
5. Account rules (default/custom row behavior, currency/account constraints) соблюдены.
6. Save возвращает на Contract, а созданный contractor доступен для подстановки (через `currentContractorId` эквивалент).
7. Role/readOnly behavior: ограничения для non-admin/onlyManager/onlyOtherUserInMinsk соблюдены.
8. После успешного Save показывается feedback: **«Контрагент успешно сохранен»**.

## B. Scenarios
### B1 Open
- Trigger: Contract form → «Добавить» у контрагента.
- Expect: 5 tabs visible, default grids populated as legacy.

### B2 Save valid
- Fill required fields + корректные accounts.
- Expect: 2xx, contractor created, return to Contract with selected/new contractor; success feedback «Контрагент успешно сохранен».

### B3 Duplicate UNP
- Existing UNP.
- Expect: validation error, save blocked, active tab preserved.

### B4 Accounts validation
- Default row with account but empty currency → fail.
- Custom row with one empty field → fail.
- `accAccount` length >35 → fail.

### B5 Role restrictions
- Non-admin cannot delete user rows as admin-only action.
- onlyManager / onlyOtherUserInMinsk sees readonly reputation/comment.

### B6 Cancel
- Cancel/back returns to Contract without creating entity.

## C. Spec gap vs dev gap
- This pack resolves **spec gap** (missing full tabs/fields/rules).
- Dev gap for N3a1 already fixed in TASK-0006; this acceptance is normative for regression.
