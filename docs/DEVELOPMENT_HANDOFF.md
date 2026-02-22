# Development Handoff — PRD и техническая документация для разработки

> **Назначение:** Единый документ передачи проекта на разработку. Соответствует принципам **brownfield clean-room rewrite ERP**: legacy Java — source of truth для бизнес-логики; новый код — на современном стеке с новым UI. Документ объединяет PRD-структуру и технические инструкции.

**Дата:** 2026-02-22  
**Версия:** 2.0

---

## Часть I. Принципы проектирования

### Контекст
- **Brownfield clean-room rewrite ERP:** legacy Java (исходники, SQL, миграции, триггеры) — основной источник фактов о бизнес-правилах.
- **Новый код:** пишем на новом стеке и с новым UI. Код не копируем, а **формализуем правила и воспроизводим поведение**.
- **Frontend:** dashboard shell на **shadcn/ui + Tailwind CSS**, SPA на **Vite** (SEO не важно, приложение за логином).

### Обязательные правила при проектировании
1. **Опираться на документацию в `docs/`:**
   - `docs/PRD_MVP_Module1.md` — КП, справочники, договоры (flows, entities, формулы, валидации);
   - `docs/FEATURE_INVENTORY.md` — traceability map (feature → Action → JSP → DAO);
   - `docs/DOMAIN_ANALYSIS.md` — bounded contexts, агрегаты;
   - `docs/DB_SCHEMA_SUMMARY.md` — таблицы, PK/FK, индексы;
   - `docs/screens/<slug>/` — SNAPSHOT, CONTRACTS, ACCEPTANCE, BEHAVIOR_MATRIX.
   Не придумывать сущности, поля, статусы, расчёты — брать из этих документов.

2. **Traceability (Evidence):** в `CONTRACTS.md` указывать источник (Action/JSP/DAO) в начале и в секциях; в `PRD_MVP_Module1.md` — блоки «Источники», «Доказательства». Файл `evidence.md` в spec pack — для дополнительных ссылок на legacy (путь к файлу/классу/методу/SQL).

3. **Неоднозначности:** фиксировать в `docs/screens/<slug>/questions.md` (UNKNOWN, UNCONFIRMED). При блокирующих вопросах — в `CONTINUITY.md` (Open questions). В `CONTRACTS.md` добавлять «How to verify» для неясных моментов.

4. **Критерий качества:** в `ACCEPTANCE.md` — секция «Parity MUST» (FAIL если не выполнено); в PRD — Acceptance Criteria (Given/When/Then). Документ должен позволять разработку без угадывания; явно разделять подтверждённое legacy и требующее уточнения (questions.md, UNCONFIRMED).

---

## Часть II. PRD-структура (Product Requirements Document)

### 1. Цель / Проблема и ценность для бизнеса

**Проблема:** Legacy ERM-система (Java Struts 1.2 / JSP / Firebird) содержит критичную бизнес-логику в Actions/DAO/SQL/триггерах. Для миграции на современный стек необходимо формализовать правила и обеспечить **поведенческий паритет 1:1**.

**Ценность:**
- Уменьшение ошибок в расчётах (скидка, НДС, округление, логистика).
- Ускорение цикла продаж (КП → Договор).
- Прозрачные статусы и role-based поведение, эквивалентные legacy.

**Evidence:** `docs/PRD_MVP_Module1.md`, `docs/FEATURE_INVENTORY.md`, `src/main/webapp/WEB-INF/classes/resources/struts/struts-config.xml`.

---

### 2. Персоны (кто пользуется, роли)

| Персона | Роль | Основные экраны | Legacy source |
|---------|------|-----------------|---------------|
| Экономист | Расчёт/проверка КП, checkPrice, блокировка | КП, договоры, отчёты | `xml-permissions.xml`, `CommercialProposalsAction.internalFilter()` |
| Менеджер | Создание КП, конвертация в договор | КП, договоры, контрагенты | `ContractAction.show()`, `CommercialProposalsAction` |
| Юрист | Контроль условий, аннулирование | Договоры, условия | `xml-permissions.xml` |
| Администратор | Полный доступ, блокировки, справочники | Все экраны | `xml-permissions.xml` |
| Логист | Поставки, отгрузки | Заказы, поставки | `OrdersAction`, `ShippingsAction` |

**Evidence:** `xml-permissions.xml`, `ContractAction.show()`, `CommercialProposalsAction.internalFilter()`.

---

### 3. Scope / Out-of-scope

**В scope текущей итерации:**
- Auth, справочники (countries, currencies, units, sellers, departments, languages, purposes, stuffcategories).
- Контрагенты (list, create, edit, contact persons).
- Договоры (list, create, import from CP, spec, attachments, conditions).
- КП (list, create/edit, produce, transport).
- Заказы (list, create/edit, produce, payments).
- Отчёт «Маржа».

