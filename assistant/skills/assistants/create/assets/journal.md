# Layer 4 — Journal

The assistant's *record*. Append-only log of all activity, **newest last** — the encoding
stream: every query, action, error, or event leaves a trace here.

It is the single comprehensive activity log for the assistant (the wiki keeps no separate log).
`skills/core/reflect` reads this stream to consolidate durable learnings into the upper memory
layers — see the Memory table in `memory/procedural.md` — then may compact already-consolidated
entries to keep the file bounded.

It grows without bound: never read it in full. Slice the most recent entries (see Bootstrapping
in `memory/procedural.md`).

## Entries

Format, one line per trace, appended at the end (greppable):

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

---

_(no activity yet)_
