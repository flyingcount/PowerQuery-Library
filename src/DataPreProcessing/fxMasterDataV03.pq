////////////////////////////////////////////////////////////////////////////////
// fxMasterDataV03
// Category : DataPreProcessing
// Description : Combines and deduplicates a key column from two queries into a master list (bulk table ops).
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/DataPreProcessing/fxMasterDataV03
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxMasterDataV03
    Description: Resolves columns by trimmed header name, cleans errors/blanks with
                 bulk Table.* operations (errors removed before distinct), trims text,
                 pre-deduplicates each source, combines, deduplicates again, sorts,
                 and returns a text master table. Prefer over fxMasterDataV02 for large inputs.
    Author: Paul Chan
    Date: 2026-08-09

    Parameters:
    - Table1: First query/table.
    - ColName1: Column name in Table1 (e.g. "SKU").
    - Table2: Second query/table.
    - ColName2 (optional): Column name in Table2. Defaults to ColName1 if blank.

    Example:
        fxMasterDataV03(Sales, "SKU", Inventory)
        fxMasterDataV03(Sales, "SKU", Inventory, "ItemCode")
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

        // Bulk path: shrink after error/blank cleanup (safe if the key column has errors)
        CleanKeys = (tbl as table, col as text) as list =>
        let
            Names = Table.ColumnNames(tbl),
            Match = List.Select(Names, each Text.Trim(_) = col),
            Resolved =
                if List.IsEmpty(Match) then
                    error "Column not found: " & col
                else
                    Match{0},

            Selected = Table.SelectColumns(tbl, {Resolved}),

            // Strip cell errors before Distinct — Distinct can fail on error values
            NoErrorsInitial = Table.RemoveRowsWithErrors(Selected, {Resolved}),

            AsText = Table.TransformColumnTypes(
                NoErrorsInitial,
                {{Resolved, type text}}
            ),

            // Drop values that could not convert to text
            NoErrorsTyped = Table.RemoveRowsWithErrors(AsText, {Resolved}),

            Trimmed = Table.TransformColumns(
                NoErrorsTyped,
                {{Resolved, each if _ = null then null else Text.Trim(_), type text}}
            ),

            Filtered = Table.SelectRows(
                Trimmed,
                each
                    let
                        Value = Record.Field(_, Resolved)
                    in
                        Value <> null and Value <> ""
            ),

            // Distinct after clean/trim so "A1 "/"A1" and 123/"123" collapse here
            DistinctKeys = Table.Distinct(Filtered),

            ExtractedList = Table.Column(DistinctKeys, Resolved)
        in
            ExtractedList,

        // Pre-shrink each source before combine (helps large duplicated inputs)
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

        TypedOutput = Table.TransformColumnTypes(
            ResultTable,
            {{CleanColName1, type text}}
        )
    in
        TypedOutput,

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
        Documentation.Name = "fxMasterDataV03",
        Documentation.LongDescription = "Resolves columns by trimmed header name, cleans errors/blanks with bulk Table operations (errors removed before distinct), trims text, pre-deduplicates each source, combines, deduplicates again, sorts, and returns a text master table."
    ]
in
    Value.ReplaceType(CombineAndDeduplicate, FunctionType)
