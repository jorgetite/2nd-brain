# Memory Model

Operational memory is four layers, mirroring human memory. They live in `assistant/memory/`.
Identity and knowledge are kept separate: this is how the assistant *acts*; the `bundles/` are what
it *knows* for the human.

| Layer | File | Holds | Lifespan |
|---|---|---|---|
| L1 Core | `core.md` | identity + stable principles (the *why*) | stable |
| L2 Procedural | `procedural.md` + `skills/` | layout, rules, skill routing (the *what / how*) | slow-changing |
| L3 State | `state.md` | current-state facts (the *now*) | limited (entries expire) |
| L4 Journal | `journal.md` | append-only activity log (the *record*) | unbounded append |

## The consolidation loop

Information **encodes** at L4 (every action leaves a trace) and **consolidates upward** via the
`memory-reflect` skill — the capability-compounding loop:

```
L4 journal ──reflect──▶ L3 state · L2 procedural · L1 core · bundles
```

`memory-reflect` reads the journal stream, promotes durable learnings to their real home (routed by the
**Recording** table in `procedural.md`), prunes expired state entries, and collapses
each processed block into a `reflect:` summary line — the watermark for the next run, keeping
history compressed and the file bounded.

## Capturing facts

User-stated facts enter through the `memory-remember` skill, which files each by kind — durable facts about the human's things into a `bundle`, dated or short-lived items into `state`, preferences into `core` — asking when the kind is unclear, using the same Recording table `memory-reflect` follows.

Within `state`, a fact anchored to a specific date goes to *Upcoming Deadlines* and anything open-ended to *Entries*. `bundle-ingest` also mirrors a source's time-sensitive facts into `state` while filing the durable knowledge to a bundle. When a deadline passes, `memory-reflect` promotes anything of lasting significance to a bundle/journal, then drops it — or, if it has a `Repeats` interval (a filter change every 3 months, a yearly certificate renewal), rolls its date forward instead.

## Reading discipline

Bootstrapping loads L1 → L3 in full; the L4 log is never read whole (it grows without bound) — only
its recent tail is sliced. See the **Bootstrapping** section in `procedural.md`.

See also: [concepts](concepts.md), [bundles](bundles.md).
