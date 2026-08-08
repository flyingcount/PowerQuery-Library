////////////////////////////////////////////////////////////////////////////////
// fxTableSchema
// Category : Info
// Description : Returns a table containing the schema metadata for the input table.
// Author      : Paul Chan
// Date        : 2026-03-07
// Source path : Function Library/InfoFunctions/fxTableSchema
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxTableSchema
    Description: Returns a table containing the schema metadata for the input table.
                 The output includes the column name, column order, data type, 
                 and whether the column allows null values. This is essential for 
                 auditing data structures and validating source-to-target mapping.
    Author: Paul Chan
    Date: 2026-03-07
*/
let
    Source = (InputTable as table) =>
let
    // Table.Schema returns a table with columns: 
    // Name, Position, Kind, Nullable, DataType
    Schema = Table.Schema(InputTable)
in
    Schema
in
    Source
