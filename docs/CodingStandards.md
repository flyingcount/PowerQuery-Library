# Coding Standards

## File header

Every `.pq` file should start with a short banner:

```powerquery
////////////////////////////////////////////////////////////////////////////////
// fxExample
// Category : CleanseRows
// Description : One-line summary of behaviour.
// Author      : Your Name
// Date        : YYYY-MM-DD
////////////////////////////////////////////////////////////////////////////////
```

## Function shape

Prefer a typed function expression:

```powerquery
(InputTable as table) as table =>
let
    Result = Table.Distinct(InputTable)
in
    Result
```

When you need nested helpers, the `let Source = (… ) => … in Source` pattern is fine — keep the **public** parameter list clear.

## Style

1. **Immutability** — name each step; avoid mutating “the same” variable meaning.
2. **Null safety** — treat `null` and `""` explicitly when cleansing text.
3. **Types** — set types on outputs where practical (`type text`, `Int64.Type`, `Percentage.Type`).
4. **Comments** — explain *why* or non-obvious logic; skip narrating every `Table.ColumnNames`.
5. **Errors** — use `error "message"` for configuration/audit failures (see `fxApplyMetadataAndTypes`).
6. **Performance** — `Table.Buffer` / `List.Buffer` only when needed for repeated scans or sampling.

## Do / don’t

| Do | Don’t |
|----|--------|
| Parameterise column names | Hard-code column names like `"Colour"` unless documenting a sample |
| Keep functions pure (table in → table/list out) | Hide workbook side effects unless the function is workbook-scoped (e.g. `Excel.CurrentWorkbook`) |
| Handle empty tables safely | Assume `List.Count` / averages without null checks on analytics functions |

## Pull requests

- One logical change per PR (new function, fix, or docs).
- Update `docs/FunctionCatalog.md` (or regenerate via `scripts/split-section1.js` + catalog) when adding functions.
- Add a short entry under `CHANGELOG.md`.
- Include a manual test note under `tests/` when behaviour is non-trivial.
