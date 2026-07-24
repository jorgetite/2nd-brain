# 2nd Brain

A flexible implementation of an everyday, AI-powered personal assistant. It targets any agent harness that supports the `AGENTS.md` and `SKILL.md` standards and is agnostic of the underlying provider and model.

It is the synthesis of two ideas (see [docs/concepts.md](docs/concepts.md)):

- **The LLM Wiki** — knowledge that compounds: the assistant curates persistent, interlinked knowledge instead of re-deriving answers each time. Here that knowledge lives in one or more [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) (OKF) bundles.
- **The Continual Harness** — capability that compounds: the assistant adapts its own memory and skills from its activity history.

## How it works

The framework **source** lives in `src/` (version-controlled): `AGENTS.md`, the blank `memory/`
contracts, and `skills/`. You **install** a working assistant from it into a target directory of your
choice — inside the repo (e.g. `assistant/`, which is gitignored) or anywhere on disk. The installed
instance is what the harness boots from, and it evolves freely at runtime without touching the tracked
source. An installed assistant is a self-contained directory:

```
assistant/   (installed from src/)
├── AGENTS.md      # entrypoint: bootstrap, then act
├── memory/        # 4-layer memory — core · procedural · state · journal
├── skills/        # SKILL.md playbooks — core/ · bundles/
├── sources/       # raw source pipeline — inbox → library/archive
├── bundles/       # OKF knowledge bundles (index.md catalogs them)
└── artifacts/     # generated deliverables (exports)
```

- **Memory** is layered like human memory; the `reflect` skill consolidates activity upward into
  durable learnings. See [docs/memory.md](docs/memory.md).
- **Skills** are the operating procedures: `core/` (init, reflect, remember), `bundles/` (create,
  import, remove, ingest, query, lint), `artifacts/` (export). `memory/procedural.md` routes intent → skill.
- **Bundles** hold the knowledge: each is an OKF-compliant markdown tree for one domain, and the
  assistant manages as many as it needs. See [docs/bundles.md](docs/bundles.md).

## Quick Start

1. Clone this repo.
2. **Install** the working assistant from the source: `sh ./install.sh assistant` (or any path,
   relative or absolute — e.g. `sh ./install.sh ~/my-brain`).
3. Point your harness to the installed directory and run the `init` skill to set its identity,
   domain, and purpose — and optionally stand up its first bundle.
