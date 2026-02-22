# Domain Analysis (Initial)

This is an initial pass based on:
- Database objects in `db/Lintera_dcl-5_schema.ddl`.
- Struts action mappings and JSP screen names in `src/main/webapp/WEB-INF/classes/resources/struts/struts-config.xml` and `src/main/webapp/jsp`.

## Candidate bounded contexts & aggregates (to be validated)

### Security & access
- **Aggregate roots**: User (`DCL_USER`), Role (`DCL_ROLE`), Action/Permission (`DCL_ACTION`).
- **Supporting tables**: `DCL_USER_ROLE`, `DCL_ACTION_ROLE`, `DCL_USER_LINK`, `DCL_USER_SETTING`.
- **Legacy entry points**: Users/Roles/ActionRoles screens and actions.

### Contractors & contacts
- **Aggregate roots**: Contractor (`DCL_CONTRACTOR`), ContactPerson (`DCL_CONTACT_PERSON`).
- **Supporting tables**: `DCL_CONTACT_PERSON_USER`, `DCL_CONTRACTOR_USER`, `DCL_CONTRACTOR_REQUEST`.
- **Legacy entry points**: Contractors, Contractor Requests, Contact Persons screens/actions.

### Contracts & specifications
- **Aggregate roots**: Contract (`DCL_CONTRACT`), ContractClosed (`DCL_CONTRACT_CLOSED`).
- **Supporting tables**: `DCL_CON_LIST_SPEC`, `DCL_CON_MESSAGE`, `DCL_CTC_LIST`, `DCL_CTC_PAY`, `DCL_CTC_SHP`, `DCL_SPC_LIST_PAYMENT`.
- **Legacy entry points**: Contracts, Conditions for Contract, Specification and Specification Import screens.

### Commercial proposals
- **Aggregate roots**: Commercial Proposal (`DCL_COMMERCIAL_PROPOSAL`).
- **Supporting tables**: `DCL_CPR_LIST_PRODUCE`, `DCL_CPR_TRANSPORT`.
- **Legacy entry points**: Commercial Proposals, Commercial Proposal Produce, and related print/import actions.

### Orders & payments
- **Aggregate roots**: Order (`DCL_ORDER`), Payment (`DCL_PAYMENT`).
- **Supporting tables**: `DCL_ORD_LIST_PRODUCE`, `DCL_ORD_LIST_PAYMENT`, `DCL_ORD_LIST_PAY_SUM`, `DCL_PAY_LIST_SUMM`.
- **Legacy entry points**: Orders, Order Produce, Order Payments, Pay Sum, Orders Statistics.

### Delivery & shipping
- **Aggregate roots**: Delivery Request (`DCL_DELIVERY_REQUEST`), Shipping (`DCL_SHIPPING`).
- **Supporting tables**: `DCL_DLR_LIST_PRODUCE`, `DCL_SHP_LIST_PRODUCE`, `DCL_READY_FOR_SHIPPING`.
- **Legacy entry points**: Delivery Requests, Shipping, Shipping Positions, Shipping Reports.

### Production & assembly
- **Aggregate roots**: Produce (`DCL_PRODUCE`), Assemble (`DCL_ASSEMBLE`).
- **Supporting tables**: `DCL_ASM_LIST_PRODUCE`, `DCL_OPR_LIST_EXECUTED`, `DCL_PRODUCTION_TERM`.
- **Legacy entry points**: Assembles, Assemble Positions, Produce Movement, Current Works.

### Costing & calculations
- **Aggregate roots**: Produce Cost (`DCL_PRODUCE_COST`).
- **Supporting tables**: `DCL_PRODUCE_COST_CUSTOM`, `DCL_PRC_LIST_PRODUCE`.
- **Legacy entry points**: Produce Cost, Produce Cost Positions, Produce Cost Report.

### Reference data
- **Aggregate roots**: Country, Currency, Unit, Route, Seller, Department, Language, NDS Rate, Purpose.
- **Supporting tables**: `DCL_COUNTRY`, `DCL_CURRENCY`, `DCL_CURRENCY_RATE`, `DCL_UNIT`, `DCL_ROUTE`, `DCL_SELLER`, `DCL_DEPARTMENT`, `DCL_LANGUAGE`, `DCL_RATE_NDS`, `DCL_PURPOSE`, `DCL_PURCHASE_PURPOSE`, `DCL_STUFF_CATEGORY`, `DCL_SHP_DOC_TYPE`, `DCL_TERM_INCO`.
- **Legacy entry points**: Reference data screens and lists.

### Communication & logs
- **Aggregate roots**: Outgoing Letter (`DCL_OUTGOING_LETTER`), Instruction (`DCL_INSTRUCTION`).
- **Supporting tables**: `DCL_INF_MESSAGE`, `DCL_LOG`, `DCL_FIELD_COMMENT`.
- **Legacy entry points**: Outgoing Letters, Instructions, Logs, Journals.

### Attachments & files
- **Aggregate roots**: Attachment (`DCL_ATTACHMENT`), FilesPath (`DCL_FILES_PATH`).
- **Legacy entry points**: Attachments, File Paths, File Upload screens.

## Business rules & state machines (to confirm)
- Triggers assign IDs via generators; any additional trigger logic should be captured and reimplemented in domain/application layer or DB migration.
- Status/state transitions are likely implemented in DAO/service code and via flags on order/contract/shipping tables; needs deeper inspection of `net.sam.dcl.dao` and `net.sam.dcl.service`.

## Traceability gaps to address next
- For each domain above, map specific Actions → Service/DAO → Tables.
- Identify validations in form beans and JSPs (required fields, format constraints).
- Locate any SQL queries that emulate FK relationships (since DDL has no FK constraints).
