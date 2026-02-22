# Order Edit Screen - Payloads Directory

## Overview
This directory contains network payload captures for the Order Edit screen.

## Status
**BLOCKED** - Network captures not yet available from running legacy system.

## Files

| File | Description | Status |
|------|-------------|--------|
| `network.har.BLOCKED.md` | Instructions for capturing HAR files | Created |
| `open-request.json` | Request for opening edit form | NOT CREATED |
| `open-response.json` | Response with form data | NOT CREATED |
| `save-request.json` | Request for saving order | NOT CREATED |
| `save-response.json` | Response after save | NOT CREATED |
| `payments-grid-request.json` | AJAX request for payments grid | NOT CREATED |
| `payments-grid-response.html` | AJAX response HTML | NOT CREATED |
| `pay-sums-grid-request.json` | AJAX request for pay sums grid | NOT CREATED |
| `pay-sums-grid-response.html` | AJAX response HTML | NOT CREATED |

## How to Capture Payloads

1. Start legacy application
2. Open browser DevTools (F12)
3. Go to Network tab
4. Perform operations
5. Export HAR with content
6. Extract request/response bodies to JSON files

## Notes

- All payloads should be anonymized (remove real user data)
- Use test data from TEST_DATA_SPEC.md
- Document any discrepancies between expected and actual format
