---
name: brain-init
description: First-run setup of the assistant — its name, purpose, the areas of life it covers, the human's standing preferences, and a starter bundle per area. Use when memory/core.md still contains {{placeholders}}, or when the human wants to rename, re-scope, or re-personalize the assistant.
---

# Brain init

Personalize a freshly installed assistant, or update an existing personalization. Work from the
assistant's root. `memory/{core,procedural,state,journal}.md` must exist; if any is missing the
install is broken — ask the human to re-install rather than recreating them.

## Gather

Ask for everything in one round, offering a sensible default for each so the human can accept or
correct (use the harness's structured-question tool if it has one): the assistant's name and
one-sentence purpose; the areas of life or work to cover; and standing preferences — units, time
zone, language, how replies should read. Don't invent answers (*Truth over invention*). On a re-run,
change only what the human asks to change.

Fill `{{assistant-name}}`, `{{scope}}`, and `{{purpose}}` in `memory/core.md`, and record the
preferences under its *Preferences*. Leave the Principles as they are unless the human adds one.

## Propose the bundles

Draft the whole set in one message: one bundle per self-contained area — merging areas that would
need to reference each other, since bundles don't link across — each with a scope line, its *Not
here* boundaries, and three to six starter concept types. Once the human approves or edits the draft,
build each approved bundle with `skills/bundle-create`, passing the agreed name, scope, boundaries, and
types so it doesn't re-ask them. Skip any area the human isn't ready to start. When the harness
supports sub-agents, independent bundles can be built in parallel; write the catalog rows yourself
so boundaries stay reciprocal.

Then re-read `memory/core.md` (your in-context copy is stale), log the setup in
`memory/journal.md`, and commit.

## Done when

`grep "{{" memory/core.md` returns nothing, preferences are recorded, every approved bundle is in
`bundles/index.md` with reciprocal boundaries, and the setup is journaled and committed.
