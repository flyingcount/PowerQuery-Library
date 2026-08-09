# Test: `fxCreateDateTable`

Works in **Excel Power Query** and **Power BI Desktop**.

## Setup

1. Blank query **`HolidaysList`** ← `src/Dates/HolidaysList.pq`
2. Blank query **`fxCreateDateTable`** ← `src/Dates/fxCreateDateTable.pq`

## Steps

```powerquery
fxCreateDateTable(#date(2026, 1, 1), #date(2026, 1, 31))
fxCreateDateTable(#date(2024, 4, 1), #date(2025, 3, 31), 4)
```

## Expected (calendar month)

- 31 rows; `Date` typed as date.
- Columns include Year, Quarter, Month Number, Month, Day, Day Of Week Number (Mon=1), Day Of Week, **Day Name Short** (e.g. Mon), **Is Weekday**, **Is Weekend**, **Is Working Day**, Week, MMM-YYYY, Month sort, Fiscal Year, Fiscal Period.
- With default FY start, Fiscal Year = Year and Fiscal Period = Month Number.
- Saturdays/Sundays: `Is Weekend = true`, `Is Weekday = false`, `Is Working Day = false`.

## Holidays

Default (no 4th argument) uses `HolidaysList[Date]` (2026 UK E&W seed).

Override with an explicit list:

```powerquery
fxCreateDateTable(#date(2024, 12, 23), #date(2024, 12, 27), 1, {#date(2024, 12, 25), #date(2024, 12, 26)})
```

- `2026-12-25` with default HolidaysList: `Is Weekday = true`, `Is Working Day = false`.

## Expected (FY start April)

- First row `2024-04-01`: Fiscal Period = 1, Fiscal Year = 2025 (ending-year label).
- `2025-03-31`: Fiscal Period = 12, Fiscal Year = 2025.

## Power BI

1. Home → Transform data → New Source → Blank Query → paste function.
2. New blank query: `= fxCreateDateTable(#date(2020, 1, 1), #date(2030, 12, 31))`
3. Close & Apply → Model view → mark as date table on `Date`.
