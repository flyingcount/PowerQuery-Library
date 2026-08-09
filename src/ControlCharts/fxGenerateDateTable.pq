////////////////////////////////////////////////////////////////////////////////
// fxGenerateDateTable
// Category : ControlCharts
// Description : Generates a complete calendar table based on a dynamic range.
// Source path : Function Library/ControlCharts/DateTable
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxGenerateDateTable
    Description: Generates a complete calendar table based on a dynamic range.
    Usage: fxGenerateDateTable(#date(2023, 1, 1), #date(2026, 12, 31))

    Prefer fxCreateDateTable (src/Dates/) for new work — adds Day, Quarter,
    and optional fiscal columns; same Excel PQ / Power BI compatibility.
*/
(StartDate as date, EndDate as date) =>
let
    // Generate list of dates
    DateList = List.Dates(
        StartDate, 
        Duration.Days(EndDate - StartDate) + 1, 
        #duration(1, 0, 0, 0)
    ),

    // Convert to table
    Calendar = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),

    // Add required columns
    AddYear = Table.AddColumn(Calendar, "Year", each Date.Year([Date]), Int64.Type),
    AddMonthNum = Table.AddColumn(AddYear, "Month Number", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "Month", each Date.MonthName([Date]), type text),
    AddMMMYYYY = Table.AddColumn(AddMonthName, "MMM-YYYY", each Date.ToText([Date], "MMM-yyyy"), type text),
    AddDayOfWeekNum = Table.AddColumn(AddMMMYYYY, "Day Of Week Number", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    AddDayOfWeek = Table.AddColumn(AddDayOfWeekNum, "Day Of Week", each Date.DayOfWeekName([Date]), type text),
    AddWeek = Table.AddColumn(AddDayOfWeek, "Week", each Date.WeekOfYear([Date]), Int64.Type),
    
    // Add sorting column (e.g., "01-January")
    AddMonthSort = Table.AddColumn(AddWeek, "Month sort", each 
        Text.PadStart(Text.From([#"Month Number"]), 2, "0") & " " & Text.Start([Month], 3), type text),
        
    // Final Type Enforcement
    FinalTable = Table.TransformColumnTypes(AddMonthSort, {
        {"Date", type date}
    })
in
    FinalTable
