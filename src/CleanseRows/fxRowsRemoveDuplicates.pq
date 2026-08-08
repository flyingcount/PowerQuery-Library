////////////////////////////////////////////////////////////////////////////////
// fxRowsRemoveDuplicates
// Category : CleanseRows
// Description : Removes duplicate rows
// Author      : Paul Chan
// Date        : 2026-03-07
// Source path : Function Library/CleanseRows/fxRowsRemoveDuplicates
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxRowsRemoveDuplicates
    Description: Removes duplicate rows
    Author: Paul Chan
    Date: 2026-03-07
*/
let
    Source = (tbl as table) =>

// removes duplicate rows
    Table.Distinct(tbl)
in
    Source
