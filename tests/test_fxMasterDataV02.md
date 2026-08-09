# Test: `fxMasterDataV02`

## Input — Table1 (`Sales`)

| SKU | Qty |
|-----|-----|
| A1 | 1 |
| A1 | 2 |
| B2 | 3 |
| null | 4 |
| `""` | 5 |
| `   ` | 6 |
| C3 | 7 |

## Input — Table2 (`Inventory`)

| ItemCode | OnHand |
|----------|--------|
| B2 | 10 |
| c4 | 5 |
|  | 0 |
| 100 | 1 |

## Steps

1. Load both tables in Power Query.
2. Invoke `fxMasterDataV02(Sales, "SKU", Inventory, "ItemCode")`.
3. Optionally invoke with whitespace-only `ColName2` (should default to `"SKU"` when both tables share that header).
4. Optionally rename a header to `"SKU "` and invoke with `"SKU"` — column should still resolve.

## Expected

| SKU |
|-----|
| 100 |
| A1 |
| B2 |
| C3 |
| c4 |

- Nulls, `""`, and whitespace-only text removed.
- Numeric `100` coerced to text `"100"`.
- Duplicates within and across tables collapsed once.
- Result sorted ascending.
- Result column named from cleaned `ColName1` (`SKU`), typed as text.
- Missing column should error with `Column not found: …`.
