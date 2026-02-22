# Commercial Proposals List Screen - Payloads Directory

## Overview
This directory contains network payload captures for the Commercial Proposals List screen.

## Status
**BLOCKED** - Network captures not yet available from running legacy system.

## Files

| File | Description | Status |
|------|-------------|--------|
| `network.har.BLOCKED.md` | Instructions for capturing HAR files | Created |
| `filter-request.json` | Request for filtering list | NOT CREATED |
| `filter-response.json` | Response with filtered grid | NOT CREATED |
| `block-request.json` | Request for blocking CP | NOT CREATED |
| `export-response.xls` | Excel export file | NOT CREATED |

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
