# admzone — DB invariants (enforced only)

## Screen-specific enforced invariants
- No direct screen-local DB constraints/triggers/procedures were identified for `/AdmZone.do` itself (it is a static forward screen).

## Related maintenance operation notes
- `/FixAttachments.do` performs data cleanup through application service logic (`AttachmentsService`), not through a dedicated DB procedure declared for Adm Zone in analyzed DDL.
- Therefore, DB-level invariants for this screen are **UNKNOWN / not directly declared** at screen boundary.

## How to verify deeper
1. Trace exact SQL emitted by `AttachmentsService.delete` during `/FixAttachments.do`.
2. Correlate with `DCL_ATTACHMENT` constraints/triggers in DDL for enforced guarantees.

## SQL RE-EVALUATION (Patch 0.5+)
- Source: `db/Lintera_dcl-5_schema.ddl` (SQL priority over UI).

- Relevant table mapping: UNKNOWN (manual mapping required).
- Foreign Keys: UNKNOWN.
- Check Constraints: UNKNOWN.
- Trigger Logic: UNKNOWN.
- Stored Procedures: UNKNOWN.

