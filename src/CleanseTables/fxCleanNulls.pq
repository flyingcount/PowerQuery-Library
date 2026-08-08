////////////////////////////////////////////////////////////////////////////////
// fxCleanNulls
// Category : CleanseTables
// Source path : Function Library/CleanseTables/fxCleanNulls
////////////////////////////////////////////////////////////////////////////////

let
    Source = (InputTable as table) as table =>
let
    ColNames = Table.ColumnNames(InputTable),
    Result = Table.ReplaceValue(
        InputTable,
        "null",
        null,
        Replacer.ReplaceValue,
        ColNames
    )
in
    Result
in
    Source
