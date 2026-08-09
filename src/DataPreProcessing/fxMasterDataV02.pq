////////////////////////////////////////////////////////////////////////////////
// fxMasterDataV02
// Category : DataPreProcessing
// Description : Combines and deduplicates a key column from two queries into a master list.
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/DataPreProcessing/fxMasterDataV02
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxMasterDataV02
    Description: Safely trims column headers, pre-shrinks and deduplicates lists
                 individually, combines them, cleans out errors/blanks, and returns
                 a single master table (typed as text).
    Author: Paul Chan
    Date: 2026-08-09

    Parameters:
    - Table1: First query/table.
    - ColName1: Column name in Table1 (e.g. "SKU").
    - Table2: Second query/table.
    - ColName2 (optional): Column name in Table2. Defaults to ColName1 if blank.

    Example:
        fxMasterDataV02(Sales, "SKU", Inventory)
        fxMasterDataV02(Sales, "SKU", Inventory, "ItemCode")
*/
let
    CombineAndDeduplicate = (
        Table1 as table,
        ColName1 as text,
        Table2 as table,
        optional ColName2 as text
    ) as table =>
    let
        // Trim headers so "SKU " vs "SKU" does not cause Column not found
        CleanTable1 = Table.RenameColumns(
            Table1,
            List.Zip({
                Table.ColumnNames(Table1),
                List.Transform(Table.ColumnNames(Table1), Text.Trim)
            })
        ),
        CleanTable2 = Table.RenameColumns(
            Table2,
            List.Zip({
                Table.ColumnNames(Table2),
                List.Transform(Table.ColumnNames(Table2), Text.Trim)
            })
        ),

        CleanColName1 = Text.Trim(ColName1),
        CleanColName2 =
            if ColName2 = null or ColName2 = "" then
                CleanColName1
            else
                Text.Trim(ColName2),

        RawList1 = Table.Column(CleanTable1, CleanColName1),
        RawList2 = Table.Column(CleanTable2, CleanColName2),

        NoErrorList1 = List.Transform(RawList1, each try _ otherwise null),
        NoErrorList2 = List.Transform(RawList2, each try _ otherwise null),

        CleanList1 = List.Distinct(List.RemoveNulls(NoErrorList1)),
        CleanList2 = List.Distinct(List.RemoveNulls(NoErrorList2)),

        CombinedList = List.Combine({CleanList1, CleanList2}),
        FinalList = List.Distinct(CombinedList),

        ResultTable = Table.FromList(
            FinalList,
            Splitter.SplitByNothing(),
            {CleanColName1},
            null,
            ExtraValues.Ignore
        ),

        TypedTable = Table.TransformColumnTypes(
            ResultTable,
            {{CleanColName1, type text}}
        )
    in
        TypedTable,

    FunctionType = type function (
        Table1 as (
            type table meta [
                Documentation.FieldCaption = "First Query",
                Documentation.FieldDescription = "Select the first query."
            ]
        ),
        ColName1 as (
            type text meta [
                Documentation.FieldCaption = "Column Name 1",
                Documentation.FieldDescription = "Type the column name (e.g., SKU)."
            ]
        ),
        Table2 as (
            type table meta [
                Documentation.FieldCaption = "Second Query",
                Documentation.FieldDescription = "Select the second query."
            ]
        ),
        optional ColName2 as (
            type text meta [
                Documentation.FieldCaption = "Column Name 2 (Optional)",
                Documentation.FieldDescription = "Optional. If left blank, it defaults to Column Name 1."
            ]
        )
    ) as table meta [
        Documentation.Name = "fxMasterDataV02",
        Documentation.LongDescription = "Safely trims all column headers, pre-shrinks and deduplicates lists individually, combines them, cleans out errors/blanks, and returns a single, bulletproof master table."
    ]
in
    Value.ReplaceType(CombineAndDeduplicate, FunctionType)
