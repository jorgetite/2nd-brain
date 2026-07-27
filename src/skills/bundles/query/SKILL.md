---
name: query
description: Answer a question from a bundle and file valuable new syntheses back as concepts. Use to retrieve and reason over existing knowledge rather than re-deriving it each time.
---

# Query

Retrieve, synthesize, and — crucially — file the synthesis back so the work compounds instead of
being lost in chat.

## Steps

1. **Locate.** Scan the **whole** `bundles/index.md` catalog and open **every** bundle whose domain
   could plausibly bear on the question — don't stop at the first match; a question may span several
   bundles. Enter each at its `index.md`, follow into the type folders' own `index.md` as needed, and read
   the relevant concepts via their `[title](/path/to/concept.md)` links (the leading `/` is
   bundle-root-relative).
2. **Synthesize** an answer grounded only in what the concepts (and their cited sources) support. When
   the answer draws on more than one bundle, **attribute** each fact to the bundle/concept it came
   from. If the bundles can't answer, say so plainly — *Truth over invention* — and note the gap.
3. **File valuable results back.** If the synthesis is durable and not already captured, record it as
   a new concept or fold it into an existing one — writing it exactly as `skills/bundles/ingest` step 4
   does, from the bundle's `templates/<type>.md`. A cross-cutting synthesis goes into
   the **single most-relevant bundle**; if it belongs to no single bundle, leave it in the reply
   rather than forcing it somewhere (*One fact, one home*). Update that bundle's `index.md` and
   `log.md`, and cross-link.
4. **Surface gaps.** If answering revealed missing knowledge, suggest an `ingest` (or capture the gap
   as a link to a not-yet-created concept).
5. **Log it.** Append an entry to `memory/journal.md`.

## Notes

- Prefer the curated bundles over recall. Cite the concept or source behind each claim.
- A query that files nothing back is fine; one that re-derives known knowledge without checking the
  bundles is not.
