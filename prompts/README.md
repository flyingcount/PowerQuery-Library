# Prompt library

Reusable prompts for Cursor Agent, versioned in **code-library** and synced with GitHub.

GitHub is the source of truth. Clone or pull this repo to get the latest prompts; do not keep the only copy in chat or User Rules.

## How to use

1. Open `CATALOG.md` and pick a prompt.
2. In Cursor chat, `@`-mention the file (for example `@prompts/library-ops/add-function.md`) or paste the **Prompt** section.
3. Attach the files the prompt asks for (`@src/...`, `@docs/...`).

## How to add or change a prompt

Follow `.cursor/rules/prompt-library.mdc`. Short version:

1. Copy `_template.md` to `prompts/<category>/<slug>.md`.
2. Fill the frontmatter and body.
3. Add or update the row in `CATALOG.md`.
4. Note the change in `CHANGELOG.md`.
5. Commit and push so GitHub matches the workspace.

## Categories

| Folder | Use for |
|--------|---------|
| `power-query/` | Authoring and reviewing M / `.pq` functions |
| `excel-power-bi/` | Excel and Power BI Desktop workflows that use **code-library** |
| `library-ops/` | Repo hygiene: new functions, tests, catalog, changelog, harvesting prompts |
| `archive/` | Retired prompts (keep for history) |
