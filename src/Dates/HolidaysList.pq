////////////////////////////////////////////////////////////////////////////////
// HolidaysList
// Category : Dates
// Description : Editable holidays table (pre-populated with 2026 England & Wales bank holidays).
// Author      : Paul Chan
// Date        : 2026-08-09
// Source path : Function Library/Dates/HolidaysList
////////////////////////////////////////////////////////////////////////////////

/*
    Query: HolidaysList
    Description: Load this as a standalone query named HolidaysList in Excel or Power BI.
                 fxCreateDateTable reads HolidaysList[Date] when its Holidays argument is omitted.
                 Add/remove rows here to maintain your organisation's non-working days.

    Source: GOV.UK bank holidays for England and Wales, 2026
            (Boxing Day observed Mon 28 Dec 2026 as substitute for Sat 26 Dec).
*/
let
    Source = #table(
        type table [
            Date = date,
            Holiday = text,
            Region = text,
            Year = Int64.Type
        ],
        {
            {#date(2026, 1, 1), "New Year's Day", "England and Wales", 2026},
            {#date(2026, 4, 3), "Good Friday", "England and Wales", 2026},
            {#date(2026, 4, 6), "Easter Monday", "England and Wales", 2026},
            {#date(2026, 5, 4), "Early May bank holiday", "England and Wales", 2026},
            {#date(2026, 5, 25), "Spring bank holiday", "England and Wales", 2026},
            {#date(2026, 8, 31), "Summer bank holiday", "England and Wales", 2026},
            {#date(2026, 12, 25), "Christmas Day", "England and Wales", 2026},
            {#date(2026, 12, 28), "Boxing Day (substitute day)", "England and Wales", 2026}
        }
    )
in
    Source
