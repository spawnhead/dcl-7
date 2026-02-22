# Contractors list — Acceptance

## A. Parity MUST
1. Фильтры 1:1: ctr_name, ctr_full_name, ctr_account, ctr_address, user, department, ctr_email, ctr_unp.
2. Грид: колонки в legacy-порядке, block checkbox, edit link, delete link (admin + !occupied).
3. Row actions используют icons (edit/delete/block) — единообразно во всех строках.
3. Пагинация: page size 15, next/prev серверные.
4. Кнопка «Создать» → `/contractors/new` (returnTo=contractors).
5. Edit → `/contractors/{id}/edit`.
6. Block: только admin может менять; non-admin видит readonly.

## B. Scenarios
### B1 Open
- Trigger: меню References → Contractors.
- Expect: lookups loaded, grid first page, filters empty.

### B2 Filter
- Fill filter, Apply.
- Expect: grid shows filtered rows, page=1.

### B3 Clear filter
- After filter, Clear.
- Expect: filters reset, grid full first page.

### B4 Pagination
- Next/Prev.
- Expect: page changes, rows update.

### B5 Create
- Click «Создать».
- Expect: navigate to `/contractors/new`, returnTo=contractors.

### B6 Edit
- Click edit on row.
- Expect: navigate to `/contractors/{id}/edit`.

### B7 Block (admin)
- Admin toggles block.
- Expect: 200, grid row updates.

### B8 Block (non-admin)
- Non-admin: block disabled or readonly.

### B9 Delete
- Admin, occupied=false: delete visible.
- Admin, occupied=true: delete hidden.
- Non-admin: delete hidden.

### B10 Delete confirm + feedback
- Trigger: click delete icon.
- Expect: Popconfirm opens with legacy text (**UNCONFIRMED**, see SNAPSHOT §3.4) and actions Confirm/Cancel.
- Confirm: delete request sent; success feedback shown; row removed or grid refreshed.
- Cancel: no changes.

## C. UNCONFIRMED
- Merge contractors — не в scope v1.
- Excel export — defer.
- Кнопка «Контактные лица» — child screen TBD.
