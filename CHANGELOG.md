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
