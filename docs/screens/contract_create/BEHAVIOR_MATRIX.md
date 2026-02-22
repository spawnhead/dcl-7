# N3a Contract create — Behavior matrix

| Scenario | Trigger | Expected network | Expected UI | Verify / Trace |
|----------|---------|------------------|-------------|----------------|
| Open create | GET /contracts/new (admin) | GET /api/contracts/create/open (или lookups) | Форма пустая, lookups загружены; блоки Спецификации, Прикреплённые файлы видны (пустые); кнопка «Добавить» у contractor | ContractAction.input, inputCommon |
| Save valid | Fill required, click Save | POST /api/contracts/create/save 200 | Redirect /contracts, договор в гриде | process → saveCommon → insert → back |
| Save invalid | Empty contractor, Save | POST ... 400 validation | Ошибки под полями, форма не закрыта | validation.xml contractor.id required |
| Cancel | Click Отмена | — (SPA navigate) или GET /contracts | Возврат на список | dispatch back → ContractsAction.restore |
| con_final_date required | !con_reusable, seller=1, con_final_date empty, Save | 400 или client-side block | Alert/error msg.contract.requiredConFinalDate | Contract.jsp processClick |
| con_fax/con_original | Check con_fax_copy then con_original | — | con_fax_copy unchecked | JS conOriginalOnClick |
| No access | Manager on /contracts/new | 403 или redirect | Form not shown | xml-permissions |
| Click «Добавить» у contractor (N3a1) | Click | Navigate /contractors/new?returnTo=contract | Форма N3a1; после save → /contracts/new?newContractorId=…; contractor подставлен | docs/screens/contractor_create/ |
| Click «Добавить Спецификацию» (N3a2) | Click | Navigate /contracts/draft/specifications/new | Экран N3a2; после save → return, grid +1 row | docs/screens/contract_spec_create/ |
| Click «Прикрепить» (N3a3) | Click (showAttach) | Navigate /contracts/draft/attachments | Экран N3a3; upload, download, delete, back | docs/screens/contract_attachments/ |

## UNCONFIRMED
- Wire-формат lookups (legacy serverList).
- **HOW TO VERIFY:** legacy ContractAction.do?dispatch=input; Network при фокусе contractor/currency/seller.
