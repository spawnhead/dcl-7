# PRD MVP Module 1 — Коммерческие предложения (КП), справочники, договоры

## 1. Executive Summary
### 1.1 Problem / Value Proposition
Legacy-система хранит критичную бизнес-логику КП и конвертации КП→Договор в Java Actions/Beans + SQL procedures. Для clean-room rewrite нужно формализовать правила в продуктовые требования, чтобы обеспечить **поведенческий паритет 1:1** (расчёты, валидации, статусы, права).

**Ценность MVP Module 1:**
- Уменьшение ошибок в денежных расчётах (скидка/НДС/округление/логистика).
- Ускорение цикла продаж за счёт управляемого потока «КП → Договор».
- Прозрачные статусы и role-based поведение, эквивалентные legacy.

**Источники:**
- `CommercialProposalAction.saveCommon()` (валидации/сохранение/номер КП).
- `CommercialProposal.calculateInString()` + `CommercialProposal.calculate()` (формулы).
- `ContractAction.importCP()` + `Contract.importFromCP()` (конвертация в договор).
- `sql-resources.xml` (`select-commercial_proposals`, `commercial_proposal-*`, `contract-*`).

### 1.2 User Personas
1. **Экономист** — расчёт/проверка КП, checkPrice, блокировка, контроль условий.
2. **Менеджер** — создание КП и последующая конвертация в договор, чаще в рамках своего подразделения.
3. **Юрист** — контроль условий договора и аннулирования.
4. **Администратор** — полный доступ, включая блокировки и справочники.

**Источники ролей:** `xml-permissions.xml` + runtime checks в `ContractAction.show()`/`CommercialProposalsAction.internalFilter()`.

---

## 2. Functional Requirements (The Core)

### 2.1 User Flows

#### Flow A — Create Proposal (КП)
1. Пользователь открывает форму создания КП (`input`).
2. Заполняет шапку: контрагент, валюта таблицы/печати, курс, НДС, Incoterm, сроки/условия.
3. Добавляет табличные строки и логистику.
4. Система выполняет пересчёт строк (`calculateInString`) и итоговых строк (`calculate`).
5. При `Save` выполняются проверки:
   - если `proposal_received=true`, поле `date_accept` обязательно;
   - `date_accept >= cpr_date`;
   - при одинаковых валютах курс обязан быть `1`, при разных — не `1`;
   - для old-version запрещены пустые строки товара;
   - при `assemble_minsk_store` проверка резервов (requested ≤ rest).
6. При успехе:
   - если это новый КП, генерируется номер `BYMYYMM/NNNN-USERCODE`;
   - сохраняются шапка, строки, логистика;
   - итог `cpr_summ = totalPrint`.

**Доказательства:**
- `CommercialProposalAction.saveCommon()` (валидации, генерация номера, insert/update).
- `CommercialProposalForm.isIncorrectWhenEqualCurrencies()/isIncorrectWhenNotEqualCurrencies()`.
- `CommercialProposal.calculateInString()/calculate()`.

#### Flow B — Proposal to Contract
1. На экране списка договоров пользователь нажимает «Импорт из КП» (`dispatch=selectCP`).
2. Выбирает КП.
3. `ContractAction.importCP()` загружает КП и вызывает `Contract.importFromCP()`.
4. Система создаёт черновик договора:
   - переносит номер/дату/контрагента/валюту;
   - создаёт спецификацию №1 с `spc_summ = commercialProposal.totalPrint`, `spc_summ_nds = commercialProposal.ndsPrint`;
   - строит условия поставки/оплаты по веткам предоплаты (0/100/частичная);
   - формирует schedule платежей.
5. При сохранении договора:
   - `con_summ = calculateTotalSum()`;
   - `con_executed = '1'`, только если нет незакрытых спецификаций; иначе пусто.

**Доказательства:**
- `Contracts.jsp` кнопка `dispatch="selectCP"`.
- `ContractsAction.selectCP()` и `ContractAction.importCP()`.
- `Contract.importFromCP()`.
- `ContractAction.saveCommon()`.

### 2.2 Entity Specifications

