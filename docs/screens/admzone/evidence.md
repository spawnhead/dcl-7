# admzone — Evidence

## Happy path A (shutdown prep)
1. Open `/AdmZone.do`.
2. Click `adm_zone.start-shutdown-button`.
3. Expected:
   - application sets shutdown mode (`loginDisabled=true`),
   - active users receive close-window session message,
   - admin is forwarded back to AdmZone.

## Happy path B (fix attachments)
1. Open `/AdmZone.do`.
2. Confirm and run `adm_zone.fix-attachments`.
3. Expected:
   - maintenance report appears in `request.message`,
   - inconsistent attachment records/files are cleaned/moved per action logic.

## Negative case
1. Run FixAttachments when filesystem path is inaccessible or DB issues occur.
2. Expected: operation fails through legacy error flow; exact message/payload UNKNOWN.

## Actual status in this cycle
- Static proof based on JSP + Struts mappings + action implementations.
- Runtime verification (HAR/logs with real side effects) pending.
