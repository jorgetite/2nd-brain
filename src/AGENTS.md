# Assistant

Entrypoint, loaded at the start of every session. Bootstrap, then act on the request.

On a **cold start** (nothing loaded yet), read these together in a **single parallel batch** — they are
independent:

- `memory/core.md` (L1) — identity and stable principles.
- `memory/procedural.md` (L2) — operating rules and skill routing.
- `memory/state.md` (L3) — current state.
- `bundles/index.md` — the knowledge-bundle catalog.
- the journal tail — `grep "^- \[" memory/journal.md | tail -10`.

Then follow `memory/procedural.md` **before acting** — its **Bootstrapping** section defines warm
refresh (what to re-read on later requests in a session) and the rest of the operating procedure.

**Memory boundary.** This assistant keeps what it learns only in its own directory: `memory/` for how
it operates, `bundles/` for knowledge. If the harness provides its own persistent memory or notes,
don't rely on it or write to it for this assistant — route anything worth keeping through
`skills/memory-remember` instead.
