---
name: ingest
description: Absorb a new raw source from sources/inbox into an OKF bundle — extract, file into concepts, cross-link, update the bundle index and log, surface any time-sensitive facts into state.md, and relocate the source to library/. Use when new material needs to enter a knowledge base.
---

# Ingest

Turn a raw source into durable, interlinked OKF concepts. Knowledge compounds: integrate into
existing concepts rather than appending duplicates.

## Steps

1. **Take a source** from `sources/inbox/`. Read it; do not edit it (*Sources are immutable*).
2. **Pick the target bundle.** Read `bundles/index.md` and choose the bundle whose domain owns this
   material. If none fits, create one first with `skills/bundles/create`.
3. **Decide concept types** from the target bundle's `templates/`. One source may touch several
   concepts.
4. **File the knowledge.** For each affected concept:
   - New concept → start from the matching `templates/<type>.md` skeleton, fill it (required `type:`;
     set `timestamp` to today), name the file kebab-case, place it at the bundle root or in the right
     subdirectory.
   - Existing concept → integrate the new facts in place; reconcile, don't append blindly; bump its
     `timestamp`.
   - Cross-link related concepts with the OKF absolute bundle-relative form
     `[title](/path/to/concept.md)`. Trace every claim to the source under a `# Citations` section,
     citing it by its `sources/library/<file>` path (its permanent home after step 8) — a stable,
     greppable key that lets `skills/bundles/remove` find this bundle's backing sources later.
5. **Update the `index.md`** — add/adjust the list entry for each created or renamed concept. If a
   concept lives in a subdirectory, update that subdirectory's own `index.md` (create it if the
   subdirectory is new) and make sure the parent `index.md` links to the subdirectory — so large
   bundles stay progressively disclosed.
6. **Append to the bundle `log.md`** — a `* **Creation**`/`* **Update**` bullet under a
   `## YYYY-MM-DD` heading (newest first) naming what changed.
7. **Surface time-sensitive facts.** If the source carries anything with a shelf life — deadlines,
   appointments, renewals, active-task status — record it in `memory/state.md` (date-anchored →
   *Upcoming Deadlines*; open-ended → *Entries*). The durable facts stay in the bundle; this mirrors
   only the time-sensitive slice into state.
8. **Relocate the source** from `sources/inbox/` to `sources/library/` (it is now ingested and
   permanent). If a concept needs a local copy of the source to cite, place it under the bundle's
   `references/`.
9. **Log it.** Append an entry to `memory/journal.md` naming the source, the bundle, and the concepts
   touched.

## Done when

The source's knowledge lives in the bundle as conformant concepts, the bundle `index.md` and `log.md`
are in sync, any time-sensitive facts are in `state.md`, and the source sits in `library/`.
