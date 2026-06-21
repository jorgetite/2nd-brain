# Layer 2 — Procedural Memory

The assistant's *what and how*. Defines the architecture layout, the operating procedures and conventions, and the routes to the skills that carry out specific workflows. This file plus the skills it indexes say *how* the work is done.


## Architecture 

### Layout

```
assistant/
├── AGENTS.md             # entry point for the assistant
├── assistants/           # child assistants; index.md is the roster `delegate` routes by
├── memory/               # assistant memory
│   ├── core.md               # Layer 1 — identity and principles
│   ├── procedural.md         # Layer 2 — layout and procedural hub / workflow index (this file)
│   ├── state.md              # Layer 3 — current state facts
│   └── journal.md            # Layer 4 — append-only activity log
├── skills/               # workflow playbooks (Agent SKILL.md spec)
│   ├── assistants/           # manage child assistants
│   │   ├── create/           # create a new assistant
│   │   ├── remove/           # remove an assistant
│   ├── core/
│   │   ├── init/             # initialize the assistant
│   │   ├── reflect/          # reflect on the assistant's state
│   │   ├── delegate/         # delegate a task to a child assistant
│   │   └── remember/         # record a fact to the right memory layer
│   └── wiki/                 # wiki management skills
│       ├── ingest/           # ingest a new wiki page
│       ├── lint/             # audit the wiki's health
│       └── query/            # query the wiki for information
├── sources/              # immutable source documents (read & relocate, never edit content)
│   ├── archive/              # archived sources (permanent)
│   ├── inbox/                # drop zone: sources awaiting ingestion
│   └── library/              # ingested sources (permanent)
├── templates/            # wiki page templates
└── wiki/                 # the compiled, interlinked knowledge base (persistent knowledge)
    ├── index.md              # catalog of every wiki page
    ├── schema.md             # schema of the wiki 
    └── {{folder-name}}/      # domain specific folder(s) for wiki pages
```

### Memory

The four memory layers and how information flows between them (mirrors human memory):

| Layer | File | Holds | Promotes to |
|---|---|---|---|
| 1 — Principles | `memory/core.md` | Purpose, vision, principles (the *why*) | — |
| 2 — Operational | `memory/procedural.md` + `skills/` | Workflows, conventions, schema (the *what/how*) | — |
| 3 — State | `memory/state.md` | Cross-session short-term state | → Layer 2 / 1 |
| 4 — Journal | `memory/journal.md` | Append-only activity stream | → Layer 3 / 2 |




## Operation Procedures

### Bootstrapping

Layer 2 → Layer 3 → Layer 4 is the retrieval path at the start of every request.

**Before any work**, read this file, plus:
- `memory/state.md` — entire file.
- `assistants/index.md` — the roster of your direct children and their domains (empty if you have none).
- `memory/journal.md` — the 5 most recent entries only (the log grows without bound; never read the whole file):

  `grep "^- \[" memory/journal.md | tail -5`

To read a date range, scan entries cheaply first, then slice from the first one in range:
```bash
grep -n "^- \[" memory/journal.md | tail -40   # recent entries with line numbers
tail -n +<line> memory/journal.md              # emit from that line onward
```

### Skill Routes

This is how the assistant decides what to do. The skills themselves live in `skills/`; this layer only routes to the appropriate self-contained operational workflows. Load the one whose trigger matches the task; each skill is a folder holding a `SKILL.md` (Agent Skills format).


| Trigger / intent                 | Skill                                |
| -------------------------------- | ------------------------------------ |
| Personalize a fresh assistant    | `skills/core/init/SKILL.md`          |
| Remember / note a fact for later | `skills/core/remember/SKILL.md`      |
| Hand a task to a child assistant | `skills/core/delegate/SKILL.md`      |
| Consolidate / self-improve       | `skills/core/reflect/SKILL.md`       |
| Absorb a new raw source          | `skills/wiki/ingest/SKILL.md`        |
| Answer from existing knowledge   | `skills/wiki/query/SKILL.md`         |
| Audit the wiki's health          | `skills/wiki/lint/SKILL.md`          |
| Add a child assistant            | `skills/assistants/create/SKILL.md`  |
| Remove a child assistant         | `skills/assistants/remove/SKILL.md`  |

**Delegation & self-handling.** By default, **handle a request yourself**. Delegate (via
`skills/core/delegate`) only when a child in `assistants/index.md` owns the request's domain — you
know your children from bootstrap. With no children, or none fitting, handle it yourself. Creating a
child assistant is a **human-initiated** action — never create one to satisfy a request.


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
| Transient state with a shelf life (active tasks, deadlines, current context) | `memory/state.md` |
| Durable knowledge for the human | `wiki/` — via `skills/wiki/ingest` or `query` |
| A new repeatable workflow + its trigger | a skill under `skills/` + a route in **Skill Routes** |
| A lasting principle (rare) | `memory/core.md` |

### Conventions

Global operating conventions for the assistant:

- **Dates & timestamps:** Use today's actual date (check via shell if unsure) for `created`/`updated` fields and log entries. Convert relative dates ("last week", "in 3 days") to absolute `YYYY-MM-DD`.
- **Secrets:** Record only *where* a secret lives (e.g. "1Password vault HomeLab", "in the `.env` on the host"), never the secret value itself.
- **Changes:** Make small, frequent, well-described edits. It's a git repo of markdown — favour many focused commits over sweeping rewrites, and keep history clean.
- **Cross-linking:** Use `[[wikilinks]]` liberally between related pages; a link to a not-yet-created page is a useful marker of work to do.
- **Filenames:** kebab-case (`page-name.md`, `other-page.md`).
- **Sources are immutable:** read and relocate between `sources/inbox → library/archive`; never edit a source's content.
- **Reflect regularly:** run `skills/core/reflect` at session end, and/or once a batch of entries has accrued since the last `reflect:` watermark — sooner if a clear pattern emerged or `state` is about to expire; not after every action. Frequency matters: too often churns the slow-changing layers, too rarely stalls learning.
