# Layer 2 — Procedural Memory

The assistant's *what and how*. Defines the architecture layout, the operating procedures and conventions, and the routes to the skills that carry out specific workflows. This file plus the skills it indexes say *how* the work is done.


## Architecture 

### Layout

```
assistant/
├── AGENTS.md             # entry point for the assistant
├── memory/               # assistant memory
│   ├── core.md               # Layer 1 — identity and principles
│   ├── procedural.md         # Layer 2 — layout and procedural hub / workflow index (this file)
│   ├── state.md              # Layer 3 — current state facts
│   └── journal.md            # Layer 4 — append-only activity log
├── skills/               # workflow playbooks (Agent SKILL.md spec)
│   ├── core/
│   │   ├── init/             # initialize the assistant
│   │   ├── reflect/          # reflect on the assistant's state
│   │   └── remember/         # record a fact to the right memory layer
│   └── bundles/              # OKF knowledge-bundle skills
│       ├── create/           # create a new OKF bundle
│       ├── import/           # adopt an existing OKF bundle
│       ├── ingest/           # ingest a source into a bundle
│       ├── lint/             # audit a bundle's OKF conformance & health
│       ├── query/            # query a bundle for information
│       └── remove/           # retire a bundle
├── sources/              # immutable source documents (read & relocate, never edit content)
│   ├── archive/              # archived sources (permanent)
│   ├── inbox/                # drop zone: sources awaiting ingestion
│   └── library/              # ingested sources (permanent)
└── bundles/              # OKF knowledge bundles (persistent knowledge)
    ├── index.md              # catalog of every bundle (progressive disclosure)
    └── {{bundle-name}}/      # an OKF-compliant bundle
        ├── index.md              # OKF listing (may carry `okf_version: "0.1"`)
        ├── log.md                # OKF change history (newest-first, ISO dates)
        ├── templates/            # per-type concept skeletons
        │   └── {{type}}.md
        ├── references/           # optional: cited source copies
        ├── {{concept}}.md        # concepts (require `type:` frontmatter)
        └── {{subdir}}/           # optional: group concepts; carries its own index.md
            ├── index.md              # OKF listing for this subtree
            └── {{concept}}.md
```

### Memory

The four memory layers and how information flows between them (mirrors human memory):

| Layer | File | Holds | Promotes to |
|---|---|---|---|
| 1 — Principles | `memory/core.md` | Purpose, vision, principles (the *why*) | — |
| 2 — Operational | `memory/procedural.md` + `skills/` | Workflows, conventions, schema (the *what/how*) | — |
| 3 — State | `memory/state.md` | Cross-session short-term state | → Layer 2 / 1 / bundle |
| 4 — Journal | `memory/journal.md` | Append-only activity stream | → Layer 3 / 2 |




## Operation Procedures

### Bootstrapping

The retrieval path is Layer 2 → Layer 3 → Layer 4 plus the `bundles/index.md` catalog. The reads are
independent — issue them in **one parallel batch**, not one at a time.

**Cold vs. warm.** Bootstrap cost is paid per request, so re-read only what can have changed:

- **Cold start** — a fresh session, or the context was reset, so L1/L2 aren't in memory yet. Read
  everything: `memory/core.md`, `memory/procedural.md` (this file), `memory/state.md`,
  `bundles/index.md`, and the journal tail.
- **Warm** — L1/L2 are already loaded this session. Skip re-reading `core.md` and `procedural.md`;
  refresh only the volatile reads:
  - `memory/state.md` — entire file.
  - `bundles/index.md` — the catalog of your knowledge bundles and their domains.
  - `memory/journal.md` — the 10 most recent entries only (never read the whole file):
    `grep "^- \[" memory/journal.md | tail -10`.
- **Force a full reload** of `core.md` and/or `procedural.md` whenever they change during a session
  (after `init`, a `reflect` that promoted to L1/L2, or a manual edit) — your in-context copy is stale
  until you re-read the changed file.

**Check initialization** from the `core.md` you already loaded — no separate command needed: if it
still contains `{{placeholders}}` (name, domain, purpose), the assistant hasn't been personalized —
route to `skills/core/init` before any other work.

To read a journal date range, scan entries cheaply first, then slice from the first one in range:
```bash
grep -n "^- \[" memory/journal.md | tail -50   # recent entries with line numbers
tail -n +<line> memory/journal.md              # emit from that line onward
```

### Routing

**Bundle selection.** Knowledge lives in one or more OKF bundles under `bundles/` — you know them
from `bundles/index.md` at bootstrap. When a request touches durable knowledge, pick the bundle whose
domain owns it; if none fits, create one first (via `skills/bundles/create`). Creating a bundle is a
**human-initiated** action — confirm before adding one.

