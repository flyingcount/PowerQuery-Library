# Folder / multi-table import example

## Pattern: folder of Excel/CSV → clean

```powerquery
let
    Combined = fxCombineFolderFiles("C:\Data\Incoming"),
    Clean = fxCleanAllText(fxRemoveAllBlankRows(fxTrimColumnNames(Combined)))
in
    Clean
```

CSV-only:

```powerquery
fxCombineFolderFiles("C:\Data\Incoming", {".csv"})
```

## Pattern: all sheets in one workbook

```powerquery
let
    Combined = fxExpandExcelSheets("C:\Data\Sales.xlsx"),
    Clean = fxNullIfBlank(fxTrimColumnNames(Combined))
in
    Clean
```

Sheets whose names contain `"Actual"`:

```powerquery
fxExpandExcelSheets("C:\Data\Sales.xlsx", "Actual")
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
