# Test: `fxAddDateParts`

## Input

| OrderDate | Amount |
|-----------|--------|
| 2026-03-15 | 10 |
| null | 5 |
| 2026-03-15T14:30:00 | 7 |

## Steps

1. Load input as a table (`OrderDate` as date or datetime).
2. Invoke `fxAddDateParts(Input, "OrderDate")`.

## Expected

- Row 1: `Year=2026`, `Quarter=1`, `Month Number=3`, `Month=March`, `Day=15`, `Day Of Week Number` = Monday-based (Sun=7), `Week` set, `MMM-YYYY=Mar-2026`, `Month sort=03 Mar`.
- Row 2: all added part columns are `null`; `Amount` unchanged.
- Row 3: same calendar parts as row 1 (datetime normalized to date).
- Original `OrderDate` and `Amount` columns retained.
