---
name: memory-remember
description: Keep something the human asks to have remembered — a note, a reminder, a recurring chore, a fact, or a preference — and file it where it belongs. Use when the human says remember/note/save/remind, or wants something kept for later.
---

# Remember

The human-facing way to capture a fact. File it where it belongs, per the **Recording table** in
`memory/procedural.md`, rather than dumping everything in one place:

- **Transient state** *(the default)* → `memory/state.md`. A specific future date (due date,
  appointment, renewal) goes to *Upcoming Deadlines* as `| YYYY-MM-DD | <repeats or —> | [bundle]
  <description> |`; give a recurring chore its interval (`every 3 months`, `yearly`). Anything
  open-ended goes to *Entries* as `- [recorded: YYYY-MM-DD] [expires: YYYY-MM-DD | review] — <fact>`;
  infer or ask for an expiry, and use `review` if unclear. State is pruned by reflect, so nothing rots.
- **Durable knowledge for the human** → hand off to `skills/bundle-ingest` so it becomes a concept in
  the right bundle.
- **A lasting preference about how the assistant should behave** → `memory/core.md`.

If the fact already lives somewhere, update it in place instead of re-adding it. Tell the human what
you saved and where, and log it in `memory/journal.md`.
