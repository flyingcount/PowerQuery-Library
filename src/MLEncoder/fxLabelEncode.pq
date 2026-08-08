////////////////////////////////////////////////////////////////////////////////
// fxLabelEncode
// Category : MLEncoder
// Source path : Function Library/MLEncoder/fxLabelEncode
////////////////////////////////////////////////////////////////////////////////

(SourceTable as table, ColumnName as text) =>
let
    // 1. Get unique sorted categories
    UniqueCategories = List.Sort(List.Distinct(Table.Column(SourceTable, ColumnName))),
    
    // 2. Create a lookup table (Category -> Integer)
    LookupTable = Table.FromColumns(
        {UniqueCategories, {0..List.Count(UniqueCategories)-1}}, 
        {ColumnName, "EncodedValue"}
    ),
    
    // 3. Join the lookup table back to the original
    Joined = Table.NestedJoin(SourceTable, {ColumnName}, LookupTable, {ColumnName}, "Temp", JoinKind.LeftOuter),
    
    // 4. Expand the encoded value and remove the original text column
    Expanded = Table.ExpandTableColumn(Joined, "Temp", {"EncodedValue"}),
    RemovedOriginal = Table.RemoveColumns(Expanded, {ColumnName}),
    
    // 5. Rename the new column to the original name and set as Int64
    FinalRename = Table.RenameColumns(RemovedOriginal, {{"EncodedValue", ColumnName}}),
    SetType = Table.TransformColumnTypes(FinalRename, {{ColumnName, Int64.Type}})
in
    SetType
