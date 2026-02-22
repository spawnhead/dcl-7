# N3a3 Contract attachments — QA role presets

| Role | Access | Verify |
|------|--------|--------|
| admin | Full (showAttach) | Upload, download, delete, back |
| economist | Full | Same |
| lawyer | Full | Same |
| manager | Denied | No showAttach; кнопка «Прикрепить» не видна |

## Source
- Contract.showAttach: admin, economist, lawyer (xml-permissions ContractAction).
