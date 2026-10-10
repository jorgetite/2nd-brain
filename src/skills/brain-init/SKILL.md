---
name: brain-init
description: One-time setup of a freshly installed assistant — give it a name, a purpose, and the life areas it covers, and optionally stand up one knowledge bundle per area. Use when core.md still has {{placeholders}} or the human wants to re-personalize the assistant.
---

# Init

Turn a freshly installed, domain-neutral assistant into a personalized one. Run from the assistant's
root. The install from `src/` (via `install.sh`) provides `memory/{core,procedural,state,journal}.md`;
if any is missing, stop and have the human re-install rather than improvising them.

## What to establish

- **Identity.** Interview the human for the assistant's name, its purpose (one sentence), and the
  areas of life or work it should cover (e.g. home, homelab, a hobby, health). Ask; don't invent —
  *Truth over invention*. Fill `{{assistant-name}}`, `{{scope}}` (a one-line summary of those areas),
  and `{{purpose}}` in `memory/core.md`. Leave the Principles unchanged unless the human wants
  additions.
- **Bundles (optional).** A new assistant has an empty `bundles/index.md`. For each area the human
  is ready to start, offer `skills/bundle-create` — confirming each bundle. Help the human draw the
  boundaries: an area that would constantly need links into another (cameras and photography,
  fitness and health) belongs in one bundle, because bundles don't link to each other. Areas can
  also be added later.
- **Routing (rare).** Add routes to `memory/procedural.md` only if an area needs a skill beyond the
  defaults; don't duplicate existing routes.

Log the setup in `memory/journal.md`.

## Done when

`grep -R "{{" memory/core.md` returns nothing (bundle `templates/` keep theirs — they're filled per
concept), and any bundles the human chose to start are registered in `bundles/index.md` with their
scope and boundaries.
