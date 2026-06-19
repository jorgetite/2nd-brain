---
name: reflect
description: Consolidate working memory into the upper layers and prune stale state — the self-improvement loop. Run at session end, or when working.md has accrued many un-consolidated entries.
---

# Reflect

The capability-compounding loop (Continual Harness). It reads the activity stream and moves durable
learnings to their real home, then trims the stream — adapting the assistant, not any model weights.

## Steps

1. **Read the trajectory.** Load the un-consolidated tail of `memory/working.md` (recent entries;
   never the whole file — see Bootstrapping in `memory/procedural.md`).
2. **Consolidate, routing by the Recording table** in `memory/procedural.md`:
   - Durable knowledge for the human → `wiki/` via `skills/wiki/ingest` or `query`.
   - A repeatable workflow that emerged → a new/updated skill under `skills/` **and** a route in
     `procedural.md`.
   - A lasting principle (rare) → `memory/core.md`.
   - Still-current short-lived state → `memory/declarative.md`.
3. **Prune declarative.** Drop entries in `memory/declarative.md` past their `expires` date;
   re-evaluate `review` entries.
4. **Compact working.** Remove or summarize already-consolidated `working.md` entries to keep the
   file bounded. Never drop an entry that hasn't been consolidated.
5. **Log it.** Append a one-line reflection summary (what was promoted/pruned) to `memory/working.md`.

## Cautions

- Promote only what is genuinely durable; churn in `core.md` and `procedural.md` is a smell — those
  layers are slow-changing.
- Self-edits stay within this assistant. Never touch a sibling's or parent's memory or skills.
