# N3a3 Contract attachments — Behavior matrix

| Scenario | Trigger | Expected network | Expected UI | Verify / Trace |
|----------|---------|------------------|-------------|----------------|
| Open | Click «Прикрепить» | GET /api/contracts/draft/attachments | Grid (пустой или deferred), кнопка Прикрепить | DeferredAttachmentsAction.init |
| Upload | Прикрепить → file | POST multipart 200 | Grid +1 row | DefferedUploadFileAction |
| Download | Click link | GET .../download | File download | DeferredAttachmentsAction.download |
| Delete | Click Delete | DELETE 204 | Row removed | DeferredAttachmentsAction.delete |
| Back | Click Назад | Navigate /contracts/new | Return to Contract | back |

## UNCONFIRMED
- Deferred при con_id=null.
- **HOW TO VERIFY:** legacy create → upload → save contract; Network + DB.