**Out-of-scope (явно не делаем в текущей итерации):**
- Полная миграция 170 экранов — поэтапно по фазам.
- Production deployment — только dev/stage.
- Интеграции с внешними системами (1C и др.) — отдельный контур.

---

### 4. User flows (шаги бизнес-процессов)

#### Flow A — Создание КП
1. Пользователь открывает форму создания КП (`input`).
2. Заполняет шапку: контрагент, валюта, курс, НДС, Incoterm, сроки.
3. Добавляет строки и логистику.
4. Система пересчитывает строки (`calculateInString`) и итоги (`calculate`).
5. При Save — валидации (date_accept при proposal_received, курс при равных/разных валютах, резервы Минск-склад).
6. При успехе — генерация номера, сохранение шапки/строк/логистики.

**Evidence:** `CommercialProposalAction.saveCommon()`, `CommercialProposal.calculateInString()`, `CommercialProposal.calculate()`.

#### Flow B — КП → Договор
1. На списке договоров — «Импорт из КП» (`dispatch=selectCP`).
2. Выбор КП.
3. `ContractAction.importCP()` → `Contract.importFromCP()`.
4. Создание черновика: перенос полей, спецификация №1, условия поставки/оплаты, schedule платежей.
5. При сохранении: `con_summ = calculateTotalSum()`, `con_executed` по статусу спецификаций.

**Evidence:** `Contracts.jsp` (кнопка selectCP), `ContractAction.importCP()`, `Contract.importFromCP()`.

#### Flow C — Создание контрагента
1. Форма создания (`create`).
2. Заполнение вкладок (Главная, Реквизиты, Контактные лица и др.).
3. Save → INSERT в `dcl_contractor`, редирект по `returnTo`.

**Evidence:** `ContractorAction.create()`, `ContractorCreateService`, `docs/screens/contractor_create/`.

---

### 5. Функциональные требования (user stories)

- **FR-1:** Пользователь может создать КП с валидацией полей и расчётом итогов. *Evidence: CommercialProposalAction.saveCommon().*
- **FR-2:** Пользователь может импортировать КП в договор с переносом данных и спецификации. *Evidence: ContractAction.importCP().*
- **FR-3:** Пользователь может создать/редактировать контрагента с вкладками и контактными лицами. *Evidence: ContractorAction, ContractorEditService.*
- **FR-4:** Пользователь может создать договор с спецификацией и прикреплёнными файлами. *Evidence: ContractAction, ContractCreateService.*
- **FR-5:** Пользователь может просматривать отчёт «Маржа» с фильтрами и экспортом. *Evidence: MarginAction, MarginDevData.*

Полный список — в `docs/FEATURE_INVENTORY.md`, traceability — в `docs/screens/<slug>/CONTRACTS.md`.

---

### 6. Нефункциональные требования

| Требование | Критерий | Evidence |
|------------|----------|----------|
| Безопасность | Role-based доступ по xml-permissions | `xml-permissions.xml`, `ContractAction.show()` |
| Производительность | API p95 < 200ms для типичных запросов | — |
| Аудит/логирование | Логирование критичных операций | `DCL_LOG`, `net.sam.dcl.log` |
| Доступность | SPA за логином, SEO не важно | Vite, shadcn/ui |

---

### 7. Acceptance criteria (Given/When/Then) и parity with legacy

**Parity with legacy:** результаты расчётов, статусы, правила обязательных полей должны совпадать со старой системой.

Примеры (полный набор — в `docs/PRD_MVP_Module1.md` §4, `docs/screens/<slug>/ACCEPTANCE.md`):

```gherkin
Scenario: Нельзя принять КП без даты принятия
  Given пользователь установил флаг "КП принято"
  When поле "Дата принятия" пустое
  Then сохранение отклоняется с ошибкой accepted

Scenario: Валюты одинаковые — курс должен быть 1
  Given валюта таблицы = валюта печати
  When курс != 1
  Then сохранение отклоняется с ошибкой equalCurrencies

Scenario: Конвертация КП в договор
  Given пользователь нажал "Импорт из КП"
  When выбрана КП
  Then создаётся черновик договора с полями из КП
  And создаётся спецификация №1 с суммами totalPrint и ndsPrint
```

---

### 8. Зависимости

| Зависимость | Описание | Источник |
|-------------|----------|----------|
| Справочники | Валюты, контрагенты, страны, отделы, пользователи | `DCL_CURRENCY`, `DCL_CONTRACTOR`, `DCL_COUNTRY`, `DCL_DEPARTMENT`, `DCL_USER` |
| Миграции БД | Flyway из `db/Lintera_dcl-5_schema.ddl` | `modern/backend/.../db/migration/` |
| Legacy DDL | Единственный источник схемы | `db/Lintera_dcl-5_schema.ddl` |
| Миграция данных | Firebird → Postgres после реализации экранов | `docs/DATA_MIGRATION_PLAN.md` |

