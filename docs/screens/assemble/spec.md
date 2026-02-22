# assemble (slug: `assemble`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/Assemble.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `apr_count_formatted`
- `asmDisassembleCount`
- `asm_block`
- `asm_count`
- `asm_date`
- `asm_id`
- `asm_number`
- `asm_type_assemble`
- `asm_type_disassemble`
- `catalogNumberForStuffCategory`
- `createUser.userFullName`
- `createUser.usr_id`
- `ctn_number`
- `editUser.userFullName`
- `editUser.usr_id`
- `formReadOnly`
- `gridAsmDisasm`
- `gridSpec`
- `is_new_doc`
- `produce.addParams`
- `produce.id`
- `produce.name`
- `produce.params`
- `produce.type`
- `produce.unit.name`
- `stf_name`
- `stuffCategory.id`
- `stuffCategory.name`
- `usr_date_create`
- `usr_date_edit`

### Колонки/гриды (по JSP markup)
- `apr_count_formatted`
- `catalogNumberForStuffCategory`
- `ctn_number`
- `produce.addParams`
- `produce.name`
- `produce.params`
- `produce.type`
- `produce.unit.name`
- `stf_name`

## 3) Действия
- См. `api.contract.md` (ожидаемые endpoint based on JSP links/forms).

## 4) Валидации и ошибки
- UNKNOWN: требуется сверка `validation.xml` и runtime HAR.

## 5) DB invariants
- См. `db.invariants.md`.

## 6) Unknowns
- См. `questions.md`.

## SQL-aligned UI->DB mapping (Patch 0.5+)
- SQL has priority over UI for required/optional/type constraints.
- Candidate mapped tables: `DCL_ASSEMBLE`.
- Column-level mapping requires screen action/DAO trace; until confirmed, treat non-null SQL columns as required at API boundary.

