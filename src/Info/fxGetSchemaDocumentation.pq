////////////////////////////////////////////////////////////////////////////////
// fxGetSchemaDocumentation
// Category : Info
// Description : Returns a reference table containing the definitions
// Author      : Paul Chan
// Date        : 2026-03-08
// Source path : Function Library/InfoFunctions/fxGetSchemaDocumentation
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGetSchemaDocumentation
    Description: Returns a reference table containing the definitions 
                 for the metadata columns returned by Table.Schema.
    Author: Paul Chan
    Date: 2026-03-08
*/
let
    fxGetSchemaDocumentation = () as table =>
    let
        // Define the rows of the documentation
        SourceData = {
            {"Name", "The actual column header/name from your source data."},
            {"Position", "The integer representing the column's order in the table (1-based)."},
            {"TypeName", "The specific Power Query type (e.g., Int64.Type, Text.Type, Date.Type)."},
            {"Kind", "The high-level data category (e.g., text, number, logical)."},
            {"IsNullable", "A boolean (true/false) indicating if the column allows null values."},
            {"NumericPrecisionBase", "The base of the numeric precision (usually 10 for decimals)."},
            {"NumericPrecision", "The total number of significant digits in a numeric column."},
            {"NumericScale", "The number of digits to the right of the decimal point."},
            {"IsSigned", "Boolean indicating if the numeric column can hold negative numbers."},
            {"DateTimePrecision", "The fractional seconds precision for Date/Time/DateTime types."},
            {"MaxLength", "The maximum character length allowed for Text or Binary types."},
            {"IsVariableLength", "Boolean indicating if the column length is variable (e.g., varchar)."},
            {"NativeTypeName", "The original type name from the source system (e.g., SQL Server nvarchar)."},
            {"NativeDefaultExpression", "The default value expression defined at the source."},
            {"NativeExpression", "Any specific expression or constraint assigned at the source."},
            {"Description", "Custom text describing the column (often empty unless set in the source)."},
            {"IsWritable", "Boolean indicating if the column can be edited/updated in the source."},
            {"FieldCaption", "A user-friendly, display-ready name for the column (if available)."}
        },
        
        // Convert the list to a table
        OutputTable = Table.FromRows(SourceData, {"Column Name", "Explanation"})
    in
        OutputTable
in
    fxGetSchemaDocumentation
