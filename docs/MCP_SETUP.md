# MCP Setup for DCL Modern

> TASK-0045: Cursor MCP integration for Postgres, Docker, Playwright, GitHub.
> Rule: no secrets in git. Use env vars locally.

## 1. Environment variables (local only)

Create `.env` in project root (gitignored) or set in shell. **Never commit values.**

```bash
# Postgres (matches ops/docker-compose.yml)
export DCL_PG_HOST=localhost
export DCL_PG_PORT=5432
export DCL_PG_DB=dcl
export DCL_PG_USER=dcl
export DCL_PG_PASSWORD=dcl

# GitHub (optional, for GitHub MCP write)
# export GITHUB_TOKEN=<your-personal-access-token>
```

## 2. Cursor MCP configuration

Config location: **Cursor Settings → Features → MCP** (or `~/.cursor/mcp.json` / project `.cursor/mcp.json` depending on Cursor version).

### 2.1 Postgres MCP

- **Source:** https://github.com/modelcontextprotocol/servers (postgres)
- **Install:** `npx -y @modelcontextprotocol/server-postgres`
- **Config (stdio):**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://dcl:dcl@localhost:5432/dcl"],
      "env": {}
    }
  }
}
```
- **Read-only:** default. Use for SELECT, schema inspection after save/ migrate.

### 2.2 Docker MCP

- **Source:** https://github.com/ckreiling/mcp-server-docker
- **Install:** `npx -y @modelcontextprotocol/server-docker` (or per repo)
- **Use:** compose up/down, container logs, status.

### 2.3 Playwright MCP

- **Source:** https://github.com/executeautomation/mcp-playwright
- **Install:** per repo instructions
- **Use:** smoke-check URLs after UI/API changes; Console 0 errors.

### 2.4 GitHub MCP

- **Source:** https://github.com/github/github-mcp-server
- **Install:** requires `GITHUB_TOKEN` env
- **Default:** read-only.

### 2.5 Chrome DevTools MCP

- **Source:** https://github.com/ChromeDevTools/chrome-devtools-mcp
- **Install:** `npx chrome-devtools-mcp@latest` (автоматически при первом вызове)
- **Config (stdio):**
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    }
  }
}
```
- **Requirements:** Node.js 20+, Chrome (stable), npm. Browser запускается автоматически при первом использовании tool.
- **Tools:** `navigate_page`, `list_console_messages`, `list_network_requests`, `get_network_request`, `take_screenshot`, `take_snapshot`, `click`, `fill`, `fill_form`, `wait_for`, `performance_start_trace`, `performance_stop_trace`.
- **Use:** Console 0 errors, Network 2xx, smoke-check после UI/API изменений. Вместо ручного DevTools или Playwright MCP.
- **Cursor:** Settings → MCP → New MCP Server → вставить config выше.

**Опции (опционально):**
- `--headless=true` — без UI
- `--isolated=true` — временный user-data-dir (очищается после закрытия)
- `--channel=canary` — dev/canary Chrome

## 3. Smoke-check URLs (fixed ports)

| URL | Purpose |
|-----|---------|
| http://localhost:5173/contracts | Contracts list |
| http://localhost:5173/contractors | Contractors list |
| http://localhost:5173/contractors/new?returnTo=contract | Contractor create |
| http://localhost:5173/contracts/new | Contract create |

## 4. Verification commands (bash)

```bash
# 1. Postgres
docker compose -f ops/docker-compose.yml up -d
psql -h localhost -U dcl -d dcl -c "SELECT count(*) FROM dcl_contract;"
psql -h localhost -U dcl -d dcl -c "SELECT count(*) FROM dcl_contractor;"

# 2. Docker
docker compose -f ops/docker-compose.yml ps

# 3. Backend + UI
cd modern/backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
cd modern/ui && npm run dev -- --host --port 5173
```

## 5. MCP Command Cookbook (DCL)

Готовые сценарии для проверки после изменений. Порты: UI 5173, Backend 8080, Postgres 5432.

### 5.1 Postgres MCP

**Tool:** `query` (input: `sql` string). Read-only.

| Сценарий | SQL | PASS | FAIL |
|----------|-----|------|------|
| N3a contract_create — After Save | `SELECT con_id, con_number, con_date FROM dcl_contract ORDER BY con_id DESC LIMIT 5` | Новый договор в результате | Contract not found |
| N3a1 contractor_create — After Save | `SELECT ctr_id, ctr_name, ctr_unp FROM dcl_contractor ORDER BY ctr_id DESC LIMIT 5` | Новый контрагент в результате | Contractor not found |
| /contractors list — Count match | `SELECT count(*) FROM dcl_contractor` | Count = UI grid row count | Mismatch |
| Flyway history check | `SELECT installed_rank, version, description FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5` | Ожидаемые миграции присутствуют | Missing migration |

**MCP Evidence:** `SELECT count(*) FROM dcl_contract` → N

### 5.2 Docker MCP (ckreiling/mcp-server-docker)

**Tools:** `list_containers`, `fetch_container_logs`, `start_container`, `stop_container`, `remove_container`.

Compose (bash-only): `docker compose -f ops/docker-compose.yml up -d` / `down`.

| Сценарий | MCP / bash | PASS | FAIL |
|----------|------------|------|------|
| Stack health | `list_containers` или `docker compose -f ops/docker-compose.yml ps` | postgres Up, 0.0.0.0:5432->5432 | Container down |
| Postgres logs | `fetch_container_logs` (container name) | Без FATAL/ERROR | FATAL/ERROR |
| Restart only DB | `stop_container` + `start_container` или `docker compose -f ops/docker-compose.yml restart postgres` | postgres Up | Failed |

