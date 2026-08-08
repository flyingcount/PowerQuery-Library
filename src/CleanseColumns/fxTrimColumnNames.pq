////////////////////////////////////////////////////////////////////////////////
// fxTrimColumnNames
// Category : CleanseColumns
// Description : Trims leading and trailing whitespace from all column names.
// Author      : Paul Chan
// Date        : 2026-03-06
// Source path : Function Library/CleanseColumns/fx TrimColumnNames
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxTrimHeaders
    Description: Trims leading and trailing whitespace from all column names.
    Author: Paul Chan
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    // Get the current list of column names
    OldHeaders = Table.ColumnNames(InputTable),
    
    // Create a new list with trimmed names
    NewHeaders = List.Transform(OldHeaders, each Text.Trim(_)),
    
    // Pair old names with new names for Table.RenameColumns
    RenamePairs = List.Zip({OldHeaders, NewHeaders}),
    
    // Rename the columns
    TrimmedTable = Table.RenameColumns(InputTable, RenamePairs)
in
    TrimmedTable
in
    Source
