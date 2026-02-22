# Технологический стек проекта dcl-modern

**Источник истины** для стека. Все документы (DEVELOPMENT_HANDOFF, AGENTS, правила) должны соответствовать этому файлу.

Полный перечень библиотек, зависимостей, инструментов и стилей, используемых в проекте.

---

## 0. Backend

| Компонент | Версия | Назначение |
|-----------|--------|------------|
| **Java** | 21 LTS | JDK |
| **Spring Boot** | 3.5.x | Фреймворк |
| **Spring Modulith** | — | Модульный монолит |
| **Spring Data JPA + Hibernate** | — | ORM |
| **PostgreSQL** | 16 | БД (миграция с Firebird) |
| **Flyway** | — | Миграции БД |
| **OpenAPI/Swagger** | — | REST API, документация |
| **Maven** | — | Сборка |

---

## 1. Ядро и сборка

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **react** | ^19.2.3 | Библиотека UI |
| **react-dom** | ^19.2.3 | Рендеринг React в DOM |
| **vite** | ^7.3.0 | Сборщик и dev-сервер |
| **@vitejs/plugin-react-swc** | ^4.2.2 | Плагин Vite для React (компиляция через SWC) |
| **typescript** | ~5.9.3 | Язык TypeScript |

---

## 2. Роутинг и архитектура

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **@tanstack/react-router** | ^1.141.2 | Роутинг с типизацией |
| **@tanstack/router-plugin** | ^1.141.2 | Плагин для генерации маршрутов |
| **zustand** | ^5.0.9 | Глобальное состояние (stores) |

---

## 3. Работа с данными и API

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **axios** | ^1.13.2 | HTTP-клиент для запросов к API |
| **@tanstack/react-query** | ^5.90.12 | Кеширование, загрузка и обработка данных |

---

## 4. Формы и валидация

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **react-hook-form** | ^7.68.0 | Управление формами |
| **zod** | ^4.2.0 | Схемы и валидация |
| **@hookform/resolvers** | ^5.2.2 | Связка Zod и react-hook-form |

---

## 5. UI-компоненты (Radix UI / Shadcn)

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **@radix-ui/react-alert-dialog** | ^1.1.15 | Диалоги подтверждения |
| **@radix-ui/react-avatar** | ^1.1.11 | Аватары |
| **@radix-ui/react-checkbox** | ^1.3.3 | Чекбоксы |
| **@radix-ui/react-collapsible** | ^1.1.12 | Раскрывающиеся блоки |
| **@radix-ui/react-dialog** | ^1.1.15 | Модальные окна |
| **@radix-ui/react-dropdown-menu** | ^2.1.16 | Выпадающие меню |
| **@radix-ui/react-icons** | ^1.3.2 | Иконки Radix |
| **@radix-ui/react-label** | ^2.1.8 | Подписи к полям |
| **@radix-ui/react-popover** | ^1.1.15 | Всплывающие окна |
| **@radix-ui/react-radio-group** | ^1.3.8 | Радио-кнопки |
| **@radix-ui/react-scroll-area** | ^1.2.10 | Области прокрутки |
| **@radix-ui/react-select** | ^2.2.6 | Селекты |
| **@radix-ui/react-separator** | ^1.1.8 | Разделители |
| **@radix-ui/react-slot** | ^1.2.4 | Утилита для композиции компонентов |
| **@radix-ui/react-switch** | ^1.2.6 | Переключатели |
| **@radix-ui/react-tabs** | ^1.1.13 | Вкладки |
| **@radix-ui/react-tooltip** | ^1.2.8 | Подсказки |

---

## 6. Стилизация и CSS

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **tailwindcss** | ^4.1.18 | CSS-фреймворк |
| **@tailwindcss/vite** | ^4.1.18 | Плагин Tailwind для Vite |
| **clsx** | ^2.1.1 | Условные CSS-классы |
| **tailwind-merge** | ^3.4.0 | Слияние классов Tailwind |
| **class-variance-authority** | ^0.7.1 | Варианты компонентов (cva) |
| **tw-animate-css** | ^1.4.0 | Анимации для Tailwind |

### Файлы стилей

| Файл | Назначение |
|------|------------|
| **src/styles/index.css** | Основной CSS: Tailwind, tw-animate, theme, базовые стили |
| **src/styles/theme.css** | CSS-переменные темы (светлая/тёмная), цвета, радиусы |

### Импорты в index.css

- `tailwindcss` — ядро Tailwind
- `tw-animate-css` — анимации
- `./theme.css` — тема и переменные

### Переменные темы (theme.css)

- **Цвета:** background, foreground, card, popover, primary, secondary, muted, accent, destructive, border, input, ring
- **Графики:** chart-1 … chart-5
- **Sidebar:** sidebar, sidebar-foreground, sidebar-primary, sidebar-accent, sidebar-border, sidebar-ring
- **Радиусы:** --radius, --radius-sm, --radius-md, --radius-lg, --radius-xl
- **Шрифты:** --font-inter, --font-manrope

### Шрифты (Google Fonts)

- **Inter** — основной шрифт
- **Manrope** — дополнительный шрифт

Подключение в `index.html`:

```html
<link href="https://fonts.googleapis.com/css2?family=Inter:...&family=Manrope:...&display=swap" rel="stylesheet" />
```

---

