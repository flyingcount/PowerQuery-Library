---
id: harvest-prompt
title: Harvest a chat into the prompt library
category: library-ops
status: active
created: 2026-08-14
updated: 2026-08-14
tags: [prompts, github, harvest]
tools: [agent]
---

# Harvest a chat into the prompt library

## When to use

- The user has a working ad-hoc prompt and wants it saved for reuse.
- Agent noticed the same instruction appearing more than once.
- Do not harvest one-off questions, secrets, or text that already lives in `docs/`.

## Inputs

- The source prompt text or the chat turns to distill
- Optional: target category (`power-query`, `excel-power-bi`, `library-ops`)
- `@prompts/_template.md` and `@.cursor/rules/prompt-library.mdc`

## Prompt

Turn the provided instructions into one library prompt and sync it to GitHub.

1. Search `prompts/CATALOG.md` and `prompts/` for a duplicate. Update in place if the same job already exists.
2. Distill stable steps. Strip one-off table names, personal paths, secrets, and conversational filler. Parameterise remaining inputs.
3. Copy `prompts/_template.md` to `prompts/<category>/<slug>.md`. Set `id` to the file stem, `status: active`, `created`/`updated` to today.
4. Fill **When to use**, **Inputs**, **Prompt**, **Output**, and **Guardrails**. The **Prompt** section must be pasteable into a new chat.
5. Add a row to `prompts/CATALOG.md` and an Unreleased note in `CHANGELOG.md`.
6. If this is a multi-step slash workflow, add `.cursor/skills/<slug>/SKILL.md` that references the prompt file instead of copying it.

Keep the prompt under ~150 lines. Do not duplicate the body into `.cursor/rules/`.

## Output

- New or updated `prompts/<category>/<slug>.md`
- Catalog and changelog updates
- Confirmation of the `id`, path, and that the change is committed for GitHub sync

## Guardrails

- Follow `.cursor/rules/prompt-library.mdc` for layout, frontmatter, retire-vs-edit, and git sync.
- Never commit credentials or local workbook contents.
