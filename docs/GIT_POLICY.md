# Git & Release Policy — Agent Dev 2

Внутренний стандарт команды: порядок в ветках, истории, PR/MR, релизах и разрешении конфликтов. Все агенты и разработчики обязаны следовать этому документу.

---

## Входные данные (текущие допущения)

Если параметры не заданы явно, действуют значения по умолчанию:

| Параметр | Значение по умолчанию |
|----------|------------------------|
| Хостинг | GitHub или GitLab (правила формулируются агностично) |
| Основная ветка | `main` |
| Стратегия истории | Rebase фич-веток на main перед PR; merge в main через PR (squash или merge commit — см. п. 5) |
| CI | Обязателен: линт, тесты, сборка backend и (при наличии) UI |
| Стек | Java 21 / Spring Boot (backend), React/TypeScript (UI), монорепо `modern/` |
| Версионирование | SemVer (vMAJOR.MINOR.PATCH) |
| Монорепо | Да: `modern/backend`, `modern/ui`, `docs`, `ops` |
| Hotfix/release-ветки | Да, по процедуре (п. 8) |

**Уточняющие вопросы (если нужно изменить политику):** хостинг (GitHub/GitLab/Bitbucket), имя основной ветки, merge vs squash в main, список required CI checks, нужны ли release-ветки и защита main.

---

## 1) Цель и область действия

- **Единый workflow** для людей и Agent Dev 2: одна и та же последовательность pull → работа → тесты → push → PR.
- **Предсказуемая история:** понятное именование веток/коммитов/тегов, минимум force-push, воспроизводимые релизы.
- **Защита main:** изменения только через PR/MR; обязательные проверки (линт, тесты, сборка) и при необходимости ревью.
- **Чёткое разрешение конфликтов:** один алгоритм для merge и rebase, фиксация решений в коммите/PR.
- **Область:** весь репозиторий (включая `modern/`, `docs/`, `ops/`); legacy `src/` затрагивается только по исключению с фиксацией в CONTINUITY.md.

---

## 2) Базовые принципы

- **Trunk-based с короткоживущими фичами:** основная линия — `main`; работа ведётся в ветках `feature/*` или `fix/*`, срок жизни — дни, не недели.
- **main всегда деплоябелен:** в main не мерджится сломанный сборкой/тестами код; CI на main должен быть зелёным.
- **Изменения в main только через PR/MR:** прямые коммиты в main запрещены (кроме санкционированных hotfix по процедуре).
- **Rebase до push:** перед созданием/обновлением PR фич-ветка перебазируется на актуальный `main`; конфликты решаются в ветке, не в main.
- **Один PR — одна логическая цель:** не смешивать несвязанные фичи/рефакторинги в одном PR (исключения — явно оговорены в описании PR).

---

## 3) Ветвление и PR/MR процесс

### Разрешённые ветки

| Тип | Имя | Откуда | Куда мерджится | Кто пушит |
|-----|-----|--------|----------------|-----------|
| Основная | `main` | — | — | Никто напрямую (только через PR) |
| Фича | `feature/<short-name>` или `feat/<short-name>` | main | main | Dev / Agent |
| Исправление бага | `fix/<short-name>` | main | main | Dev / Agent |
| Hotfix | `hotfix/<short-name>` или `hotfix/vX.Y.Z` | main (или release) | main + при необходимости release | По процедуре п. 8 |
| Release (опционально) | `release/vX.Y.Z` | main | main (merge back) | Ответственный за релиз |

- `<short-name>`: строчные буквы, цифры, дефис; без пробелов (например `feature/country-crud`, `fix/currency-validation`).
- Ветки типа `feature/*` и `fix/*` после мерджа в main удаляются (настройка на хостинге или вручную).

### PR/MR процесс

1. **Создание PR:** из ветки `feature/*` или `fix/*` в `main`; описание по шаблону (см. п. 10).
2. **Required checks:** все перечисленные в п. 7 проверки должны быть зелёными.
3. **Ревью (если включено):** минимум 1 approval; при работе только агента — approval может быть отменён по решению команды (документировать в репозитории).
4. **Merge:** только после зелёного CI и выполнения Definition of Done (п. 7). Стратегия merge: **Squash and merge** по умолчанию (один коммит на PR в main); альтернатива — Merge commit, если нужна явная история веток.
5. **Protected branch:** `main` защищён: push только через PR; force push запрещён; при необходимости — require status checks, require branch up to date.

### Проверяемость

- Убедиться, что в main нет коммитов, не прошедших через PR (история/логи).
- Все мерджи в main имеют соответствующий закрытый PR с зелёными checks.