4. Create a knowledge bundle with `create` (if `init` didn't), drop material into `sources/inbox/`
   and run `ingest`; ask questions with `query`.
5. Add more bundles with `create` when the assistant needs to cover another domain.

> `src/` is the only version-controlled part; an installed instance is a runtime artifact that evolves
> as you use it. The repo already gitignores `assistant/`, so the common in-repo install stays
> untracked; install elsewhere to keep it outside the repo entirely. Reinstall or reset any time from
> `src/`.

## Using with Claude Co-Work

To use this assistant with Claude Co-Work, first set up your Claude Co-Work environment and then point Claude Co-Work to the `assistant/` directory or create a project pointing to the `assistant/` directory.

### Initializing the Assistant

If `assistant/` doesn't exist yet (a fresh clone only has `src/`), install it first:
`sh ./install.sh assistant`.

Start a new task in Claude Co-Work and ensure your working directory is the `assistant/` directory.

In the task chat, type `run init` to initialize the assistant.

### Common Commands

#### Add Sources

Add sources to the `sources/inbox/` directory to provide context for the assistant.
Type `run ingest` to process the inbox and file sources into the right bundle. Ingested sources are permanently stored in the `sources/library/` directory.

#### Query & Search

Type your query `<query text>` or `run query <query_text>` to search the bundles for relevant knowledge.

#### Ask the Assistant

Type your query `<query text>` to ask the assistant a question. The assistant will respond with a relevant answer based on its memory and the concepts in its bundles.

#### Take Notes

Type `remember <fact>` (or `run remember <fact>`). The `remember` skill files it to the right memory layer for you — a short-lived note in `state` by default, durable knowledge into a bundle, or a lasting preference into `core`.

### Running Skills

To run a skill, use the `run` command followed by the skill name and any required arguments. For example:

```
run <skill_name> <arg1> <arg2> ...
```

Available skills:

| Skill | Run | What it does |
|---|---|---|
| `init` | `run init` | One-time setup — set the assistant's identity, domain, and purpose, and optionally stand up its first bundle. |
| `remember` | `run remember <fact>` | Save a fact to the right memory layer — a short-lived note by default, durable knowledge to a bundle, or a lasting preference to core. |
| `create` | `run create <name>` | Create a new OKF knowledge bundle for a domain. |
| `import` | `run import <path>` | Adopt an existing OKF bundle authored elsewhere — verify it and register it. |
| `remove` | `run remove <name>` | Retire a bundle — confirms first, offers to preserve a copy, then deletes and deregisters it, archiving its unshared backing sources to `sources/archive/`. |
| `ingest` | `run ingest` | Pull new material from `sources/inbox/` into the right bundle, then file the source into `sources/library/`. |
| `query` | `run query <text>` | Answer a question from the bundles and save useful new findings back as concepts. |
| `lint` | `run lint` | Audit a bundle for OKF conformance, contradictions, stale claims, orphans, and broken links. |
| `reflect` | `run reflect` | Consolidate recent activity into durable memory and prune stale state (self-improvement). |
| `export` | `run export <what>` | Produce a deliverable (summary, report, slide outline, copied source) into `artifacts/` — not filed into a bundle. |

## Customizing Your Assistant

Everything the assistant is and does lives in editable markdown under `assistant/`:

- **Identity & principles** — edit `memory/core.md` (or re-run `init`) to change the assistant's name, domain, purpose, and core principles.
- **Routing & conventions** — edit `memory/procedural.md` to add skill routes, operating rules, or conventions.
- **Knowledge structure** — a bundle's concept types live in its `templates/` (created for you by `create`); edit them to match the domain.
- **Add a skill** — create `skills/<group>/<name>/SKILL.md` (Agent Skills format), with `scripts/` or `assets/` if it needs them, then add a route for it in `memory/procedural.md`.

The assistant also customizes itself over time: `reflect` promotes durable learnings from its activity log into its memory and skills.

## Managing Bundles

Knowledge lives in one or more OKF bundles under `bundles/` — one per domain. The assistant manages as many as it needs; the `bundles/index.md` catalog lists them all.

1. `run create <name>` — stands up a new `bundles/<name>/` with its `index.md`, `log.md`, and per-type `templates/` (see `skills/bundles/create`). Or `run import <path>` to adopt an existing OKF bundle authored elsewhere (see `skills/bundles/import`).
2. Drop material into `sources/inbox/` and `run ingest` — it files concepts into the right bundle.
3. `run query <text>` answers from the bundles; `run lint` keeps a bundle OKF-conformant and healthy.
4. `run remove <name>` retires a bundle you no longer need (destructive — confirms first; archives its unshared backing sources to `sources/archive/`).

See [docs/bundles.md](docs/bundles.md) for the full model.

## Architecture

The framework is markdown conventions only, so there is no build step or runtime.

- **Multiple bundles.** The assistant covers several domains by managing multiple OKF knowledge bundles under `bundles/` — one per domain — rather than a single wiki. See [docs/bundles.md](docs/bundles.md).
- **Four-layer memory.** `core` (identity & principles) · `procedural` (layout, routes, conventions) · `state` (short-lived state) · `journal` (append-only activity log). `reflect` consolidates upward and is the self-improvement loop. See [docs/memory.md](docs/memory.md).
- **Skills** are self-contained `SKILL.md` procedures under `skills/{core,bundles}/`, routed from `memory/procedural.md`. They follow the [Agent Skills spec](https://agentskills.io/specification).
- **Knowledge vs. memory.** `bundles/` hold durable, user-facing knowledge (OKF concepts) curated from `sources/`; `memory/` is the assistant's own operating state. The two are kept separate.
- **Source vs. instance (dev/install split).** `src/` is the only version-controlled tree — `AGENTS.md`, the blank `memory/` contracts, and `skills/`. A working instance is installed from it by `install.sh` into any target path (the repo gitignores `assistant/` for the common in-repo case); it evolves its own memory, skills, and bundles at runtime without touching `src/`.

See also [docs/concepts.md](docs/concepts.md) for the two foundational ideas, and `CLAUDE.md` for guidance on working on the framework itself.

## License

MIT.
