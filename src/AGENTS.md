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
