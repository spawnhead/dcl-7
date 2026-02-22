# N3a Contract create — Acceptance criteria (1:1)

## Parity MUST (FAIL если не выполнено)
1. Экран открывается по `/contracts/new` для ролей admin, economist, lawyer.
2. Форма содержит поля в порядке legacy: con_number, con_date, con_reusable, con_final_date, contractor, currency, con_fax_copy, con_original, seller, con_annul, con_annul_date, спецификации (grid), прикреплённые файлы, con_comment.
3. con_number, con_date, contractor, currency, seller — обязательные; валидация maxlength 50 для con_number, 5000 для con_comment.
4. con_fax_copy и con_original взаимоисключающие (один снимает другой).
5. con_final_date обязателен при !con_reusable && seller.id=="1" (JS validation).
6. Кнопки «Отмена» и «Сохранить» внизу формы.
7. «Отмена» → возврат на `/contracts`.
8. «Сохранить» при валидных данных → ContractDAO.insert → redirect `/contracts`, новый договор появляется в гриде.
9. При validation error — форма остаётся, отображаются сообщения об ошибках.
10. manager, user_in_lithuania, logistic — доступ к create запрещён (кнопка «Создать» на списке скрыта).

## Parity MUST (дополнение)
11. Рядом с полем «Контрагент» отображается кнопка «Добавить» (N3a1). Клик → navigate /contractors/new?returnTo=contract; после save → return /contracts/new?newContractorId=…; contractor подставлен. Spec: docs/screens/contractor_create/.
12. Блок «Табличная часть» (Спецификации): grid виден (пустой при create); кнопка «Добавить Спецификацию» (N3a2) видна. Клик → /contracts/draft/specifications/new; после save → return, grid +1 row. Spec: docs/screens/contract_spec_create/.
13. Блок «Прикреплённые файлы»: grid виден (пустой при create); кнопка «Прикрепить» (N3a3) видна при showAttach (admin/economist/lawyer). Клик → /contracts/draft/attachments. Spec: docs/screens/contract_attachments/.

## Allowed diffs
- Спецификации при create: grid пустой (0 строк); добавление → отдельный flow (Specification screen).
- Attachments при create: grid пустой; кнопка «Прикрепить» по showAttach.

## Приёмочные сценарии

### 1) Open create form
- Trigger: GET /contracts/new (роль admin).
- Expected: форма с пустыми полями, lookups загружены (contractors, currencies, sellers), кнопки Отмена/Сохранить.

### 2) Save valid contract (header only)
- Trigger: заполнить con_number, con_date, contractor, currency, seller; нажать Сохранить.
- Expected: 200, redirect /contracts, договор в гриде.

### 3) Validation: required fields
- Trigger: пустые con_number или contractor; Сохранить.
- Expected: 400, сообщения «Введите Номер», «Выберите Контрагента» (или эквивалент).

### 4) Cancel
- Trigger: нажать Отмена.
- Expected: redirect /contracts, форма не сохранена.

### 5) con_final_date conditional
- Trigger: con_reusable=false, seller.id=1, con_final_date пусто; Сохранить.
- Expected: JS или server validation — «Поле Срок действия обязательно».

### 6) con_fax_copy / con_original mutual exclusive
- Trigger: включить con_fax_copy, затем con_original.
- Expected: con_fax_copy снимается.

### 7) No access for manager
- Trigger: роль manager; открыть /contracts/new напрямую.
- Expected: 403 или redirect, форма не показывается.
