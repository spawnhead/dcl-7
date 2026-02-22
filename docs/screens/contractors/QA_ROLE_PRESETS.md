# Contractors list — QA role presets

## 1) admin
- `X-Dev-User: admin.contractors`
- `X-Dev-Roles: admin`
- `X-Dev-Department-Id: 10`

Ожидание: Create, Edit, Block, Delete (если !occupied).

## 2) manager
- `X-Dev-User: manager.contractors`
- `X-Dev-Roles: manager`
- `X-Dev-Department-Id: 20`

Ожидание: Create UNCONFIRMED; Edit ✓; Block readonly; Delete ✗.

## 3) economist
- `X-Dev-User: economist.contractors`
- `X-Dev-Roles: economist`
- `X-Dev-Department-Id: 30`

Ожидание: Create ✓; Edit ✓; Block readonly; Delete ✗.

## 4) lawyer
- `X-Dev-User: lawyer.contractors`
- `X-Dev-Roles: lawyer`

Ожидание: Create ✓; Edit ✓; Block readonly; Delete ✗.
