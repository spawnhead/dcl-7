# Legacy Screen Snapshot - Reports -> Margin

> **Source note:** This snapshot is reconstructed from legacy JSP/Action sources in the repo because the legacy UI was not runnable in this environment (no live HAR/UI capture). `network.har` and payload JSON are placeholders derived from source analysis; screenshots must be captured separately.

Related docs:
- Contracts: `docs/screens/margin/CONTRACTS.md`
- Acceptance checklist: `docs/screens/margin/ACCEPTANCE.md`
- Behavior matrix: `docs/screens/margin/BEHAVIOR_MATRIX.md`

## 1. Screen identity
- Legacy menu path: Отчеты -> Маржа
- Legacy URL/route: `/MarginAction.do?dispatch=input`
- Required roles/permissions (если видно):
  - UI-level permission checks not visible in JSP; server-side logic hides logistics column for non-admin/economist users (`view_other_sum` becomes read-only/empty).
  - API filter for modern `/api/margin` suggests roles: admin/economist/manager (legacy role mapping may differ).

## 2. Layout map (all UI elements)

### Filters panel
**Date range**
- `date_begin` (ctrl:date): date picker, required for Generate/Excel enable.
- `date_end` (ctrl:date): date picker, required for Generate/Excel enable.
- Validation/enable rule: Generate + Excel buttons enabled only when both dates are filled **and** one of the aspect filters has a value (user/department/contractor/stuff category/route).

**Form by (value selectors) + Aspect by (single checkbox)**
Each row has a server-side lookup field + an “aspect” checkbox; only one aspect checkbox can be selected at once.
- User (`user.userFullName`, `user.usr_id`)
  - Lookup: `/UsersListAction` (filter + have_all; for chief dep includes dep_id)
  - Aspect checkbox: `user_aspect`
- Department (`department.name`, `department.id`)
  - Lookup: `/DepartmentsListAction` (have_all)
  - Aspect checkbox: `department_aspect`
- Contractor (`contractor.name`, `contractor.id`)
  - Lookup: `/ContractorsListAction` (filter + have_all)
  - Aspect checkbox: `contractor_aspect`
- Stuff Category (`stuffCategory.name`, `stuffCategory.id`)
  - Lookup: `/StuffCategoriesListAction` (filter + have_all)
  - Aspect checkbox: `stuff_category_aspect`
- Route (`route.name`, `route.id`)
  - Lookup: `/RoutesListAction` (have_all)
  - Aspect checkbox: `route_aspect`

**Options (checkboxes)**
- `onlyTotal`: “Выводить только итоги”
- `itog_by_spec`: “Выводить итоги по спецификациям договоров”
- `itog_by_user`: “Разбивать итог спецификации на пользователей” (enabled only when `itog_by_spec` checked)
- `itog_by_product`: “Разбивать итог пользователя на итоги по продуктам” (enabled only when `itog_by_user` checked)
- `get_not_block`: “Включить в отчёт незаблокированные закрытия договоров”

**View columns (checkboxes)**
Columns toggles controlling table visibility (set in Margin session, read by `MarginDevData`):
- `view_contractor`, `view_country`, `view_contract`, `view_stuff_category`, `view_shipping`, `view_payment`,
  `view_transport`, `view_transport_sum`, `view_custom`, `view_other_sum` (logistics), `view_montage_sum`,
  `view_montage_time`, `view_montage_cost`, `view_update_sum`, `view_summ_zak`, `view_koeff`,
  `view_user`, `view_department`.

### Action buttons
- **Clear all** (`dispatch=cleanAll`): clears filters and margin session data.
- **Generate** (`dispatch=generate`): submits form to build Margin session dataset.
- **Excel** (`dispatch=generateExcel`): triggers iframe download for Excel export.

### Grid/Table (iframe)
Iframe source: `/test/MarginReportGridStandalone.jsp`

**Toolbar**
- Status text (“Загрузка…”, error text, results count)
- “Грузить” select: limit for server fetch (50/100/200/500/1000; default 200)
- “Показывать” select: pagination page size (25/50/100/200; default 50)
- Quick search input (“Поиск…”) — table quick filter
- Buttons: Обновить, Сбросить фильтр, Экспорт CSV

