# Excel ETL example

Typical cleanse pipeline using functions from this library.

## Setup

1. Load a sheet/table into Power Query as `RawData`.
2. Paste these functions as separate blank queries (same names as files):
   - `fxSkipJunkHeaderRowsv2`
   - `fxTrimColumnNames`
   - `fxRemoveAllBlankColumns`
   - `fxRemoveAllBlankRows`
   - `fxCleanAllText`
   - `fxRowsRemoveDuplicates`

## Orchestrating query

```powerquery
let
    Source = Excel.CurrentWorkbook(){[Name="RawData"]}[Content],
    SkipJunk = fxSkipJunkHeaderRowsv2(Source),
    Promoted = Table.PromoteHeaders(SkipJunk, [PromoteAllScalars=true]),
    TrimHeaders = fxTrimColumnNames(Promoted),
    DropBlankCols = fxRemoveAllBlankColumns(TrimHeaders),
    DropBlankRows = fxRemoveAllBlankRows(DropBlankCols),
    CleanText = fxCleanAllText(DropBlankRows),
    Distinct = fxRowsRemoveDuplicates(CleanText)
in
    Distinct
```

## Metadata-driven variant

1. Invoke `fxGetTableMetadata` on the cleaned table and load the result to a worksheet named `ColumnMap`.
2. Edit **Keep Y/N**, rename targets in **ColumnNameDuplicate**, set **DataType**.
3. Apply:

```powerquery
let
    Source = /* cleaned table from above */,
    Map = Excel.CurrentWorkbook(){[Name="ColumnMap"]}[Content],
    Typed = fxApplyMetadataAndTypes(Source, Map)
in
    Typed
```
