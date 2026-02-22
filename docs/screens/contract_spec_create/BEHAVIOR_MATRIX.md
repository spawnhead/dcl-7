# N3a2 Contract specification create — Behavior matrix

| Scenario | Trigger | Expected behavior | Legacy trace |
|---|---|---|---|
| Open create | Contract -> Add specification | 2 tabs loaded, defaults applied, 1 payment row | SpecificationAction.insert/input |
| Save valid | beforeSave/process | validation pass -> insert into contract session list -> return back | beforeSave + process |
| Missing user on non-executed | save with empty user and `spc_executed` empty | business error `error.specification.empty_user` | beforeSave |
| Occupied sum guard | occupied spec with low `spc_summ` | errors for payed/shipped comparisons | beforeSave + SpecificationDAO loaders |
| Add payment row | ajaxAddToPaymentGrid | row appended, payments description recalculated | ajaxAddToPaymentGrid |
| Remove payment row | ajaxRemoveFromPaymentGrid | row removed; when one left -> 100% and full sum | ajaxRemoveFromPaymentGrid |
| Recalculate payments | ajaxRecalculatePaymentGrid | descriptions updated, grid rerender | ajaxRecalculatePaymentGrid |
| Reload NDS by date | change spc_date | ndsRate updated | ajaxReloadDate |
| Reload reminder | change percent/sum/date/term | reminder text updated | ajaxReloadReminder |
| Calculate delivery date | additional days changed | calculated date response | ajaxCalculateDeliveryDate |
| Attach copy | deferredAttachCopy | selected contract attachment appears in spec attachments grid | deferredAttachCopy |
| Attach file | deferredAttach | forwards to multi-attach flow (with mandatory checks) | deferredAttach |
| Delete/download attachment | deleteAttachment/downloadAttachment | attachment removed or downloaded | corresponding dispatch |
| Cancel | back | rollback deferred attachment service; return to contract | back |
