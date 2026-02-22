# N3a2 Contract specification create — Contracts (Dev-ready)

> Legacy actions: `insert`, `beforeSave`, `process`, `back`, attachment and ajax dispatches.

## 1) Open
### GET `/api/contracts/draft/specifications/new/open`
Must return:
- two-tab layout metadata (`mainPanel`, `complaintSpecification`),
- full form defaults,
- lookups (`users`, `deliveryTerms`, maybe contract attachments for copy list),
- one default payment row `{percent:100, sum:0, currencyName}`,
- role flags/readOnly flags.

## 2) Save
### POST `/api/contracts/draft/specifications/save`
- Content-Type UTF-8 JSON.
- Equivalent to legacy `beforeSave` + `process`.

Validation parity:
- `spcNumber` required, max 50.
- `spcDate` required + valid date.
- `spcSumm` required currency.
- `deliveryTerm.id` required.
- `spcDeliveryCond`, `spcAddPayCond`, `spcComment` max 5000.
- `spcAdditionalDaysCount` max 3 + integer.
- `spcLetter1Date/2Date/3Date`, `spcComplaintInCourtDate`, `spcAnnulDate` valid dates.
- Business validations from `beforeSave`:
  - if occupied: `spcSumm >= payedSumm` and `spcSumm >= shippedSumm`.
  - if not executed: `user.usrId` required.

Success:
```json
{ "success": true, "redirectTo": "/contracts/new" }
```

## 3) Cancel/back
### POST/GET `/api/contracts/draft/specifications/cancel` (or client route back)
- Must rollback deferred attachment context and return to contract screen.

## 4) Additional parity endpoints (if exposed by modern API)
Legacy dispatches that must be represented or internally emulated:
- `ajaxSpecificationPaymentsGrid`
- `ajaxAddToPaymentGrid`
- `ajaxRemoveFromPaymentGrid`
- `ajaxRecalculatePaymentGrid`
- `ajaxReloadPrices`
- `ajaxReloadDate`
- `ajaxReloadReminder`
- `ajaxCalculateDeliveryDate`
- `deferredAttach`
- `deferredAttachCopy`
- `deleteAttachment`
- `downloadAttachment`

If modern UI does calculations client-side, output/result behavior must remain 1:1 (same guardrails and errors).

## 5) UNCONFIRMED / BLOCKED
- Exact legacy wire payloads for ajax + attachments remain UNCONFIRMED.
- HAR instructions in `payloads/network.har.BLOCKED.md`.
