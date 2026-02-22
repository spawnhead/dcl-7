# N3a1 Contractor create — QA role presets

| Role | Access to ContractorAddActionContract | Notes |
|---|---|---|
| admin | Yes | Full actions, can delete user rows |
| economist | Yes | Access granted by permissions bundle |
| manager | Context-dependent | In common contractor permissions list, but readonly behavior applies in fields/actions |
| lawyer | Context-dependent | In common contractor permissions list |
| other_user_in_Minsk | Context-dependent | readonly reputation/comment flags apply |
| logistic/declarant | Context-dependent | per common contractor action permission list |

## Verification notes
- For N3a contract-create flow, minimum must-pass roles: admin/economist.
- Additional role access from `xml-permissions` should be regression-checked against actual business policy.
