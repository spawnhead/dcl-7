# commercialproposals — Expected API contracts (legacy-inferred)

- `/CommercialProposalAction.do?dispatch=edit`
- `/CommercialProposalAction.do?dispatch=input`
- `/CommercialProposalsAction`
- `/ContractorsListAction`
- `/DepartmentsListAction`
- `/StuffCategoriesListAction`
- `/UsersListAction`

Error semantics: UNKNOWN (verify via legacy runtime/HAR).

## SQL constraint alignment (Patch 0.5+)
- Request payload fields must respect SQL types/lengths/NOT NULL from mapped tables.
- Exact field-to-column mapping: UNKNOWN (requires action/DAO SQL trace).

