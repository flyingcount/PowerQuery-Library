# Function Catalog

Generated from the Power Query library source files. Each entry links to its .pq file.

**Total functions:** 39

## AddColumn

| Function | Description | File |
|----------|-------------|------|
| fxAddPercentageOfCategoryColumn | _No description_ | [src/AddColumn/fxAddPercentageOfCategoryColumn.pq](../src/AddColumn/fxAddPercentageOfCategoryColumn.pq) |
| fxAddRunningTotalColumn | _No description_ | [src/AddColumn/fxAddRunningTotalColumn.pq](../src/AddColumn/fxAddRunningTotalColumn.pq) |

## CleanseColumns

| Function | Description | File |
|----------|-------------|------|
| fxGetAllColumnNamesAsList | Returns a list of all column headers from an input table. | [src/CleanseColumns/fxGetAllColumnNamesAsList.pq](../src/CleanseColumns/fxGetAllColumnNamesAsList.pq) |
| fxGetAllColumnNamesAsTable | Returns a single-column table containing all column names from an input table. | [src/CleanseColumns/fxGetAllColumnNamesAsTable.pq](../src/CleanseColumns/fxGetAllColumnNamesAsTable.pq) |
| fxGetFullColumnStats | Audit table schema, cardinality, and Primary Key suitability. | [src/CleanseColumns/fxGetFullColumnStats.pq](../src/CleanseColumns/fxGetFullColumnStats.pq) |
| fxGetMatchingColumnNames | Returns a list of column names that contain any of the strings in the SearchList. | [src/CleanseColumns/fxGetMatchingColumnNames.pq](../src/CleanseColumns/fxGetMatchingColumnNames.pq) |
| fxKeepListedColumnNames | Returns a table containing only columns that match any string in a provided list. | [src/CleanseColumns/fxKeepListedColumnNames.pq](../src/CleanseColumns/fxKeepListedColumnNames.pq) |
| fxRemoveAllBlankColumns | Removes columns where all columns are null or empty. | [src/CleanseColumns/fxRemoveAllBlankColumns.pq](../src/CleanseColumns/fxRemoveAllBlankColumns.pq) |
| fxRemoveConstantColumns | Deletes any column where every row contains the exact same value. | [src/CleanseColumns/fxRemoveConstantColumns.pq](../src/CleanseColumns/fxRemoveConstantColumns.pq) |
| fxTrimColumnNames | Trims leading and trailing whitespace from all column names. | [src/CleanseColumns/fxTrimColumnNames.pq](../src/CleanseColumns/fxTrimColumnNames.pq) |

## CleanseRows

| Function | Description | File |
|----------|-------------|------|
| fxCleanNullTrimEmptyRows | Replaces "null" strings with actual nulls, trims text, and removes completely empty rows. | [src/CleanseRows/fxCleanNullTrimEmptyRows.pq](../src/CleanseRows/fxCleanNullTrimEmptyRows.pq) |
| fxRemoveAllBlankRows | Removes rows where all rows are null or empty. | [src/CleanseRows/fxRemoveAllBlankRows.pq](../src/CleanseRows/fxRemoveAllBlankRows.pq) |
| fxRowsRemoveDuplicates | Removes duplicate rows | [src/CleanseRows/fxRowsRemoveDuplicates.pq](../src/CleanseRows/fxRowsRemoveDuplicates.pq) |
| fxSkipJunkHeaderRows | Skips top rows that contain only nulls or empty strings. | [src/CleanseRows/fxSkipJunkHeaderRows.pq](../src/CleanseRows/fxSkipJunkHeaderRows.pq) |
| fxSkipJunkHeaderRowsv2 | Skips rows as long as they contain nulls or empty strings. | [src/CleanseRows/fxSkipJunkHeaderRowsv2.pq](../src/CleanseRows/fxSkipJunkHeaderRowsv2.pq) |

## CleanseTables

| Function | Description | File |
|----------|-------------|------|
| fxCleanAllText | Dynamically identifies all columns containing 'text' data types | [src/CleanseTables/fxCleanAllText.pq](../src/CleanseTables/fxCleanAllText.pq) |
| fxCleanNulls | _No description_ | [src/CleanseTables/fxCleanNulls.pq](../src/CleanseTables/fxCleanNulls.pq) |
| fxNullIfBlank | Replaces empty or whitespace-only text values with null. | [src/CleanseTables/fxNullIfBlank.pq](../src/CleanseTables/fxNullIfBlank.pq) |
| fxTrimAll | Trims whitespace from text cells while preserving numbers, dates, and other types. Does not trim the column header | [src/CleanseTables/fxTrimAll.pq](../src/CleanseTables/fxTrimAll.pq) |

## ControlCharts

