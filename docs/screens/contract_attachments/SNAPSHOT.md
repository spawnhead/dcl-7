# N3a3 Contract attachments — Legacy Snapshot

> Дочерний экран: открывается по кнопке «Прикрепить» на форме Contract. Parent: DCL_CONTRACT (att_parent_table, att_parent_id). При create con_id=null — legacy использует DeferredAttachmentService (session storage до save).

## 1) Идентификация
- Legacy route: ContractAction.deferredAttach → DeferredAttachmentsAction.do?dispatch=init (redirect).
- JSP: DeferredAttachments.jsp.
- Modern route: `/contracts/draft/attachments` или `/contracts/:conId/attachments` (conId optional при create).
- Parent: DCL_CONTRACT (att_parent_table='DCL_CONTRACT', att_parent_id=con_id).

## 2) UI-слепок
- grid: property="grid", key="idx".
- Колонки: originalFileName (link download), Delete.
- Кнопка «Назад» → back → ContractAction.retFromSpecificationOperation.
- Кнопка «Прикрепить» → DefferedUploadFileAction.do?dispatch=input → upload form.

## 3) DCL_ATTACHMENT
- att_id, att_parent_id, att_parent_table, att_name, att_file_name, att_link_id, usr_id, att_create_date.
- att_parent_table='DCL_CONTRACT', att_parent_id=con_id.

## 4) Flow при create (con_id=null)
- UNCONFIRMED: DeferredAttachmentService хранит файлы в session до save Contract; при save — привязка att_parent_id.
- **HOW TO VERIFY:** legacy Contract create → Прикрепить → upload → save contract; проверить Network и DB.

## 5) Flow при edit (con_id есть)
- GET list: DCL_ATTACHMENT WHERE att_parent_table='DCL_CONTRACT' AND att_parent_id=con_id.
- POST upload: multipart; att_parent_id=con_id.
- DELETE: delete by att_id.

## 6) Traceability
- DeferredAttachments.jsp, AttachmentsAction, DefferedUploadFileAction.
- struts-config: forward attach → DeferredAttachmentsAction.dispatch=init.
- ContractAction retFromSpecificationOperation.
