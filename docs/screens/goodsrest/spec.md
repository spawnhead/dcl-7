# goodsrest (slug: `goodsrest`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/GoodsRest.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `by_user`
- `date_begin`
- `date_end`
- `department.name`
- `goods_on_storage`
- `have_date_to`
- `onlyTotal`
- `order_by_date_receipt`
- `order_by_name`
- `order_by_stuff_category`
- `purpose.id`
- `purpose.name`
- `shipping_goods`
- `stuffCategory.name`
- `user.userFullName`
- `view_1c_number`
- `view_comment`
- `view_cost_one_by`
- `view_debt`
- `view_department`
- `view_lpc_count`
- `view_order_for`
- `view_prc_date`
- `view_prc_number`
- `view_price_list_by`
- `view_purpose`
- `view_sums`
- `view_usr_shipping`

### Колонки/гриды (по JSP markup)
- UNKNOWN

## 3) Действия
- См. `api.contract.md` (ожидаемые endpoint based on JSP links/forms).

## 4) Валидации и ошибки
- UNKNOWN: требуется сверка `validation.xml` и runtime HAR.

## 5) DB invariants
- См. `db.invariants.md`.

## 6) Unknowns
- См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: UNKNOWN.

