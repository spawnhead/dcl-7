# dcl-modern bootstrap

Первичный каркас modern-части проекта создан согласно `docs/DEVELOPMENT_HANDOFF.md`:

- `backend/` — Spring Boot 3.5 + Java 21 + Flyway + OpenAPI + Modulith starter.
- `ui/` — React 19 + Vite + TypeScript + Tailwind bootstrap.
- `ops/docker-compose.yml` в корне репозитория — PostgreSQL 16 на порту 5432.

Дальше реализация идёт поэкранно из `docs/SCREENS_INDEX.md` и spec pack в `docs/screens/<slug>/`.
