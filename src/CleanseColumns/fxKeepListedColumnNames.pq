////////////////////////////////////////////////////////////////////////////////
// fxKeepListedColumnNames
// Category : CleanseColumns
// Description : Returns a table containing only columns that match any string in a provided list.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxKeepListedColumnNames
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxSelectColumnsByKeyword
    Description: Returns a table containing only columns that match any string in a provided list.
    Author: Paul Chan
    Date: 2026-03-06

    The SearchList can be a list in Power Query or input manually as {item1, item2, ...}

*/
let
    Source = (InputTable as table, SearchList as list) as table =>
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
    ),
    
    // Extract the final table with only those columns
    ResultTable = Table.SelectColumns(InputTable, SelectedColumns)
in
    ResultTable
in
    Source
