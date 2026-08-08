////////////////////////////////////////////////////////////////////////////////
// fxAddRunningTotalColumn
// Category : AddColumn
// Source path : Function Library/AddColumn/fxAddRunningTotalColumn
////////////////////////////////////////////////////////////////////////////////

(SourceTable as table, ColumnName as text) =>
let
    // Convert the target column to a list for calculation
    ColumnList = Table.Column(SourceTable, ColumnName),
    
    // Use List.Generate to build the running total in one pass O(n)
    RunningTotalList = List.Generate(
        () => [Total = ColumnList{0}, i = 0],
        each [i] < List.Count(ColumnList),
        each [Total = [Total] + ColumnList{[i] + 1}, i = [i] + 1],
        each [Total]
    ),
    
    // Add the list as a new column
    AddTotal = Table.FromColumns(
        Table.ToColumns(SourceTable) & {RunningTotalList},
        Table.ColumnNames(SourceTable) & {"Running Total"}
    )
in
    AddTotal
