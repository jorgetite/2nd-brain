---
name: memory-remember
description: Keep, correct, or forget something the human tells the assistant — a reminder, a recurring chore, a fact about their things or life, or a preference — filing it where it belongs. Use when the human says remember, note, save, remind me, forget, or tells the assistant something has changed.
---

# Remember

The human-facing way to capture a fact. File each one where it belongs (the Recording table in
`memory/procedural.md`):

- **About the human's things, people, or history** — a serial number, a filter size, an allergy, a
  kit's paint scheme — and still true a year from now: durable knowledge. Hand it to
  `skills/bundle-ingest`, which files it into the right bundle with the human as its source
  (`human:<id>`) and marks it verified by them.
- **Tied to a date or a shelf life** — an appointment, a renewal, a chore, the status of something in
  progress: `memory/state.md`, in the formats it defines — a date goes to *Upcoming Deadlines* (with a
  `Repeats` interval for a recurring chore), open-ended context to *Entries* with an expiry or `review`.
- **How the assistant should behave or present things** — units, time zone, reply style: the
  *Preferences* section of `memory/core.md`.

When it isn't clear which kind a fact is, ask — a durable fact parked in state can be pruned. Resolve
relative dates ("next Tuesday") to absolute ones in the human's time zone.

**Secrets** — passwords, PINs, keys, card numbers — are never stored (*Discretion*). Record only where
the secret lives (a password manager, a named vault), and tell the human why.

**Reminders** surface only when the human next talks to the assistant. If the harness offers
scheduling or a calendar, offer to set a real reminder as well — that is outward-facing, so confirm
first.

**Corrections and forgetting.** Find where the fact lives and update or remove it there; in a bundle,
keep the old value with its date where history matters. Removed content survives in the git history —
say so when it is sensitive.

If the fact already lives somewhere, update it in place rather than adding a copy. Tell the human what
you saved or changed and where, and log it in `memory/journal.md`.

## Done when

The fact lives in exactly one place matching its kind, no secret value was stored, and the human knows
where it went.
