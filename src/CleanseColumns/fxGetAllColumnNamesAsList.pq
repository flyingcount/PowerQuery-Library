////////////////////////////////////////////////////////////////////////////////
// fxGetAllColumnNamesAsList
// Category : CleanseColumns
// Description : Returns a list of all column headers from an input table.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxGetAllColumnNamesAsList
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetAllColumnNamesAsList
    Description: Returns a list of all column headers from an input table.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as list =>
let
    // Extract the column names as a list
    AllColumns = Table.ColumnNames(InputTable)
in
    AllColumns
in
    Source
