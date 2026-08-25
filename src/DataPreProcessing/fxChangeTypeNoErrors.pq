////////////////////////////////////////////////////////////////////////////////
// fxChangeTypeNoErrors
// Category : DataPreProcessing
// Description : Applies column types, ignoring names that are not in the table.
// Author      : Chandeep Chhabra @ goodly.co.in
// Date        : 2026-08-25
// Source path : Function Library/DataPreProcessing/fxChangeTypeNoErrors
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxChangeTypeNoErrors
    Description: Applies Table.TransformColumnTypes only to columns that exist
                 in the input table. Missing column names in the type list do
                 not raise an error.
    Author: Chandeep Chhabra @ goodly.co.in
    Date: 2026-08-25

    Parameters:
    - InputTable: Source table.
    - DataTypes: List of {column name, type} pairs, same shape as
                 Table.TransformColumnTypes.

    Example:
        fxChangeTypeNoErrors(
            Source,
            { {"Date", type date}, {"Region", type text}, {"Units", Int64.Type} }
        )
*/
let
    ChangeTypeNoErrors = (InputTable as table, DataTypes as list) as table =>
    let
        SourceCols = Table.ColumnNames(InputTable),
        DataTypesColumnList = List.Transform(DataTypes, each _{0}),
        MatchingCols = List.Intersect({SourceCols, DataTypesColumnList}),
        MatchingTypes =
            List.Transform(
                List.Transform(
                    MatchingCols,
                    each List.PositionOf(DataTypesColumnList, _)
                ),
                each DataTypes{_}
            ),
        TypedTable = Table.TransformColumnTypes(InputTable, MatchingTypes)
    in
        TypedTable,

    FunctionType = type function (
        InputTable as (
            type table meta [
                Documentation.FieldCaption = "Table",
                Documentation.FieldDescription = "The table whose column types should be applied."
            ]
        ),
        DataTypes as (
            type list meta [
                Documentation.FieldCaption = "Data Types",
                Documentation.FieldDescription = "List of {column name, type} pairs. Columns not found in the table are skipped."
            ]
        )
    ) as table meta [
        Documentation.Name = "fxChangeTypeNoErrors",
        Documentation.Description = "Returns no error if the data types applied are not found.",
        Documentation.Author = "Chandeep Chhabra @ goodly.co.in",
        Documentation.Examples = {
            [
                Description = "There are 2 arguments to this function. Table, DataTypes as List of List",
                Code = "fxChangeTypeNoErrors(
    Source,
    { {""Date"", type date}, {""Region"", type text}, {""Units"", Int64.Type} }
)",
                Result = "Table with no errors"
            ]
        }
    ]
in
    Value.ReplaceType(ChangeTypeNoErrors, FunctionType)
