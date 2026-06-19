---
name: init
description: Personalize a fresh assistant — set its identity, domain, and purpose, seed its wiki, and verify no placeholders remain. Use once when bootstrapping a newly cloned repo or a child created by add.
---

# Init

Turn a domain-neutral assistant skeleton into a personalized one. Run from the assistant's root.

## Steps

1. **Confirm the memory contracts exist.** Ensure `memory/{core,procedural,declarative,working}.md`
   are present. If this node was just scaffolded by `add` and any are missing, create them from the
   parent's versions, with `core.md` reset to its `{{placeholders}}` and `declarative.md` /
   `working.md` empty.
2. **Interview the human** for: assistant name, domain (one clear area of responsibility), and
   purpose (one sentence). Ask; do not invent — *Truth over invention*.
3. **Fill `memory/core.md`.** Replace `{{assistant-name}}`, `{{domain}}`, `{{purpose}}`. Leave the
   Principles section unchanged unless the human wants domain-specific principles added.
4. **Seed the wiki.** Create any domain category folders under `wiki/` (per `wiki/schema.md`) and
   leave `wiki/index.md` as the empty catalog.
5. **Tune routing if needed.** Add domain-specific routes to `memory/procedural.md` only if the
   domain calls for skills beyond the defaults. Do not duplicate existing routes.
6. **Verify completion.** `grep -R "{{" memory/core.md` must return nothing. (Templates under
   `templates/` are expected to keep `{{...}}` — they are filled per page at ingest time.)
7. **Log it.** Append an entry to `memory/working.md`.

## Done when

`core.md` carries a real identity, the wiki is ready to receive pages, and no `{{...}}` remain in
the node's contract files.
