# Deployment Guide (local)

**Tech stack:** см. `docs/TECH_STACK.md` (источник истины).

## Prerequisites (facts from 2026-02-09 dev run)

- **JDK 21** (not JRE). Backend requires Java 21; system may have Java 8 in PATH. Set before Maven:
  ```bash
  export JAVA_HOME="/c/Program Files/Eclipse Adoptium/jdk-21.0.6.7-hotspot"   # Git Bash; adjust path for your JDK 21
  ```
- **Docker Desktop** must be **running** for:
  - `docker compose` (Postgres)
  - Integration tests (Testcontainers). If Docker is not available, the Country integration test is **skipped** and the build still passes.
- **Node.js** and **npm** for UI (checked: v22, npm 11).

## Steps

1. Start Postgres (Docker Desktop must be running):
   ```bash
   docker compose -f ops/docker-compose.yml up -d
   ```
2. Run Flyway + tests (with JAVA_HOME=JDK 21):
   ```bash
   cd modern/backend
   export JAVA_HOME="/c/Program Files/Eclipse Adoptium/jdk-21.0.6.7-hotspot"   # adjust path
   ./mvnw test
   ```
3. Start the backend (keep JAVA_HOME set). Для Development Dashboard и dev-bypass авторизации включите профиль **dev**:
   ```bash
   cd modern/backend
   ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
   ```
   Без `-Dspring-boot.run.profiles=dev` эндпоинты `/api/dev/status` и `/api/me` недоступны.
4. Verify OpenAPI:
   ```bash
   curl http://localhost:8080/v3/api-docs
   ```
5. (Optional) Swagger UI:
   ```bash
   open http://localhost:8080/swagger-ui.html
   ```
6. Start the UI (after backend is up for `generate:api`):
   ```bash
   cd modern/ui
   npm install
   npm run generate:api
   npm run dev
   ```
   UI runs on http://localhost:5173/ (or next free port if 5173 in use). In dev, Vite proxies `/api`, `/v3`, `/swagger-ui` to the backend (http://localhost:8080), so the same origin works and countries load in the grid.

## Dev profile and Development Dashboard

- **Включение:** `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev`
- **Эндпоинты (только при активном профиле dev):**
  - `GET /api/dev/status` — статус (profile, javaVersion, serverTime, db, flyway, dataMode, authMode). Контракт: docs/dev/DEV_DASHBOARD_SPEC.md.
  - `GET /api/me` — текущий пользователь (id, name, roles, department, chiefDepartment, authMode). Контракт: docs/security/DEV_BYPASS.md.
- **Заголовки dev-bypass (только в профиле dev):**
  - `X-Dev-User` — логин (по умолчанию `dev`)
  - `X-Dev-Roles` — роли через запятую (по умолчанию `admin`)
  - `X-Dev-Department-Id`, `X-Dev-Department-Name`, `X-Dev-Chief-Department` (0|1) — опционально для Margin-сценариев
- **dataMode** (в ответе `/api/dev/status`), источник истины: docs/db/SEED_DATA_PLAN.md:
  - `FAKE_SEEDED` — в таблице `dcl_setting` есть запись `STN_NAME='DEV_SEED_VERSION'` и `STN_VALUE` начинается с `margin-`
  - `REAL` — маркера нет, но есть доменные данные
  - `EMPTY` — маркера нет и ключевые таблицы пусты
- **authMode:** `DEV_BYPASS` в профиле dev; при старте с dev в логе: `DEV_BYPASS_ENABLED=true`.
- Страница **Development**: http://localhost:5173/dev (меню «Development»). Блоки по DEV_DASHBOARD_SPEC, кнопка «Повторить».

## Config changes made during dev run

- **ops/docker-compose.yml**: Removed obsolete `version: "3.8"` to avoid Docker Compose warning.
- **modern/backend** (CountryIntegrationTest): Added `@Testcontainers(disabledWithoutDocker = true)` so integration test is skipped when Docker is unavailable; build passes either way.
- **modern/backend** (2026-02-09 E2E): Added `flyway-database-postgresql` dependency for Flyway + PostgreSQL 16. Flyway migrations V3/V4 create Modulith tables `event_publication` and `event_publication_archive`. Currency entity: `cur_no_round`/`cur_sort_order` mapped as `Short` (DB SMALLINT).
- **modern/ui**: `scripts/generate-api.sh` uses `npx openapi-typescript` so the script works when run directly; otherwise use `npm run generate:api`.