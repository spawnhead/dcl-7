# Reports → Margin: Behavior Matrix

> Source: `docs/screens/margin/SNAPSHOT.md` + payload examples in `docs/screens/margin/payloads/*.json`. Items marked **UNCONFIRMED** require live capture (HAR + screenshots).

| Scenario | Steps | Expected network call(s) | Expected UI state | Notes / edge cases |
| --- | --- | --- | --- | --- |
| Initial load | Open Reports → Margin | GET `/MarginAction.do?dispatch=input`; GET `/test/MarginReportGridStandalone.jsp`; GET `/MarginDevData.do?limit=200` | Filters visible; Generate/Excel disabled until valid inputs; grid shows session data | Limit default 200. **UNCONFIRMED** if grid empty on first load. |
| Generate | Set date range + one selector → click Generate | POST `/MarginAction.do?dispatch=generate`; then GET `/MarginDevData.do?limit=...` | Grid reloads with data | **UNCONFIRMED** exact form fields and redirect behavior. |
| Clear all | Click Clear all | POST `/MarginAction.do?dispatch=cleanAll`; then GET `/MarginDevData.do?limit=...` | Filters cleared; grid reset/empty | **UNCONFIRMED** whether grid clears or keeps prior data. |
| Change selector | Choose user/department/contractor/stuff/route | Lookup GET `/...ListAction` (depending on selector) | Other selectors cleared; only one aspect checkbox allowed | Selector change disables its own aspect checkbox. **UNCONFIRMED** exact UX. |
| Toggle onlyTotal | Check `onlyTotal` | No immediate network | `onlyTotal` may auto-uncheck if no selector; unchecks `itog_by_spec` | **UNCONFIRMED**: auto-uncheck behavior. |
| Toggle itog_by_spec | Check/uncheck | No immediate network | Enables/disables `itog_by_user`; uncheck clears it | **UNCONFIRMED**. |
| Toggle itog_by_user | Check/uncheck | No immediate network | Enables/disables `itog_by_product`; uncheck clears it | **UNCONFIRMED**. |
| Change “Грузить” limit | Select limit 50/100/200/500/1000 | GET `/MarginDevData.do?limit=...` | Grid refetches with new max rows | **UNCONFIRMED** list of allowed values. |
| Change page size | Select 25/50/100/200 | No network (client-side) | Pagination size updates | **UNCONFIRMED** default page size. |
| Sort column | Click column header | No network (client-side) | Sorted rows | All columns sortable. |
| Export Excel | Click Excel | GET `/MarginAction.do?dispatch=generateExcel` | Browser downloads Excel | Uses iframe injection. |
| Export CSV | Click “Экспорт CSV” | No network (client-side) | CSV file `margin_export.csv` downloaded | Client-side table export. |
| Error: non-JSON response | Simulate HTML response from `/MarginDevData.do` | GET `/MarginDevData.do?limit=...` returns HTML | Shows “Сервер вернул страницу вместо JSON…” and clears grid | **UNCONFIRMED** exact text. |
| Error: no access | Simulate permission HTML page | GET `/MarginDevData.do?limit=...` returns permission HTML | Shows “Нет прав на доступ к данным” | **UNCONFIRMED** exact text. |
