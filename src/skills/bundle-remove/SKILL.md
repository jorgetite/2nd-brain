---
name: bundle-remove
description: Retire a knowledge bundle the human no longer wants — survey what removal affects, confirm, optionally export a copy, archive its unshared sources, delete it, and clean up the catalog and state. Destructive and human-initiated; use only when the human asks to remove a bundle.
---

# Bundle remove

Retire a bundle. Removal is **destructive** and **human-initiated** — never remove a bundle to satisfy
an unrelated request, and never without explicit confirmation (*Reversible by default*). If the human
wants the knowledge kept in another bundle, that is a move, not a removal: file it there with
`skills/bundle-ingest` first.

## Steps

1. **Survey, changing nothing.** Find the bundle in `bundles/index.md`; if it isn't listed, stop and
   say so. Work out exactly what removal touches:
   - the concepts, templates, and `references/` under `bundles/<name>/`;
   - its backing sources — every `library:<file>` in its concepts' `sources` (a v0.1 bundle cites
     `sources/library/<file>` under `# Citations`). Those no other bundle cites will move to
     `sources/archive/`; shared ones stay;
   - other bundles' catalog rows whose *Not here* clauses name it;
   - `memory/state.md` entries tagged with it — some, like recurring maintenance, may still matter.
2. **Confirm once, with specifics** — the concept count, the sources to archive, each affected boundary
   clause (proposing to drop it or widen the neighbour's scope), and each state entry (proposing to
   keep or drop it). Say plainly how recoverable removal is: in a git-versioned assistant the bundle
   stays in history — recoverable, but not erased. If the human is removing it for privacy (health
   records, say), tell them purging history is a separate step they would have to ask for. Proceed
   only on an explicit go-ahead.
3. **Offer a portable copy.** OKF bundles are self-contained; offer to export one outside `bundles/`
   (for example to `artifacts/`) before deleting. Skip if declined.
4. **Archive** the unshared backing sources (`sources/library/ → sources/archive/`); shared sources
   stay.
5. **Delete** `bundles/<name>/`.
6. **Clean up the catalog** — remove its row (restoring `_(no bundles yet)_` if it was the last), and
   drop or re-point the other rows' *Not here* clauses that named it, as agreed.
7. **Clean up state** — keep or drop its entries as agreed; a kept entry loses the bundle tag.
8. **Commit and log** — one commit for the whole removal, and a journal line naming the bundle and the
   sources archived.

## Done when

`bundles/<name>/` is gone and nothing in the catalog names it, including other rows' boundaries; its
unshared sources sit in `sources/archive/`; its state entries were kept or dropped as the human
chose; the removal is committed and journaled; and the human knows whether the content survives in
history.