**Skill routing.** This is how the assistant decides what to do. The skills themselves live in `skills/`; this layer only routes to the appropriate self-contained operational workflows. Load the one whose trigger matches the task; each skill is a folder holding a `SKILL.md` (Agent Skills format).


| Trigger / intent                 | Skill                                |
| -------------------------------- | ------------------------------------ |
| Personalize a fresh assistant    | `skills/core/init/SKILL.md`          |
| Remember / note a fact for later | `skills/core/remember/SKILL.md`      |
| Consolidate / self-improve       | `skills/core/reflect/SKILL.md`       |
| Create a new knowledge bundle    | `skills/bundles/create/SKILL.md`     |
| Add an existing OKF bundle       | `skills/bundles/import/SKILL.md`      |
| Retire a knowledge bundle        | `skills/bundles/remove/SKILL.md`     |
| Absorb a new raw source          | `skills/bundles/ingest/SKILL.md`     |
| Answer from existing knowledge   | `skills/bundles/query/SKILL.md`      |
| Audit a bundle's health          | `skills/bundles/lint/SKILL.md`       |


### Logging

Append every action, query, error, or event to `memory/journal.md` (newest last). Every request will generate one or more log entries.

Format, one line per trace, appended at the end (greppable):

`- [YYYY-MM-DD HH:MM:SS] <skill | actor | event>: <title> - <what happened>`

The `reflect:` summary line that `skills/core/reflect` writes doubles as the **consolidation watermark** — every entry after the latest one is un-consolidated.


### Recording

Route what you learn to its home (this operationalizes the *One fact, one home* principle):

| Kind of information | Home |
|---|---|
| Any action, query, error, or event | `memory/journal.md` — always |
| Transient state with a shelf life (active tasks, deadlines, current context) | `memory/state.md` — date-anchored → *Upcoming Deadlines*, open-ended → *Entries* |
| Durable knowledge for the human | a bundle — via `skills/bundles/ingest` or `query` |
| A new repeatable workflow + its trigger | a skill under `skills/` + a route in **Skill Routes** |
| A lasting principle (rare) | `memory/core.md` |

`skills/bundles/ingest` also mirrors a source's time-sensitive facts into `memory/state.md` (by the date rule above) while filing the durable knowledge to a bundle.

### Conventions

Global operating conventions for the assistant:

- **Dates & timestamps:** Use today's actual date (check via shell if unsure) for `created`/`updated` fields and log entries. Convert relative dates ("last week", "in 3 days") to absolute `YYYY-MM-DD`.
- **Secrets:** Record only *where* a secret lives (e.g. "1Password vault HomeLab", "in the `.env` on the host"), never the secret value itself.
- **Changes:** Make small, frequent, well-described edits. It's a git repo of markdown — favour many focused commits over sweeping rewrites, and keep history clean.
- **OKF concepts:** Every non-reserved `.md` in a bundle is a concept and MUST carry a `type:` in its
  YAML frontmatter (recommended too: `title`, `description`, `resource`, `tags`, `timestamp`). Use the
  conventional `# Schema`, `# Examples`, `# Citations` sections where they apply. Reserved names
  `index.md` and `log.md` are exempt.
- **Cross-linking:** Link related concepts with the OKF absolute bundle-relative form
  `[title](/path/to/concept.md)` — the leading `/` resolves to the **bundle root**
  (`bundles/<name>/…`), not the working directory or repo root. A link to a not-yet-created concept is
  a useful marker of work to do (broken links are tolerated). Links stay **within a bundle**: bundles
  are self-contained, so connect knowledge across bundles via the `bundles/index.md` catalog and query
  reasoning, not links.
- **Filenames:** kebab-case (`concept-name.md`, `other-concept.md`).
- **Source citations:** when a concept draws on a global source, cite it under `# Citations` by its
  `sources/library/<file>` path — a stable, greppable key — so the claim is traceable and so
  `skills/bundles/remove` can find a bundle's backing sources.
- **Sources are immutable:** read and relocate, never edit a source's content. `sources/inbox/` is the
  drop zone awaiting ingestion; `sources/library/` holds sources that actively back a bundle;
  `sources/archive/` holds sources retired when their last citing bundle was removed.
- **Keep L1/L2 lean:** `core.md` and `procedural.md` load on every cold start and `procedural.md` is
  the bulk of that payload. Keep them tight — push detail into skills or bundles rather than growing
  the hot path, and don't split `procedural.md` (that trades tokens for extra round-trips).
- **Reflect regularly:** run `skills/core/reflect` at session end, and/or once a batch of entries has accrued since the last `reflect:` watermark — sooner if a clear pattern emerged or `state` is about to expire; not after every action. Frequency matters: too often churns the slow-changing layers, too rarely stalls learning.