**MCP Evidence:** postgres Up, 0.0.0.0:5432->5432

### 5.3 Playwright MCP (@executeautomation/playwright-mcp-server)

**Tools:** `Playwright_navigate`, `Playwright_console_logs` (type: error), `playwright_get_visible_text`, `Playwright_screenshot`.

| Сценарий | URL | PASS | FAIL |
|----------|-----|------|------|
| Smoke-check /contracts | http://localhost:5173/contracts | Заголовок + грид, Console 0 errors | Blank/errors |
| Smoke-check /contractors | http://localhost:5173/contractors | Список контрагентов, Console 0 | Blank/errors |
| Smoke-check /contractors/new | http://localhost:5173/contractors/new?returnTo=contract | Форма «Создание контрагента», Console 0 | Blank/errors |
| Smoke-check /contracts/new | http://localhost:5173/contracts/new | Форма «Создание договора», Console 0 | Blank/errors |

**Console check:** `Playwright_console_logs` с `type: error`. Если MCP не поддерживает — fallback: ручной DevTools Preserve log.

**MCP Evidence:** /contracts, /contractors/new → PASS (Console 0)

### 5.4 GitHub MCP

**Tools:** `get_file_contents`, `search_code`, `list_pull_requests`, `get_pull_request`. Default read-only.

| Сценарий | Действие | PASS | FAIL |
|----------|----------|------|------|
| Verify diff contains TASK-ID | `get_pull_request` + проверка diff/description | TASK-XXXX в commit/diff | Not found |
| Find PR by branch | `list_pull_requests` (branch filter) | PR найден | Not found |
| Attach log link (text) | В комментарий PR или описание: `logs/dev-xxx-YYYYMMDD-HHMM.md` | Ссылка добавлена | N/A |

**MCP Evidence:** branch X, commit Y, TASK-0047 in message

### 5.5 Chrome DevTools MCP (chrome-devtools-mcp)

**Tools:** `navigate_page`, `list_console_messages`, `list_network_requests`, `get_network_request`, `take_snapshot`, `take_screenshot`.

| Сценарий | URL | MCP действия | PASS | FAIL |
|----------|-----|--------------|------|------|
| /contracts | http://localhost:5173/contracts | navigate_page → list_console_messages (types: error) → list_network_requests (resourceTypes: xhr,fetch) | Console 0 errors, /api/* 2xx | Errors / 4xx/5xx |
| /contractors | http://localhost:5173/contractors | navigate_page → list_console_messages (types: error) → list_network_requests | Console 0, /api/* 2xx | Errors / 4xx/5xx |
| /contracts/new | http://localhost:5173/contracts/new | navigate_page → list_console_messages (types: error) → list_network_requests | Console 0, open 200 | Errors / 404 |
| /contractors/new | http://localhost:5173/contractors/new?returnTo=contractors | navigate_page → list_console_messages (types: error) → list_network_requests | Console 0, open 200 | Errors / 404 |

> Примечание: 3-й и 4-й сценарии — разные URL: /contracts/new (договор) и /contractors/new (контрагент).

**Порядок проверки:**
1. `navigate_page` (type: url, url: выше)
2. `list_console_messages` (types: ["error"]) — ожидать 0 сообщений
3. `list_network_requests` (resourceTypes: ["xhr","fetch"]) — проверить /api/* — status 2xx

**MCP Evidence:** ChromeDevTools: /contracts, /contractors/new → Console 0, Network 2xx

### 5.5.1 UI / Layout tasks (Figma integration)

Для задач внедрения макета (Figma → экран) или layout-рефакторинга обязателен чеклист из правила **.cursor/rules/082-figma-integration.mdc**:

1. **Verify route target** — роут ведёт в нужный компонент (path → element в App.tsx).
2. **Delete old layout, no leftovers** — старый layout удалён, нет дублей страниц.
3. **Build pass** — `npm run build` (modern/ui) без ошибок.
4. **Chrome DevTools MCP evidence** — navigate_page на URL → list_console_messages (error) → 0; list_network_requests → API 2xx.

В отчёте задачи (AGENT_TASK_REPORTS) для таких тасков указывать выполнение чеклиста и минимум один пункт MCP Evidence (Chrome DevTools). Текстовые замены — только bash (не PowerShell), см. правило 010-bash-only.mdc.

### 5.6 Minimum MCP Evidence per task

| MCP | Минимум | Пример |
|-----|---------|--------|
| Postgres | 1 SELECT | `SELECT count(*) FROM dcl_contract` → N |
| Playwright | 1 smoke run | /contracts → PASS (Console 0) |
| ChromeDevTools | 1 smoke run | /contracts, /contractors/new → Console 0, Network 2xx |
| Docker | Container status | postgres Up |
| GitHub | Diff/commit ref | branch main, TASK-0047 in commit |

### 5.7 Copy-paste MCP Evidence block (for report)

```markdown
### MCP Evidence
- **Postgres:** `SELECT count(*) FROM dcl_contract` → 14
- **Playwright:** /contracts, /contractors/new → PASS (Console 0)
- **ChromeDevTools:** /contracts, /contractors/new → Console 0, Network /api/* 2xx
- **Docker:** postgres Up, 0.0.0.0:5432->5432
- **GitHub:** branch main, commit abc123 def (TASK-0047)
```

---

## 6. References

- Chrome DevTools MCP: https://github.com/ChromeDevTools/chrome-devtools-mcp
- Postgres MCP: https://cursor.directory/mcp/postgresql
- Docker MCP: https://cursor.directory/mcp/docker
- Playwright MCP: https://cursor.directory/mcp/playwright
- GitHub MCP: https://github.com/github/github-mcp-server
- Cursor Rule: `.cursor/rules/090-mcp-usage.mdc`
