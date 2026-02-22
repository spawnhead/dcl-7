# Orders payload samples

These are canonical examples derived from legacy code (`Orders.jsp`, `OrdersAction`, `OrdersForm`, SQL mapping) and intended for parity implementation.

Required coverage included:
- filtering request (`list-filter.request.json`),
- paging requests (`list-grid-next.request.json`, `list-grid-prev.request.json`),
- dependent reload request (`list-reload.request.json`),
- HTML response interpretation + row field sample (`list-response.sample.json`).

Pending: replace/augment with real legacy HAR-captured payload snapshots.
