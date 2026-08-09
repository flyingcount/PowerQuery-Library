# Changelog

All notable changes to this library are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- `fxNullIfBlank` (`src/CleanseTables/`) — replace empty or whitespace-only text with `null` (optional column list).
- `fxAddDateParts` (`src/Dates/`) — add Year, Quarter, Month, Week, and day-of-week columns from a date/datetime field.
- `fxCombineFolderFiles` (`src/Files/`) — combine CSV/Excel files from a folder with `SourceFileName`.
- `fxExpandExcelSheets` (`src/Files/`) — append workbook sheets (optional name pattern) with `SourceSheet`.
- `fxMasterDataV02` (`src/DataPreProcessing/`) — combine and deduplicate a key column from two queries into a text master list (resolve by trimmed header, blank/error cleanup, per-source then final distinct, sorted).
- `fxMasterDataV03` (`src/DataPreProcessing/`) — same purpose as V02 using bulk `Table.*` ops; remove errors before distinct; trim text keys (prefer for large inputs).
- `fxCreateDateTable` (`src/Dates/`) — calendar dimension table for Excel Power Query and Power BI, with optional fiscal year start month, Day Name Short, Is Weekday / Is Weekend / Is Working Day, and optional Holidays list.
- `HolidaysList` (`src/Dates/`) — editable holidays table seeded with 2026 England & Wales bank holidays; used by `fxCreateDateTable` when Holidays is omitted.

### Changed
- Moved VBA scaffold and Personal workbook material to [Excel-VBA-Library](https://github.com/flyingcount/Excel-VBA-Library).

## [0.1.0] - 2026-08-08

### Added
- Initial repository structure for a reusable Power Query function library.
- Extracted 31 functions from `Data/Personal.xlsb` into individual `.pq` files under `src/`.
- Categories: CleanseColumns, CleanseRows, CleanseTables, Info, DataPreProcessing, Dates, ControlCharts, Sampling, AddColumn, MLEncoder.
- Documentation: CodingStandards, NamingConvention, FunctionCatalog.
- Example usage notes for Excel ETL and Power BI.
- Fact / dimension query templates.
- Manual test stubs and sample-data placeholder.