---

### 9. Риски и открытые вопросы

**Зафиксированные риски:**
- **DCL_CONTRACT_FILTER:** Реализация в application layer; Postgres FUNCTION не создаётся. *Evidence: docs/db/DCL_CONTRACT_FILTER_DECISION.md*
- **231 stored procedures:** Требуют triage — move to app vs keep in DB. *Evidence: DB_FIREBIRD_TO_POSTGRES_MAPPING.md*
- **Нет явной state machine для КП:** accepted/declined/blocked — набор флагов. *Recommendation: ввести enum + матрицу переходов.*

**UNCONFIRMED по экранам:** `docs/screens/<slug>/questions.md`, `evidence.md`, `review.md`.

**При отсутствии ясности:** записать в CONTINUITY.md → Open questions; пометить UNCONFIRMED в spec; добавить "How to verify" в CONTRACTS.md.

---

## Часть III. Источники истины и документация

### 10. Источники истины (обязательно)

| Источник | Путь | Назначение |
|----------|------|------------|
| **Tech stack** | `docs/TECH_STACK.md` | Источник истины для стека. Frontend: shadcn/ui, Tailwind, Vite. |
| **DDL схемы** | `db/Lintera_dcl-5_schema.ddl` | Единственный источник схемы БД. Не выдумывать таблицы/поля. |
| **Legacy код** | `src/` | Actions, DAO, Forms, JSP — для трассируемости и бизнес-правил. |
| **CONTINUITY** | `CONTINUITY.md` | Цель, ограничения, решения, Done/Now/Next. |
| **AGENTS** | `AGENTS.md` | Инструкции агента-мигратора, фазы. |

---

### 11. Индекс документации

| Файл | Содержание |
|------|------------|
| `docs/PRD_MVP_Module1.md` | PRD MVP: КП, справочники, договоры — flows, entities, формулы, Evidence |
| `docs/FEATURE_INVENTORY.md` | Функциональная структура, traceability (feature → Action → JSP → DAO) |
| `docs/DOMAIN_ANALYSIS.md` | Bounded contexts, агрегаты |
| `docs/LEGACY_CODEMAP.md` | Пакеты Java, Struts, JSP, точки входа |
| `docs/DB_SCHEMA_SUMMARY.md` | Таблицы, PK/FK, индексы, триггеры, процедуры |
| `docs/DB_FIREBIRD_TO_POSTGRES_MAPPING.md` | Маппинг типов, генераторы → sequences |
| `docs/SCREENS_INDEX.md` | Список экранов (ready/todo/needs_sql_review) |
| `docs/SPECS_INDEX.md` | Spec packs (ready) |
| `docs/DEPLOYMENT_GUIDE.md` | Запуск: DB, backend, UI, dev profile |
| `docs/TECH_STACK.md` | **Источник истины стека** |

### 12. Spec pack для каждого экрана (`docs/screens/<slug>/`)

| Файл | Назначение |
|------|------------|
| `SNAPSHOT.md` | Визуальное описание, layout, блоки |
| `CONTRACTS.md` | API endpoints, request/response, **Evidence (Action/JSP/DAO)** |
| `ACCEPTANCE.md` | Критерии приёмки, **parity MUST** |
| `BEHAVIOR_MATRIX.md` | Матрица поведения (флаги, роли, сценарии) |
| `evidence.md` | **Доказательства из legacy** (путь к файлу/классу/методу) |
| `questions.md` | Вопросы, UNCONFIRMED |
| `payloads/` | Примеры request/response |

---

## Часть IV. Технический стек и структура

### 13. Технический стек

> **Источник истины:** `docs/TECH_STACK.md`

**Backend:** Java 21, Spring Boot 3.5.x, Spring Modulith, Spring Data JPA, PostgreSQL, Flyway, OpenAPI, Maven.

**Frontend:** React 19, Vite, TypeScript, **shadcn/ui (Radix UI)**, **Tailwind CSS**, @tanstack/react-router, @tanstack/react-table, react-hook-form, zod, TanStack Query.

**Порты:** UI 5173, Backend 8080, Postgres 5432.

---

### 14. Структура репозитория

```
dcl-v5/
├── db/Lintera_dcl-5_schema.ddl    # Источник истины схемы
├── src/                           # Legacy (только чтение)
├── modern/
│   ├── backend/                   # Spring Boot Modulith
│   └── ui/                        # React SPA (shadcn/ui + Tailwind)
├── docs/screens/<slug>/          # Spec packs с Evidence
├── ops/
└── logs/
```

