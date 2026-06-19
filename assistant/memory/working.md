# Layer 4 — Working Memory

Append-only record of all activity, **newest last**. This is the encoding stream: every query,
action, or event leaves a trace here.

It is the single comprehensive activity log for the assistant. The `skills/core/reflect` reads this stream to consolidate durable learnings upward into declarative, procedural, and core memory, then may compact already-consolidated entries.

## Entries

Format, one line per trace, appended at the end:

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

---
