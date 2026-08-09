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
    Description: Resolves columns by trimmed header name, cleans errors/blanks,
                 pre-deduplicates each source list (important for large tables),
                 combines them, deduplicates again, sorts, and returns a text master table.
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
        CleanColName1 = Text.Trim(ColName1),
        CleanColName2 =
            if ColName2 = null or Text.Trim(ColName2) = "" then
                CleanColName1
            else
                Text.Trim(ColName2),

        // Resolve one column by trimmed header (avoids renaming the whole table)
        CleanKeys = (tbl as table, col as text) as list =>
        let
            Names = Table.ColumnNames(tbl),
            Match = List.Select(Names, each Text.Trim(_) = col),
            Resolved =
                if List.IsEmpty(Match) then
                    error "Column not found: " & col
                else
                    Match{0},
            Raw = Table.Column(tbl, Resolved),
            Cleaned = List.Transform(
                Raw,
                each
                    let
                        Value = try _ otherwise null
                    in
                        if Value = null then
                            null
                        else if Value is text and Text.Trim(Value) = "" then
                            null
                        else
                            Text.From(Value)
            )
        in
            List.Distinct(List.RemoveNulls(Cleaned)),

        // Pre-shrink each source before combine (helps ~500k-row inputs)
        CleanList1 = CleanKeys(Table1, CleanColName1),
        CleanList2 = CleanKeys(Table2, CleanColName2),

        CombinedList = List.Combine({CleanList1, CleanList2}),
        FinalList = List.Sort(List.Distinct(CombinedList)),

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
        Documentation.LongDescription = "Resolves columns by trimmed header name, cleans errors/blanks, pre-deduplicates each source list, combines them, deduplicates again, sorts, and returns a text master table."
    ]
in
    Value.ReplaceType(CombineAndDeduplicate, FunctionType)
