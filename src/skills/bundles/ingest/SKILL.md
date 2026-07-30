---
name: ingest
description: Absorb a new raw source from sources/inbox into an OKF bundle — extract, file into concepts, cross-link, update the bundle index and log, surface any time-sensitive facts into state.md, and relocate the source to library/. Use when new material needs to enter a knowledge base.
---

# Ingest

Turn a raw source into durable, interlinked OKF concepts. Knowledge compounds: integrate into
existing concepts rather than appending duplicates.

## Steps

1. **Take a source** from `sources/inbox/`. Read it; do not edit it (*Sources are immutable*).
   Ingest also accepts a **hand-off with no source file** — a fact from `skills/core/remember` or a
   learning promoted by `skills/core/reflect`. For those, cite per the sourceless form in the
   Source-citations convention (`memory/procedural.md`) and skip step 8.
2. **Pick the target bundle(s).** Read `bundles/index.md` and choose the bundle whose domain owns
   this material. A source spanning domains files each part into the bundle owning it — each cites
   the same `sources/library/<file>` (shared sources are expected; `skills/bundles/remove` accounts
   for them). If none fits, create one first with `skills/bundles/create`.
3. **Decide concept types** by listing the target bundle's `templates/`. One source may touch several
   concepts. If the material needs a type with no `templates/<type>.md`, **stop and ask** the human —
   add the template (`skills/bundles/create` step 3 has the shape) or use an existing type. Never
   invent a type or a page format on the fly — *Truth over invention*.
4. **File the knowledge.** For each affected concept:
   - New concept → copy `templates/<type>.md` and fill it. The template is **binding**: keep its
     frontmatter keys and its heading set and order (drop a section only where the template says it
     may be omitted); replace every `{{placeholder}}`; obey the `# Authoring` rules and then **delete
     that section**. Set `timestamp` to today. Name the file kebab-case and place it in the folder
     matching its type — `<type>/<name>.md`, mirroring the `templates/<type>.md` it came from. (An
     **imported** bundle keeps whatever layout it was authored with; follow that instead of imposing
     this one — its structure isn't ours to restructure.)
   - Existing concept → integrate the new facts in place; reconcile, don't append blindly; bump its
     `timestamp`. Bring the page up to its template while you're there if the template has since
     gained sections or fields it lacks.
   - Cross-link related concepts with the OKF absolute bundle-relative form
     `[title](/path/to/concept.md)`. Trace every claim to the source under a `# Citations` section,
     citing it by its `sources/library/<file>` path (its permanent home after step 8) — a stable,
     greppable key that lets `skills/bundles/remove` find this bundle's backing sources later.
5. **Update the `index.md`** — add/adjust the list entry for each created or renamed concept in its
   own `<type>/index.md`. The root `index.md` lists the type folders, so it only needs touching when a
   type folder is new (create its `index.md` too) — that split is what keeps a large bundle
   progressively disclosed.
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

The source's knowledge lives in the bundle as conformant concepts — each matching its type's
template, with no `{{placeholder}}` or `# Authoring` section left behind — the bundle `index.md` and
`log.md` are in sync, any time-sensitive facts are in `state.md`, and the source sits in `library/`.
