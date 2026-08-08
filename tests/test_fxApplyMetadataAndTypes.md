# Test: `fxApplyMetadataAndTypes`

## Input table

| Id | Name | Unused |
|----|------|--------|
| 1 | Ada | z |
| 2 | Bob | z |

## Map table (`fxGetTableMetadata` shape)

| Index | ColumnHeaders | ColumnNameDuplicate | DataType | Keep Y/N |
|-------|---------------|---------------------|----------|----------|
| 1 | Id | CustomerId | Int64 | Y |
| 2 | Name | CustomerName | Text | Y |
| 3 | Unused | Unused | Text | N |

## Expected

- Output columns: `CustomerId` (whole number), `CustomerName` (text).
- `Unused` dropped.
- Error if the source has a column missing from the map.
