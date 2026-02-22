# admzone — Expected API contracts (legacy-inferred)

- **GET/POST** `/AdmZone.do`
  - Purpose: render admin maintenance page.

- **GET/POST** `/PrepareAppToShutdown`
  - Purpose: put application in shutdown-preparation mode.
  - Side effects: disable login (`App.loginDisabled=true`), broadcast close-window session message to logged users.
  - Response: forward back to `/AdmZone.do`.

- **GET/POST** `/FixAttachments.do`
  - Purpose: run attachment consistency maintenance.
  - Side effects: delete broken attachment rows, move orphan files to `lost_in_base`, return report in request attribute `message`.

Error semantics:
- Runtime failures use generic legacy error mechanism (exact payload/text UNKNOWN).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

