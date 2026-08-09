////////////////////////////////////////////////////////////////////////////////
// fxCreateDateTable
// Category : Dates
// Description : Creates a calendar / date-dimension table for Excel PQ or Power BI.
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/Dates/fxCreateDateTable
////////////////////////////////////////////////////////////////////////////////

/*
    Function: fxCreateDateTable
    Description: Builds one row per day between StartDate and EndDate (inclusive)
                 with calendar and optional fiscal attributes. Pure M — works in
                 Excel Power Query and Power BI Desktop / Service (no VBA, no
                 Excel.CurrentWorkbook).

    Parameters:
    - StartDate: First date in the calendar.
    - EndDate: Last date in the calendar (must be >= StartDate).
    - FiscalYearStartMonth (optional): Month number when the fiscal year begins
      (1–12). Default = 1 (calendar year). Fiscal Year is labeled by the ending
      calendar year when start month > 1.
    - Holidays (optional): List of dates treated as non-working (used by Is Working Day).
      When omitted/null, dates are taken from the HolidaysList query column [Date]
      (create HolidaysList from src/Dates/HolidaysList.pq in the same workbook/model).

    Setup:
    1. Create blank query HolidaysList → paste src/Dates/HolidaysList.pq (UK 2026 seed data).
    2. Create blank query fxCreateDateTable → paste this file.
    3. Invoke, e.g. fxCreateDateTable(#date(2026, 1, 1), #date(2026, 12, 31)).

    Example:
        fxCreateDateTable(#date(2026, 1, 1), #date(2026, 12, 31))
        fxCreateDateTable(#date(2026, 4, 1), #date(2027, 3, 31), 4)
        fxCreateDateTable(#date(2026, 1, 1), #date(2026, 12, 31), 1, {#date(2026, 12, 24)})

    Power BI tip: mark the date query as a Date table and set Date as the key column.
*/
let
    Source = (
        StartDate as date,
        EndDate as date,
        optional FiscalYearStartMonth as nullable number,
        optional Holidays as nullable list
    ) as table =>
let
    FyStart =
        let
            m = if FiscalYearStartMonth = null then 1 else FiscalYearStartMonth
        in
            if m < 1 or m > 12 then
                error "FiscalYearStartMonth must be between 1 and 12."
            else
                Number.RoundDown(m),

    // Prefer explicit Holidays list; else HolidaysList[Date] if that query exists
    HolidaySet =
        if Holidays <> null then
            Holidays
        else
            let
                SharedQueries = #shared,
                HasHolidaysList = Record.HasFields(SharedQueries, "HolidaysList"),
                FromTable =
                    if not HasHolidaysList then
                        {}
                    else
                        try
                            let
                                Tbl = Record.Field(SharedQueries, "HolidaysList")
                            in
                                if Tbl is table and Table.HasColumns(Tbl, "Date") then
                                    List.Transform(Table.Column(Tbl, "Date"), each Date.From(_))
                                else
                                    {}
                        otherwise
                            {}
            in
                List.Buffer(FromTable),

    DayCount =
        if EndDate < StartDate then
            error "EndDate must be on or after StartDate."
        else
            Duration.Days(EndDate - StartDate) + 1,

    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),

    Calendar = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),

    WithYear = Table.AddColumn(Calendar, "Year", each Date.Year([Date]), Int64.Type),
    WithQuarter = Table.AddColumn(WithYear, "Quarter", each Date.QuarterOfYear([Date]), Int64.Type),
    WithMonthNum = Table.AddColumn(WithQuarter, "Month Number", each Date.Month([Date]), Int64.Type),
    WithMonth = Table.AddColumn(WithMonthNum, "Month", each Date.MonthName([Date]), type text),
    WithDay = Table.AddColumn(WithMonth, "Day", each Date.Day([Date]), Int64.Type),
    WithDowNum = Table.AddColumn(
        WithDay,
        "Day Of Week Number",
        each Date.DayOfWeek([Date], Day.Monday) + 1,
        Int64.Type
    ),
    WithDow = Table.AddColumn(WithDowNum, "Day Of Week", each Date.DayOfWeekName([Date]), type text),
    // Abbreviated day name (Mon, Tue, …) — locale-aware short form
    WithDayMmm = Table.AddColumn(
        WithDow,
        "Day Name Short",
        each Date.ToText([Date], "ddd"),
        type text
    ),
    WithIsWeekday = Table.AddColumn(
        WithDayMmm,
        "Is Weekday",
        each [#"Day Of Week Number"] <= 5,
        type logical
    ),
    WithIsWeekend = Table.AddColumn(
        WithIsWeekday,
        "Is Weekend",
        each [#"Day Of Week Number"] >= 6,
        type logical
    ),
    // Working day = Mon–Fri and not in Holidays list
    WithIsWorkingDay = Table.AddColumn(
        WithIsWeekend,
        "Is Working Day",
        each [#"Is Weekday"] and not List.Contains(HolidaySet, [Date]),
        type logical
    ),
    WithWeek = Table.AddColumn(WithIsWorkingDay, "Week", each Date.WeekOfYear([Date]), Int64.Type),
    WithMmmYyyy = Table.AddColumn(
        WithWeek,
        "MMM-YYYY",
        each Date.ToText([Date], "MMM-yyyy"),
        type text
    ),
    WithMonthSort = Table.AddColumn(
        WithMmmYyyy,
        "Month sort",
        each Text.PadStart(Text.From([#"Month Number"]), 2, "0") & " " & Text.Start([Month], 3),
        type text
    ),

    WithFiscalYear = Table.AddColumn(
        WithMonthSort,
        "Fiscal Year",
        each
            let
                m = [#"Month Number"],
                y = [Year]
            in
                if FyStart = 1 then
                    y
                else if m >= FyStart then
                    y + 1
                else
                    y,
        Int64.Type
    ),

    WithFiscalPeriod = Table.AddColumn(
        WithFiscalYear,
        "Fiscal Period",
        each
            let
                m = [#"Month Number"]
            in
                if FyStart = 1 then
                    m
                else if m >= FyStart then
                    m - FyStart + 1
                else
                    m + (12 - FyStart + 1),
        Int64.Type
    ),

    Typed = Table.TransformColumnTypes(WithFiscalPeriod, {{"Date", type date}})
in
    Typed
in
    Source
