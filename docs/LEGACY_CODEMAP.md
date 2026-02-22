# Legacy Code Map

Source tree: `src/main`.

## Entry points & web configuration
- **Struts 1.2 ActionServlet** is mapped to `*.do` with configuration at `/WEB-INF/classes/resources/struts/struts-config.xml`.
- **API servlet**: `net.sam.dcl.api.ApiDispatchServlet` mapped to `/api/*`.
- **Filters**: request/response setup, Hibernate session, defender/auth, config reload, and API/UI routing filters.
- **Session listener**: `net.sam.dcl.session.SessionListener` handles session end cleanup (record unlocking).

## Struts configuration
- **Action mappings**: 336 action mappings defined in `struts-config.xml`.
- **Form beans**: 174 form beans defined in `struts-config.xml`.

## Java package map (top-level)
- `net.sam.dcl.action`: Struts Actions for CRUD screens and workflows.
- `net.sam.dcl.controller`: controller utilities and action helpers.
- `net.sam.dcl.dao`: data access objects (Hibernate/JDBC patterns).
- `net.sam.dcl.service`: service layer / business operations.
- `net.sam.dcl.dbo`: database object models/entities.
- `net.sam.dcl.form`: Struts form beans.
- `net.sam.dcl.filters`: servlet filters (auth, session, config, API).
- `net.sam.dcl.session`: session management/listeners.
- `net.sam.dcl.api`: API servlet + API routing/filtering.
- `net.sam.dcl.navigation`: menu/navigation helpers.
- `net.sam.dcl.taglib`: custom JSP taglibs.
- `net.sam.dcl.report`: reporting utilities.
- `net.sam.dcl.tasks`: background tasks.
- `net.sam.dcl.util`: shared utilities.
- `net.sam.dcl.message`: messaging/notification helpers.
- `net.sam.dcl.locking`: record-locking utilities.
- `net.sam.dcl.log`: logging utilities.
- `net.sam.dcl.config`: config loading.
- `net.sam.dcl.servlet`: servlets (init, API dispatch).
- `net.sam.dcl.test`: test harness & Struts test actions/forms.

Other packages include third-party or vendor utilities:
- `org.ditchnet.*` (taglibs, XML utilities)
- `by.nbrb.www` and `net.sam.*` supporting packages

## UI layer map

### JSP entry points
- Primary screens live in `src/main/webapp/jsp/*.jsp`.
- AJAX fragments are in `src/main/webapp/ajax/*.jsp`.
- Layout and tiles definitions are in `src/main/webapp/layout*` and `src/main/webapp/layout-items`.
- Dialogs live in `src/main/webapp/dialogs`.
- Misc UI entry files in `src/main/webapp/index.jsp`, `browser_check.html`, and `trusted` directories.

### Notable screen groups (by naming)
- Commercial proposals, contracts, orders, delivery requests, shipping, payments.
- Reference data lists (countries, currencies, units, routes, purposes, NDS rates).
- Production and cost calculation screens (produce cost, specification import, montage adjustments).
- Administration (users/roles, settings, logs, sessions, actions/permissions).

