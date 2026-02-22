# N3b Contract import from CP — Test data spec

## Domains
- **Contracts:** legacy contract_doc, contract_doc_det
- **CommercialProposals:** legacy commercial_proposal / commercial_proposal_det

## Required for import-cp screen

### 1) Lookups (minimal)
- `departments`: ≥1 row
- `users`: ≥1 row
- `contractors`: ≥1 row
- `stuff_categories`: ≥1 row

### 2) Commercial proposals (minimal)
- ≥3 КП с разными статусами и датами для фильтрации
- Как минимум один КП без блокировки (cpr_block=0), чтобы можно было выбрать

### 3) SQL / inserts (по DDL)
- Источник: `db/Lintera_dcl-5_schema.ddl`
- Таблицы: коммерческие предложения, связанные справочники
- Order: FK зависимостей (contractors, users, departments, stuff_categories → commercial_proposal)

### 4) Verification
- После seed: GET /api/contracts/import-cp/data (defaults) → items.length ≥ 1
- Select одного cprId → /contracts/new с pre-filled данными из КП
