-- Baseline bootstrap migration for clean-room startup.
-- Full schema migrations must be derived from docs/db/Lintera_dcl-5_schema.ddl.
CREATE TABLE IF NOT EXISTS app_bootstrap_marker (
  id BIGSERIAL PRIMARY KEY,
  marker_key VARCHAR(64) NOT NULL UNIQUE,
  marker_value VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO app_bootstrap_marker(marker_key, marker_value)
VALUES ('initialized', 'true')
ON CONFLICT (marker_key) DO NOTHING;
