# N3a3 Contract attachments — API Contracts

> Источник: DeferredAttachmentsAction, DeferredAttachments.jsp, DCL_ATTACHMENT.

## 1) GET `/api/contracts/draft/attachments` или `/api/contracts/:conId/attachments`

Назначение: list attachments. При draft (con_id=null) — session/deferred list; при con_id — DB.

Request: `GET /api/contracts/draft/attachments` или `GET /api/contracts/123/attachments`.

Response (200):
```json
{
  "items": [
    {
      "idx": "string",
      "id": "string",
      "originalFileName": "string",
      "attCreateDate": "string"
    }
  ]
}
```

## 2) POST `/api/contracts/draft/attachments/upload` (multipart)

Назначение: upload file. При draft — deferred (session); при con_id — persist to DCL_ATTACHMENT.

Request: `multipart/form-data`, file field.
Content-Type: multipart/form-data.

Response (200):
```json
{
  "id": "string",
  "originalFileName": "string",
  "attCreateDate": "string"
}
```

## 3) GET `/api/contracts/:conId/attachments/:id/download`

Назначение: download file.

Response: file stream (Content-Disposition: attachment).

## 4) DELETE `/api/contracts/draft/attachments/:id` или `/api/contracts/:conId/attachments/:id`

Назначение: delete attachment.

Response (204): no content.

## 5) Back
- Navigate /contracts/new (или /contracts/:conId).

## 6) UNCONFIRMED / How to verify
- Deferred attachment при con_id=null: session storage vs temp file.
- **HOW TO VERIFY:** legacy Contract create → Прикрепить → upload → save contract; Network + DB dcl_attachment.
