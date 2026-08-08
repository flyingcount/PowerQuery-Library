# Test: `fxNullIfBlank`

## Input

| Name | City | Qty |
|------|------|-----|
| Ada | London | 1 |
| `""` | `   ` | 2 |
| Bob | null | 3 |

## Steps

1. Load input as a table.
2. Invoke `fxNullIfBlank(Input)`.
3. Optionally invoke `fxNullIfBlank(Input, {"Name"})`.

## Expected (all columns)

| Name | City | Qty |
|------|------|-----|
| Ada | London | 1 |
| null | null | 2 |
| Bob | null | 3 |

- `""` and whitespace-only text become `null`.
- Numeric `Qty` unchanged.
- Existing `null` stays `null`.

## Expected (`{"Name"}` only)

Only `Name` is transformed; `City` keeps `"   "` as text.
