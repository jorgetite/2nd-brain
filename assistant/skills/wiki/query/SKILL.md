---
name: query
description: Answer a question from the wiki and file valuable new syntheses back as pages. Use to retrieve and reason over existing knowledge rather than re-deriving it each time.
---

# Query

Retrieve, synthesize, and — crucially — file the synthesis back so the work compounds instead of
being lost in chat.

## Steps

1. **Locate.** Start from `wiki/index.md`, then read the relevant pages. Follow `[[links]]`.
2. **Synthesize** an answer grounded only in what the pages (and their cited sources) support. If
   the wiki can't answer, say so plainly — *Truth over invention* — and note the gap.
3. **File valuable results back.** If the synthesis is durable and not already captured, record it:
   a new `note` (or fold it into an existing entity/topic) per `wiki/schema.md`. Update
   `wiki/index.md` and cross-link.
4. **Surface gaps.** If answering revealed missing knowledge, suggest an `ingest` (or capture the
   gap as a `[[stub-link]]`).
5. **Log it.** Append an entry to `memory/working.md`.

## Notes

- Prefer the curated wiki over recall. Cite the page or source behind each claim.
- A query that files nothing back is fine; one that re-derives known knowledge without checking the
  wiki is not.