---

## 4) Pull/Push дисциплина (обязательная рутина)

### Чеклист перед началом работы

1. Прочитать `CONTINUITY.md` и при необходимости обновить (цель, Now, Next).
2. Убедиться, что работаешь в нужной ветке: `git status`, `git branch --show-current`.
3. Подтянуть актуальный main и перебазировать свою ветку (если уже есть):
   ```bash
   git fetch origin main
   git rebase origin/main
   ```
4. При конфликтах при rebase — разрешить по п. 6, затем `git rebase --continue`.

### Чеклист перед push

1. Линт и тесты локально (п. 7): выполнить обязательные команды и убедиться, что они проходят.
2. Коммиты соответствуют стандарту (п. 5): сообщения в формате Conventional Commits.
3. Нет лишних файлов в коммите: не коммитить `target/`, `node_modules/`, `build/`, локальные конфиги с секретами, логи (кроме примеров в `logs/` по договорённости).
4. Rebase на актуальный main выполнен: `git fetch origin main && git rebase origin/main`.
5. Push без force: `git push origin <branch>`; при отклонении из-за истории — не делать `--force` без процедуры исключения (п. 9).

### Обязательные команды/алиасы (bash)

```bash
# Рекомендуемые алиасы (.gitconfig или скрипт в ops/scripts/)
git config alias.sync-main '!git fetch origin main && git rebase origin/main'
git config alias.pre-push '!bash -c "cd modern/backend && mvn -q validate compile test -DskipTests=false 2>/dev/null || true"'
```

Перед каждым push агент должен фактически выполнить эквивалент: fetch + rebase на main, затем запуск проверок (см. п. 7).

---

## 5) Стандарты коммитов и сообщений

### Формат: Conventional Commits

```
<type>(<scope>): <short description>

[optional body]

[optional footer: Breaking-Change:, Ref: ticket]
```

