////////////////////////////////////////////////////////////////////////////////
// fxCleanAllText
// Category : CleanseTables
// Description : Dynamically identifies all columns containing 'text' data types
// Author      : Gemini
// Date        : 2026-03-07
// Source path : Function Library/CleanseTables/fxCleanAllText
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxCleanAllText
    Description: Dynamically identifies all columns containing 'text' data types
                 and applies both 'Text.Trim' (to remove leading/trailing whitespace)
                 and 'Text.Clean' (to remove non-printable control characters).
                 This ensures consistency and prevents load errors caused by 
                 hidden characters in source data.
    Author: Gemini
    Date: 2026-03-07
    Parameters:
    - InputTable: The source table to be processed.
*/
let
    Source = (InputTable as table) as table =>
let
    // 1. Get the list of all text columns in the table
    Schema = Table.Schema(InputTable),
    TextColumns = Table.SelectRows(Schema, each ([Kind] = "text"))[Name],

    // 2. Build the transformation list for text columns
    // We apply both Trim (removes spaces) and Clean (removes non-printable chars)
    TransformList = List.Transform(TextColumns, each {_, each Text.Trim(Text.Clean(_))}),

    // 3. Apply the transformations dynamically
    CleanedTable = Table.TransformColumns(InputTable, TransformList)
in
    CleanedTable
in
    Source
