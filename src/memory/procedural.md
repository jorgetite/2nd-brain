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
├── bundles/              # OKF knowledge bundles
│   ├── index.md              # catalog of bundles (progressive disclosure)
│   └── <bundle>/             # OKF tree: index.md · log.md · templates/<type>.md · references/ · <type>/index.md · <type>/<concept>.md
└── artifacts/            # generated deliverables (exports); not versioned — the human prunes
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
- **Force a full reload** of `core.md`/`procedural.md` when they change in a session (after `brain-init`, a `memory-reflect` promotion, or a manual edit) — the in-context copy is stale until you re-read it.

**Check initialization** from the already-loaded `core.md`: if it still has `{{placeholders}}`, route to `skills/brain-init` before other work.

**Check consolidation** from the already-loaded `state.md` and journal tail: if a deadline has passed, or the journal has grown well past the last `reflect:` line, run `skills/memory-reflect` after answering the request.

To read a journal date range without loading the whole file: `grep -n "^- \[" memory/journal.md | tail -50` to locate the line, then `tail -n +<line> memory/journal.md`.

### Routing

**Bundle selection.** Knowledge lives in OKF bundles under `bundles/`, known from `bundles/index.md` at bootstrap. For a request touching durable knowledge, pick the bundle whose catalog scope owns it, honouring each row's *Not here* boundaries (ask if two fit equally); if none fits, create one (`skills/bundle-create`) — human-initiated, so confirm first.

**Skill routing.** Load the skill whose trigger matches; each is a folder with a `SKILL.md` (Agent Skills format).

| Trigger / intent | Skill |
| --- | --- |
| Personalize a fresh assistant | `skills/brain-init/SKILL.md` |
| Remember, remind, correct, or forget something | `skills/memory-remember/SKILL.md` |
| Consolidate / self-improve | `skills/memory-reflect/SKILL.md` |
| Create a new knowledge bundle | `skills/bundle-create/SKILL.md` |
| Add an existing OKF bundle | `skills/bundle-import/SKILL.md` |
| Retire a knowledge bundle | `skills/bundle-remove/SKILL.md` |
| Absorb a new raw source | `skills/bundle-ingest/SKILL.md` |
| Answer from existing knowledge | `skills/bundle-query/SKILL.md` |
| Audit a bundle's health | `skills/bundle-lint/SKILL.md` |
| Produce a deliverable (export a document) | `skills/artifact-export/SKILL.md` |

### Logging

Append every action, query, error, or event to `memory/journal.md` (newest last), one greppable line per trace:

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

A trace is a **pointer, not a report**: one sentence of what happened plus where the detail lives (the bundle's `log.md`, the concept, the git diff). Never restate detail already recorded at its home — the journal indexes activity; it doesn't hold content.

When the human corrects the assistant, log it as its own `correction:` trace — `skills/memory-reflect` learns from them.

The `reflect:` line `skills/memory-reflect` writes is the **consolidation watermark** — everything after the latest one is un-consolidated.

### Recording

Route what you learn to its home (the *One fact, one home* principle):

| Kind of information | Home |
|---|---|
| Any action, query, error, or event | `memory/journal.md` — always |
| Transient state with a shelf life | `memory/state.md` — date-anchored (or recurring) → *Upcoming Deadlines*, open-ended → *Entries* |
| Durable knowledge for the human | a bundle — via `skills/bundle-ingest` or `bundle-query` |
| A new repeatable workflow + its trigger | a skill under `skills/` + a route in the Skill routing table |
| An operating convention (rare) | `memory/procedural.md` |
| A standing preference (units, time zone, reply style) | `memory/core.md` — *Preferences* |
| A lasting principle of behavior (rare) | `memory/core.md` — proposed to the human first |

(`bundle-ingest` also mirrors a source's time-sensitive facts into `state.md` while the durable knowledge goes to the bundle.)

### Conventions

- **Dates:** use today's actual date (check via shell if unsure) for `timestamp` and log entries; convert relative dates to absolute `YYYY-MM-DD`.
- **Secrets:** record only *where* a secret lives (e.g. a named vault, the host `.env`), never the value.
- **Changes:** small, focused, well-described edits. When the assistant is a git repo (`install.sh` makes it one), commit after changing `memory/` or `skills/` so a bad self-edit can be rolled back; favour many small commits over sweeping rewrites.
- **OKF concepts:** every non-reserved `.md` in a bundle MUST carry a `type:` in its YAML frontmatter (recommended too: `title`, `description`, `resource`, `tags`, `timestamp`); use content headings named for what they hold, plus `# Examples` and `# Citations` where they apply — the type's `templates/<type>.md` defines the binding heading set. `index.md`/`log.md` are exempt.
- **Concept templates:** `templates/<type>.md` is the binding format for its type — a concept keeps the template's frontmatter keys and heading set/order, fills every `{{placeholder}}`, and obeys then deletes the `# Authoring` section. No `{{` or `# Authoring` survives in a concept; no template, no new type.
- **Concept placement:** a concept of type `X` lives at `<X>/<name>.md` with its own `<X>/index.md`, mirroring `templates/<X>.md`; the bundle's root `index.md` lists the type folders. Imported bundles keep their authored layout.
- **Cross-linking:** link concepts with the OKF bundle-relative form `[title](/path/to/concept.md)` — the leading `/` is the **bundle root**, not the working dir or repo root. Links stay within a bundle (bundles are self-contained); connect across bundles via the `bundles/index.md` catalog, not links. A link to a not-yet-created concept is a fine work marker (broken links tolerated).
- **Filenames:** kebab-case.
- **Source citations:** cite a global source under `# Citations` by its `sources/library/<file>` path — a stable, greppable key so the claim is traceable and `skills/bundle-remove` can find a bundle's backing sources. Knowledge with no backing file is cited as `human — YYYY-MM-DD` (a fact from the human), `<URL> — retrieved YYYY-MM-DD` (something looked up), or by cross-links to the concepts a synthesis derives from.
- **Sources are immutable:** read and relocate, never edit content. `inbox/` awaits ingestion; `library/` backs a bundle; `archive/` holds sources retired with their last citing bundle.
- **Keep L1/L2 lean:** `core.md`/`procedural.md` load on every cold start (procedural is the bulk). Keep them tight — push detail into skills or bundles; don't split `procedural.md` (trades tokens for round-trips).
