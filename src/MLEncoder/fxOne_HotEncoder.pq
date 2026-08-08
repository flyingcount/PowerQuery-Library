////////////////////////////////////////////////////////////////////////////////
// fxOne_HotEncoder
// Category : MLEncoder
// Source path : Function Library/MLEncoder/fxOne_HotEncoder
////////////////////////////////////////////////////////////////////////////////

(SourceTable as table, ColumnName as text, DropFirst as logical) =>
let
    // 1. Trim category column
    #"Trimmed Text" = Table.TransformColumns(SourceTable,{{"Colour", Text.Trim, type text}}),

    // 2. Get unique categories and sort them
    UniqueCategories = List.Sort(List.Distinct(Table.Column(#"Trimmed Text", ColumnName))),
    
    // 3. Logic to decide which columns to create
    ColumnsToKeep = if DropFirst then List.Skip(UniqueCategories, 1) else UniqueCategories,

    // 3. Add the '1' helper
    AddConstant = Table.AddColumn(SourceTable, "TempDummy", each 1),
    
    // 4. Pivot
    Pivoted = Table.Pivot(
        AddConstant, 
        ColumnsToKeep, 
        ColumnName, 
        "TempDummy", 
        List.Sum
    ),
    
    // 5. Replace nulls with 0
    ReplaceNulls = Table.ReplaceValue(
        Pivoted,
        null,
        0,
        Replacer.ReplaceValue,
        ColumnsToKeep
    )
in
    ReplaceNulls
