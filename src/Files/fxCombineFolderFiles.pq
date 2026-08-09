////////////////////////////////////////////////////////////////////////////////
// fxCombineFolderFiles
// Category : Files
// Description : Combines CSV/Excel files from a folder and adds a SourceFileName column.
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/Files/fxCombineFolderFiles
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxCombineFolderFiles
    Description: Reads CSV and Excel files from a folder, loads each into a table,
                 appends them, and adds SourceFileName from the file name.
                 Excel files use the first sheet by default.
    Author: Paul Chan
    Date: 2026-08-09

    Parameters:
    - FolderPath: Full folder path (e.g. "C:\Data\Incoming").
    - Extensions (optional): List of extensions including the dot.
      Default = {".csv", ".xlsx", ".xls", ".xlsm"}.
    - PromoteHeaders (optional): Promote first row to headers. Default = true.

    Example:
        fxCombineFolderFiles("C:\Data\Incoming")
        fxCombineFolderFiles("C:\Data\Incoming", {".csv"}, true)
*/
let
    Source = (
        FolderPath as text,
        optional Extensions as nullable list,
        optional PromoteHeaders as nullable logical
    ) as table =>
let
    AllowedExtensions =
        if Extensions = null then
            {".csv", ".xlsx", ".xls", ".xlsm"}
        else
            List.Transform(Extensions, each Text.Lower(_)),

    DoPromote = if PromoteHeaders = null then true else PromoteHeaders,

    Files = Folder.Files(FolderPath),

    Filtered = Table.SelectRows(
        Files,
        each List.Contains(AllowedExtensions, Text.Lower([Extension]))
    ),

    WithName = Table.AddColumn(Filtered, "SourceFileName", each [Name], type text),

    // Load one file binary into a table (first Excel sheet for workbooks)
    LoadFile = (Content as binary, Extension as text) as table =>
        let
            Ext = Text.Lower(Extension),
            RawTable =
                if Ext = ".csv" then
                    Csv.Document(Content)
                else if List.Contains({".xlsx", ".xls", ".xlsm", ".xlsb"}, Ext) then
                    let
                        Workbook = Excel.Workbook(Content, null, true),
                        Sheets = Table.SelectRows(Workbook, each [Kind] = "Sheet"),
                        FirstSheet = if Table.IsEmpty(Sheets) then error "No sheets found in workbook." else Sheets{0}[Data]
                    in
                        FirstSheet
                else
                    error "Unsupported extension: " & Ext,
            Result =
                if DoPromote then
                    Table.PromoteHeaders(RawTable, [PromoteAllScalars = true])
                else
                    RawTable
        in
            Result,

    WithTables = Table.AddColumn(
        WithName,
        "Data",
        each LoadFile([Content], [Extension]),
        type table
    ),

    // Keep provenance + nested data only
    Selected = Table.SelectColumns(WithTables, {"SourceFileName", "Data"}),

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
