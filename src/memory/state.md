# Layer 3 — State

The assistant's *now*. Holds transient current-state facts — what is true right now about the
human, active tasks, and context. Read in full at the start of every request.

Every entry is short-lived and carries an expiry. Keep this file lean (well under 100 lines).

**Where a fact goes (route by date):**
- **Anchored to a specific future date** (due date, appointment, renewal, event) → *Upcoming Deadlines*.
- **Open-ended or to re-evaluate later** (current context, active-task status, temporary preference)
  → *Entries*.

**On expiry — promote, then drop.** When a deadline's date passes (or an Entry's `expires` is reached),
`skills/core/reflect` first records anything of lasting significance to its real home — the outcome to
a dated note in the `wiki/`, or, if minor, a line in `memory/journal.md` — and **then** removes it from
this file. Items with no lasting value are simply dropped. (Durable facts and lasting principles are
promoted to the `wiki/` / `core.md` per the Recording table in `memory/procedural.md`.)

Surface **imminent or overdue** deadlines to the human when relevant — this file is read in full at the
start of every request.

## Upcoming Deadlines

Sorted by date; the deadline date is the entry's expiry.

| Deadline (YYYY-MM-DD) | Description |
| --- | --- |
|  |  |

## Entries

General transient facts, most recent first:

`- [recorded: YYYY-MM-DD] [expires: YYYY-MM-DD | review] — <fact>`

Use `review` instead of a date when an entry should be re-evaluated at the next reflect rather
than auto-pruned.

_(none yet)_
