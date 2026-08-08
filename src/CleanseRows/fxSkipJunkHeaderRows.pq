////////////////////////////////////////////////////////////////////////////////
// fxSkipJunkHeaderRows
// Category : CleanseRows
// Description : Skips top rows that contain only nulls or empty strings.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseRows/fxSkipJunkHeaderRows
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxSkipJunkHeaderRows
    Description: Skips top rows that contain only nulls or empty strings.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // Use Table.Skip with a predicate to keep skipping while the row is "blank"
    SkippedTable = Table.Skip(InputTable, each List.Contains(Record.FieldValues(_),null))
in
    SkippedTable
in
    Source
