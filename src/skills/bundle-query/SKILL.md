---
name: bundle-query
description: Answer a question from what the assistant already knows — across one or several bundles — and file valuable new syntheses back as concepts. Use for any question the bundles might bear on, before reasoning from general knowledge.
---

# Query

Retrieve, synthesize, and — crucially — file the synthesis back so the work compounds instead of
being lost in chat.

## How

**Locate.** Scan the whole `bundles/index.md` catalog: a question may span several bundles (a camera
bought for the homelab's security setup; a workout plan constrained by an injury). Open every
plausibly relevant bundle's `index.md` in one parallel batch, then the type-folder indexes and
concepts you need — again batching reads that don't depend on each other. Concept links are
bundle-root-relative (`/type/name.md`).

**Answer** only from what the concepts and their cited sources support, citing the concept or source
behind each claim and attributing facts to their bundle when more than one contributed. If the
bundles can't answer, say so plainly and name the gap — *Truth over invention*; suggest an ingest,
or note the gap as a link to a not-yet-written concept.

**File back** a synthesis that is durable and not already captured: a new concept or an update to an
existing one, written from the bundle's `templates/<type>.md` exactly as `skills/bundle-ingest` step 4
does, with that bundle's `index.md` and `log.md` updated. A cross-cutting synthesis goes into the
single most-relevant bundle; if it belongs to none, leave it in the reply (*One fact, one home*).
Filing nothing back is fine; re-deriving known knowledge without checking the bundles is not.

Log the query in `memory/journal.md`.

## Done when

The answer is grounded and cited, gaps are named, and anything durable is filed in the right bundle.
