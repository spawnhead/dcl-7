# mergecontractors (slug: `mergecontractors`) — Legacy Screen Spec

## 1) Вход в экран
- Primary JSP source: `src/main/webapp/jsp/MergeContractors.jsp`.
- Entry route(s): UNKNOWN (requires Struts mapping verification).

## 2) Что видит пользователь
- Экран основан на JSP и содержит UI-элементы/поля, перечисленные ниже.

### Поля (из JSP `property`)
- `contractorLeft.addInfo`
- `contractorLeft.bank_props`
- `contractorLeft.building`
- `contractorLeft.comment`
- `contractorLeft.country.name`
- `contractorLeft.email`
- `contractorLeft.fax`
- `contractorLeft.fullname`
- `contractorLeft.index`
- `contractorLeft.name`
- `contractorLeft.okpo`
- `contractorLeft.phone`
- `contractorLeft.place`
- `contractorLeft.region`
- `contractorLeft.reputation.description`
- `contractorLeft.street`
- `contractorLeft.unp`
- `contractorRight.addInfo`
- `contractorRight.bank_props`
- `contractorRight.building`
- `contractorRight.comment`
- `contractorRight.country.name`
- `contractorRight.email`
- `contractorRight.fax`
- `contractorRight.fullname`
- `contractorRight.index`
- `contractorRight.name`
- `contractorRight.okpo`
- `contractorRight.phone`
- `contractorRight.place`
- `contractorRight.region`
- `contractorRight.reputation.description`
- `contractorRight.street`
- `contractorRight.unp`
- `leftAddInfo`
- `leftBank`
- `leftBuilding`
- `leftComment`
- `leftCountry`
- `leftEMail`
- `leftFax`
- `leftFullName`
- `leftIndex`
- `leftName`
- `leftOKPO`
- `leftPhone`
- `leftPlace`
- `leftRegion`
- `leftReputation`
- `leftStreet`
- `leftUNP`
- `newId`
- `oldId`
- `rightAddInfo`
- `rightBank`
- `rightBuilding`
- `rightComment`
- `rightCountry`
- `rightEMail`
- `rightFax`
- `rightFullName`
- `rightIndex`
- `rightName`
- `rightOKPO`
- `rightPhone`
- `rightPlace`
- `rightRegion`
- `rightReputation`
- `rightStreet`
- `rightUNP`

### Колонки/гриды (по JSP markup)
- UNKNOWN

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
- Candidate mapped tables: UNKNOWN.

