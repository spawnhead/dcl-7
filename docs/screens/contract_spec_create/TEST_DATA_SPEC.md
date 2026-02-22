# N3a2 Contract specification create — Test data spec

## Preconditions
- Contract draft/session exists and contains currency/seller context.
- Delivery terms dictionary contains at least one item.
- Users lookup contains at least one selectable user.
- Contract attachment service has at least one file for copy-attach scenario.

## Datasets
1. **Happy path**: valid required fields, one payment row.
2. **Validation set**: empty required fields, over-limit text fields, invalid dates.
3. **Business occupied set**: occupied spec with mocked payed/shipped totals greater than sum.
4. **Payments dynamics**: multiple rows with percent/sum/date combinations.
5. **Complaint set**: all complaint dates + long comment near limit.
6. **Attachment set**: copy attachment + uploaded attachment + delete case.

## Expected
- Deterministic pass/fail per acceptance matrix.
- Contract grid reflects inserted specification after save.
