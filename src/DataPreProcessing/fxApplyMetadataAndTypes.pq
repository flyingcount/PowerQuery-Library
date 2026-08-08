////////////////////////////////////////////////////////////////////////////////
// fxApplyMetadataAndTypes
// Category : DataPreProcessing
// Description : Orchestrates a metadata-driven ETL transformation.
// Author      : Gemini
// Date        : 2026-03-07
// Source path : Function Library/DataPreProcessing/fxApplyMetadataAndTypes
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxApplyMetadataAndTypes
    Description: Orchestrates a metadata-driven ETL transformation. 
                 It validates source schema against a configuration table, 
                 filters columns based on 'Keep Y/N' flags, handles name 
                 remapping, enforces data types, and gracefully ignores 
                 columns missing from the source.
    Author: Gemini
    Date: 2026-03-07
*/
let
    Source = (InputTable as table, MapTable as table) as table =>
let
    // 1. Normalize and Validate
    NormalizedMap = Table.TransformColumns(MapTable, {
        {"DataType", each Text.Proper(Text.Trim(_))},
        {"Keep Y/N", each Text.Upper(Text.Trim(_))}
    }),

    // 2. Audit Gate (Ensures all source columns are defined in metadata)
    SourceColumns = Table.ColumnNames(InputTable),
    AuditGate = if List.Count(List.RemoveItems(SourceColumns, NormalizedMap[ColumnHeaders])) > 0 
                then error "Missing Metadata for columns: " & Text.Combine(List.RemoveItems(SourceColumns, NormalizedMap[ColumnHeaders]), ", ")
                else NormalizedMap,

    // 3. Filter for "Keep" and existing columns
    ValidKeepOnly = Table.SelectRows(AuditGate, each ([#"Keep Y/N"] = "Y") and List.Contains(SourceColumns, [ColumnHeaders])),
    
    // 4. Integrity Check
    FinalCheck = if Table.IsEmpty(ValidKeepOnly) 
                 then error "Configuration Error: No valid columns to keep." 
                 else Table.Sort(ValidKeepOnly, {{"Index", Order.Ascending}}),

    // 5. Build Type Mapping
    TypeList = List.Transform(Table.ToRows(Table.SelectColumns(FinalCheck, {"ColumnNameDuplicate", "DataType"})), 
        each {
            _{0}, 
            if _{1} = "Text" then type text
            else if _{1} = "Int64" then Int64.Type
            else if _{1} = "Number" then type number
            else if _{1} = "Date" then type date
            else if _{1} = "DateTime" then type datetime
            else if _{1} = "Logical" then type logical
            else if _{1} = "Currency" then Currency.Type
            else type any
        }),

    // 6. Robust Projection (Selects only relevant columns, ignores non-existent)
    Projected = Table.SelectColumns(InputTable, FinalCheck[ColumnHeaders], MissingField.Ignore),
    
    // 7. Rename to Mapping target
    Renamed = Table.RenameColumns(Projected, Table.ToRows(Table.SelectColumns(FinalCheck, {"ColumnHeaders", "ColumnNameDuplicate"})), MissingField.Ignore),
    
    // 8. Apply Types
    Typed = Table.TransformColumnTypes(Renamed, TypeList)
in
    Typed
in
    Source
