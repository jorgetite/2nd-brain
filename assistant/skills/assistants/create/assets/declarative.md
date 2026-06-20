# Layer 3 — Declarative Memory

The assistant's *now*. Holds transient current-state facts — what is true right now about the
human, active tasks, and context. Read in full at the start of every request.

Every entry is short-lived and carries an expiry. `skills/core/reflect` prunes expired entries
and promotes durable ones to their real home — Core, Procedural, or the `wiki/` — following the
Recording table in `memory/procedural.md`. Keep this file lean (well under 100 lines).

Sections below are organizational; add or remove them as the domain needs.

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