| Function | Description | File |
|----------|-------------|------|
| fxGenerateDateTable | Generates a complete calendar table based on a dynamic range. | [src/ControlCharts/fxGenerateDateTable.pq](../src/ControlCharts/fxGenerateDateTable.pq) |

## DataPreProcessing

| Function | Description | File |
|----------|-------------|------|
| fxApplyMetadataAndTypes | Orchestrates a metadata-driven ETL transformation. | [src/DataPreProcessing/fxApplyMetadataAndTypes.pq](../src/DataPreProcessing/fxApplyMetadataAndTypes.pq) |
| fxChangeTypeNoErrors | Applies column types, ignoring names that are not in the table. | [src/DataPreProcessing/fxChangeTypeNoErrors.pq](../src/DataPreProcessing/fxChangeTypeNoErrors.pq) |
| fxGetTableMetadata | Returns a table with Index, Column Name, Duplicate, Type, and a "Keep Y/N" flag. | [src/DataPreProcessing/fxGetTableMetadata.pq](../src/DataPreProcessing/fxGetTableMetadata.pq) |
| fxMasterDataV02 | Combines and deduplicates a key column from two queries into a sorted text master list. | [src/DataPreProcessing/fxMasterDataV02.pq](../src/DataPreProcessing/fxMasterDataV02.pq) |
| fxMasterDataV03 | Combines and deduplicates a key column from two queries via bulk Table ops (prefer for large inputs). | [src/DataPreProcessing/fxMasterDataV03.pq](../src/DataPreProcessing/fxMasterDataV03.pq) |
| fxRandomSampleDefault10Percent | Performs a statistically random sample of an input table. | [src/DataPreProcessing/fxRandomSampleDefault10Percent.pq](../src/DataPreProcessing/fxRandomSampleDefault10Percent.pq) |

## Dates

| Function | Description | File |
|----------|-------------|------|
| fxAddDateParts | Adds common calendar attributes from a date/datetime column. | [src/Dates/fxAddDateParts.pq](../src/Dates/fxAddDateParts.pq) |
| fxCombineTablesByPrefix | Dynamically finds and expands all Excel tables that start with a specific text. | [src/Dates/fxCombineTablesByPrefix.pq](../src/Dates/fxCombineTablesByPrefix.pq) |
| fxCreateDateTable | Creates a calendar / date-dimension table for Excel PQ or Power BI (incl. day short name, weekday/weekend/working day; uses HolidaysList by default). | [src/Dates/fxCreateDateTable.pq](../src/Dates/fxCreateDateTable.pq) |
| HolidaysList | Editable holidays table (seed: 2026 England & Wales bank holidays). Companion to fxCreateDateTable. | [src/Dates/HolidaysList.pq](../src/Dates/HolidaysList.pq) |

## Files

| Function | Description | File |
|----------|-------------|------|
| fxCombineFolderFiles | Combines CSV/Excel files from a folder and adds a SourceFileName column. | [src/Files/fxCombineFolderFiles.pq](../src/Files/fxCombineFolderFiles.pq) |
| fxExpandExcelSheets | Combines sheets from one Excel workbook into a single table. | [src/Files/fxExpandExcelSheets.pq](../src/Files/fxExpandExcelSheets.pq) |

## Info

| Function | Description | File |
|----------|-------------|------|
| fxGetAllowedTypes | Returns a list of valid Power Query type strings for mapping. | [src/Info/fxGetAllowedTypes.pq](../src/Info/fxGetAllowedTypes.pq) |
| fxGetSchemaDocumentation | Returns a reference table containing the definitions | [src/Info/fxGetSchemaDocumentation.pq](../src/Info/fxGetSchemaDocumentation.pq) |
| fxGetTableProfile | Generates a statistical summary (Profile) of a given table. | [src/Info/fxGetTableProfile.pq](../src/Info/fxGetTableProfile.pq) |
| fxTableEnhancedProfile | _No description_ | [src/Info/fxTableEnhancedProfile.pq](../src/Info/fxTableEnhancedProfile.pq) |
| fxTableSchema | Returns a table containing the schema metadata for the input table. | [src/Info/fxTableSchema.pq](../src/Info/fxTableSchema.pq) |

## MLEncoder

| Function | Description | File |
|----------|-------------|------|
| fxLabelEncode | _No description_ | [src/MLEncoder/fxLabelEncode.pq](../src/MLEncoder/fxLabelEncode.pq) |
| fxOne_HotEncoder | _No description_ | [src/MLEncoder/fxOne_HotEncoder.pq](../src/MLEncoder/fxOne_HotEncoder.pq) |

## Sampling

| Function | Description | File |
|----------|-------------|------|
| fxGenerateXMRDiagnostics | This function constructs a full diagnostic overlay for X-mR control chart analysis, | [src/Sampling/fxGenerateXMRDiagnostics.pq](../src/Sampling/fxGenerateXMRDiagnostics.pq) |

