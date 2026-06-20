---
name: init
description: Personalize a fresh assistant — set its identity, domain, and purpose, build its domain-specific wiki schema and page templates, and verify no placeholders remain. Use once when bootstrapping a newly cloned repo or a child created by create.
---

# Init

Turn a domain-neutral assistant skeleton into a personalized one. Run from the assistant's root.

## Steps

1. **Confirm the memory contracts exist.** `create` (or a fresh clone) provides
   `memory/{core,procedural,state,journal}.md`. If any are missing, stop — the assistant
   wasn't scaffolded correctly; re-run `create` rather than improvising them here.
2. **Interview the human** for: assistant name, domain (one clear area of responsibility), and
   purpose (one sentence). Ask; do not invent — *Truth over invention*.
3. **Fill `memory/core.md`.** Replace `{{assistant-name}}`, `{{domain}}`, `{{purpose}}`. Leave the
   Principles section unchanged unless the human wants domain-specific principles added.
4. **Build the domain wiki (required).** A new assistant arrives with only an empty `wiki/index.md`
   and no `templates/` or `wiki/schema.md` — `init` MUST create them, tailored to the domain:
   - **Decide the page types** this domain needs — the key kinds of entity or record it will track
     (e.g. a recipes assistant: `recipe`, `ingredient`; a contacts assistant: `person`, `company`).
   - **Create a template per type** at `templates/<type>.md`: YAML front-matter (`title`, `type`,
     `created`, `updated`, `sources`) plus a section skeleton, using `{{placeholders}}` that are
     filled per page at ingest.
   - **Write `wiki/schema.md`** documenting those page types and their templates, plus naming
     (kebab-case), cross-linking (`[[page-name]]`), and source-tracing conventions.
   - Leave `wiki/index.md` empty until pages exist; add category folders only if the schema calls
     for them.
5. **Tune routing if needed.** Add domain-specific routes to `memory/procedural.md` only if the
   domain calls for skills beyond the defaults. Do not duplicate existing routes.
6. **Verify completion.** `grep -R "{{" memory/core.md` must return nothing. (Any page templates
   you add under `templates/` keep their `{{...}}` — they're filled per page at ingest time.)
7. **Log it.** Append an entry to `memory/journal.md`.

## Done when

`core.md` carries a real identity; `wiki/schema.md` and at least one domain page template exist;
`wiki/index.md` is empty and ready; and no `{{...}}` remain in the assistant's contract files.
