# order_edit (slug: `order_edit`) — Legacy Screen Spec

Baseline spec created during loop normalization.

## Existing legacy spec references
- TEST_DATA_SPEC.md; SNAPSHOT.md; ACCEPTANCE.md; CONTRACTS.md; BEHAVIOR_MATRIX.md

## Status
- Detailed migration-ready content requires consolidation from referenced legacy docs and runtime evidence.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: `DCL_ORDER`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

