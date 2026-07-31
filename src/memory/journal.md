# Layer 4 — Journal

The assistant's *record*. Append-only log of all activity, **newest last** — the encoding
stream: every query, action, error, or event leaves a trace here.

It is the assistant's operational activity log; each bundle keeps its own OKF `log.md` for its
knowledge-change history.
`skills/core/reflect` consolidates durable learnings from here into the upper memory layers (per the
Recording table in `memory/procedural.md`), then **collapses** each consolidated block into one
`reflect:` summary line. That summary line is the **watermark** — the next reflection processes only
the entries after it, so history is kept in compressed form and the file stays bounded.

For normal reads, never load the whole file — slice the most recent entries (see Bootstrapping in
`memory/procedural.md`). `reflect` is the exception: it reads every entry since the last `reflect:`
watermark.

## Entries

Format, one line per trace, appended at the end (greppable):

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

A trace is a **pointer, not a report** — one sentence plus where the detail lives (the bundle's
`log.md`, the concept, the git diff); detail recorded at its home is not restated here.

---

_(no activity yet)_
