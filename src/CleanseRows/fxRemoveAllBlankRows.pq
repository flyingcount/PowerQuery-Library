////////////////////////////////////////////////////////////////////////////////
// fxRemoveAllBlankRows
// Category : CleanseRows
// Description : Removes rows where all rows are null or empty.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseRows/fxRemoveAllBlankRows
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxRemoveAllBlankRows
    Description: Removes rows where all rows are null or empty.
    Author: Paul Chan
    Date: 2026-03-06
*/	
(InputTable as table) as table =>
let
    CleanedTable = Table.SelectRows(InputTable, each 
        let 
            RowValues = Record.ToList(_),
            // Replace "" with null before checking
            CleanedValues = List.Transform(RowValues, each if _ = "" then null else _)
        in 
            not List.MatchesAll(CleanedValues, each _ = null)
    )
in
    CleanedTable
