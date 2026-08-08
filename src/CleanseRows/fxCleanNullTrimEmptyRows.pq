////////////////////////////////////////////////////////////////////////////////
// fxCleanNullTrimEmptyRows
// Category : CleanseRows
// Description : Replaces "null" strings with actual nulls, trims text, and removes completely empty rows.
// Author      : Gemini
// Date        : 2026-03-06
// Source path : Function Library/CleanseRows/fxCleanNullTrimEmptyRows
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxCleanNullTrimEmptyRows
    Description: Replaces "null" strings with actual nulls, trims text, and removes completely empty rows.
    Author: Gemini
    Date: 2026-03-06
*/
let
    Source = (InputTable as table) as table =>
let
    Cols = Table.ColumnNames(InputTable),
    
    // 1. Replace the string "null" with actual nulls
    ReplaceNullString = Table.ReplaceValue(
        InputTable,
        "null",
        null,
        Replacer.ReplaceValue,
        Cols
    ),
    
    // 2. Trim text values
    TrimTransform = List.Transform(Cols, each {
        _, 
        (Value) => if Value is text then Text.Trim(Value) else Value
    }),
    AppliedTrim = Table.TransformColumns(ReplaceNullString, TrimTransform),
    
    // 3. Remove rows that are entirely empty/null
    // We check if all columns in the row result in null or empty string
    RemoveEmpty = Table.SelectRows(AppliedTrim, each 
        List.AnyTrue(
            List.Transform(Record.FieldValues(_), each _ <> null and _ <> "")
        )
    )
in
    RemoveEmpty
in
    Source
