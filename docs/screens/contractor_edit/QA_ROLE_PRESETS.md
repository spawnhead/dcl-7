# Contractor Edit — QA Role Presets

> Ролевые пресеты для тестирования редактирования контрагента.

## 1) Admin
**Headers:**
```
X-Dev-User: dev_admin
X-Dev-Roles: admin
```

**Expected capabilities:**
- Can edit any contractor (if not blocked).
- Can delete any contractor (if not occupied).
- Can add/remove any user in «Курируют» tab.
- Can block/unblock contact persons.
- Can edit reputation field.
- Can edit comment field.
- `adminRole=true`, `readOnlyReputation=false`, `readOnlyComment=false`.

**Test scenarios:**
1. Open edit for ctrId=1 → all fields editable.
2. Delete ctrId=1 → success (if not occupied).
3. Add user in «Курируют» → any user available.
4. Block contact person → success.

## 2) Manager
**Headers:**
```
X-Dev-User: dev_manager
X-Dev-Roles: manager
```

**Expected capabilities:**
- Can edit contractor (if not blocked).
- Cannot delete contractor.
- Can add only self in «Курируют» tab (with confirm dialog).
- Cannot delete users from «Курируют».
- Cannot block contact persons.
- Reputation field is read-only.
- Comment field is read-only.
- `adminRole=false`, `readOnlyReputation=true`, `readOnlyComment=true`.

**Test scenarios:**
1. Open edit for ctrId=1 → reputation/comment readonly.
2. Delete icon hidden on contractors list.
3. Add user in «Курируют» → confirm dialog, only self added.
4. Block contact person → checkbox readonly.

## 3) Economist
**Headers:**
```
X-Dev-User: dev_economist
X-Dev-Roles: economist
```

**Expected capabilities:**
- Can edit contractor (if not blocked).
- Cannot delete contractor.
- Can add only self in «Курируют» tab.
- Cannot delete users from «Курируют».
- Cannot block contact persons.
- Reputation field is editable.
- Comment field is editable.
- `adminRole=false`, `readOnlyReputation=false`, `readOnlyComment=false`.

**Test scenarios:**
1. Open edit for ctrId=1 → all fields editable except blocked.
2. Delete icon hidden on contractors list.
3. Reputation field editable.

## 4) Manager Chief
**Headers:**
```
X-Dev-User: dev_manager_chief
X-Dev-Roles: manager_chief
```

**Expected capabilities:**
- Same as manager, but may have additional permissions (TBD based on legacy).
- `adminRole=false`, `readOnlyReputation=true`, `readOnlyComment=true`.

## 5) Blocked Contractor (any role)
**Precondition:** `ctr_block=1`

**Expected behavior:**
- `formReadOnly=true`.
- All fields disabled.
- «Сохранить» button disabled.
- «Отмена» button enabled.
- No edits possible.

**Test scenarios:**
1. Open edit for ctrId=2 (blocked) → form readonly.
2. Click «Сохранить» → disabled, no action.

## 6) Occupied Contractor (any role)
**Precondition:** `occupied=true`

**Expected behavior:**
- Edit allowed.
- Delete hidden on contractors list.
- `canDelete=false`.

**Test scenarios:**
1. View contractors list → ctrId=3 has no delete icon.
2. Open edit for ctrId=3 → edit allowed.

## 7) Role Flags Summary

| Role | adminRole | readOnlyReputation | readOnlyComment | canDelete | canBlockCP |
|------|-----------|-------------------|-----------------|-----------|------------|
| admin | true | false | false | true* | true |
| manager | false | true | true | false | false |
| economist | false | false | false | false | false |
| manager_chief | false | true | true | false | false |

*canDelete only if `occupied=false`

## 8) Dev Bypass Headers

For local development, use `X-Dev-User` and `X-Dev-Roles` headers:

```bash
# Admin
curl -H "X-Dev-User: dev_admin" -H "X-Dev-Roles: admin" http://localhost:8080/api/contractors/1/edit/open

# Manager
curl -H "X-Dev-User: dev_manager" -H "X-Dev-Roles: manager" http://localhost:8080/api/contractors/1/edit/open
```

## 9) /api/me Response

```json
{
  "name": "dev_admin",
  "department": { "id": "1", "name": "Отдел IT" },
  "chiefDepartment": false,
  "authMode": "dev",
  "roles": ["admin"]
}
```

## 10) UNCONFIRMED

- Exact role mapping for `onlyManager` and `onlyOtherUserInMinsk` — UNCONFIRMED. How to verify: check legacy `User.isOnlyManager()` and `User.isOnlyOtherUserInMinsk()` implementations.
- `manager_chief` specific permissions — UNCONFIRMED. How to verify: test in legacy UI.
