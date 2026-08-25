# Test: `fxChangeTypeNoErrors`

## Input table

| Date | Region | Units | Extra |
|------|--------|-------|-------|
| 2026-01-15 | North | 10 | keep |
| 2026-02-01 | South | 5 | keep |

## Type list

```powerquery
{
    {"Date", type date},
    {"Region", type text},
    {"Units", Int64.Type},
    {"MissingCol", type text}
}
```

## Steps

1. Load the input as a table (columns may all start as text).
2. Invoke:

```powerquery
fxChangeTypeNoErrors(
    Input,
    { {"Date", type date}, {"Region", type text}, {"Units", Int64.Type}, {"MissingCol", type text} }
)
```

## Expected

- `Date` is type date, `Region` is text, `Units` is Int64.
- `Extra` is unchanged (not in the type list).
- `MissingCol` is skipped; the query does **not** error.
- All four original columns remain.
