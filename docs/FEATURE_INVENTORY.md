# Feature Inventory (Legacy)

Source references:
- Struts action mappings and form beans in `src/main/webapp/WEB-INF/classes/resources/struts/struts-config.xml`.
- JSP screens in `src/main/webapp/jsp/*.jsp` and AJAX fragments in `src/main/webapp/ajax/*.jsp`.

## Authentication & session
- Login/logout, permission checks, no-permission screen.
- Session tracking, locked records handling, global lock errors.

## Commercial proposals
- Commercial proposals list/detail, print, and produce associations.
- Produce lists for commercial proposals and related transport data.
- Import operations for commercial proposals.

## Contracts & specifications
- Contracts list/detail, conditions for contract, contract close, and contract messages.
- Specification management, specification import + import positions.
- Specification payments and linkage between contracts and specifications.

## Orders & order fulfillment
- Orders list/detail, order print, executed produces, statistics, logistics, and unexecuted views.
- Order payments, pay sums, and linked orders grid.

## Delivery & shipping
- Delivery requests list/detail, positions, and produce assignments.
- Shipping list/detail, positions, managers, and shipping reports.
- Shipping document types and notice/covering letter prints.

## Payments & finance
- Payments list/detail, pay sums, payment summaries.
- Currency and currency rate management.
- NDS (VAT) rate reference management.

## Production & cost calculation
- Produce cost lists, detail, positions, custom cost, cost reports.
- Assemble operations and positions, montage adjustments with history.
- Production terms, goods circulation, goods rest.

## Contractors & contacts
- Contractors list/detail, merge contractors, contractor requests and prints.
- Contact persons list/detail and assignment to users.

## Reference data & catalogs
- Countries, languages, units, routes, sellers, departments.
- Purposes, purchase purposes, stuff categories, custom codes and history.
- Inco terms, delivery conditions, serial number list.

## Administration & settings
- Users, roles, action roles, user settings.
- System settings and configuration pages.
- Logs, journals, sessions, reports, current works.

## Attachments & files
- Attachments management, file paths, multiple file upload, deferred uploads.

## Imports & utilities
- Import file handling, specification import, order import, condition for contract import.
- Smart import and custom import helpers.

## Traceability map (feature → Struts Action / JSP / DAO)
- **Countries (reference data)**: `CountriesAction`, `CountryAction`, `CountriesListAction` → `Countries.jsp`, `Country.jsp` → `CountryDAO`.
- **Currencies & rates**: `CurrenciesAction`, `CurrencyAction`, `CurrencyRatesAction`, `CurrencyRateAction` → `Currencies.jsp`, `currency.jsp`, `CurrencyRates.jsp`, `CurrencyRate.jsp` → `CurrencyDAO`, `CurrencyRateDAO`.
- **Units & routes**: `UnitsAction`, `UnitAction`, `RoutesAction`, `RouteAction` → `Units.jsp`, `Unit.jsp`, `Routes.jsp`, `Route.jsp` → `UnitDAO`, `RouteDAO`.
- **Orders**: `OrdersAction`, `OrderAction`, `OrderProduceAction`, `OrdersStatisticsAction`, `OrdersUnexecutedAction`, `OrdersLogisticsAction` → `Orders.jsp`, `Order.jsp`, `OrderProduce.jsp`, `OrdersStatistics.jsp`, `OrdersUnexecuted.jsp`, `OrdersLogistics.jsp` → `OrderDAO`, `OrderProduceDAO`.
- **Contracts**: `ContractsAction`, `ContractAction`, `ConditionsForContractAction`, `ConditionForContractAction` → `Contracts.jsp`, `Contract.jsp`, `ConditionsForContract.jsp`, `ConditionForContract.jsp` → `ContractDAO`, `ConditionForContractDAO`.
- **Contractors & requests**: `ContractorsAction`, `ContractorAction`, `ContractorRequestsAction`, `ContractorRequestAction` → `contractors.jsp`, `contractor.jsp`, `ContractorRequests.jsp`, `ContractorRequest.jsp` → `ContractorDAO`, `ContractorRequestDAO`.
- **Shipping & delivery**: `ShippingsAction`, `ShippingAction`, `ShippingPositionsAction`, `ShippingReportAction`, `DeliveryRequestsAction`, `DeliveryRequestAction` → `Shippings.jsp`, `Shipping.jsp`, `ShippingPositions.jsp`, `ShippingReport.jsp`, `DeliveryRequests.jsp`, `DeliveryRequest.jsp` → `ShippingDAO`, `ShippingPositionDAO`, `DeliveryRequestDAO`.
- **Payments**: `PaymentsAction`, `PaymentAction`, `PaySumAction` → `Payments.jsp`, `Payment.jsp`, `PaySum.jsp` → `PaymentDAO`, `PaySumDAO`.
- **Produce cost**: `ProduceCostAction`, `ProduceCostPositionsAction`, `ProduceCostReportAction` → `ProduceCost.jsp`, `ProduceCostPositions.jsp`, `ProduceCostReport.jsp` → `ProduceCostDAO`, `ProduceCostProduceDAO`.
- **Users & roles**: `UsersAction`, `UserAction`, `RolesAction`, `RoleAction`, `ActionRolesAction` → `users.jsp`, `user.jsp`, `Roles.jsp`, `Role.jsp`, `ActionRoles.jsp` → `UserDAO`, `RoleDAO`, `ActionDAO`.