**Columns list (order)**
1. `ctr_name` — Контрагент
2. `cut_name` — Страна
3. `con_number_formatted` — № контракта
4. `con_date_formatted` — Дата контракта (date filter)
5. `spc_number_formatted` — № спецификации
6. `spc_date_formatted` — Дата спецификации (date filter)
7. `spc_summ_formatted` — Сумма (right aligned)
8. `cur_name` — Валюта
9. `stf_name_show` — Продукт (производитель)
10. `shp_number_show` — № отгрузки
11. `shp_date_show` — Дата отгрузки (date filter)
12. `pay_date_show` — Дата оплаты (date filter)
13. `lps_summ_eur_formatted` — Сумма, EUR (right aligned)
14. `lps_summ_formatted` — Сумма без НДС (right aligned)
15. `lps_sum_transport_formatted` — Транспорт (right aligned)
16. `lcc_transport_formatted` — Транспорт Минск‑Клиент (right aligned)
17. `lps_custom_formatted` — Таможенные (right aligned)
18. `lcc_charges_formatted` — Логистика (right aligned)
19. `lcc_montage_formatted` — Монтаж и наладка (right aligned)
20. `lps_montage_time_formatted` — Время на монтаж, часы (right aligned)
21. `montage_cost_formatted` — Ст-ть монтажа (норматив) (right aligned)
22. `lcc_update_sum_formatted` — Корректировка (right aligned)
23. `summ_formatted` — Сумма товара (right aligned)
24. `summ_zak_formatted` — Сумма закупки (right aligned)
25. `margin_formatted` — Маржа (right aligned)
26. `koeff_formatted` — Средний коэфф‑т (right aligned)
27. `usr_name_show` — Пользователь
28. `dep_name_show` — Отдел

**Row interactions / styles**
- Sorting: enabled for all columns.
- Filtering: floating filters, date filters for date columns.
- Row class styling:
  - `itogLine` → bold row (mg-itog).
  - `spc_group_delivery` present → green background; if `haveUnblockedPrc` true then gradient green+pink.
  - `haveUnblockedPrc` without group → pink background.
- Pagination: client-side pagination with page size control.

### Secondary panels/modals
- None detected in JSP/JS. No row details modal is wired in legacy grid.

## 3. Behavior (exact)

> Note: behaviors described from JSP/JS logic rather than live UI.

**A) Initial load**
- Trigger: open `/MarginAction.do?dispatch=input` from Reports menu.
- UI change: filters render; Generate/Excel disabled until valid date + at least one selector.
- Network calls fired:
  - GET `/MarginAction.do?dispatch=input`
  - GET `/test/MarginReportGridStandalone.jsp` (iframe)
  - GET `/MarginDevData.do?limit=200` from grid JS

**B) Нажать “Сформировать”**
- Trigger: submit with `dispatch=generate`.
- UI change: page reloads and grid reloads; margin session populated by backend (MarginAction.generate → filter → DAO fill).
- Network calls: POST `/MarginAction.do?dispatch=generate` with form fields; iframe reload triggers GET `/MarginDevData.do?limit=...`.

**C) Изменить каждый фильтр по очереди**
- Selecting any of user/department/contractor/stuffCategory/route clears the others (JS `onChange*` handlers) and disables its own aspect checkbox; re-evaluates onlyTotal/enterDate.
- Only one aspect checkbox can be selected at a time (mutual exclusion).
- `onlyTotal`: if checked but no selector chosen, it auto-unchecks; also unchecks `itog_by_spec` when selected.
- `itog_by_spec`: enables `itog_by_user`; unchecking disables and clears `itog_by_user`.
- `itog_by_user`: enables `itog_by_product`; unchecking disables and clears `itog_by_product`.

**D) Сбросить фильтры**
- Trigger: Clear all button (`dispatch=cleanAll`).
- UI change: clears filters and grid session list; grid will show empty or previous state depending on session.
- Network calls: POST `/MarginAction.do?dispatch=cleanAll`, followed by grid data fetch.

**E) Пагинация / page size**
- Pagination is client-side. Page size dropdown changes `paginationPageSize` and displays status text.
- “Грузить” limit changes server fetch limit; triggers refetch `/MarginDevData.do?limit=...`.

**F) Сортировка по колонкам**
- Default sort (client-side). No server sort parameters.

**G) Экспорт (Excel/CSV/Print)**
- Excel: button injects hidden iframe to `/MarginAction.do?dispatch=generateExcel`, downloads Excel file.
- CSV: “Экспорт CSV” uses client-side export with filename `margin_export.csv`.

**H) Открытие деталей**
- Not implemented in grid JS; no row click handlers in `MarginReportGridStandalone.jsp`.

**I) Ошибочные состояния**
- Grid JS handles non‑JSON responses: shows “Сервер вернул страницу вместо JSON…” (e.g., auth redirect) and clears grid.
- “Нет прав на доступ к данным” shown if response HTML hints at permission denial.
- Generic API error message for fetch failures.

## 4. Network contract inventory (from HAR)

> HAR not captured; contracts listed from JSP/Action sources.

