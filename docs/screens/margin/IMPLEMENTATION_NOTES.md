# Margin Screen — Implementation Notes

## Status: IMPLEMENTED (fake data)

Margin parity implemented per CONTRACTS.md, ACCEPTANCE.md, BEHAVIOR_MATRIX.md. Data source: in-memory fake (250 rows). Backend module: `modern/backend/.../margin/`. UI: `modern/ui/src/features/margin/`.

## Parity acceptance checklist (from ACCEPTANCE.md)

| MUST | Status | Notes |
|------|--------|--------|
| Generate/Excel enablement (dates + at least one selector) | DONE | Generate and Excel disabled until date_begin, date_end and one of user/department/contractor/stuffCategory/route set |
| Selector mutual exclusivity and aspect checkbox rules | DONE | Selecting one selector clears others; only one aspect checkbox at a time; aspect enabled only when that selector is set |
| Option dependencies (onlyTotal / itog_by_spec / itog_by_user / itog_by_product) | DONE | itog_by_user enabled when itog_by_spec; itog_by_product when itog_by_user; uncheck cascades; onlyTotal auto-unchecks when no selector (useEffect); checking onlyTotal unchecks itog_by_spec |
| Column visibility toggles (view_*) | DONE | view_* checkboxes in UI (block "Колонки:"); grid column visibility via colDef.hide from viewFlags; init from response.view on load; Generate sends view in body |
| Grid column order, labels, formats, sort/filter | DONE | 28 columns in SNAPSHOT order; right-aligned numeric; sort and floating filters |
| Row styling (itogLine, spc_group_delivery, haveUnblockedPrc) | DONE | .mg-itog bold; .mg-group green; .mg-unblocked pink; .mg-group-unblocked gradient |
| Excel and CSV export | DONE | Excel: GET /api/margin/export/excel; CSV: client-side exportDataAsCsv margin_export.csv |
| Error/empty/loading states | DONE | "Загрузка…"; "Сервер вернул страницу вместо JSON…"; "Нет прав на доступ к данным"; generic error text |

## Implemented

- **Backend** (`modern/backend/src/main/java/com/dcl/modern/margin/`):
  - `api/`: MarginController, MarginLineDto, ViewFlagsDto, MarginGridResponse, MarginMetaDto, MarginGenerateRequest, LookupItemResponse
  - `application/`: MarginService (generate, cleanAll, getData, exportExcel, lookups)
  - `domain/`: MarginLine, ViewFlags
  - `infrastructure/`: MarginFakeDataProvider (250 rows), MarginExcelExport (POI)
  - Endpoints: GET /api/margin/data?limit=, POST /api/margin/generate, POST /api/margin/cleanAll, GET /api/margin/export/excel, GET /api/margin/lookups/{users,departments,contractors,stuff-categories,routes}
- **UI** (`modern/ui/src/features/margin/`):
  - MarginPage: filters (dates, 5 selectors + aspect), options (onlyTotal with auto-uncheck when no selector + uncheck itog_by_spec on check), view_* checkboxes block "Колонки:" driving grid column visibility (init from response.view), buttons (Сбросить всё clears get_not_block too, Сформировать, Excel), toolbar, table 28 columns with viewFlags→hide, row classes, loading/error
- **Tests**: MarginIntegrationTest (getData, generate, cleanAll, lookups, exportExcel)

## Real progress loader (2026-02-09) — DONE

- **No fake timers**: progress driven only by real requests and events (lookup query statuses, mutation success, grid onFirstDataRendered, XHR onprogress/onload).
- **Initial load**: Steps "Пользователи", "Отделы", "Контрагенты", "Категории", "Маршруты"; details "Загружено справочников: N/5"; sync from useQuery statuses; finish/fail when all done or any error.
- **Generate**: Steps "Отправка запроса" → "Получение данных" → "Отрисовка таблицы"; render step done on table onFirstDataRendered; finishProgress() then.
- **Export**: XHR via downloadWithProgress.ts (onprogress → progressPct when Content-Length; onComplete → saveBlobAsFile); steps "Запрос отправлен" → "Получение файла" → "Сохранение".
- **UI**: useMarginProgress.ts, MarginProgress.tsx (Steps + Progress + Spin + Alert), MarginPage wires all phases; log: logs/dev-margin-progress-loader-20260209.log.

## Initial load and Clear all (strict 1:1)

- **Grid empty on entry**: No grid-fetch on mount. `gridQuery` has `enabled: isGridActive`; `isGridActive` defaults to `false`. rowData = `[]` until first Generate.
- **Lookups on mount**: Allowed; 5 lookups (users, departments, contractors, stuff-categories, routes) run on mount for filters.
- **Generate**: On "Сформировать" → POST generate; onSuccess `setIsGridActive(true)` + invalidateQueries → grid query runs (enabled), rowData from response.
- **Clear all**: On "Сбросить всё" → POST cleanAll; onSuccess `setIsGridActive(false)` + clear filters → grid empty again (rowData = `[]`), no grid-fetch until next Generate.
- **Totals/meta**: Shown only when `isGridActive` and data loaded; otherwise not shown.

## QA blockers fix (2026-02-09)

1. **View flags → grid visibility**: viewFlags state (init from gridQuery.data?.view); VIEW_FLAG_LABELS + COLUMN_VIEW_KEY; 18 checkboxes "Колонки:"; columnDefs useMemo with hide: !viewFlags[key]; Generate sends view in body.
2. **onlyTotal rules**: useEffect: when !hasOneSelector setOnlyTotal(false); onlyTotal onChange: when checked setItogBySpec(false) then setOnlyTotal.
3. **Clear all get_not_block**: cleanAllMutation onSuccess adds setGetNotBlock(false).

## Logs

- Empty grid verification (initial / Generate / Clear all): `logs/dev-margin-empty-grid-20260209.log`
- Progress loader verification: `logs/dev-margin-progress-loader-20260209.log`
- Blockers fix verification: `logs/dev-margin-blockers-fix-notes.log`
- Backend test: `logs/dev-margin-backend-test.log`
- Backend run: `logs/dev-margin-backend-run.log`
- UI install: `logs/dev-margin-ui-install.log`
- UI generate:api: `logs/dev-margin-ui-generate-api.log`
- UI run: `logs/dev-margin-ui-run.log`
- E2E notes: `logs/dev-margin-e2e-notes.log`

## Next steps

- Replace fake data with real DB queries (Margin DAO/session from legacy).
- Re-run QA (QA_PARITY_REPORT) after blockers fix.
- Capture live HAR/screenshots to confirm legacy request/response shapes.
