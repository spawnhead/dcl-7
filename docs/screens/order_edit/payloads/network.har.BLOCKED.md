# Order edit — network.har.BLOCKED

Status: **BLOCKED (HAR not attached in repo yet)**.

Legacy host is available: `http://localhost:8082`.
This file defines exact capture checklist required to freeze wire-level parity.

## Capture setup
1. Open `http://localhost:8082` and login with role that can edit/save orders.
2. DevTools → Network → Preserve log + Disable cache.
3. Clear network log before each scenario.
4. Save HAR with content after each scenario.

## Mandatory scenarios
1. Open create form: `GET/POST /OrderAction.do?dispatch=input`.
2. Open edit form: `POST /OrderAction.do?dispatch=edit` (`ord_id=<existing>`).
3. Save flow: `POST /OrderAction.do?dispatch=ajaxCheckSave` then `POST /OrderAction.do?dispatch=process`.
4. Produce operations from main page:
   - `newProduce`, `editProduce`, `cloneProduce`, `deleteProduce`, `changeViewNumber`.
5. External flows dispatches:
   - `selectCP` + return `returnFromSelectCP`,
   - `importExcel`,
   - `produceMovement` + `fromProduceMovement`,
   - `newContractor`/`newContactPerson`/`newContractorFor` + returns.
6. Attachment operations:
   - `deferredAttach`, `deleteAttachment`, `downloadAttachment`.
7. AJAX grids:
   - payments: `ajaxOrderPaymentsGrid`, `ajaxAddToPaymentGrid`, `ajaxRemoveFromPaymentGrid`, `ajaxRecalculatePaymentGrid`.
   - pay sums: `ajaxOrderPaySumsGrid`, `ajaxAddToPaySumGrid`, `ajaxRemoveFromPaySumsGrid`, `ajaxRecalcPaySumGrid`.
8. CP/spec probes:
   - `ajaxIsContractCopy` (`contract-id`),
   - `ajaxIsSpecificationCopy` (`specification-id`).

## What must be extracted from HAR
- Method, URL, query, status code.
- Request content-type and payload field names (including nested names like `contractor.id`).
- Response content-type and fragment/full-page shape.
- Redirect chain (if any) for external flows.

## Output placement
- Save raw HAR under `docs/screens/order_edit/payloads/`.
- Add per-scenario distilled request/response markdown/json files.