### 4.1 Screen + Grid endpoints
- **GET** `/MarginAction.do?dispatch=input`
  - Purpose: render filter form + iframe.
  - Params: none.
- **GET** `/test/MarginReportGridStandalone.jsp`
  - Purpose: load table shell (client JS).
- **GET** `/MarginDevData.do?limit={n}`
  - Purpose: JSON grid data + view column toggles + meta counts.
  - Query params: `limit` (default 200, max 1000).
  - Response shape:
    - `{ data: MarginLine[], view: ViewFlags, meta: { rowsTotal, rowsReturned, limited } }` or `{ error: string }`.

### 4.2 Filter/Action endpoints
- **POST** `/MarginAction.do?dispatch=generate`
  - Purpose: build Margin session dataset (filters + totals).
  - Body params (form):
    - Dates: `date_begin`, `date_end`
    - Selectors: `user.userFullName`, `user.usr_id`, `department.name`, `department.id`, `contractor.name`, `contractor.id`, `stuffCategory.name`, `stuffCategory.id`, `route.name`, `route.id`
    - Aspects: `user_aspect`, `department_aspect`, `contractor_aspect`, `stuff_category_aspect`, `route_aspect`
    - Options: `onlyTotal`, `itog_by_spec`, `itog_by_user`, `itog_by_product`, `get_not_block`
    - View toggles: `view_*` (see list above)
- **POST** `/MarginAction.do?dispatch=cleanAll`
  - Purpose: clear session and filters.
- **GET** `/MarginAction.do?dispatch=generateExcel`
  - Purpose: download Excel of current Margin session.

### 4.3 Lookup endpoints (serverList HTML)
- **GET** `/UsersListAction?filter=...&have_all=true[&dep_id=...]`
- **GET** `/DepartmentsListAction?have_all=true`
- **GET** `/ContractorsListAction?filter=...&have_all=true`
- **GET** `/StuffCategoriesListAction?filter=...&have_all=true`
- **GET** `/RoutesListAction?have_all=true`

### Filtering protocol
- All filters are encoded as standard Struts form fields (URL‑encoded form body). Checkbox values are `1` when checked.

### Sorting protocol
- Sorting is client-side only; no server sort params.

### Pagination protocol
- Client-side pagination; server only limits max rows via `limit` parameter.

### Headers/cookies/session requirements
- Session required (JSESSIONID used in iframe and data URL). Data endpoint reads Margin session state.

## 5. Data model mapping (screen DTO)

**Filter DTO (MarginForm inputs)**
- `date_begin`, `date_end`: strings (dd.MM.yyyy)
- `user`: { `usr_id`, `userFullName` }
- `department`: { `id`, `name` }
- `contractor`: { `id`, `name` }
- `stuffCategory`: { `id`, `name` }
- `route`: { `id`, `name` }
- Aspects: `user_aspect`, `department_aspect`, `contractor_aspect`, `stuff_category_aspect`, `route_aspect`
- Options: `onlyTotal`, `itog_by_spec`, `itog_by_user`, `itog_by_product`, `get_not_block`
- View flags: `view_contractor`, `view_country`, `view_contract`, `view_stuff_category`, `view_shipping`, `view_payment`,
  `view_transport`, `view_transport_sum`, `view_custom`, `view_other_sum`, `view_montage_sum`, `view_montage_time`,
  `view_montage_cost`, `view_update_sum`, `view_summ_zak`, `view_koeff`, `view_user`, `view_department`.

**Grid row DTO (MarginLine JSON)**
- `ctr_name`, `cut_name`, `con_number_formatted`, `con_date_formatted`,
  `spc_number_formatted`, `spc_date_formatted`, `spc_summ_formatted`, `cur_name`,
  `stf_name_show`, `shp_number_show`, `shp_date_show`, `pay_date_show`,
  `lps_summ_eur_formatted`, `lps_summ_formatted`, `lps_sum_transport_formatted`, `lcc_transport_formatted`,
  `lps_custom_formatted`, `lcc_charges_formatted`, `lcc_montage_formatted`, `lps_montage_time_formatted`,
  `montage_cost_formatted`, `lcc_update_sum_formatted`, `summ_formatted`, `summ_zak_formatted`,
  `margin_formatted`, `koeff_formatted`, `usr_name_show`, `dep_name_show`,
  `itogLine` (bool), `spc_group_delivery` (string), `haveUnblockedPrc` (bool).

**Summary/Meta DTO**
- `meta`: `{ rowsTotal: number, rowsReturned: number, limited: boolean }`

## 6. Parity acceptance checklist
- See `docs/screens/margin/ACCEPTANCE.md` → Parity “MUST” list.
