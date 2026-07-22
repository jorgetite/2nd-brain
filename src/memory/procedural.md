# Layer 2 — Procedural Memory

The assistant's *what and how*: the architecture layout, operating procedures and conventions, and the routes to the skills that do the work.

## Architecture

### Layout

```
assistant/
├── AGENTS.md             # entrypoint
├── memory/               # the four layers: core.md · procedural.md (this file) · state.md · journal.md
├── skills/               # workflow playbooks (Agent SKILL.md spec); enumerated in Skill routing
├── sources/              # immutable sources: inbox → library → archive
└── bundles/              # OKF knowledge bundles
    ├── index.md              # catalog of bundles (progressive disclosure)
    └── <bundle>/             # OKF tree: index.md · log.md · templates/<type>.md · references/ · <concept>.md · <subdir>/index.md
```

### Memory

The four layers and how information flows between them:

| Layer | File | Holds | Promotes to |
|---|---|---|---|
| 1 — Principles | `memory/core.md` | Purpose, principles (the *why*) | — |
| 2 — Operational | `memory/procedural.md` + `skills/` | Layout, procedures, routing (the *what/how*) | — |
| 3 — State | `memory/state.md` | Cross-session short-term state | → Layer 2 / 1 / bundle |
| 4 — Journal | `memory/journal.md` | Append-only activity stream | → Layer 3 / 2 |

## Operation Procedures

### Bootstrapping

`AGENTS.md` defines the **cold-start batch** (core, procedural, state, catalog, journal tail — read in one parallel round-trip). This section defines what to re-read afterward.

**Cold vs. warm** — re-read only what can have changed:

- **Cold start** — fresh session or reset context (L1/L2 not in memory): do the cold-start batch from `AGENTS.md`.
- **Warm** — L1/L2 already loaded this session: skip `core.md`/`procedural.md`; refresh only the volatile reads — `state.md` (whole), `bundles/index.md`, and the journal tail (`grep "^- \[" memory/journal.md | tail -10`).
- **Force a full reload** of `core.md`/`procedural.md` when they change in a session (after `init`, a `reflect` promotion, or a manual edit) — the in-context copy is stale until you re-read it.

**Check initialization** from the already-loaded `core.md`: if it still has `{{placeholders}}`, route to `skills/core/init` before other work.

To read a journal date range without loading the whole file: `grep -n "^- \[" memory/journal.md | tail -50` to locate the line, then `tail -n +<line> memory/journal.md`.

### Routing

**Bundle selection.** Knowledge lives in OKF bundles under `bundles/`, known from `bundles/index.md` at bootstrap. For a request touching durable knowledge, pick the bundle whose domain owns it; if none fits, create one (`skills/bundles/create`) — human-initiated, so confirm first.

**Skill routing.** Load the skill whose trigger matches; each is a folder with a `SKILL.md` (Agent Skills format).

| Trigger / intent | Skill |
| --- | --- |
| Personalize a fresh assistant | `skills/core/init/SKILL.md` |
| Remember / note a fact for later | `skills/core/remember/SKILL.md` |
| Consolidate / self-improve | `skills/core/reflect/SKILL.md` |
| Create a new knowledge bundle | `skills/bundles/create/SKILL.md` |
| Add an existing OKF bundle | `skills/bundles/import/SKILL.md` |
| Retire a knowledge bundle | `skills/bundles/remove/SKILL.md` |
| Absorb a new raw source | `skills/bundles/ingest/SKILL.md` |
| Answer from existing knowledge | `skills/bundles/query/SKILL.md` |
| Audit a bundle's health | `skills/bundles/lint/SKILL.md` |

### Logging

Append every action, query, error, or event to `memory/journal.md` (newest last), one greppable line per trace:

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

The `reflect:` line `skills/core/reflect` writes is the **consolidation watermark** — everything after the latest one is un-consolidated.

### Recording

Route what you learn to its home (the *One fact, one home* principle):

| Kind of information | Home |
|---|---|
| Any action, query, error, or event | `memory/journal.md` — always |
| Transient state with a shelf life | `memory/state.md` — date-anchored → *Upcoming Deadlines*, open-ended → *Entries* |
| Durable knowledge for the human | a bundle — via `skills/bundles/ingest` or `query` |
| A new repeatable workflow + its trigger | a skill under `skills/` + a route in the Skill routing table |
| An operating convention (rare) | `memory/procedural.md` |

(`ingest` also mirrors a source's time-sensitive facts into `state.md` while the durable knowledge goes to the bundle.)

### Conventions

- **Dates:** use today's actual date (check via shell if unsure) for `created`/`updated` and log entries; convert relative dates to absolute `YYYY-MM-DD`.
- **Secrets:** record only *where* a secret lives (e.g. a named vault, the host `.env`), never the value.
- **Changes:** small, focused, well-described edits — it's a git repo of markdown; favour many small commits over sweeping rewrites.
- **OKF concepts:** every non-reserved `.md` in a bundle MUST carry a `type:` in its YAML frontmatter (recommended too: `title`, `description`, `resource`, `tags`, `timestamp`); use the `# Schema`, `# Examples`, `# Citations` sections where they apply. `index.md`/`log.md` are exempt.
- **Cross-linking:** link concepts with the OKF bundle-relative form `[title](/path/to/concept.md)` — the leading `/` is the **bundle root**, not the working dir or repo root. Links stay within a bundle (bundles are self-contained); connect across bundles via the `bundles/index.md` catalog, not links. A link to a not-yet-created concept is a fine work marker (broken links tolerated).
- **Filenames:** kebab-case.
- **Source citations:** cite a global source under `# Citations` by its `sources/library/<file>` path — a stable, greppable key so the claim is traceable and `skills/bundles/remove` can find a bundle's backing sources.
- **Sources are immutable:** read and relocate, never edit content. `inbox/` awaits ingestion; `library/` backs a bundle; `archive/` holds sources retired with their last citing bundle.
- **Keep L1/L2 lean:** `core.md`/`procedural.md` load on every cold start (procedural is the bulk). Keep them tight — push detail into skills or bundles; don't split `procedural.md` (trades tokens for round-trips).
