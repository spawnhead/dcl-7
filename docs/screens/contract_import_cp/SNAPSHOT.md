# N3b — Contract import from CP (Импорт из КП) — Legacy Snapshot

> Spec pack для экрана выбора КП при импорте в договор. Доступ: Contracts list кнопка «Импорт из КП» → `/contracts/import-cp`. Восстановлено из legacy (SelectFromGridAction, CommercialProposalsAction, CommercialProposals.jsp).

## 1) Идентификация
- Legacy route: `ContractsAction.do?dispatch=selectCP&minsk_store=1` → forward → `/SelectCPContractsAction.do?dispatch=input`.
- SelectCPContractsAction: `SelectFromGridAction` — input forward = `/CommercialProposalsAction.do?dispatch=input`.
- Return: forward `return` → `/ContractAction.do?dispatch=importCP`.
- Modern route: `/contracts/import-cp`.
- Traceability: Contracts.jsp:123–125, struts-config.xml:474–482.

## 2) UI-слепок (CommercialProposals в select mode)

### 2.1 Фильтры (CommercialProposalsForm)
| Поле | Контрол | SQL param |
|------|---------|-----------|
| number | text | :number |
| department | serverList DepartmentsListAction | :department.name |
| date_begin | date | :date_begin_date |
| date_end | date | :date_end_date |
| sum_min_formatted | text (currency) | :sum_min |
| sum_max_formatted | text (currency) | :sum_max |
| user | serverList UsersListAction | :user.usr_name |
| contractor | serverList ContractorsListAction | :contractor.name |
| stuffCategory | serverList StuffCategoriesListAction | :stuffCategory.name |
| cpr_proposal_received_flag_in | checkbox value=1 | :cpr_proposal_received_flag_in |
| cpr_proposal_declined_in | checkbox value=1 | :cpr_proposal_declined_in |

Кнопки: Очистить фильтр (dispatch=input), Применить фильтр (dispatch=filter).

### 2.2 Грид КП (grid, key=cpr_id)
Колонки (порядок 1:1 CommercialProposals.jsp):
1. cpr_number, 2. cpr_date_date, 3. cpr_contractor, 4. cprSumFormatted, 5. cpr_currency,
6. cpr_stf_name, 7. reservedState, 8. attachSqr (icon), 9. cpr_block (checkbox), 10. cpr_user,
11. cpr_department, 12. cpr_check_price, 13–14. (hideOnSelectMode) clone/edit.

**В select mode:** колонки clone/edit скрыты (hideOnSelectMode). Вместо них — клик по строке вызывает `__setSelect(this, cpr_id)` → form.action = SelectCPContractsAction.do?dispatch=select, SELECT_ID=cpr_id, form.submit().

### 2.3 Кнопка «Отмена» (select mode)
В select mode FormTagEx добавляет кнопку «Отмена» — `__setSelect(this,"",1)` → submit с пустым SELECT_ID (отмена выбора).

### 2.4 Блок gridBottom (не в select mode)
Кнопки «Формировать Excel», «Создать» — в select mode скрыты (ctrl:notShowIfSelectMode).

## 3) Flow
1. Contracts: POST dispatch=selectCP, minsk_store=1 → ContractsAction.selectCP → forward.
2. SelectCPContractsAction.input: setSelectMode(session), return input forward.
3. CommercialProposalsAction.input: reset form, internalFilter → DAOUtils.fillGrid(select-commercial_proposals).
4. User clicks row: form submits to SelectCPContractsAction.do?dispatch=select, SELECT_ID=cpr_id.
5. SelectFromGridAction.select: setSelectedId(cpr_id), clearSelectMode, return forward.
6. ContractAction.importCP: getSelectedId → CommercialProposalDAO.load → contract.importFromCP → inputCommon → show.

## 4) minsk_store (UNCONFIRMED)
- Contracts.jsp: scriptUrl="minsk_store=1" при submit.
- select-commercial_proposals SQL не включает cpr_assemble_minsk_store в фильтр.
- CommercialProposalsForm.cpr_assemble_minsk_store — отдельное поле (для формы КП, не для списка).
- **Вывод из кода:** minsk_store при transition из Contracts возможно не влияет на грид КП. Требует HAR-проверки.

## 5) SQL select-commercial_proposals
`dcl_commercial_proposal_filter(:number, :contractor.name, :date_begin_date, :date_end_date, :sum_min, :sum_max, :user.usr_name, :department.name, :stuffCategory.name, :cpr_proposal_received_flag_in, :cpr_proposal_declined_in)`.

## 6) Traceability
- SelectFromGridAction.java, FormTagEx.java, ColLinkTag.
- CommercialProposalsAction.java (input, filter, internalFilter).
- CommercialProposals.jsp, CommercialProposalsForm.CommercialProposal.
- sql-resources.xml: select-commercial_proposals.
- ContractAction.importCP, Contract.importFromCP.
