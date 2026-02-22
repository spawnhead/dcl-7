# N3b Contract import from CP — Behavior matrix

| Scenario | Trigger | Expected network | Expected UI | Verify / Trace |
|----------|---------|------------------|-------------|----------------|
| Open | Click «Импорт из КП» (minsk_store=1) | GET /contracts/import-cp + POST /api/contracts/import-cp/data (или open) | Грид КП, select mode | ContractsAction.selectCP → SelectCPContractsAction.input → CommercialProposalsAction.input |
| Select row | Click row | POST /api/contracts/import-cp/select {cprId} | Redirect /contracts/new, form pre-filled | SelectFromGridAction.select → ContractAction.importCP |
| Cancel | Click Отмена | — (SPA navigate) или POST select с empty | Return /contracts | __setSelect(,,1) |
| Filter | Apply + filter params | POST /api/contracts/import-cp/data | Grid updated | CommercialProposalsAction.filter |
| Clear | Clear | POST /api/contracts/import-cp/data (defaults) | Filters reset, grid reload | dispatch=input |

## UNCONFIRMED
- minsk_store: влияние на грид не подтверждено в SQL. **HOW TO VERIFY:** legacy HAR; сравнить запросы с minsk_store=1 и без.
