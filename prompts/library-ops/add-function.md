---
id: add-function
title: Add a Power Query function
category: library-ops
status: active
created: 2026-08-14
updated: 2026-08-14
tags: [new-function, power-query, catalog]
tools: [agent]
---

# Add a Power Query function

## When to use

- The user wants a new reusable `fx*` function in **code-library**.
- Do not use for one-off queries that belong only in a workbook, or for VBA (that lives in Excel-VBA-Library).

## Inputs

- Purpose of the function in one or two sentences
- `@docs/NamingConvention.md` and `@docs/CodingStandards.md`
- Optional: a similar existing function to mirror (`@src/<Category>/fx….pq`)
- Optional: sample shape of the input table

## Prompt

Add one Power Query (M) function to **code-library**.

1. Choose the `src/<Category>/` folder from `docs/NamingConvention.md`. Create a new folder only if no existing category fits.
2. Name it `fx` + PascalCase verb-first (file name = function name + `.pq`). One function per file.
3. Start the file with the standard banner (name, category, one-line description, author, date) from `docs/CodingStandards.md`.
4. Use a typed function expression (`(InputTable as table) as table => …` or equivalent). Parameterise column names; do not hard-code sample headers unless documenting an example.
5. Handle empty tables, `null`, and `""` explicitly when cleansing text. Prefer pure table-in / table-or-list-out functions.
6. Add a short Unreleased → Added note in `CHANGELOG.md`.
7. Add or regenerate the row in `docs/FunctionCatalog.md`.
8. If behaviour is non-trivial, add a manual test note under `tests/test_<FunctionName>.md`.

Do not modify `Data/Section1.m` or source workbooks. Do not bundle unrelated refactors in the same change.

## Output

- New `src/<Category>/<FunctionName>.pq`
- Catalog and changelog updates
- Test note when warranted
- Brief usage snippet (Excel blank query paste + invoke example)

## Guardrails

- Follow existing helpers instead of duplicating them.
- Keep the PR to one logical change.
