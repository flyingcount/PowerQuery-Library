# Test: `fxMasterDataV02`

## Input — Table1 (`Sales`)

| SKU | Qty |
|-----|-----|
| A1 | 1 |
| A1 | 2 |
| B2 | 3 |
| null | 4 |

## Input — Table2 (`Inventory`)

| ItemCode | OnHand |
|----------|--------|
| B2 | 10 |
| C3 | 5 |
|  | 0 |

## Steps

1. Load both tables in Power Query.
2. Invoke `fxMasterDataV02(Sales, "SKU", Inventory, "ItemCode")`.
3. Optionally invoke with blank `ColName2` when both tables share `"SKU"`: `fxMasterDataV02(Sales, "SKU", Inventory2)`.

## Expected

| SKU |
|-----|
| A1 |
| B2 |
| C3 |

- Nulls / blanks removed.
- Duplicates within and across tables collapsed once.
- Result column named from cleaned `ColName1` (`SKU`), typed as text.
- Overlapping key `B2` appears once.
