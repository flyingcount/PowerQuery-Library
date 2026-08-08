////////////////////////////////////////////////////////////////////////////////
// DimensionTable_Template
// Description : Starter pattern for a dimension: cleanse → distinct → surrogate key.
////////////////////////////////////////////////////////////////////////////////

let
    Source = Excel.CurrentWorkbook(){[Name="DimSource"]}[Content],

    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    TrimHeaders = fxTrimColumnNames(Promoted),
    CleanText = fxCleanAllText(fxRemoveAllBlankRows(TrimHeaders)),

    // Keep business key columns only (edit list)
    Selected = Table.SelectColumns(CleanText, {"BusinessKey", "Attribute1", "Attribute2"}),

    Distinct = fxRowsRemoveDuplicates(Selected),

    WithSurrogate = Table.AddIndexColumn(Distinct, "DimKey", 1, 1, Int64.Type)
in
    WithSurrogate
