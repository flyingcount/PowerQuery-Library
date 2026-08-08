////////////////////////////////////////////////////////////////////////////////
// fxGetFullColumnStats
// Category : CleanseColumns
// Description : Audit table schema, cardinality, and Primary Key suitability.
// Author      : Gemini
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxGetFullColumnStats
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetFullColumnStats
    Description: Audit table schema, cardinality, and Primary Key suitability.
    Author: Gemini
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    TotalRows = Table.RowCount(InputTable),
    Schema = Table.Schema(InputTable),
    BaseTable = Table.SelectColumns(Schema, {"Name", "Kind"}),

    AddStats = Table.AddColumn(BaseTable, "Stats", each 
        let
            CurrentColumn = [Name],
            ColumnData = Table.Column(InputTable, CurrentColumn),
            Nulls = List.Count(List.Select(ColumnData, each _ = null)),
            Distinct = List.Count(List.Distinct(ColumnData)),
            
            // Logic for Primary Key Candidate:
            // 1. Must have zero nulls
            // 2. Distinct Count must equal Total Row Count
            IsKeyCandidate = (Nulls = 0) and (Distinct = TotalRows)
        in
            [
                DistinctCount = Distinct, 
                NullCount = Nulls, 
                #"Null %" = if TotalRows > 0 then Nulls / TotalRows else 0,
                CardinalityFlag = if (TotalRows > 0 and Distinct / TotalRows > 0.9) then "High" else "Low/Medium",
                IsKeyCandidate = IsKeyCandidate
            ]
    ),

    Expanded = Table.ExpandRecordColumn(AddStats, "Stats", {"DistinctCount", "NullCount", "Null %", "CardinalityFlag", "IsKeyCandidate"}),
    
    // Final Typing
    Typed = Table.TransformColumnTypes(Expanded, {
        {"DistinctCount", Int64.Type}, 
        {"NullCount", Int64.Type}, 
        {"Null %", Percentage.Type},
        {"IsKeyCandidate", type logical}
    })
in
    Typed
in
    Source
