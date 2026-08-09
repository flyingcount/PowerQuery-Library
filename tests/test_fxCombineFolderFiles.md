# Test: `fxCombineFolderFiles`

## Setup

Folder with:

- `North.csv` — headers `Region,Amount` and 2 data rows  
- `South.xlsx` — first sheet with same headers and 1 data row  

## Steps

1. Paste `fxCombineFolderFiles` as a blank query.
2. Invoke:

```powerquery
fxCombineFolderFiles("C:\Path\To\Folder")
```

## Expected

- One combined table with columns from both files plus `SourceFileName`.
- Rows from `North.csv` show `SourceFileName = North.csv`.
- Rows from `South.xlsx` show `SourceFileName = South.xlsx`.
- Headers promoted (default).

## Optional filter

```powerquery
fxCombineFolderFiles("C:\Path\To\Folder", {".csv"})
```

Only CSV files are included.
