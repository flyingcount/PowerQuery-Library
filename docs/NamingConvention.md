# Naming Convention

## Functions

| Rule | Example |
|------|---------|
| Prefix with `fx` | `fxRemoveAllBlankRows` |
| PascalCase after the prefix | `fxGetTableProfile` |
| Verb-first names | `fxSkip…`, `fxRemove…`, `fxGet…`, `fxAdd…` |
| File name = function name + `.pq` | `fxTrimAll.pq` |
| One function per file | — |

Avoid spaces in query names (legacy workbook path `fx TrimColumnNames` is normalised to `fxTrimColumnNames` in this repo).

## Folders (`src/`)

Group by capability, not by project:

| Folder | Use for |
|--------|---------|
| `CleanseColumns` | Column-level cleanup / selection |
| `CleanseRows` | Row-level cleanup |
| `CleanseTables` | Whole-table text/null transforms |
| `Info` | Schema, profiling, reference helpers |
| `DataPreProcessing` | Metadata-driven ETL steps |
| `Dates` | Date / calendar / workbook date helpers |
| `ControlCharts` | SPC / control-chart support |
| `Sampling` | Sampling & diagnostic sampling |
| `AddColumn` | Derived columns |
| `MLEncoder` | Encoding for modelling prep |
| `Files` | Folder / workbook ingestion helpers |

Add a new folder only when a clear category emerges (e.g. `Validation/`).

## Parameters

| Preference | Example |
|------------|---------|
| `InputTable` / `SourceTable` / `tbl` for tables | `(InputTable as table)` |
| Explicit column name as `text` | `ColumnName as text` |
| Optional params marked `optional` / `nullable` | `optional TopN as nullable number` |

## Workbook folder paths (optional)

If you keep a personal Excel Function Library, mirror repo folders:

`Function Library/<Category>/<FunctionName>`
