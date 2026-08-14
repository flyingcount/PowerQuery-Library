---
id: example-slug
title: Example prompt title
category: library-ops
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [example]
tools: [agent]
---

# Example prompt title

## When to use

- Use when …
- Do not use when …

## Inputs

- `@path/to/file` — what it is
- Function or query name
- Any constraints from the user

## Prompt

You are working in the Power Query library at the repo root.

1. …
2. …
3. …

Do not invent APIs. Prefer existing helpers under `src/`. Follow `docs/NamingConvention.md` and `docs/CodingStandards.md`.

## Output

- What the agent should produce (patch, checklist, test note, etc.)

## Guardrails

- One logical change; update `docs/FunctionCatalog.md` and `CHANGELOG.md` when adding functions.
- Do not commit secrets, local workbooks under `Data/*.xlsb`, or `Data/Section1.m`.
