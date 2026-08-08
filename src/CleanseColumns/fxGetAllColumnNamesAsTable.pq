////////////////////////////////////////////////////////////////////////////////
// fxGetAllColumnNamesAsTable
// Category : CleanseColumns
// Description : Returns a single-column table containing all column names from an input table.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxGetAllColumnNamesAsTable
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetAllColumnNamesAsTable
    Description: Returns a single-column table containing all column names from an input table.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // 1. Get column names as a list
    AllColumnsList = Table.ColumnNames(InputTable),
    
    // 2. Convert that list into a single-column table
    // The string "ColumnHeaders" below sets the column header name
    HeadersTable = Table.FromList(AllColumnsList, Splitter.SplitByNothing(), {"ColumnHeaders"}, null, ExtraValues.Error)
in
    HeadersTable
in
    Source
