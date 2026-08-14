# Power Query Library

Reusable **Power Query (M)** functions for Excel and Power BI — cleansing, profiling, metadata-driven typing, sampling, control-chart diagnostics, and encoding helpers.

Originally curated in a personal workbook (`Data/Personal.xlsb`) and organised here as a GitHub-friendly source library.

Power Query M lives under `src/`. Excel VBA lives in a separate repo: [Excel-VBA-Library](https://github.com/flyingcount/Excel-VBA-Library).

## Repository layout

```text
.
├── README.md
├── CHANGELOG.md
├── LICENSE
├── src/                    ← Power Query (.pq)
├── examples/
├── templates/
├── tests/
├── docs/
├── prompts/                ← reusable Cursor prompts (GitHub-synced)
└── .cursor/rules/          ← project rules, including prompt-library.mdc
```

## Quick start (Excel)

1. Open **Power Query Editor** (Data → Get Data / Transform).
2. Create a **Blank Query** → Advanced Editor.
3. Paste the contents of a `.pq` file from `src/`.
4. Rename the query to match the function (e.g. `fxRemoveAllBlankRows`).
5. Invoke from another query, for example:

```powerquery
let
    Source = Excel.CurrentWorkbook(){[Name="MyTable"]}[Content],
    Cleaned = fxRemoveAllBlankRows(Source)
in
    Cleaned
```

### Personal workbook / Function Library folders

Functions were originally nested as:

`Function Library/<Category>/<FunctionName>`

In this repo each function lives at:

`src/<Category>/<FunctionName>.pq`

## Quick start (Power BI Desktop)

1. Home → Transform data → New Source → Blank Query.
2. Paste a function from `src/` into Advanced Editor.
3. Use **Invoke Custom Function** or reference it from other queries in the same model.

## Function categories

| Folder | Focus |
|--------|--------|
| `CleanseColumns` | Blank/constant columns, header trim, column selection & stats |
| `CleanseRows` | Junk headers, blank rows, null/trim cleanup, distinct rows |
| `CleanseTables` | Table-wide null/`Text.Trim`/`Text.Clean` |
| `Info` | Schema, profiling, allowed types |
| `DataPreProcessing` | Metadata maps, type application, random sample |
| `Dates` | Date parts; combine workbook tables by name prefix |
| `Files` | Combine folder CSV/Excel; expand workbook sheets |
| `ControlCharts` | Calendar / date dimension generator |
| `Sampling` | X̄–mR diagnostics & Western Electric rules |
| `AddColumn` | Running total, % of category |
| `MLEncoder` | One-hot and label encoding |

Full inventory: [docs/FunctionCatalog.md](docs/FunctionCatalog.md)

## Conventions

- Prefix functions with `fx` (e.g. `fxTrimAll`).
- One function per `.pq` file; file name = function name.
- Prefer typed parameters (`as table`, `as text`, …) and short header comments.
- See [docs/NamingConvention.md](docs/NamingConvention.md) and [docs/CodingStandards.md](docs/CodingStandards.md).
- Reusable Agent prompts live in [prompts/](prompts/README.md). The rule `.cursor/rules/prompt-library.mdc` governs how they are added, updated, and pushed to GitHub.

## Regenerating from the workbook

If you update queries in `Data/Personal.xlsb`:

1. Extract `Formulas/Section1.m` from the workbook DataMashup (or refresh `Data/Section1.m`).
2. Run:

```bash
node scripts/split-section1.js
```

## License

MIT — see [LICENSE](LICENSE).
