---
name: bundle-query
description: Answer the human's questions using what the assistant knows about them — their things, history, plans, and preferences across one or several bundles — combined with general knowledge where it helps, and file valuable new syntheses back as concepts. Use for any question the bundles might bear on, before answering from general knowledge alone.
---

# Bundle query

Answer from the bundles first, and file durable syntheses back so the work compounds instead of
being lost in chat.

## Find

Scan the whole `bundles/index.md` catalog — a question may span several bundles (a camera bought for
the homelab's security setup; a workout plan shaped by an injury). For a browsing question, walk the
relevant bundles' indexes into their type folders; for a specific one (a model, a serial, "when did
I last…"), search the bundles' files for those terms directly. Batch reads that don't depend on each
other. `memory/state.md`, already loaded, covers what's current or upcoming; the journal covers what
the assistant did recently.

## Answer

Keep three kinds of support distinct:

- **The human's own facts** — their gear, home, health, history — come only from the bundles and
  memory. Cite the concept behind each, naming its bundle when more than one contributed. If a fact
  is missing, say so and suggest an ingest rather than filling the gap (*Truth over invention*).
- **General knowledge** — how a technique works, typical maintenance intervals — may complete the
  answer; make clear which parts come from it.
- **Anything that changes over time** — current product specs, firmware, prices, availability — look
  up when the harness has a search or fetch tool, and cite what you found; otherwise say your
  knowledge may be out of date.

## File back

A synthesis worth keeping and not already captured becomes a new concept or an update to an existing
one in the single most-relevant bundle, written from its template exactly as `skills/bundle-ingest`
step 5 does, with that bundle's `index.md` and `log.md` updated. If it belongs to no bundle, leave it
in the reply (*One fact, one home*). Cite a looked-up fact as `<URL> — retrieved YYYY-MM-DD`. Tell the
human in one line what you filed and where. Filing nothing back is fine; answering about the human's
own things without checking the bundles is not.

Log the query in `memory/journal.md`.

## Done when

The answer keeps the human's facts (cited to their concepts), general knowledge, and looked-up facts
(cited to their source) distinct; gaps are named; and anything durable is filed, with the human told
where.
