# AGENTS.md — Guidelines for Codex and AI Coding Agents

This repository is a **brownfield clean-room rewrite** of a legacy Java ERM system. The goal is to migrate to a modern stack (Spring Boot + React) with **1:1 behavioral parity** to legacy. All instructions for building the application are in **`docs/DEVELOPMENT_HANDOFF.md`** — read it first.

Format: [agents.md](https://github.com/agentsmd/agents.md) — a simple, open format for guiding coding agents.

---

## 1. Start Here (Mandatory)

- **Read `CONTINUITY.md`** at the start of every step. Update Done/Now/Next at the end.
- **Read `docs/DEVELOPMENT_HANDOFF.md`** — main PRD, phases, checklist, Definition of Done.
- **Sources of truth:** `db/Lintera_dcl-5_schema.ddl` (DB schema), `docs/TECH_STACK.md` (stack), `src/` (legacy, read-only).

---

## 2. Dev Environment Tips

- **Bash only** — no PowerShell. All commands in bash (Git Bash/WSL/Linux).
- **JDK 21** required for backend. Set before Maven:
  ```bash
  export JAVA_HOME="/c/Program Files/Eclipse Adoptium/jdk-21.0.6.7-hotspot"  # Windows; adjust path
  ```
- **Docker** must be running for Postgres and Testcontainers.
- **Fixed ports:** UI 5173, Backend 8080, Postgres 5432. Do not change silently.

---

## 3. Useful Commands

| Command | Purpose |
|---------|---------|
| `docker compose -f ops/docker-compose.yml up -d` | Start Postgres |
| `cd modern/backend && ./mvnw test` | Run backend tests |
| `cd modern/backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev` | Start backend (dev profile) |
| `cd modern/ui && npm install && npm run generate:api && npm run dev` | Start UI (backend must be up first for generate:api) |
| `curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/v3/api-docs` | Verify backend (expect 200) |
| `curl -s -o /dev/null -w "%{http_code}" http://localhost:5173/` | Verify UI (expect 200) |

**Full procedure:** see `docs/DEPLOYMENT_GUIDE.md`.

---

## 4. Testing Instructions

- **Backend:** `cd modern/backend && ./mvnw test`. Integration tests use Testcontainers (Docker required).
- **UI:** `cd modern/ui && npm run build` — must pass.
- **Smoke-check:** After UI/API changes — open page in browser, Console 0 errors, Network 2xx. Log in `logs/dev-browser-check-*.log`.
- **Parity:** Results (calculations, statuses, validations) must match legacy. See `docs/screens/<slug>/ACCEPTANCE.md` (Parity MUST).

---

## 5. Per-Screen Workflow (from DEVELOPMENT_HANDOFF)

1. Pick screen from `docs/SCREENS_INDEX.md` (ready).
2. Read spec pack: `docs/screens/<slug>/` — SNAPSHOT, CONTRACTS, ACCEPTANCE, BEHAVIOR_MATRIX.
3. Implement: backend module (api/application/domain/infrastructure) → Flyway migration → REST + OpenAPI → UI route (shadcn/ui + Tailwind).
4. Add traceability comment in code (Action → JSP → DAO).
5. Run tests, smoke-check, report in `docs/AGENT_TASK_REPORTS.md`.

---

## 6. Definition of Done (Feature)

1. Trace to legacy in docs (Evidence).
2. Flyway migration or justified decision.
3. Backend endpoint + OpenAPI.
4. UI screen.
5. Tests covering business rules.
6. Parity: calculations/statuses match legacy.

---

## 7. Forbidden

- Modify legacy in `src/` without necessity.
- Invent DB schema without reading DDL.
- Implement without Evidence (path to legacy source).
- Direct calls to domain/application of another module.
- Mark Done without smoke-check and report.

---

## 8. Key Documents

| Document | Purpose |
|----------|---------|
| `docs/DEVELOPMENT_HANDOFF.md` | **Main PRD** — phases, flows, checklist, rules |
| `docs/TECH_STACK.md` | Source of truth for stack |
| `docs/PRD_MVP_Module1.md` | КП, справочники, договоры — flows, entities, formulas |
| `docs/FEATURE_INVENTORY.md` | Traceability map (feature → Action → JSP → DAO) |
| `docs/screens/<slug>/CONTRACTS.md` | API contracts, Traceability |
| `CONTINUITY.md` | Goal, constraints, Done/Now/Next |

---

When in doubt, restart the dev server and re-read `docs/DEVELOPMENT_HANDOFF.md`.
