---
name: add
description: Create a new child assistant under assistants/ with the full node structure, seeded from this assistant, then personalize it via init. Use to spin up a specialized assistant for a sub-domain.
---

# Add

Grow the tree by one node. A child is an identical, self-contained assistant — it must run
standalone and as a child.

## Steps

1. **Name it.** Pick a kebab-case domain name; the child lives at `assistants/<name>/`. Refuse if it
   already exists.
2. **Scaffold the node** at `assistants/<name>/` with the full shape:
   `memory/`, `skills/`, `sources/{inbox,library,archive}/`, `templates/`, `wiki/`, `assistants/`.
3. **Seed capability from this assistant** (children inherit current, possibly self-evolved skills):
   copy `skills/`, `templates/`, `AGENTS.md`, and `memory/procedural.md` as-is.
4. **Start state empty:** create `memory/core.md` with `{{placeholders}}`, empty `declarative.md`
   and `working.md`, and `wiki/{index.md,schema.md}`. Do **not** copy this assistant's identity,
   declarative facts, working log, sources, or wiki pages.
5. **Personalize.** Run `skills/core/init` scoped to `assistants/<name>/` to set the child's
   identity, domain, and purpose.
6. **Log it.** Append an entry to `memory/working.md`.

## Done when

`assistants/<name>/` is a complete, personalized node that bootstraps on its own, and `delegate`
can route to it.
