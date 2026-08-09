# Test: `HolidaysList` + `fxCreateDateTable`

## Setup

1. Blank query named **`HolidaysList`** ← paste `src/Dates/HolidaysList.pq`
2. Blank query named **`fxCreateDateTable`** ← paste `src/Dates/fxCreateDateTable.pq`
3. Blank query:

```powerquery
fxCreateDateTable(#date(2026, 1, 1), #date(2026, 12, 31))
```

## Expected — HolidaysList

8 rows (England & Wales 2026), including:

| Date | Holiday |
|------|---------|
| 2026-01-01 | New Year's Day |
| 2026-04-03 | Good Friday |
| 2026-04-06 | Easter Monday |
| 2026-05-04 | Early May bank holiday |
| 2026-05-25 | Spring bank holiday |
| 2026-08-31 | Summer bank holiday |
| 2026-12-25 | Christmas Day |
| 2026-12-28 | Boxing Day (substitute day) |

## Expected — date table

- Those dates: `Is Working Day = false` (even weekdays).
- e.g. `2026-12-25` (Friday): `Is Weekday = true`, `Is Working Day = false`.
- A normal Wednesday in June: `Is Working Day = true`.
