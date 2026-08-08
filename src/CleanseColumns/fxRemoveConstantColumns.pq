////////////////////////////////////////////////////////////////////////////////
// fxRemoveConstantColumns
// Category : CleanseColumns
// Description : Deletes any column where every row contains the exact same value.
// Author      : Gemini
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fxRemoveConstantColumns
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxRemoveConstantColumns
    Description: Deletes any column where every row contains the exact same value.
    Author: Gemini
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // 1. Get the list of all column names
    ColumnNames = Table.ColumnNames(InputTable),

    // 2. Identify which columns have only one unique value
    ColumnsToRemove = List.Select(ColumnNames, each 
        let
            // Get the distinct values of the current column
            DistinctValues = List.Distinct(Table.Column(InputTable, _)),
            // Count them—if it's 1, every row is the same
            IsConstant = List.Count(DistinctValues) = 1
        in
            IsConstant
    ),

    // 3. Remove those columns from the table
    ResultTable = Table.RemoveColumns(InputTable, ColumnsToRemove)
in
    ResultTable
in
    Source
