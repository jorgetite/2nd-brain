---
name: init
description: Personalize a fresh assistant — set its identity, domain, and purpose, optionally stand up its first knowledge bundle, and verify no placeholders remain. Use once when bootstrapping a newly cloned repo.
---

# Init

Turn a domain-neutral assistant skeleton into a personalized one. Run from the assistant's root.

## Steps

1. **Confirm the memory contracts exist.** The install from `src/` (via `install.sh`) provides
   `memory/{core,procedural,state,journal}.md`. If any are missing, stop — the assistant wasn't
   installed correctly; re-install from `src/` rather than improvising them here.
2. **Interview the human** for: assistant name, domain (one clear area of responsibility), and
   purpose (one sentence). Ask; do not invent — *Truth over invention*.
3. **Fill `memory/core.md`.** Replace `{{assistant-name}}`, `{{domain}}`, `{{purpose}}`. Leave the
   Principles section unchanged unless the human wants domain-specific principles added.
4. **Stand up the first bundle (optional).** A new assistant arrives with an empty `bundles/index.md`
   and no bundles. If the human is ready to start a knowledge base, run `skills/bundles/create` to add
   the first OKF bundle for the domain. Otherwise leave `bundles/` empty — bundles can be created
   later as needed.
5. **Tune routing if needed.** Add domain-specific routes to `memory/procedural.md` only if the
   domain calls for skills beyond the defaults. Do not duplicate existing routes.
6. **Verify completion.** `grep -R "{{" memory/core.md` must return nothing. (Any concept templates
   under `bundles/<name>/templates/` keep their `{{...}}` — they're filled per concept at ingest.)
7. **Log it.** Append an entry to `memory/journal.md`.

## Done when

`core.md` carries a real identity, no `{{...}}` remain in the assistant's contract files, and — if the
human chose to start one — a first bundle is registered in `bundles/index.md`.
