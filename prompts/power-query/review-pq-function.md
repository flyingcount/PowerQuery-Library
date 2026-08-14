---
id: review-pq-function
title: Review a Power Query function
category: power-query
status: active
created: 2026-08-14
updated: 2026-08-14
tags: [review, m-language, quality]
tools: [agent]
---

# Review a Power Query function

## When to use

- Reviewing a new or changed `.pq` file before merge.
- The user asks for a code review, quality pass, or “does this match the library style?”.
- Do not use for adding a brand-new function (use `add-function`) or for VBA.

## Inputs

- The function file(s), e.g. `@src/<Category>/fxName.pq`
- `@docs/NamingConvention.md` and `@docs/CodingStandards.md`
- Optional: `@tests/test_fxName.md` and the catalog row

## Prompt

Review the attached Power Query function against this library’s conventions.

Check, in order:

1. **Name and location** — `fx` prefix, PascalCase, verb-first, file name = function name, folder matches capability.
2. **Header** — banner with name, category, description, author, date.
3. **Shape** — typed parameters and return type; public parameter list is clear if nested helpers exist.
4. **Correctness** — empty table, null, and blank-text behaviour; no assumed column names unless they are parameters or documented samples.
5. **Style** — named steps, comments only for non-obvious why, `Table.Buffer` / `List.Buffer` only when needed.
6. **Docs** — `docs/FunctionCatalog.md` and `CHANGELOG.md` updated if this is a new or behaviour-changing function; test note present if behaviour is non-trivial.

Quote the relevant snippet when flagging an issue. Distinguish must-fix vs optional.

## Output

- Verdict: approve / request changes
- Ordered list of findings (severity, location, suggested fix)
- What is already in good shape (one short paragraph)

## Guardrails

- Do not rewrite the function unless the user asked for fixes.
- Do not expand scope to unrelated files.
