# Contractors list (References → Контрагенты) — Legacy Snapshot

## 1) Идентификация
- Экран в меню legacy: **References → Contractors** (`menus.contractors`, `id.contractors`).
- Legacy route: `GET/POST /ContractorsAction.do` (`dispatch=input|filter|restore|block`, плюс grid pager).
- Tile/JSP: `.contractors` → `/jsp/contractors.jsp`.
- Modern route: **`/contractors`**.

## 2) Legacy entry points (traceability)
- Struts Action: `net.sam.dcl.action.ContractorsAction`.
- Form: `net.sam.dcl.form.ContractorsForm` (+ inherited JournalForm).
- JSP: `src/main/webapp/jsp/contractors.jsp`.
- SQL resource: `select-contractors` → `dcl_contractor_filter_full(...)`.
- Validation: `/ContractorsAction:filter`.
- Permissions: `xml-permissions.xml` `/ContractorsAction.do,/ContractorAction.do`.
- Checkers: `blockChecker` (admin only for block), `show-delete-checker` (occupied → delete hidden).

## 3) UI-слепок 1:1
### 3.1 Фильтры
1. `ctr_name_journal` — text (Наименование).
2. `ctr_full_name_journal` — text (Полное наименование).
3. `ctr_account_journal` — text (Расчетный счет).
4. `ctr_address_journal` — text (Адрес).
5. `user.userFullName` + `user.usr_id` — serverList `/UsersListAction`.
6. `department.name` + `department.id` — serverList `/DepartmentsListAction`.
7. `ctr_email_journal` — text.
8. `ctr_unp_journal` — text (УНП).

Кнопки: «Очистить фильтр» (`dispatch=input`), «Применить фильтр» (`dispatch=filter`).

### 3.2 Кнопки под гридом
- **adminOrOtherUserInMinsk:** «Очистить» (clear selection), «Объединить» (mergeContractors — out of scope v1).
- **Excel:** `dispatch=generateExcel` — экспорт в Excel.
- **«Создать»:** link `/ContractorAction.do?dispatch=create` (contractors.jsp:136–137) → modern `/contractors/new`.

### 3.3 Колонки грида (порядок)
1. Checkbox (adminOrOtherUserInMinsk) — для merge.
2. `ctr_name` (20%).
3. `ctr_full_name`.
4. `ctr_address` (20%).
5. `ctr_phone` (5%).
6. `ctr_fax` (5%).
7. `ctr_email` (8%) — link mailto.
8. `ctr_bank_props` (15%).
9. «Контактные лица» — link `/ContractorAction.do?dispatch=editContactPersons`.
10. Block status — checkbox (`ctr_block`), submit `dispatch=block`.
11. Edit — link `/ContractorAction.do?dispatch=edit`.
12. Delete (admin only + `!occupied`) — link `/ContractorAction.do?dispatch=delete`.

### 3.4 Иконки и подтверждения (legacy)
- Block: header icon **lock.gif** (`tooltip.Contractors.block_status`).
- Edit: grid edit icon (tooltip `tooltip.Contractors.edit`).
- Delete: grid delete icon (tooltip `tooltip.Contractors.delete`).
- Delete confirm: **UNCONFIRMED** (в `contractors.jsp` нет `askUser` для delete). How to verify: удалить контрагента в legacy и зафиксировать текст подтверждения/наличие confirm.

### 3.4 Пагинация
- Server-side, page size 15 (Config `table.pageSize`).
- NEXT/PREV через `grid` + `NEXT_PAGE`/`PREV_PAGE`.

## 4) Роли/права
- `blockChecker`: только admin может block/unblock.
- `show-delete-checker`: delete виден только если `!contractor.isOccupied()`.
- `adminOrOtherUserInMinsk`: checkbox и merge UI только для admin/otherUserInMinsk.

## 5) Связь с backend (legacy)
- `input`: сброс фильтров + internalFilter.
- `filter`: page=1 + internalFilter.
- `block`: ContractorDAO.saveBlock + internalFilter.
- `generateExcel`: select-contractors-all (без limit) + Grid2Excel.

## 6) UNCONFIRMED
- Delete confirm текст/наличие — см. §3.4.
- Кнопка «Создать» в contractors.jsp — проверить наличие и placement.
- dcl_contractor_filter_full — сигнатура в DDL; маппинг в Postgres.
- Точный wire-format block (ctr_id_journal, block) — UNCONFIRMED.
- Merge contractors — исключён из v1.
