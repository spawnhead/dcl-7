# N3a2 Contract specification create — QA role presets

| Role | Access | Editability expectation |
|---|---|---|
| admin | Allowed | Full edit; can edit executed constraints where allowed |
| economist | Allowed | Editable when spec not executed |
| lawyer | Allowed | Editable when spec not executed |
| manager-only | Allowed by common contracts permission | Form readonly |
| onlyUserInLithuania | Allowed by contracts permission | Form readonly; attach file visibility restricted by seller rule |
| onlyLogistic | Allowed by contracts permission | Form readonly |

## Source of truth
- Permissions: `/SpecificationAction.do` in contracts permission block.
- Runtime readonly: `SpecificationAction.input()` role logic.
