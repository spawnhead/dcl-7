# N3a3 Contract attachments — Test data spec

## Domains
- DCL_ATTACHMENT: att_parent_table='DCL_CONTRACT', att_parent_id=con_id.

## Required
- Contract (draft в session или con_id в DB).
- При con_id: можно вставить тестовый attachment для download/delete.

## Verification
- Draft: GET list → items (пустой или deferred).
- Upload → 200, grid update.
- Delete → 204.
