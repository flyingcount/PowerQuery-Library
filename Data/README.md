# Source workbook

| File | Role |
|------|------|
| `Section1.m` | Extracted Power Query mashup section (optional working copy) |

Personal VBA workbook and add-in source moved to [Excel-VBA-Library](https://github.com/flyingcount/Excel-VBA-Library).

To refresh individual `.pq` files after editing queries in Excel:

```bash
node scripts/split-section1.js
```

Requires an up-to-date `Data/Section1.m` extracted from the workbook DataMashup.
