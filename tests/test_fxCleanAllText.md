# Test: `fxCleanAllText`

## Input

| ColA | ColB |
|------|------|
| `  hello  ` | 1 |
| `world\u0001` | 2 |

(Use a non-printable character in ColA row 2 when building the sample in Excel.)

## Steps

1. Load input as a table.
2. Invoke `fxCleanAllText(Input)`.

## Expected

- Leading/trailing spaces removed from text columns.
- Non-printable characters removed (`Text.Clean`).
- Non-text columns unchanged.
