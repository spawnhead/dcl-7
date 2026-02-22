# Order create/edit (legacy `/OrderAction.do`) — ACCEPTANCE

## Presence parity (strict)
- [ ] All legacy sections from `Order.jsp` are present: header/meta, party block, in-one-spec block, financial toggles, produces grid/actions, signatures, logistics, attachments, payments, pay sums, covering letter, print params, footer actions.
- [ ] All listed dispatch buttons/links exist and map to the same legacy dispatch names.
- [ ] Produces grid supports legacy conditional columns (`ord_donot_calculate_netto`, `ord_count_itog_flag`, `ord_all_include_in_spec`, `ord_in_one_spec`).
- [ ] Attachments/payments/pay sums fragments are loaded through corresponding AJAX dispatches.

## Behavior parity
- [ ] Create (`input`) applies exact defaults from action.
- [ ] Edit (`edit`) loads all server data and role flags.
- [ ] Clone (`clone`) clears identity/logistics fields exactly as in action.
- [ ] Save uses `ajaxCheckSave` pre-check + `process` dispatch.
- [ ] Readonly/disabled state follows role flags from `show()` and JSP/JS logic.
- [ ] Date/logistics validation dependencies and warnings match action logic.

## BLOCKED_FIELD criteria
For each external dependency field/flow, parity is acceptable only if:
- [ ] Field/control is present in UI.
- [ ] Field is correctly disabled/readonly when dependency screen is unavailable.
- [ ] Documentation includes:
  - `BLOCKED_FIELD` name,
  - `dependsOnScreen`,
  - `How to verify in legacy` steps.

## Required BLOCKED_FIELD set for this screen
- [ ] contractor add flow.
- [ ] contact person add flow.
- [ ] contractor_for add flow.
- [ ] CP import flow.
- [ ] Excel import flow.
- [ ] produce add/edit/clone dialog flow.
- [ ] executed-by-date dialog flow.
- [ ] produce movement flow.
