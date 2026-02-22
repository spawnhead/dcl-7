# Contractors list — Behavior Matrix

| Action / Role | admin | manager | economist | lawyer |
|---------------|-------|---------|-----------|--------|
| View list | ✓ | ✓ | ✓ | ✓ |
| Filter / Clear | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | UNCONFIRMED | ✓ | ✓ |
| Edit row | ✓ | ✓ | ✓ | ✓ |
| Block/Unblock | ✓ | ✗ | ✗ | ✗ |
| Delete row | ✓ (if !occupied) | ✗ | ✗ | ✗ |
| Delete confirm (Popconfirm) | ✓ | ✗ | ✗ | ✗ |
| Merge (v1) | — | — | — | — |
| Excel export | TBD | TBD | TBD | TBD |

## Checkers
- **blockChecker:** !currentUser.isAdmin() → block readonly.
- **show-delete-checker:** !contractor.isOccupied() → delete visible.
- **adminOrOtherUserInMinsk:** checkbox column + merge — only for admin/otherUserInMinsk.
