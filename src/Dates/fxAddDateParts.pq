////////////////////////////////////////////////////////////////////////////////
// fxAddDateParts
// Category : Dates
// Description : Adds common calendar attributes from a date/datetime column.
// Author      : Paul Chan
// Date        : 2026-08-08
// Source path : Function Library/Dates/fxAddDateParts
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxAddDateParts
    Description: Adds Year, Quarter, Month, Week, and day-of-week columns derived
                 from a date or datetime column. Null source values produce null parts.
                 Column names align with fxGenerateDateTable where practical.
    Author: Paul Chan
    Date: 2026-08-08

    Parameters:
    - InputTable: Source table.
    - DateColumn: Name of the date or datetime column.

    Output columns added:
    - Year, Quarter, Month Number, Month, Day, Day Of Week Number,
      Day Of Week, Week, MMM-YYYY, Month sort

    Example:
        fxAddDateParts(Source, "OrderDate")
*/
let
    Source = (InputTable as table, DateColumn as text) as table =>
let
    // Normalize date/datetime/null to a date (or null)
    AsDate = (Value as any) as nullable date =>
        if Value = null then
            null
        else if Value is date then
            Value
        else if Value is datetime then
            Date.From(Value)
        else if Value is datetimezone then
            Date.From(Value)
        else
            try Date.From(Value) otherwise null,

    WithYear = Table.AddColumn(
        InputTable,
        "Year",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.Year(d),
        Int64.Type
    ),
    WithQuarter = Table.AddColumn(
        WithYear,
        "Quarter",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.QuarterOfYear(d),
        Int64.Type
    ),
    WithMonthNum = Table.AddColumn(
        WithQuarter,
        "Month Number",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.Month(d),
        Int64.Type
    ),
    WithMonthName = Table.AddColumn(
        WithMonthNum,
        "Month",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.MonthName(d),
        type text
    ),
    WithDay = Table.AddColumn(
        WithMonthName,
        "Day",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.Day(d),
        Int64.Type
    ),
    WithDowNum = Table.AddColumn(
        WithDay,
        "Day Of Week Number",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.DayOfWeek(d, Day.Monday) + 1,
        Int64.Type
    ),
    WithDowName = Table.AddColumn(
        WithDowNum,
        "Day Of Week",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.DayOfWeekName(d),
        type text
    ),
    WithWeek = Table.AddColumn(
        WithDowName,
        "Week",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.WeekOfYear(d),
        Int64.Type
    ),
    WithMmmYyyy = Table.AddColumn(
        WithWeek,
        "MMM-YYYY",
        each let d = AsDate(Record.Field(_, DateColumn)) in if d = null then null else Date.ToText(d, "MMM-yyyy"),
        type text
    ),
    WithMonthSort = Table.AddColumn(
        WithMmmYyyy,
        "Month sort",
        each
            let
                d = AsDate(Record.Field(_, DateColumn))
            in
                if d = null then
                    null
                else
                    Text.PadStart(Text.From(Date.Month(d)), 2, "0") & " " & Text.Start(Date.MonthName(d), 3),
        type text
    )
in
    WithMonthSort
in
    Source
