# admzone — Questions / UNKNOWN

1. UNKNOWN: explicit permission rules for `/PrepareAppToShutdown` and `/FixAttachments.do` in `xml-permissions` (direct action entries were not found in quick scan).
   - How to verify: inspect full permissions resolution path (menu-level + action-level checks).
2. UNKNOWN: exact response page/template and message rendering details for `/FixAttachments.do` result view.
   - How to verify: run in legacy and capture HAR + resulting HTML.
3. UNKNOWN: exact DB constraints/triggers on attachment tables that govern cleanup guarantees.
   - How to verify: inspect `DCL_ATTACHMENT` section in DDL + execute minimal repro SQL.
