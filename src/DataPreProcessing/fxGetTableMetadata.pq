////////////////////////////////////////////////////////////////////////////////
// fxGetTableMetadata
// Category : DataPreProcessing
// Description : Returns a table with Index, Column Name, Duplicate, Type, and a "Keep Y/N" flag.
// Author      : Gemini
// Date        : 2026-03-07
// Source path : Function Library/DataPreProcessing/fxGetTableMetadata
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetTableMetadata
    Description: Returns a table with Index, Column Name, Duplicate, Type, and a "Keep Y/N" flag.
    Author: Gemini
    Date: 2026-03-07
*/
let
    Source = (InputTable as table) as table =>
let
    // 1. Get the schema (Name, Kind, etc.)
    Schema = Table.Schema(InputTable),
    
    // 2. Select only the Name and Kind (Type)
    SelectCols = Table.SelectColumns(Schema, {"Name", "Kind"}),
    
    // 3. Add an Index starting at 1
    AddIndex = Table.AddIndexColumn(SelectCols, "Index", 1, 1, Int64.Type),
    
    // 4. Duplicate the "Name" column
    DuplicateNames = Table.AddColumn(AddIndex, "ColumnNameDuplicate", each [Name]),
    
    // 5. Add the "Keep Y/N" column with a default value of "Y"
    AddKeep = Table.AddColumn(DuplicateNames, "Keep Y/N", each "Y", type text),
    
    // 6. Reorder columns
    Reordered = Table.SelectColumns(AddKeep, {"Index", "Name", "ColumnNameDuplicate", "Kind", "Keep Y/N"}),
    
    // 7. Rename columns for clarity
    Renamed = Table.RenameColumns(Reordered, {{"Name", "ColumnHeaders"}, {"Kind", "DataType"}})
in
    Renamed
in
    Source