#### 2.2.1 DCL_COMMERCIAL_PROPOSAL
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| CPR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:216` |
| CPR_NUMBER | VARCHAR(20) | Да | `db/Lintera_dcl-5_schema.ddl:221` |
| CPR_DATE | DATE | Да | `db/Lintera_dcl-5_schema.ddl:222` |
| CTR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:223` |
| CUR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:226` |
| CUR_ID_TABLE | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:251` |
| CPR_COURSE | DECIMAL(18,8) | Нет | `db/Lintera_dcl-5_schema.ddl:227` |
| CPR_NDS | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:228` |
| CPR_SUM_TRANSPORT | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:234` |
| CPR_SUM_ASSEMBLING | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:246` |
| CPR_SUMM | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:243` |
| CPR_PROPOSAL_RECEIVED_FLAG | SMALLINTNN default 0 | Да | `db/Lintera_dcl-5_schema.ddl:239` |
| CPR_PROPOSAL_DECLINED | CHAR(1) default '0' | Да | `db/Lintera_dcl-5_schema.ddl:284` |
| CPR_BLOCK | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:241` |

#### 2.2.2 DCL_CPR_LIST_PRODUCE
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| LPR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:498` |
| CPR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:499` |
| LPR_PRICE_BRUTTO | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:512` |
| LPR_DISCOUNT | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:513` |
| LPR_PRICE_NETTO | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:501` |
| LPR_COUNT | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:502` |
| LPR_SALE_PRICE | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:510` |
| LPR_SALE_COST_PARKING_TRANS | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:511` |

#### 2.2.3 DCL_CPR_TRANSPORT (логистика минимум)
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| TRN_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:517` |
| CPR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:518` |
| STF_ID | INTEGER | Нет | `db/Lintera_dcl-5_schema.ddl:519` |
| TRN_SUM | DECIMAL(15,2) | Да | `db/Lintera_dcl-5_schema.ddl:520` |

#### 2.2.4 DCL_CURRENCY
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| CUR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:567` |
| CUR_NAME | VARCHAR(10) | Да | `db/Lintera_dcl-5_schema.ddl:568` |
| CUR_NO_ROUND | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:569` |
| CUR_SORT_ORDER | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:570` |

#### 2.2.5 DCL_CONTRACTOR
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| CTR_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:372` |
| CTR_NAME | VARCHAR(200) | Да | `db/Lintera_dcl-5_schema.ddl:373` |
| RPT_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:383` |
| CUT_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:388` |
| CTR_BLOCK | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:378` |

