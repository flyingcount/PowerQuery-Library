////////////////////////////////////////////////////////////////////////////////
// fxGetMatchingColumnNames
// Category : CleanseColumns
// Description : Returns a list of column names that contain any of the strings in the SearchList.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxGetMatchingColumnNames
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetMatchingColumnNames
    Description: Returns a list of column names that contain any of the strings in the SearchList.
    Author: Paul Chan
    Date: 2026-03-06
*/
(InputTable as table, SearchList as list) as list =>
let
    // Get all column names from the input table
    AllColumns = Table.ColumnNames(InputTable),
    
    // Identify columns that contain any of the strings in the SearchList
    SelectedColumns = List.Select(AllColumns, each 
        let 
            CurrentColumnName = _,
            // Check if this column name contains any item from our list
            Matches = List.AnyTrue(List.Transform(SearchList, each Text.Contains(CurrentColumnName, _)))
        in 
            Matches
    )
in
    SelectedColumns
