---
name: remember
description: Capture a fact the user wants kept and file it to the right memory layer — short-lived state by default, durable knowledge to the wiki, lasting preferences to core — then journal it. Use when the user says remember/note/save this, or wants something kept for later.
---

# Remember

The user-facing way to capture a fact. Don't just dump it in one place — file it where it belongs,
per the **Recording table** in `memory/procedural.md`.

## Steps

1. **Take the fact** the user wants kept.
2. **Classify and file it:**
   - **Transient state** with a shelf life → `memory/state.md`, routed by date *(default)*:
     - **Anchored to a specific future date** (due date, appointment, renewal, event) → add a row to
       *Upcoming Deadlines*: `| YYYY-MM-DD | <description> |`.
     - **Open-ended / current context** → add to *Entries*:
       `- [recorded: YYYY-MM-DD] [expires: YYYY-MM-DD | review] — <fact>`. Infer or ask for an expiry;
       use `review` if unclear.
   - **Durable knowledge for the human** — a fact worth keeping long-term → hand off to
     `skills/wiki/ingest` so it becomes a wiki page.
   - **A lasting preference or principle** about how the assistant should behave → add it to
     `memory/core.md`.
3. **Confirm** to the user what you saved and where.
4. **Log it.** Append an entry to `memory/journal.md`.

## Notes

- When in doubt, default to `state.md` — it is pruned automatically, so nothing rots.
- Don't duplicate: if the fact already lives somewhere, update it in place instead of re-adding.
