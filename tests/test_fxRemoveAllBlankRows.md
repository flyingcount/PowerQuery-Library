# Test: `fxRemoveAllBlankRows`

## Input

| A | B |
|---|---|
| 1 | x |
| null | null |
| | |
| 2 | y |

## Expected

Only two rows remain: `(1, x)` and `(2, y)`.
Rows that are all `null` or `""` are removed.
