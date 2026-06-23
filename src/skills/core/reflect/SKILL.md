---
name: reflect
description: Consolidate the journal into the upper memory layers and prune stale state — the self-improvement loop. Run at session end, or after a batch of new journal entries; not after every action.
---

# Reflect

The capability-compounding loop (Continual Harness). It reads recent activity, moves the durable
learnings to their real home, and trims the stream — adapting the assistant, not any model weights.

## Procedure

This skill owns its own read; do not use the cheap session-start read from Bootstrapping.

1. **Find the watermark.** The last consolidation left a `reflect:` summary line in
   `memory/journal.md`. Locate the most recent one:

   ```sh
   grep -n "reflect:" memory/journal.md | tail -1
   ```

   Everything **after** that line is the un-consolidated set. If there is no `reflect:` line yet,
   the whole journal is un-consolidated. Read the **entire** un-consolidated set — not just the
   recent tail — or you will silently drop older learnings.

2. **Judge durability.** Promote a trace only if it is one of:
   - a **fact or preference** that will matter beyond this session;
   - a **workflow that has recurred** (~2–3 times) or is clearly reusable;
   - a **correction** worth not repeating.

   One-offs and routine actions are *not* promoted — they fall away when the journal is compacted.

3. **Route each promotion by the Recording table** in `memory/procedural.md` (consult it; do not
   copy it). In short: durable knowledge for the human → `wiki/` via `skills/wiki/ingest`; a new
   repeatable workflow → a skill under `skills/` **and** a route in `procedural.md`; a lasting
   principle → `memory/core.md`; still-current short-lived state → `memory/state.md` (date-anchored →
   *Upcoming Deadlines*, open-ended → *Entries*). De-dup: if a state fact was already recorded directly,
   update it in place rather than adding a copy.

4. **Prune state (promote, then drop).** In `memory/state.md`, for any deadline whose date has passed
   or Entry past its `expires`: first record anything of lasting significance — the outcome to a dated
   note in the `wiki/`, or a minor line in `memory/journal.md` — then remove it. Re-evaluate `review`
   entries; drop items with no lasting value.

5. **Compact by collapsing.** Replace the un-consolidated block you just processed with a single
   summary line — this both bounds the journal and becomes the next watermark:

   `- [YYYY-MM-DD HH:MM:SS] reflect: consolidated N entries — <what was promoted/pruned>`

   Never collapse an entry you did not consolidate.

## Cadence

Frequency shapes how well learning compounds:

- **Too often** promotes one-offs as if durable and churns `core.md` / `procedural.md`, which are
  meant to be slow-changing.
- **Too rarely** lets the journal bloat, lets `state.md` entries expire before they can be promoted,
  and makes the assistant re-derive what it already learned.

Aim for the middle: run at **session end**, and/or once a **batch** of new entries has accumulated
since the last `reflect:` line — earlier if a clear new pattern emerged or relevant `state` is about
to expire. Do not run after every action.

## Cautions

- Promote only what is genuinely durable; churn in `core.md` and `procedural.md` is a smell.
- Self-edits stay within this assistant. Never touch a sibling's or parent's memory or skills.
