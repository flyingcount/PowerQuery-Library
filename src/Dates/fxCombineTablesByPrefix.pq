////////////////////////////////////////////////////////////////////////////////
// fxCombineTablesByPrefix
// Category : Dates
// Description : Dynamically finds and expands all Excel tables that start with a specific text.
// Author      : Gemini AI
// Date        : 2026-03-08
// Source path : Function Library/DateFunctions/fxCombineTablesByPrefix
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxCombineTablesByPrefix
    Description: Dynamically finds and expands all Excel tables that start with a specific text.
    Author: Gemini AI
    Date: 2026-03-08
*/
let
    Source = (TablePrefix as text) as table =>
let
    // 1. Get all objects in the current workbook
    Source = Excel.CurrentWorkbook(),

    // 2. Filter for tables starting with the user-defined prefix
    // This avoids expanding the query itself or unrelated tables
    FilteredRows = Table.SelectRows(Source, each Text.StartsWith([Name], TablePrefix)),

    // 3. Dynamically extract all unique column names from the nested tables
    // This ensures that even if tables have different columns, they all get expanded
    DynamicColumnNames = List.Distinct(
        List.Combine(
            List.Transform(FilteredRows[Content], each Table.ColumnNames(_))
        )
    ),

    // 4. Expand the Content column using the dynamic list
    ExpandedContent = Table.ExpandTableColumn(
        FilteredRows, 
        "Content", 
        DynamicColumnNames, 
        DynamicColumnNames
    )
in
    ExpandedContent
in
    Source
