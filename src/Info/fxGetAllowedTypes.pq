////////////////////////////////////////////////////////////////////////////////
// fxGetAllowedTypes
// Category : Info
// Description : Returns a list of valid Power Query type strings for mapping.
// Author      : Gemini
// Date        : 2026-03-06
// Source path : Function Library/InfoFunctions/fxGetAllowedTypes
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetAllowedTypes
    Description: Returns a list of valid Power Query type strings for mapping.
    Author: Gemini
    Date: 2026-03-06
*/
let
    Source = () as table =>
let
    AllowedTypes = {"text", "Int64", "number", "date", "dateTime", "logical", "currency"},
    ToTable = Table.FromList(AllowedTypes, Splitter.SplitByNothing(), {"DataType"}),
    AddExample = Table.AddColumn(ToTable, "Example", each "Type example for MapTable")
in
    ToTable
in
    Source