**Модуль Modulith:** `api/` (REST), `application/` (use cases), `domain/` (агрегаты, правила), `infrastructure/` (JPA). Доступ между модулями — только через `api/` или доменные события.

---

## Часть V. Процесс разработки

### 15. Порядок реализации (фазы)

1. **Фаза 0:** Auth, справочники
2. **Фаза 1:** Контрагенты (list, create, edit)
3. **Фаза 2:** Договоры (list, create, import from CP, spec, attachments)
4. **Фаза 3:** КП (list, create/edit, produce, transport)
5. **Фаза 4:** Заказы (list, create/edit, produce, payments)
6. **Фаза 5+:** Поставки, платежи, производство, отчёты

### 16. Чеклист для каждого экрана

- [ ] Spec pack в `docs/screens/<slug>/` с **Evidence** для каждого правила
- [ ] Flyway миграции (из DDL)
- [ ] Backend: api/application/domain/infrastructure
- [ ] REST endpoints + OpenAPI
- [ ] UI: route + компонент (shadcn/ui + Tailwind)
- [ ] **Traceability:** комментарий в коде (Action → JSP → DAO)
- [ ] Тесты: unit (domain), integration (repository)
- [ ] Smoke-check: Console 0, страница не пустая

### 17. Definition of Done (фича)

1. **Trace к legacy** в документации (Evidence)
2. Миграции БД (Flyway) или аргументированное решение
3. Backend endpoint + OpenAPI
4. UI экран
5. Тесты, проверяющие бизнес-правила
6. **Parity:** результаты расчётов/статусов совпадают с legacy

---

## Часть VI. Правила и ограничения

### 18. Запрещено

- Изменять legacy в `src/` без крайней необходимости
- Придумывать схему БД без чтения DDL
- Реализовывать без Evidence (путь к legacy-источнику)
- Прямые вызовы domain/application другого модуля
- Пометка Done без smoke-check и отчёта

### 19. Cursor rules

См. `.cursor/rules/*.mdc`. Ключевые: 000-continuity-always, 020-sources-of-truth, 030-architecture-modulith, 040-db-migrations-flyway, 070-browser-verification, 081-tables-standard.

---

## Часть VII. Запуск окружения

```bash
docker compose -f ops/docker-compose.yml up -d
cd modern/backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
cd modern/ui && npm install && npm run generate:api && npm run dev
```

Проверка: `curl http://localhost:8080/v3/api-docs` → 200, `http://localhost:5173/` → 200.

---

## Часть VIII. Что уточнить у бизнеса / пользователей

1. Какой приоритет статусов КП, если одновременно `accepted=1` и `declined=1`?
2. Нужен ли отдельный финальный статус КП (FINALIZED) помимо block/checkPrice?
3. Нужно ли в MVP поддержать все ветки расчёта Incoterm (A/B/C/D/E)?
4. Допускается ли ручная правка `cpr_summ` или только вычисление?
5. Нужна ли поддержка `reverse_calc` в MVP?
6. Для режима Минск-склад правила BYN/курс=1 — строго фиксированные или конфигурируемые?
7. Нужно ли сохранять legacy формат номера КП `BYMYYMM/NNNN-...` без изменений?
8. Нужен ли аудит переходов статусов (кто/когда/почему)?
9. Какие роли могут менять `declined` и `received`?
10. Нужна ли в MVP операция checkPrice как отдельный шаг workflow?
11. Можно ли менять валюту КП после добавления строк?
12. Что считать обязательным минимумом полей контрагента?
13. В договоре допускается ли создание без контрагента/валюты (nullable DDL)?
14. Требуется ли полноценная печать (invoice/contract) в MVP?
15. Нужно ли переносить legacy message-механику (ContractMessage) в MVP?
16. Какие stored procedures критичны для бизнеса и должны остаться в БД?
17. Нужна ли поддержка блокировок записей (locked records) в MVP?
18. Какие роли должны видеть колонку «Блок» в списках?

---

## Приложение: быстрый старт для разработчика

1. **Прочитать:** docs/TECH_STACK.md, CONTINUITY.md, docs/PRD_MVP_Module1.md, docs/FEATURE_INVENTORY.md
2. **Запустить:** docker compose up -d, backend (dev), UI
3. **Выбрать экран:** docs/SCREENS_INDEX.md (ready)
4. **Изучить spec:** docs/screens/<slug>/ с фокусом на **Evidence**
5. **Реализовать:** backend module → UI route (shadcn/ui + Tailwind) → тесты
6. **Проверить:** smoke-check, parity с legacy
7. **Отчитаться:** docs/AGENT_TASK_REPORTS.md, обновить CONTINUITY.md

---

*Конец документа*
