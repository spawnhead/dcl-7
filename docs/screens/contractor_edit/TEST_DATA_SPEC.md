# Contractor Edit — Test Data Specification

> Детерминированные тестовые данные для проверки редактирования контрагента.

## 1) Existing Contractors (seed data)

### Contractor 1: Editable, not occupied
```
ctrId: "1"
ctrName: "ООО Рога и Копыта"
ctrFullName: "Общество с ограниченной ответственностью Рога и Копыта"
country.id: "BY"
ctrIndex: "220000"
ctrRegion: "Минская обл."
ctrPlace: "г. Минск"
ctrStreet: "ул. Примерная"
ctrBuilding: "д. 1"
ctrAddInfo: "офис 100"
ctrAddress: "220000, Минская обл., г. Минск, ул. Примерная, д. 1, офис 100" (computed)
ctrPhone: "+375 17 123-45-67"
ctrFax: "+375 17 123-45-68"
ctrEmail: "info@roga.by"
ctrUnp: "100000001"
ctrOkpo: "123456789"
ctrBankProps: "ОАО «Приорбанк»\nIBAN: BY36PJRBS30141345678901234\nSWIFT: PJCBBY2X"
ctrComment: "Надежный партнер"
reputation.id: "1" (Надежный)
ctrBlock: "0"
occupied: false
```

**gridUsers:**
| number | usrId | userFullName |
|--------|-------|--------------|
| 1 | dev_admin | Администратор Системы |

**gridAccounts:**
| number | accName | accAccount | currency.id |
|--------|---------|------------|-------------|
| 1 | Расчетный счет (BYN) | BY36PJRBS30141345678901234 | BYN |
| 2 | Расчетный счет (USD) | BY36PJRBS30141345678901235 | USD |
| 3 | Валютный счет | | |

**gridContactPersons:**
| number | cpsId | cpsName | cpsPosition | cpsPhone | cpsEmail | cpsFire | cpsBlock |
|--------|-------|---------|-------------|----------|----------|---------|----------|
| 1 | 1 | Иванов Иван | Директор | +375 29 111-11-11 | ivanov@roga.by | 0 | 0 |

### Contractor 2: Blocked (read-only)
```
ctrId: "2"
ctrName: "Заблокированный контрагент"
ctrFullName: "Заблокированный контрагент ООО"
country.id: "BY"
ctrBlock: "1"
occupied: false
formReadOnly: true
```

### Contractor 3: Occupied (delete hidden)
```
ctrId: "3"
ctrName: "Занятый контрагент"
ctrFullName: "Занятый контрагент ООО"
country.id: "BY"
ctrBlock: "0"
occupied: true
```
(Has related contracts/orders — delete should be hidden)

### Contractor 4: UNP duplicate test target
```
ctrId: "4"
ctrName: "УНП Тест"
ctrFullName: "УНП Тест ООО"
country.id: "BY"
ctrUnp: "200000002"
```

## 2) Users for gridUsers

| usrId | userFullName | role |
|-------|--------------|------|
| dev_admin | Администратор Системы | admin |
| dev_manager | Менеджер Иванов | manager |
| dev_economist | Экономист Петров | economist |

## 3) Lookups

### Countries
| id | name |
|----|------|
| BY | Беларусь |
| RU | Россия |
| PL | Польша |

### Reputations
| id | description |
|----|-------------|
| 1 | Надежный |
| 2 | Новый |
| 3 | Проблемный |

### Currencies
| id | name |
|----|------|
| BYN | Белорусский рубль |
| USD | Доллар США |
| EUR | Евро |
| RUB | Российский рубль |

## 4) Test Scenarios Data

### Scenario: Edit valid data
- Open ctrId=1
- Modify: `ctrPhone` → "+375 17 999-99-99"
- Save → 200

### Scenario: UNP duplicate
- Open ctrId=1
- Modify: `ctrUnp` → "200000002" (exists for ctrId=4)
- Save → 400, error

### Scenario: Account validation
- Open ctrId=1
- Go to «Расчетные счета» tab
- Fill `accAccount` for row 3 (Валютный счет), leave `currency` empty
- Save → 400, error about currency

### Scenario: Blocked contractor
- Open ctrId=2
- All fields disabled
- Save disabled

### Scenario: Delete occupied
- View contractors list
- ctrId=3 has no delete icon

### Scenario: Delete non-occupied (admin)
- View contractors list as admin
- ctrId=1 has delete icon
- Click delete, confirm → 200

## 5) Seed Migration Reference

Contractors and related data are seeded via Flyway migrations:
- `V20__init_dcl_reputation.sql` — reputations
- `V21__dev_seed.sql` — dev seed marker
- `V22__dev_seed_contractors.sql` — contractors with address/phone/email/bank_props
- `V23__dev_seed_contractor_details.sql` — additional contractor details
- `V24__dcl_contact_person.sql` — contact persons table and seed

## 6) UNCONFIRMED

- Exact `occupied` check logic (which tables are checked) — UNCONFIRMED. How to verify: inspect `Contractor.isOccupied()` in legacy code or DB.
- Exact Popconfirm text for delete — UNCONFIRMED. How to verify: delete contractor in legacy UI.
