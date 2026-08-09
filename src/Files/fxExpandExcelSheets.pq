////////////////////////////////////////////////////////////////////////////////
// fxExpandExcelSheets
// Category : Files
// Description : Combines sheets from one Excel workbook into a single table.
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/Files/fxExpandExcelSheets
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxExpandExcelSheets
    Description: Opens an Excel workbook and appends all sheets (or sheets whose
                 names contain an optional pattern) into one table, adding SourceSheet.
    Author: Paul Chan
    Date: 2026-08-09

    Parameters:
    - FilePath: Full path to the workbook.
    - SheetNamePattern (optional): If provided, keep sheets where the name contains
      this text (case-insensitive). Null = all sheets.
    - PromoteHeaders (optional): Promote first row to headers. Default = true.

    Example:
        fxExpandExcelSheets("C:\Data\Sales.xlsx")
        fxExpandExcelSheets("C:\Data\Sales.xlsx", "Actual", true)
*/
let
    Source = (
        FilePath as text,
        optional SheetNamePattern as nullable text,
        optional PromoteHeaders as nullable logical
    ) as table =>
let
    DoPromote = if PromoteHeaders = null then true else PromoteHeaders,

    Binary = File.Contents(FilePath),
    Workbook = Excel.Workbook(Binary, null, true),

    SheetsOnly = Table.SelectRows(Workbook, each [Kind] = "Sheet"),

    FilteredSheets =
        if SheetNamePattern = null or SheetNamePattern = "" then
            SheetsOnly
        else
            Table.SelectRows(
                SheetsOnly,
                each Text.Contains([Name], SheetNamePattern, Comparer.OrdinalIgnoreCase)
            ),

    Checked =
        if Table.IsEmpty(FilteredSheets) then
            error "No sheets matched the filter in workbook: " & FilePath
        else
            FilteredSheets,

    WithSheetName = Table.AddColumn(Checked, "SourceSheet", each [Name], type text),

    Prepared = Table.AddColumn(
        WithSheetName,
        "Data",
        each
            if DoPromote then
                Table.PromoteHeaders([Data], [PromoteAllScalars = true])
            else
                [Data],
        type table
    ),

    Selected = Table.SelectColumns(Prepared, {"SourceSheet", "Data"}),

    DynamicColumnNames = List.Distinct(
        List.Combine(
            List.Transform(Selected[Data], each Table.ColumnNames(_))
        )
    ),

    Expanded = Table.ExpandTableColumn(Selected, "Data", DynamicColumnNames, DynamicColumnNames)
in
    Expanded
in
    Source