## 7. Таблицы и данные

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **@tanstack/react-table** | ^8.21.3 | Таблицы (сортировка, пагинация, фильтры) |

---

## 8. UI-утилиты и доп. компоненты

| Пакет | Версия | Назначение |
|-------|--------|------------|
| **cmdk** | 1.1.1 | Поиск по приложению (Ctrl+K) |
| **date-fns** | ^4.1.0 | Работа с датами |
| **lucide-react** | ^0.561.0 | Иконки |
| **react-day-picker** | 9.12.0 | Календарь для выбора дат |
| **react-top-loading-bar** | ^3.0.2 | Полоска загрузки сверху |
| **recharts** | ^3.6.0 | Графики и диаграммы |
| **sonner** | ^2.0.7 | Тосты (уведомления) |

---

## 9. Инструменты разработки (devDependencies)

### TypeScript

| Пакет | Версия |
|-------|--------|
| @types/node | ^25.0.2 |
| @types/react | ^19.2.7 |
| @types/react-dom | ^19.2.3 |

### ESLint

| Пакет | Версия | Назначение |
|-------|--------|------------|
| eslint | ^9.39.2 | Линтер |
| @eslint/js | ^9.39.2 | Базовые правила ESLint |
| globals | ^16.5.0 | Глобальные переменные |
| typescript-eslint | ^8.49.0 | Поддержка TypeScript |
| eslint-plugin-react-hooks | ^7.0.1 | Правила для хуков React |
| eslint-plugin-react-refresh | ^0.4.25 | Совместимость с HMR |
| @tanstack/eslint-plugin-query | ^5.91.2 | Правила для React Query |

### Prettier

| Пакет | Версия | Назначение |
|-------|--------|------------|
| prettier | ^3.7.4 | Форматирование кода |
| prettier-plugin-tailwindcss | ^0.7.2 | Сортировка классов Tailwind |
| @trivago/prettier-plugin-sort-imports | ^6.0.0 | Сортировка импортов |

### Прочее

| Пакет | Версия | Назначение |
|-------|--------|------------|
| @tanstack/react-query-devtools | ^5.91.1 | DevTools для React Query |
| @tanstack/react-router-devtools | ^1.141.2 | DevTools для роутера |
| @faker-js/faker | ^10.1.0 | Генерация тестовых данных |
| knip | ^5.73.4 | Поиск неиспользуемого кода |

---

## 10. NPM-скрипты

| Команда | Назначение |
|---------|------------|
| `npm run dev` | Запуск dev-сервера (Vite) |
| `npm run build` | Сборка (tsc + vite build) |
| `npm run preview` | Просмотр production-сборки |
| `npm run lint` | Проверка ESLint |
| `npm run format` | Форматирование Prettier |
| `npm run format:check` | Проверка форматирования |
| `npm run knip` | Поиск неиспользуемого кода |

---

## 11. Конфигурационные файлы

| Файл | Назначение |
|------|------------|
| **vite.config.ts** | Плагины Vite (TanStack Router, React, Tailwind), alias `@` |
| **tsconfig.json** | Базовый конфиг TypeScript, paths |
| **tsconfig.app.json** | Конфиг для приложения (ES2020, JSX, strict) |
| **tsconfig.node.json** | Конфиг для Node (vite.config.ts) |
| **eslint.config.js** | Правила ESLint, плагины |
| **.prettierrc** | Настройки Prettier (кавычки, отступы, плагины) |
| **knip.config.ts** | Игнорируемые пути для Knip |

---

## 12. Вспомогательные библиотеки (src/lib)

| Файл | Использует |
|------|------------|
| **utils.ts** | clsx, tailwind-merge (функция `cn`) |
| **cookies.ts** | Работа с cookies |
| **handle-server-error.ts** | axios, sonner (toast) |
| **show-submitted-data.tsx** | sonner |

---

## 13. Сводная таблица зависимостей

### Dependencies (production)

```
react, react-dom
@tanstack/react-router, @tanstack/react-query, @tanstack/react-table
axios, zustand
react-hook-form, zod, @hookform/resolvers
@radix-ui/* (alert-dialog, avatar, checkbox, collapsible, dialog, dropdown-menu, icons, label, popover, radio-group, scroll-area, select, separator, slot, switch, tabs, tooltip)
tailwindcss, @tailwindcss/vite, clsx, tailwind-merge, class-variance-authority, tw-animate-css
cmdk, date-fns, lucide-react, react-day-picker, react-top-loading-bar, recharts, sonner
```

### DevDependencies

```
typescript, @types/node, @types/react, @types/react-dom
vite, @vitejs/plugin-react-swc
@tanstack/router-plugin, @tanstack/react-query-devtools, @tanstack/react-router-devtools
eslint, @eslint/js, globals, typescript-eslint, eslint-plugin-react-hooks, eslint-plugin-react-refresh, @tanstack/eslint-plugin-query
prettier, prettier-plugin-tailwindcss, @trivago/prettier-plugin-sort-imports
@faker-js/faker, knip
```

---

---

## 14. Связанные документы

- **docs/DEVELOPMENT_HANDOFF.md** — ссылается на TECH_STACK как источник истины стека
- **AGENTS.md** — целевой стек должен соответствовать TECH_STACK
- **.cursor/rules/081-tables-standard.mdc** — Tables Standard: @tanstack/react-table per TECH_STACK

---

*Документ последний раз обновлён: февраль 2026*
