////////////////////////////////////////////////////////////////////////////////
// fxRemoveAllBlankColumns
// Category : CleanseColumns
// Description : Removes columns where all columns are null or empty.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxRemoveAllBlankColumns
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxRemoveAllBlankColumns
    Description: Removes columns where all columns are null or empty.
    Author: Paul Chan
    Date: 2026-03-06
*/
(InputTable as table) as table =>
// Remove all blank columns from a table
let
    // Get all column names from the table
    AllColumns = Table.ColumnNames(InputTable),
    
    // Identify columns where all values are either null or ""
    ColstoRemove = List.Select(AllColumns, each 
        let
            // Extract the current column as a list
            CurrentColumn = Table.Column(InputTable, _),
            // Replace empty strings with null so they count as "empty"
            NormalizedList = List.Transform(CurrentColumn, each if _ = "" then null else _)
        in
            List.NonNullCount(NormalizedList) = 0
    ),
    
    // Remove the identified columns
    RemoveBlankCols = Table.RemoveColumns(InputTable, ColstoRemove)
in
    RemoveBlankCols
