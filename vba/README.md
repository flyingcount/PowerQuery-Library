# VBA Library

Git-friendly VBA companion to the Power Query (`src/`) library.

**Design rule:** one Excel add-in project (`.xlam`) holds the full call graph. Public API modules call `Internal` helpers with normal `Call` statements — do not split helpers across workbooks.

```text
vba/
├── README.md
├── docs/
│   ├── ExportImport.md      ← how to sync Personal.xlsb / .xlam ↔ source/
│   └── ModuleMap.md         ← suggested modules + migration order
├── source/
│   ├── Api/                 ← Public entry points only
│   └── Internal/            ← Private / shared helpers (array→sheet, etc.)
└── build/                   ← compiled .xlam (local; not required in git)
```

## Quick start

1. Enable **Trust access to the VBA project object model** (see [docs/ExportImport.md](docs/ExportImport.md)).
2. Export from `Data/Personal123.xlsb` into `source/_export_raw/` (done once Trust access is on).
3. Promote shared code using [docs/ModuleMap.md](docs/ModuleMap.md) — start with `aPublicProcedures`.
4. Create `build/PowerQueryVbaLib.xlam` and import curated `source/Api` + `source/Internal` modules.
5. Load the add-in; call public macros via reference or `Application.Run`.

## Relationship to Personal123.xlsb

| Role | Location |
|------|----------|
| Live personal workbook | `Data/Personal123.xlsb` (gitignored) |
| Raw VBA export | `vba/source/_export_raw/` (gitignored) |
| Curated library source | `vba/source/Api/**`, `vba/source/Internal/**` |
| Runtime library | `build/PowerQueryVbaLib.xlam` |
| Inventory notes | [docs/PersonalInventory.md](docs/PersonalInventory.md) |
| Infrastructure vs features | [docs/InfrastructureCatalog.md](docs/InfrastructureCatalog.md) |
