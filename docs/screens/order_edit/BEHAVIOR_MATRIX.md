# Order create/edit (legacy `/OrderAction.do`) — BEHAVIOR_MATRIX

| Topic | Legacy behavior |
|---|---|
| Create defaults | `input` pre-fills date, roles from config/current user, default flags (`ord_donot_calculate_netto=1`, `ord_in_one_spec=1`), default currency, one payment row (100%), one pay-sum row (0). |
| Edit mode | `edit` loads order by `ord_id`, loads produces/payments/paySums/executed info, initializes deferred attachments service for existing doc id. |
| Clone mode | `clone` loads source, clears identity/date-state fields (`ord_id`, `ord_number`, many logistics fields, block/annul), keeps copied content and signatures defaults, then shows as new doc. |
| Form read-only | `formReadOnly=true` if blocked or only-user-in-Lithuania; otherwise false for unblocked docs/new docs. |
| roleFlags | `readOnlyIfNotLikeManager`, `readOnlyIfNotLikeLogist`, `readOnlyIfNotLikeLogistOrManager`, `readOnlyIfNotLikeLogistOrUIL`, `readOnlySentToProdDate`, `readOnlyForExecuted`, `readOnlyForCoveringLetter`, `readOnlySave` derived in `show()`. |
| Produces row buttons | Clone/edit/delete have independent readonly checkers (`cloneReadonly`, `editReadonly`, `deleteReadonly`), including blocked doc, manager role, executed count, occupied flag. |
| changeViewNumber | Checkbox in grid row posts `dispatch=changeViewNumber` and recalculates sequence links (`sameNumberAsPrevious`). |
| Logistics dependencies | `ord_date_conf_all` and `ord_ready_for_deliv_date_all` toggle availability/requirements for downstream dates/shipping fields both in JSP and save validations. |
| Save flow | Save button JS: `ajaxCheckSave` first, then `process`; on success returns to list (`forward back`), else rerenders `show`. |
| Print flow | `print` / `printLetter` call common save for new docs, persist scale, then set print flags; JSP auto-inserts hidden iframe to print actions. |
| Attachments | `deferredAttach` stores deferred service in session; `deleteAttachment` mutates deferred list; `downloadAttachment` streams binary. |
| Payments/pay sums | AJAX add/remove/recalc mutate in-memory lists and rerender fragments; when only one row remains, percent/sum auto-adjusts to 100 / total sum. |
| Create vs edit | Create starts blank/new with generated defaults; edit/clone depend on loaded DB order + role gates from current user and block state. |
