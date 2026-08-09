# Test: `fxExpandExcelSheets`

## Setup

Workbook `Multi.xlsx` with sheets:

- `Actual_Jan` — headers `Item,Value`  
- `Actual_Feb` — same headers  
- `Budget_Jan` — same headers  

## Steps

```powerquery
fxExpandExcelSheets("C:\Path\To\Multi.xlsx")
fxExpandExcelSheets("C:\Path\To\Multi.xlsx", "Actual")
```

## Expected (all sheets)

- Combined rows from all three sheets.
- `SourceSheet` holds the sheet name for each row.

## Expected (pattern `"Actual"`)

- Only `Actual_Jan` and `Actual_Feb` rows.
- `Budget_Jan` excluded.