- **type:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`.
- **scope (опционально):** модуль/пакет, например `country`, `currency`, `ui`, `flyway`.
- **short description:** императив, строчные буквы после типа, без точки в конце; до ~72 символов.

### Примеры

```
feat(country): add update and delete endpoints
fix(currency): validation for sortOrder nullable
docs: update DEPLOYMENT_GUIDE with JDK 21 prerequisite
chore(deps): bump spring-boot to 3.5.2
```

### Политика squash / rebase / merge commit

- **В фич-ветке:** разрешены несколько коммитов; перед открытием/обновлением PR — интерактивный rebase на main (при желании squash коммитов ветки в один).
- **В main:** по умолчанию **Squash and merge** для PR — в main попадает один коммит с описанием от PR. Альтернатива: **Merge commit** — сохраняются все коммиты ветки; выбор закрепляется в настройках репозитория.
- **Rebase:** только в своей ветке; после push ветки — не делать force push без процедуры исключения.

### Проверяемость

- `git log --oneline main` — сообщения в формате type(scope): description.
- В main нет merge commit'ов с пустым или неинформативным сообщением (если используется merge commit).

---

## 6) Разрешение конфликтов (SOP)

### Merge-конфликты (при merge main в ветку или при merge ветки в main через UI)

1. **Обновить ветку от main:**  
   `git fetch origin main && git merge origin/main` (или через rebase, см. ниже).
2. **Найти конфликтующие файлы:**  
   `git status` → список "both modified".
3. **Разрешить в каждом файле:**  
   Открыть файл, убрать маркеры `<<<<<<<`, `=======`, `>>>>>>>`; оставить нужный код или объединить изменения вручную. Выбор "ours" = текущая ветка, "theirs" = входящая (main при merge main в ветку).
4. **Правило выбора:**  
   - Конфликт в коде фичи при слиянии с main: приоритет — сохранить и свою логику, и актуальные изменения из main; при дублировании сигнатур/логики — оставить одну согласованную версию и зафиксировать в коммите, что именно оставлено.
   - Конфликт в конфигурации/версиях: предпочитать версию из main, если иное не обосновано в PR.
5. **Зафиксировать:**  
   `git add <resolved-files>` затем `git commit` (merge) или `git rebase --continue` (rebase). Сообщение merge commit: стандартное "Merge branch 'main' into feature/..." или осмысленное описание.
6. **Проверка после разрешения:**  
   Запустить полный цикл проверок (линт, тесты, сборка); убедиться, что приложение запускается при необходимости.

### Rebase-конфликты

1. Выполнить `git rebase origin/main`; при конфликте rebase останавливается.
2. Разрешить конфликты в указанных файлах (аналогично п. 3–4 выше). При rebase "ours" = коммит из main, "theirs" = твой коммит — не путать с merge.
3. `git add <resolved>` затем `git rebase --continue`.
4. При необходимости отменить rebase: `git rebase --abort` (возврат к состоянию до rebase).
5. После успешного rebase — обязательно запустить тесты/сборку.

### Сложные конфликты

- При массовых конфликтах в сгенерированных файлах (например OpenAPI, кодоген): предпочтительно перегенерировать артефакты после мерджа версий исходников и закоммитить результат.
- Любое решение "оставить одну из сторон" или "ручное слияние" должно быть отражено в коммите (message или комментарий в коде), чтобы было воспроизводимо.

---

## 7) CI/CD и качество (Definition of Done)

### Обязательные проверки перед merge в main

- **Линт (если настроен):** backend (Checkstyle/Spotless/иной), frontend (ESLint) — без ошибок.
- **Тесты:** все unit и integration-тесты backend проходят; при наличии — тесты UI. При недоступности Docker тесты, зависящие от Testcontainers, могут быть пропущены по конфигурации (документировать в README/CI).
- **Сборка:**  
  - Backend: `cd modern/backend && mvn -q clean compile test` (или с пропуском тяжёлых тестов по политике).  
  - UI (если менялся): `cd modern/ui && npm ci && npm run build` (или эквивалент).
- **Документация:** при изменении шагов запуска/сборки обновить `docs/DEPLOYMENT_GUIDE.md` и при необходимости `CONTINUITY.md`.

### Политика "зелёный CI или нельзя мерджить"

- В main мерджится только код, для которого все required status checks на хостинге зелёные.
- Локальный прогон проверок агент выполняет перед push (чеклист п. 4); CI на сервере — финальный гейт.

### Минимальный набор (если CI ещё не настроен)

- Ручной прогон: backend `mvn clean compile test`, UI `npm run build`; результат зафиксировать в `docs/PROGRESS.md` или в PR.

### Расширенный набор

- Автоматический CI (GitHub Actions / GitLab CI): job на каждый push в ветку и на PR в main; required checks в branch protection; кэш Maven/npm при необходимости.

---

## 8) Релизы и теги

### Семантическое версионирование (SemVer)

- Формат тега: `vMAJOR.MINOR.PATCH` (например `v1.0.0`, `v1.2.3`).
- MAJOR — несовместимые изменения API; MINOR — новая функциональность с обратной совместимостью; PATCH — исправления без изменения контрактов.

### Создание релиза

1. Убедиться, что main стабилен и CI зелёный.
2. Обновить версию в коде (если хранится в `pom.xml` / `package.json`) и при необходимости changelog в `docs/` или в описании релиза на хостинге.
3. Создать тег от main:  
   `git tag -a vX.Y.Z -m "Release vX.Y.Z: краткое описание"`  
   затем `git push origin vX.Y.Z`.
4. Создать Release на GitHub/GitLab от этого тега, приложить артефакты и описание изменений.

### Hotfix процедура

1. Создать ветку от main (или от release-ветки, если релиз ещё не влит):  
   `git checkout main && git pull && git checkout -b hotfix/vX.Y.Z-description`.
2. Внести минимальные изменения только для исправления бага; тесты и линт обязательны.
3. Открыть PR в main; после мерджа — создать тег `vX.Y.Z` (patch) от main и release.
4. При наличии ветки `release/vX.Y.Z` — при необходимости влить hotfix и туда и зафиксировать в документации.

---

## 9) Запрещённые действия и исключения

### Запрещено по умолчанию

- **`git push --force`** (включая `--force-with-lease`) в `main` или в общие ветки. В фич-ветку force push допустим только если ветка не используется другими и после локального rebase; предпочтительно не использовать force, а делать обычный push после rebase (если история ещё не пушилась — тогда push без force).
- **`git reset --hard`** без сохранения изменений (перед reset сделать stash или отдельную ветку, если нужны изменения).
- Прямые коммиты в `main` в обход PR (кроме санкционированного hotfix с последующим PR).
- Мердж в main при красном CI или при нарушении Definition of Done.
- Коммит бинарников, артефактов сборки (`target/`, `node_modules/`, `build/`), секретов и персональных конфигов в репозиторий (исключения — перечислены в `.gitignore` и документации).

### Процедура исключений

- **Кто разрешает:** ответственный за репозиторий / Tech Lead; при отсутствии — документировать в PR или в `CONTINUITY.md` с пометкой "Exception: ...".
- **Как документировать:** в коммите или в описании PR указать причину исключения (например "Exception: force push after rebase, branch not shared"); при force push в общую ветку — явное согласование и уведомление команды.
- **Восстановление после исключения:** при сломанной истории — согласованное восстановление из резервной копии или повторный push правильной истории с документированием в docs/PROGRESS.md.

---

## 10) Приложение

### Рекомендуемые настройки репозитория (branch protection)

- **main:**  
  - Require a pull request before merging.  
  - Require status checks to pass (указать конкретные job names: e.g. `build`, `test`).  
  - Require branch to be up to date before merging (опционально).  
  - Do not allow force push; do not allow delete.  
  - (Опционально) Require 1 approval.
- **GitHub:** Settings → Branches → Add rule для `main`.  
- **GitLab:** Settings → Repository → Protected branches → `main` с аналогичными ограничениями.

### Алиасы .gitconfig (пример)

```ini
[alias]
  sync-main = "!f() { git fetch origin main && git rebase origin/main; }; f"
  prepush = "!f() { git fetch origin main && git rebase origin/main && (cd modern/backend && mvn -q compile test -DskipTests=false); }; f"
  lg = log --oneline -15
