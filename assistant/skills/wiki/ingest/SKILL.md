---
name: ingest
description: Absorb a new raw source from sources/inbox into the wiki — extract, file into pages, cross-link, update the index, and relocate the source to library/. Use when new material needs to enter the knowledge base.
---

# Ingest

Turn a raw source into durable, interlinked wiki pages. Knowledge compounds: integrate into
existing pages rather than appending duplicates.

## Steps

1. **Take a source** from `sources/inbox/`. Read it; do not edit it (*Sources are immutable*).
2. **Decide page types** per `wiki/schema.md`: entity, topic, or note. One source may touch several
   pages.
3. **File the knowledge.** For each affected page:
   - New page → start from the matching `templates/` skeleton, fill it, name it kebab-case, place it
     under the right `wiki/` category.
   - Existing page → integrate the new facts in place; reconcile, don't append blindly.
   - Cross-link related pages with `[[page-name]]`. Trace every claim to the source.
4. **Update `wiki/index.md`** — add/adjust the catalog entry for each created or renamed page.
5. **Relocate the source** from `sources/inbox/` to `sources/library/` (it is now ingested and
   permanent).
6. **Log it.** Append an entry to `memory/working.md` naming the source and the pages touched.

## Done when

The source's knowledge lives in the wiki, the index is in sync, and the source sits in `library/`.
