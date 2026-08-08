////////////////////////////////////////////////////////////////////////////////
// FactTable_Template
// Description : Starter pattern for a fact table: cleanse → metadata types → keys.
// Replace Source / column names for your model.
////////////////////////////////////////////////////////////////////////////////

let
    // 1) Land raw data
    Source = Excel.CurrentWorkbook(){[Name="FactSource"]}[Content],

    // 2) Structural cleanse (requires library functions in the same workbook/model)
    SkipJunk = fxSkipJunkHeaderRowsv2(Source),
    Promoted = Table.PromoteHeaders(SkipJunk, [PromoteAllScalars = true]),
    TrimHeaders = fxTrimColumnNames(Promoted),
    DropBlankCols = fxRemoveAllBlankColumns(TrimHeaders),
    DropBlankRows = fxRemoveAllBlankRows(DropBlankCols),
    CleanText = fxCleanAllText(DropBlankRows),

    // 3) Optional: apply a worksheet/map table named ColumnMap
    // Map = Excel.CurrentWorkbook(){[Name="ColumnMap"]}[Content],
    // Typed = fxApplyMetadataAndTypes(CleanText, Map),
    Typed = CleanText,

    // 4) Enforce grain / surrogate key as needed
    WithIndex = Table.AddIndexColumn(Typed, "FactKey", 1, 1, Int64.Type)
in
    WithIndex