```

### Шаблон PR (краткий)

```markdown
## Что сделано
- (краткий список изменений)

## Связь с legacy / задачами
- Legacy: (Action/DAO/JSP/таблица при наличии)
- CONTINUITY: (обновлён ли Done/Now/Next)

## Проверки
- [ ] Локально: mvn compile test (и при необходимости npm run build)
- [ ] Rebase на main выполнен
- [ ] Коммиты в формате Conventional Commits
```

### Шаблон Issue (для трассируемости)

```markdown
## Цель
(одно предложение)

## Источники истины
- DDL: (таблица/процедура при наличии)
- Legacy: (Action/Service/DAO/JSP при наличии)

## Критерии готовности
- [ ] Код в modern/*, тесты, док обновлён
- [ ] Traceability зафиксирована в коде/документации
```

---

## Quick Start для Agent Dev 2 (всегда выполнять)

1. Прочитать и при необходимости обновить `CONTINUITY.md` (цель, Now, Next).
2. Прочитать `docs/PROGRESS.md`.
3. `git fetch origin main` и переключиться на свою ветку или создать `feature/<short-name>` от `origin/main`.
4. Выполнять работу только в ветке; не коммитить в main.
5. Перед первым push: `git rebase origin/main` при необходимости; разрешить конфликты по п. 6.
6. Запустить обязательные проверки: backend `mvn clean compile test`, при изменении UI — `npm run build`.
7. Закоммитить с сообщением в формате Conventional Commits; не включать `target/`, `node_modules/`, секреты.
8. `git push origin <branch>` (без --force для main и общих веток).
9. Создать или обновить PR в main; убедиться, что CI зелёный.
10. После мерджа обновить `CONTINUITY.md` и `docs/PROGRESS.md` (Done/Now/Next).

---

## Примеры

<Example 1 — ветки и PR>

- Текущая ветка: `main` на коммите `a1b2c3d`.
- Задача: добавить валидацию в модуль Currency.
- Действия:  
  `git checkout main && git pull` → `git checkout -b fix/currency-validation` → внести изменения → `git add ... && git commit -m "fix(currency): add validation for sortOrder and noRound"` → `git fetch origin main && git rebase origin/main` → `git push origin fix/currency-validation` → создать PR в main с описанием по шаблону. После зелёного CI — Squash and merge.

</Example>

<Example 2 — коммиты>

- Допустимые сообщения:  
  `feat(country): add update and delete endpoints`  
  `docs: update DEPLOYMENT_GUIDE with JDK 21 prerequisite`  
  `chore(ci): add Maven cache to workflow`
- Недопустимые:  
  `fix`, `WIP`, `Update file.java`, `merged main`.

</Example>

<Example 3 — конфликт при rebase>

- Ветка `feature/country-crud` отстала от main; при `git rebase origin/main` конфликт в `CountryController.java`.
- Действия: открыть файл, убрать маркеры, оставить совместимую версию (свои новые методы + актуальные импорты/сигнатуры из main) → `git add modern/backend/.../CountryController.java` → `git rebase --continue` → запустить `mvn test` → затем push (при первом push после rebase может потребоваться обычный push, если ветка ещё не пушилась; если ветка уже была запушена и делался rebase — см. процедуру исключения для force push в фич-ветку или пересоздать ветку от main и cherry-pick коммитов).

</Example>

---

*Документ утверждается командой. Изменения в политику вносятся через PR с обновлением этого файла.*
