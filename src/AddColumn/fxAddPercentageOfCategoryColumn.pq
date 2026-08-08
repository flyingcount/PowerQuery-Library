////////////////////////////////////////////////////////////////////////////////
// fxAddPercentageOfCategoryColumn
// Category : AddColumn
// Source path : Function Library/AddColumn/fxAddPercentageOfCategoryColumn
////////////////////////////////////////////////////////////////////////////////

(SourceTable as table, CategoryColumn as text, ValueColumn as text) =>
let
    // 1. Pre-calculate the total per category
    CategoryTotals = Table.Group(SourceTable, {CategoryColumn}, {{"CategoryTotal", each List.Sum(Table.Column(_, ValueColumn)), type number}}),
    
    // 2. Join the totals back to the original table
    JoinedTable = Table.NestedJoin(SourceTable, {CategoryColumn}, CategoryTotals, {CategoryColumn}, "LookupTable", JoinKind.LeftOuter),
    
    // 3. Expand the total so each row knows its category's sum
    Expanded = Table.ExpandTableColumn(JoinedTable, "LookupTable", {"CategoryTotal"}),
    
    // 4. Calculate the percentage
    AddPercent = Table.AddColumn(Expanded, "% of category", each 
        if [CategoryTotal] = 0 then 0 else Record.Field(_, ValueColumn) / [CategoryTotal], 
        Percentage.Type
    ),
    
    // 5. Clean up
    RemoveHelper = Table.RemoveColumns(AddPercent, {"CategoryTotal"})
in
    RemoveHelper