#### 2.2.6 DCL_CONTRACT
| Field Name | Type | Mandatory? | Legacy Source (File/Line) |
|---|---|---|---|
| CON_ID | INTEGER | Да | `db/Lintera_dcl-5_schema.ddl:351` |
| CON_NUMBER | VARCHAR(50) | Да | `db/Lintera_dcl-5_schema.ddl:356` |
| CON_DATE | DATE | Да | `db/Lintera_dcl-5_schema.ddl:357` |
| CTR_ID | INTEGER | Нет (DDL) | `db/Lintera_dcl-5_schema.ddl:358` |
| CUR_ID | INTEGER | Нет (DDL) | `db/Lintera_dcl-5_schema.ddl:359` |
| CON_EXECUTED | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:360` |
| CON_SUMM | DECIMAL(15,2) | Нет | `db/Lintera_dcl-5_schema.ddl:361` |
| CON_ANNUL | SMALLINT | Нет | `db/Lintera_dcl-5_schema.ddl:363` |

### 2.3 Business Logic & Calculations

#### 2.3.1 Расчёт строки КП
1. **Нетто из брутто и скидки** (если включён авторасчёт нетто):
   - `priceNetto = lpr_price_brutto * (1 - lpr_discount / 100)`
   - затем `priceNetto = round(priceNetto, 2)` и опц. целое округление по валюте.

2. **Коэффициент строки:**
   - `lprCoefficient = round( salePrice / round(priceNetto,2), 4 )`.

3. **Таможенная надбавка:**
   - `customDuty = round( saleCostParkingTrans * customPercent/100 + saleCostParkingTrans * 0.0015, 2 )`.
   - спец-правило Минск-склад: `customDuty = 0`.

4. **НДС строки:**
   - `nds = round( saleCostParkingTransCustom * cpr_nds / 100, 2 )`.
   - `costNds = round( saleCostParkingTransCustom + nds, 2 )`.

**Доказательства:** `CommercialProposal.calculateInString()`.

#### 2.3.2 Итоговые формулы КП (summary rows)
Пример ветки Case C:
- `packTransAll = round(cpr_sum_transport + cpr_sum_assembling)`
- `ndsAll = round((sumAll + packTransAll + dutyAll) * cpr_nds / 100)`
- `total = sumAll + packTransAll + dutyAll + ndsAll`
- `cpr_summ = totalPrint`

Пример ветки Case D:
- `total = saleCostParkingTransCustom + ndsAll`

Пример ветки Case E:
- `total = costNDS` (сумма уже содержит НДС)

**Доказательства:** `CommercialProposal.calculate()`.

#### 2.3.3 Округления
- Унифицированный helper: `CommercialProposalProduce.getRoundSum(sum, fRound)`:
  - сначала `roundN(sum, 2)`, затем при `fRound=true` -> `Math.round(...)`.

#### 2.3.4 Инварианты/валидации сохранения КП
1. `proposal_received=true` требует `date_accept`.
2. `date_accept >= cpr_date`.
3. Если валюты равны — курс обязан быть 1.
4. Если валюты различны — курс не должен быть 1.
5. Для old-version не допускаются пустые товарные строки.
6. Для Минск-склад при включённом резервировании: `requested_count <= rest_lpc_count`.
7. Для печати invoice/contract обязателен `purchasePurpose`.

**Доказательства:** `CommercialProposalAction.saveCommon()`, `CommercialProposalAction.canPrint()`, `CommercialProposalForm.isIncorrectWhen*Currencies()`.

#### 2.3.5 Статусы КП и переходы
В legacy нет отдельной enum-state-machine; статус выводится комбинацией флагов:
- **Accepted**: `cpr_proposal_received_flag = 1`.
- **Declined**: `cpr_proposal_declined = '1'`.
- **Blocked**: `cpr_block = 1`.
- **CheckPrice**: `cpr_check_price = 1` + принудительный `cpr_block = 1`.

Переходы:
- `block()` переключает `cpr_block` (toggle).
- `checkPrice()` выставляет `check_price=1`, дату, пользователя и блокирует запись.

**Доказательства:** `CommercialProposalsAction.block()/checkPrice()`, SQL `commercial_proposal-update-block`, `commercial_proposal-update-checkPrice`, `select-commercial_proposals`.

---

## 3. Non-Functional & Integration
### 3.1 Security roles (inferred)
Требование из запроса было ориентировано на `@PreAuthorize/@RolesAllowed`, но в legacy для этих экранов фактический источник — XML permissions + runtime checks:

- Меню КП: `admin,economist,manager,lawyer`.
- Меню договоров: `admin,economist,manager,lawyer,user_in_lithuania,logistic`.
- Меню контрагентов: `admin,economist,manager,lawyer,declarant,other_user_in_Minsk,logistic`.
- Внутри формы договора дополнительное ограничение read-only для ряда ролей (manager без расширенных ролей, user_in_lithuania, logistic).

**Доказательства:** `xml-permissions.xml`, `ContractAction.show()`, `CommercialProposalsAction.internalFilter()`.

### 3.2 Required master data (dictionaries)
MVP требует обязательную загрузку справочников:
1. Валюты (`DCL_CURRENCY`) + курсы (`DCL_CURRENCY_RATE`) — для кросс-валютных расчётов и округления.
2. Контрагенты (`DCL_CONTRACTOR`) + контактные лица (`DCL_CONTACT_PERSON`).
3. Логистика КП (`DCL_CPR_TRANSPORT`) минимум для распределения transport/assembling в формулах.
4. Условия поставки (IncoTerm) и ставка НДС (`cpr_nds`) как обязательные входы расчётного движка.

---

## 4. Acceptance Criteria & Parity
```gherkin
Scenario: Нельзя принять КП без даты принятия
  Given пользователь установил флаг "КП принято"
  When поле "Дата принятия" пустое
  Then сохранение отклоняется с ошибкой accepted

Scenario: Дата принятия не раньше даты КП
  Given пользователь установил флаг "КП принято"
  And заполнена "Дата принятия"
  When дата принятия < дата КП
  Then сохранение отклоняется с ошибкой date_accept

