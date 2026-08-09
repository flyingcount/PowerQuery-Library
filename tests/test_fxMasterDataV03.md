# Test: `fxMasterDataV03`

## Input — Table1 (`Sales`)

| SKU | Qty |
|-----|-----|
| A1 | 1 |
| A1 | 2 |
| `A1 ` | 3 |
| B2 | 4 |
| null | 5 |
| `""` | 6 |
| `   ` | 7 |
| C3 | 8 |

## Input — Table2 (`Inventory`)

| ItemCode | OnHand |
|----------|--------|
| B2 | 10 |
| c4 | 5 |
|  | 0 |
| 100 | 1 |
| `100` (text) | 2 |

## Steps

1. Load both tables in Power Query.
2. Invoke `fxMasterDataV03(Sales, "SKU", Inventory, "ItemCode")`.
3. Optionally invoke with whitespace-only `ColName2` (defaults to ColName1).
4. Optionally rename a header to `"SKU "` and invoke with `"SKU"` — column should still resolve.
5. Optional stress: ~500k-row sources with relatively few unique keys; confirm refresh is faster than `fxMasterDataV02`.

## Expected

| SKU |
|-----|
| 100 |
| A1 |
| B2 |
| C3 |
| c4 |

- Nulls, `""`, and whitespace-only text removed.
- Leading/trailing spaces trimmed (`A1 ` → `A1`).
- Numeric `100` and text `"100"` collapse to one key after type conversion + distinct.
- Duplicates within and across tables collapsed once.
- Result sorted ascending.
- Result column named from cleaned `ColName1` (`SKU`), typed as text.
- Missing column should error with `Column not found: …`.
- Values that cannot convert to text are dropped (not stringified via `Text.From`).
