////////////////////////////////////////////////////////////////////////////////
// fxTrimAll
// Category : CleanseTables
// Description : Trims whitespace from text cells while preserving numbers, dates, and other types. Does not trim the column header
// Author      : Gemini
// Date        : 2026-03-06
// Source path : Function Library/CleanseTables/fxTrimAll
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxMassTrim
    Description: Trims whitespace from text cells while preserving numbers, dates, and other types. Does not trim the column header
    Author: Gemini
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // Get the list of all column names
    ColNames = Table.ColumnNames(InputTable),

    // Create a transformation list: {ColumnName, TransformationFunction}
    // We only apply Text.Trim if the value is actually text
    TransformList = List.Transform(ColNames, each {
        _, 
        (Value) => if Value is text then Text.Trim(Value) else Value
    }),

    // Apply all transformations at once
    ResultTable = Table.TransformColumns(InputTable, TransformList)
in
    ResultTable
in
    Source
