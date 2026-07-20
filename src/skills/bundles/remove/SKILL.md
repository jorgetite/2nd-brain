---
name: remove
description: Retire a knowledge bundle — confirm the deletion, optionally preserve a copy, delete bundles/<name>/, and deregister it from the catalog. Destructive and irreversible; human-initiated. Use to permanently remove a bundle the assistant no longer needs.
---

# Remove

Retire a bundle the assistant no longer needs. This is **destructive and irreversible** — the
*Reversible by default* principle explicitly applies: confirm before deleting anything. Removal is
**human-initiated**; never remove a bundle to satisfy an unrelated request.

## Steps

1. **Identify** the target `bundles/<name>/` from `bundles/index.md`. If it isn't listed, stop and
   surface that — don't guess.
2. **Confirm with the human.** State exactly what will be deleted — the `bundles/<name>/` directory
   and everything in it (concepts, `index.md`, `log.md`, `templates/`, any `references/`). Its global
   backing sources are archived, not deleted (step 4). Do not proceed without an explicit go-ahead.
3. **Offer to preserve first.** OKF bundles are portable — offer to copy or move the bundle out to a
   path outside `bundles/` (or confirm the human already has a copy) before deleting. Skip only if the
   human declines.
4. **Archive backing sources.** Before deleting, find the global sources this bundle relied on: scan
   its concepts' `# Citations` for `sources/library/<file>` references. For each, grep the *other*
   bundles' concepts for the same path; if no other bundle cites it, move it
   `sources/library/ → sources/archive/` — its knowledge no longer lives in any bundle. Leave shared
   sources in `library/`. This is a non-destructive move; sources stay permanent.
5. **Delete** the `bundles/<name>/` directory.
6. **Deregister.** Remove the bundle's row from `bundles/index.md`. If it was the last one, restore
   the `_(no bundles yet)_` placeholder.
7. **Clear references.** Remove any lingering references to the bundle from `memory/state.md` (e.g.
   time-sensitive facts `skills/bundles/ingest` mirrored from it).
8. **Log it.** Append an entry to `memory/journal.md` naming the bundle removed and any sources archived.

## Done when

`bundles/<name>/` is gone, it no longer appears in `bundles/index.md`, its unshared backing sources
sit in `sources/archive/`, and no stale references to it remain in memory.
