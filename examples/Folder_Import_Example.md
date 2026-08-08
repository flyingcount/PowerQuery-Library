# Folder / multi-table import example

This library currently focuses on **table transforms**. For folder combines, use native connectors, then apply cleansers from `src/`.

## Pattern: folder of Excel/CSV → clean

```powerquery
let
    Source = Folder.Files("C:\Data\Incoming"),
    KeepCsv = Table.SelectRows(Source, each [Extension] = ".csv"),
    Combined = Table.Combine(
        List.Transform(KeepCsv[Content], each Csv.Document(_))
    ),
    Promoted = Table.PromoteHeaders(Combined, [PromoteAllScalars=true]),
    Clean = fxCleanAllText(fxRemoveAllBlankRows(fxTrimColumnNames(Promoted)))
in
    Clean
```

## Pattern: workbook tables by prefix

Use `fxCombineTablesByPrefix` (Excel only — uses `Excel.CurrentWorkbook`):

```powerquery
let
    Combined = fxCombineTablesByPrefix("Sales_")
in
    Combined
```

Place staging tables named `Sales_North`, `Sales_South`, etc. in the workbook, then expand/clean with the Cleanse* functions.
