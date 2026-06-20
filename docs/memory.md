# Memory Model

Operational memory is four layers, mirroring human memory. They live in `assistant/memory/`.
Identity and knowledge are kept separate: this is how the assistant *acts*; the `wiki/` is what it
*knows* for the human.

| Layer | File | Holds | Lifespan |
|---|---|---|---|
| L1 Core | `core.md` | identity + stable principles (the *why*) | stable |
| L2 Procedural | `procedural.md` + `skills/` | layout, rules, skill routing (the *what / how*) | slow-changing |
| L3 State | `state.md` | current-state facts (the *now*) | limited (entries expire) |
| L4 Journal | `journal.md` | append-only activity log (the *record*) | unbounded append |

## The consolidation loop

Information **encodes** at L4 (every action leaves a trace) and **consolidates upward** via the
`reflect` skill — the capability-compounding loop:

```
L4 journal ──reflect──▶ L3 state · L2 procedural · L1 core · wiki
```

`reflect` reads the journal stream, promotes durable learnings to their real home (routed by the
**Recording** table in `procedural.md`), prunes expired state entries, and compacts
already-consolidated journal entries so the log stays bounded.

## Capturing facts

User-stated facts enter through the `remember` skill, which files each to the right layer — a short-lived note in `state` by default, durable knowledge into the `wiki/`, or a lasting preference into `core` — using the same Recording table `reflect` follows.

## Reading discipline

Bootstrapping loads L1 → L3 in full; the L4 log is never read whole (it grows without bound) — only
its recent tail is sliced. See the **Bootstrapping** section in `procedural.md`.

See also: [concepts](concepts.md), [recursion](recursion.md).
