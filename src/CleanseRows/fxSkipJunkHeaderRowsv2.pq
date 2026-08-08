////////////////////////////////////////////////////////////////////////////////
// fxSkipJunkHeaderRowsv2
// Category : CleanseRows
// Description : Skips rows as long as they contain nulls or empty strings.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseRows/fxSkipJunkHeaderRowsv2
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxSkipJunkHeaderRowsv2
    Description: Skips rows as long as they contain nulls or empty strings.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // Skip while the row contains a null OR an empty string
    // The skip stops as soon as a row is found where NONE of the values are null/empty
    SkippedTable = Table.Skip(InputTable, each 
        List.AnyTrue(
            List.Transform(Record.FieldValues(_), each _ = null or _ = "")
        )
    )
in
    SkippedTable
in
    Source
