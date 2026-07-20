---
name: query
description: Answer a question from a bundle and file valuable new syntheses back as concepts. Use to retrieve and reason over existing knowledge rather than re-deriving it each time.
---

# Query

Retrieve, synthesize, and — crucially — file the synthesis back so the work compounds instead of
being lost in chat.

## Steps

1. **Locate.** Read `bundles/index.md` to pick the relevant bundle(s), then start from each bundle's
   `index.md` and read the relevant concepts. Follow their `[title](/path/to/concept.md)` links.
2. **Synthesize** an answer grounded only in what the concepts (and their cited sources) support. If
   the bundles can't answer, say so plainly — *Truth over invention* — and note the gap.
3. **File valuable results back.** If the synthesis is durable and not already captured, record it as
   a new concept (with a `type:`) or fold it into an existing one in the right bundle. Update that
   bundle's `index.md` and `log.md`, and cross-link.
4. **Surface gaps.** If answering revealed missing knowledge, suggest an `ingest` (or capture the gap
   as a link to a not-yet-created concept).
5. **Log it.** Append an entry to `memory/journal.md`.

## Notes

- Prefer the curated bundles over recall. Cite the concept or source behind each claim.
- A query that files nothing back is fine; one that re-derives known knowledge without checking the
  bundles is not.
