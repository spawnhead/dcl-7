# N3a1 Contractor create — Behavior matrix

| Scenario | Trigger | Expected behavior | Legacy trace |
|---|---|---|---|
| Open create | Contract -> Add contractor | 5 tabs; defaults (1 user + 3 accounts); active main tab | ContractorAction.create/input |
| Add user row | `addRowInUserGrid` | new row appended; non-admin row prefilled with current user | ContractorAction.addRowInUserGrid |
| Delete user row | `deleteRowFromUserGrid` | row removed if number matches; admin-only visibility | contractor.jsp + showDeleteUserForAdmin |
| Add account row | `addRowInAccountGrid` | row appended; first 3 rows pre-labeled by account types | ContractorAction.addRowInAccountGrid |
| Delete account row | `deleteRowFromAccountGrid` | row removed; delete button hidden when <=3 rows | show-delete-checker |
| Toggle contact fire/block | checkbox click | `cps_fire`/`cps_block` toggled in-session; tab stays contactPersons | ContractorAction.fireContactPerson/blockContactPerson |
| Save valid | `process` | insert/update + save users/accounts/contacts + set `currentContractorId` | ContractorAction.process |
| Save valid feedback | `process` | success feedback: «Контрагент успешно сохранен» | Modern UX requirement (legacy text UNCONFIRMED) |
| Save invalid duplicate UNP | `process` | error `error.contractorpage.duplicate_unp`, no persist | ContractorDAO.loadByUNP |
| Save invalid accounts | `process` | account errors + active tab `accountsContractor` | ContractorAction.process |
| Cancel | `back` | return to Contract (`retFromContractor`) without save | struts-config forward |
