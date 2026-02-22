# N3 Contracts — Behavior matrix

| Scenario | Trigger | Expected network calls (order) | Expected UI state | Notes / legacy trace |
|---|---|---|---|---|
| Initial open | Open screen | 1) `GET /api/contracts/lookups` 2) `POST /api/contracts/data` with defaults | Фильтры пустые, чекбоксы off, grid page=1 | `ContractsAction#input` + `internalFilter`; JSP defaults |
| Period + selector apply | Set `date_begin/date_end` + contractor, click Apply | `POST /api/contracts/data` with mapped filter and `page=1` | Grid обновлён по фильтру | `ContractsAction#filter`, SQL `select-contracts` |
| Clear all | Click Clear | `POST /api/contracts/cleanAll` (или lookups+data) | Сброс всех фильтров, page=1 | `dispatch=input` semantics |
| Pagination page=2 | Click next | `POST /api/contracts/page` (`direction=next`) | Page increments, rows replace, hasNextPage updates | `processBefore` pager handlers |
| Sort by key columns | Load/reload grid | sort embedded in `/data` response; backend uses fixed default SQL order | Rows in legacy order | `order by con_reminder, con_date, con_number` |
| Page size | Any fetch | `pageSize=15` in request/response | 15 rows max on page unless config override | `DAOUtils.DEF_PAGE_SIZE` |
| Dependent lookups | Type in contractor/user/seller selectors | `GET /api/contracts/lookups?...` (or dedicated lookup endpoint) | dropdown options filtered | JSP serverList actions (`ContractorsListAction`,`UsersListAction`,`SellersListAction`) |
| Export | User looks for export | **No export call** | No export button | Not present in Contracts.jsp/ContractsAction |
| Кнопка «Импорт из КП» | Click button | Navigate to `/contracts/import-cp` (SPA route; legacy: ContractsAction.do?dispatch=selectCP&minsk_store=1 → forward SelectCPContractsAction) | Экран выбора КП (placeholder OK). Кнопка в gridBottom под гридом, текст «Импорт из КП». | **Verify:** /contracts → кнопка видна → клик → /contracts/import-cp. Trace: Contracts.jsp:123–125, struts forward selectCP. |
| Кнопка «Создать» | Click button | Navigate to `/contracts/new` (SPA route; legacy: ContractAction.do?dispatch=input) | Форма создания договора (placeholder OK). Кнопка в gridBottom справа от «Импорт из КП», текст «Создать». Видна только admin, economist, lawyer; скрыта/disabled для manager, user_in_lithuania, logistic. | **Verify:** admin — кнопка видна и кликабельна; manager — скрыта/disabled. Trace: Contracts.jsp:126–128, xml-permissions. |
| HTML instead of JSON | backend misconfigured / returns html | `/api/contracts/data` returns non-json | UI shows generic error state, keeps filter values | Legacy often html-based; modern must guard parse |
| No rights | role without permission | access blocked before data calls or 403 on first call | forbidden state / redirect | `xml-permissions.xml` for `id.contractDoc` + `/ContractsAction.do` |
| Server error | DB/procedure failure | `/api/contracts/data` 5xx | error banner/toast, old rows not silently replaced | `DAOUtils.executeQuery` exception path |

## UNCONFIRMED
1. Точный wire-level формат lookup запросов из legacy serverList.
2. Точный текст/DOM placement validation and server errors in legacy Contracts page.

## HOW TO VERIFY (legacy HAR)
1. Открыть `/ContractsAction.do?dispatch=input` под ролью admin.
2. Снять HAR: initial load, Apply (с валидным фильтром), Clear, Next page.
3. Отдельно снять невалидную дату и зафиксировать response/DOM error.
4. В serverList полях выполнить поиск (2-3 символа), снять lookup calls.
5. Сверить payload field names с `payloads/*.json` и обновить если найдены расхождения.
