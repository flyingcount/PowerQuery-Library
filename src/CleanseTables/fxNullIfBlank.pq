////////////////////////////////////////////////////////////////////////////////
// fxNullIfBlank
// Category : CleanseTables
// Description : Replaces empty or whitespace-only text values with null.
// Author      : Paul Chan
// Date        : 2026-08-08
// Source path : Function Library/CleanseTables/fxNullIfBlank
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxNullIfBlank
    Description: Replaces empty strings and whitespace-only text with null.
                 Non-text values are left unchanged. Optionally limit to a
                 list of column names; omit ColumnNames to process all columns.
    Author: Paul Chan
    Date: 2026-08-08

    Parameters:
    - InputTable: Source table.
    - ColumnNames (optional): List of column names to transform. Default = all columns.

    Example:
        fxNullIfBlank(Source)
        fxNullIfBlank(Source, {"CustomerName", "City"})
*/
let
    Source = (InputTable as table, optional ColumnNames as nullable list) as table =>
let
    TargetColumns =
        if ColumnNames = null then
            Table.ColumnNames(InputTable)
        else
            ColumnNames,

    NullIfBlank = (Value as any) as any =>
        if Value is text and Text.Trim(Value) = "" then
            null
        else
            Value,

    TransformList = List.Transform(TargetColumns, each {_, NullIfBlank}),

    ResultTable = Table.TransformColumns(InputTable, TransformList)
in
    ResultTable
in
    Source