Scenario: Валюты одинаковые — курс должен быть 1
  Given валюта таблицы = валюта печати
  When курс != 1
  Then сохранение отклоняется с ошибкой equalCurrencies

Scenario: Валюты разные — курс не может быть 1
  Given валюта таблицы != валюта печати
  When курс = 1
  Then печать/сохранение отклоняется с ошибкой notEqualCurrencies

Scenario: Расчёт НДС строки
  Given sale_cost_parking_trans_custom и cpr_nds
  When выполняется calculateInString
  Then nds = round(sale_cost_parking_trans_custom * cpr_nds / 100)
  And cost_nds = round(sale_cost_parking_trans_custom + nds)

Scenario: Минск-склад режим нормализации
  Given assemble_minsk_store = true
  When открывается форма КП
  Then currencyTable и currency = BYN
  And course = 1
  And cpr_sum_transport = 0
  And cpr_sum_assembling = 0
  And customDuty по строкам принудительно 0

Scenario: Check Price блокирует КП
  Given выбран КП в списке
  When пользователь выполняет checkPrice
  Then cpr_check_price = 1
  And cpr_block = 1
  And сохраняются cpr_check_price_date и usr_id_check_price

Scenario: Конвертация КП в договор
  Given пользователь нажал "Импорт из КП"
  When выбрана КП
  Then создаётся черновик договора с полями из КП
  And создаётся спецификация №1 с суммами totalPrint и ndsPrint

Scenario: Флаг исполнения договора
  Given договор содержит спецификации
  When выполняется сохранение договора
  Then con_summ = сумма неаннулированных спецификаций
  And con_executed = '1' только если все спецификации исполнены
```

---

## 5. Risks & Unknowns
### 5.1 Выявленные риски/неоднозначности + рекомендуемое modern-решение
1. **Нет явной state machine для КП** (accepted/declined/blocked/checkPrice — набор флагов, возможны конфликтные комбинации).
   - Modern recommendation: ввести явный enum статуса + матрицу допустимых переходов; хранить legacy-флаги как compatibility слой.
2. **DDL в этом дампе не показывает явные FK в блоках таблиц**, при этом связи явно используются кодом/процедурами.
   - Modern recommendation: задать FK и индексы явно во Flyway + подготовить карту соответствия к legacy-процедурам.
3. **Сложные ветки Incoterm A/B/C/D/E в одном методе** (`calculate`) — риск регресса при переносе.
   - Modern recommendation: выделить расчётный доменный сервис по стратегиям (policy per Incoterm) + golden-master тесты на контрольных примерах.
4. **`CONTRACT.CTR_ID/CUR_ID` nullable в DDL**, но процессно фактически обязательны.
   - Modern recommendation: обсудить с бизнесом ужесточение до NOT NULL для new backend.
5. **Микс Java-логики и SQL-procedure логики** (insert/filter).
   - Modern recommendation: централизовать use-case-логику в backend сервисе, оставив SQL только для хранения/поиска.

### 5.2 Questions for Business (15)
1. Какой приоритет статусов, если одновременно `accepted=1` и `declined=1`?
2. Нужен ли отдельный финальный статус КП (например, FINALIZED), помимо block/checkPrice?
3. Нужно ли в MVP поддержать все ветки расчёта Incoterm (A/B/C/D/E) или ограничить subset?
4. Допускается ли ручная правка `cpr_summ` или только вычисление?
5. Нужна ли поддержка `reverse_calc` в MVP?
6. Для режима Минск-склад правила BYN/курс=1/нулевая таможня — строго фиксированные или конфигурируемые?
7. Нужно ли сохранять legacy формат номера КП `BYMYYMM/NNNN-...` без изменений?
8. Нужен ли аудит переходов статусов КП/договора (кто/когда/почему)?
9. Какие роли могут менять `declined` и `received`?
10. Нужна ли в MVP операция checkPrice как отдельный шаг workflow?
11. Можно ли менять валюту КП после добавления строк, и как пересчитывать существующие суммы?
12. Что считать обязательным минимумом полей контрагента в MVP?
13. В договоре допускается ли создание без контрагента/валюты (как в nullable DDL) или запрещаем?
14. Требуется ли полноценная печать (invoice/contract) уже в MVP Module 1?
15. Нужно ли переносить legacy message-механику (ContractMessage / user links) в MVP?

