# Source workbook

| File | Role |
|------|------|
| `Personal.xlsb` | Original Excel personal / function-library workbook |
| `Section1.m` | Extracted Power Query mashup section (optional working copy) |

To refresh individual `.pq` files after editing queries in Excel:

```bash
node scripts/split-section1.js
```

Requires an up-to-date `Data/Section1.m` extracted from the workbook DataMashup.
