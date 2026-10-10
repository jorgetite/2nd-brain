---
name: memory-reflect
description: The assistant's self-improvement loop — consolidate the journal into durable knowledge, preferences, and sharper skills; learn from corrections and errors; prune or roll forward stale state; compact the journal. Use when entries have built up since the last reflection, when a deadline has passed, at the end of a working session, or when the human asks the assistant to review and learn from recent work.
---

# Reflect

The capability-compounding loop (Continual Harness): read recent activity, move what's durable to its
real home, sharpen the skills that caused friction, and compact the stream. It adapts the assistant —
its memory and skills — not any model weights.

## Procedure

Order matters: the watermark bounds what you read, and only what you consolidated may be collapsed.

1. **Find the watermark** — the latest consolidation line:

   ```sh
   grep -n '^- \[[^]]*\] reflect: consolidated' memory/journal.md | tail -1
   ```

   Everything after it is un-consolidated; with no such line, every entry is. Read all of it, not just
   the recent tail — skipping older entries silently drops their learnings.

2. **Promote what's durable**, routed by the Recording table in `memory/procedural.md`: facts about
   the human's things and life to a bundle via `skills/bundle-ingest`; standing preferences to the
   *Preferences* in `memory/core.md`; still-current time-bound items to `memory/state.md`, updating an
   existing entry rather than adding a copy. One-offs and routine actions aren't promoted — they fall
   away when the journal is compacted.

3. **Learn from friction.** Look for the human's corrections, errors, retries, and questions asked
   more than once. When the same friction recurs, or the human corrected it explicitly, fix it where
   it originates: reword the skill step that misled, propose a tighter `# Authoring` rule for a
   template (templates are the human's design), or — for a workflow that has recurred two or three
   times — write a new skill and route it in `memory/procedural.md`. Prefer editing an existing rule to
   adding one, and delete rules that no longer earn their place; one session's stumble is not a
   permanent rule. A new or changed principle for `memory/core.md` is proposed to the human, not
   written.

4. **Prune state.** For each deadline past its date or Entry past its `expires`, first record anything
   of lasting significance — an outcome to a dated concept in a bundle, or a line in the journal — then
   remove it. A deadline with a `Repeats` interval instead rolls forward by that interval (past today
   if cycles were missed), keeping the table sorted. Re-evaluate `review` entries.

5. **Check, commit, compact.** Re-read each skill or memory file you changed alongside the files it
   interacts with, looking for contradictions — a fresh-context review when the harness supports
   sub-agents. Commit, which keeps the raw journal entries in history; then replace the consolidated
   block with one line, the next watermark, and commit again:

   `- [YYYY-MM-DD HH:MM:SS] reflect: consolidated N entries — <where promotions landed, what was pruned>`

   Counts and destinations, not content. Never collapse an entry you did not consolidate. If you
   changed `core.md` or `procedural.md`, re-read them — your in-context copy is stale.

## Cadence

Too often promotes one-offs and churns slow-changing files; too rarely bloats the journal and lets
state expire unpromoted. Reflect when a few dozen entries have built up since the watermark, when a
deadline has passed, at the end of a working session, or when asked — not after every action. If the
harness can schedule work, a weekly reflection keeps it regular.

## Done when

Every entry after the old watermark is consolidated and collapsed into one new `reflect:` line;
durable items live at their homes; recurring friction has a fix, or a proposal in front of the
human; `state.md` holds no expired entries; and the changes are committed.
