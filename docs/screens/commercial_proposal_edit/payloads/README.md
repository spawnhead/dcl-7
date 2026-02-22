# Commercial Proposal Edit Screen - Payloads Directory

## Overview
This directory contains network payload captures for the Commercial Proposal Edit screen.

## Status
**BLOCKED** - Network captures not yet available from running legacy system.

## Files

| File | Description | Status |
|------|-------------|--------|
| `network.har.BLOCKED.md` | Instructions for capturing HAR files | Created |
| `open-request.json` | Request for opening edit form | NOT CREATED |
| `open-response.json` | Response with form data | NOT CREATED |
| `save-request.json` | Request for saving CP | NOT CREATED |
| `save-response.json` | Response after save | NOT CREATED |
| `produces-grid-request.json` | AJAX request for produces grid | NOT CREATED |
| `produces-grid-response.html` | AJAX response HTML | NOT CREATED |
| `minsk-grid-request.json` | AJAX request for Minsk grid | NOT CREATED |
| `minsk-grid-response.html` | AJAX response HTML | NOT CREATED |
| `toggle-nds-request.json` | AJAX toggle NDS request | NOT CREATED |
| `import-excel-request.txt` | Multipart import request | NOT CREATED |

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
- Pay special attention to Minsk store mode payloads
