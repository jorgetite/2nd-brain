# 2nd Brain

A flexible implementation of an everyday, AI-powered personal assistant. It targets any agent harness that supports the `AGENTS.md` and `SKILL.md` standards and is agnostic of the underlying provider and model.

It is the synthesis of two ideas (see [docs/concepts.md](docs/concepts.md)):

- **The LLM Wiki** — knowledge that compounds: the assistant curates a persistent, interlinked wiki instead of re-deriving answers each time.
- **The Continual Harness** — capability that compounds: the assistant adapts its own memory and skills from its activity history.

## How it works

The framework **source** lives in `src/` (version-controlled): `AGENTS.md`, the blank `memory/`
contracts, and `skills/`. You **build** a working assistant from it into `assistant/` (gitignored) —
the built instance is what the harness boots from, and it evolves freely at runtime without touching
the tracked source. A built assistant is a self-contained directory:

```
assistant/   (built from src/, gitignored)
├── AGENTS.md      # entrypoint: bootstrap, then act
├── memory/        # 4-layer memory — core · procedural · state · journal
├── skills/        # SKILL.md playbooks — core/ · wiki/ · assistants/
├── sources/       # raw source pipeline — inbox → library/archive
├── templates/     # wiki page skeletons
├── wiki/          # the curated knowledge base
└── assistants/    # child assistants, each an identical assistant
```

- **Memory** is layered like human memory; the `reflect` skill consolidates activity upward into
  durable learnings. See [docs/memory.md](docs/memory.md).
- **Skills** are the operating procedures: `core/` (init, delegate, reflect, remember), `wiki/` (ingest,
  query, lint), `assistants/` (create, remove). `memory/procedural.md` routes intent → skill.
- **Recursion** is structural: an assistant holds child assistants of the same shape, so an orchestrator can
  coordinate domain assistants to any depth. See [docs/recursion.md](docs/recursion.md).

## Quick Start

1. Clone this repo.
2. **Build** the working assistant from the source: `sh ./scaffold.sh assistant`
3. Point your harness to the `assistant/` directory and run the `init` skill to set its identity,
   domain, and purpose.
4. Drop material into `sources/inbox/` and run `ingest`; ask questions with `query`.
5. Add specialized child assistants with the `create` skill when one domain isn't enough.

> `src/` is the only version-controlled part; `assistant/` is a build artifact that evolves as you
> use it (the build adds a root instance to `.gitignore` automatically, and refuses to build outside
> the project). Rebuild or reset it any time from `src/`.

## Using with Claude Co-Work

To use this assistant with Claude Co-Work, first set up your Claude Co-Work environment and then point Claude Co-Work to the `assistant/` directory or create a project pointing to the `assistant/` directory.

### Initializing the Assistant

If `assistant/` doesn't exist yet (a fresh clone only has `src/`), build it first:
`sh ./scaffold.sh assistant`.

Start a new task in Claude Co-Work and ensure your working directory is the `assistant/` directory.

In the task chat, type `run init` to initialize the assistant.

### Common Commands

#### Add Sources

Add sources to the `sources/inbox/` directory to provide context for the assistant.
Type `run ingest` to process the inbox and add sources to the wiki. Ingested sources are permanently stored in the `sources/library/` directory.

#### Query & Search

Type your query `<query text>` or `run query <query_text>` to search the wiki for relevant sources.

#### Ask the Assistant

Type your query `<query text>` to ask the assistant a question. The assistant will respond with a relevant answer based on its memory and the sources in the wiki.

#### Take Notes

Type `remember <fact>` (or `run remember <fact>`). The `remember` skill files it to the right memory layer for you — a short-lived note in `state` by default, durable knowledge into the wiki, or a lasting preference into `core`.

### Running Skills

The assistant uses a recursive loop to process requests and execute skills.

To run a skill, use the `run` command followed by the skill name and any required arguments. For example:

```
run <skill_name> <arg1> <arg2> ...
```

Available skills:

| Skill | Run | What it does |
|---|---|---|
| `init` | `run init` | One-time setup — set the assistant's identity, domain, and purpose, and build its wiki schema and page templates. |
| `remember` | `run remember <fact>` | Save a fact to the right memory layer — a short-lived note by default, durable knowledge to the wiki, or a lasting preference to core. |
| `ingest` | `run ingest` | Pull new material from `sources/inbox/` into the wiki, then file the source into `sources/library/`. |
| `query` | `run query <text>` | Answer a question from the wiki and save useful new findings back as pages. |
| `lint` | `run lint` | Audit the wiki for contradictions, stale claims, orphans, and broken links. |
| `reflect` | `run reflect` | Consolidate recent activity into durable memory and prune stale state (self-improvement). |
| `create` | `run create <name>` | Create a new specialized child assistant under `assistants/`. |
| `delegate` | `run delegate <task>` | Hand a task to the child assistant whose domain fits. |
| `remove` | `run remove <name>` | Retire a child assistant (confirms first). |

## Customizing Your Assistant

Everything the assistant is and does lives in editable markdown under `assistant/`:

- **Identity & principles** — edit `memory/core.md` (or re-run `init`) to change the assistant's name, domain, purpose, and core principles.
- **Routing & conventions** — edit `memory/procedural.md` to add skill routes, operating rules, or conventions.
- **Knowledge structure** — edit `wiki/schema.md` and the page templates in `templates/` to match your domain (these are created for you by `init`).
- **Add a skill** — create `skills/<group>/<name>/SKILL.md` (Agent Skills format), with `scripts/` or `assets/` if it needs them, then add a route for it in `memory/procedural.md`.

The assistant also customizes itself over time: `reflect` promotes durable learnings from its activity log into its memory and skills.

## Creating Sub-Assistants

When one domain isn't enough, give the assistant specialized children. Each sub-assistant is a complete, self-contained assistant that owns one domain; the parent coordinates by delegating to it, and sub-assistants can nest to any depth.

1. `run create <name>` — scaffolds `assistants/<name>/` (see `skills/assistants/create`).
2. `run init` in the new sub-assistant — personalize its identity, domain, and wiki.
3. From the parent, `run delegate <task>` routes domain work to the child.

See [docs/recursion.md](docs/recursion.md) for the full model.

## Architecture

The framework is markdown conventions only (the lone exception is `create`'s optional scaffolding script), so there is no build step or runtime.

- **Recursive assistants.** Every assistant — root or child — is the same directory shape (see *How it works*). Orchestrator vs. domain assistant is a role, not a structure: an orchestrator simply has a populated `assistants/`. See [docs/recursion.md](docs/recursion.md).
- **Four-layer memory.** `core` (identity & principles) · `procedural` (layout, routes, conventions) · `state` (short-lived state) · `journal` (append-only activity log). `reflect` consolidates upward and is the self-improvement loop. See [docs/memory.md](docs/memory.md).
- **Skills** are self-contained `SKILL.md` procedures under `skills/{core,wiki,assistants}/`, routed from `memory/procedural.md`. They follow the [Agent Skills spec](https://agentskills.io/specification).
- **Knowledge vs. memory.** `wiki/` is durable, user-facing knowledge curated from `sources/`; `memory/` is the assistant's own operating state. The two are kept separate.
- **Source vs. instance (dev/build split).** `src/` is the only version-controlled tree — `AGENTS.md`, the blank `memory/` contracts, and `skills/`. A working `assistant/` is built from it by the root `scaffold.sh` and is gitignored; it evolves its own memory and skills at runtime without touching `src/`. New children are built the same way — **pristine from `src/`** — so there is a single source of truth and no template to keep in sync.

See also [docs/concepts.md](docs/concepts.md) for the two foundational ideas, and `CLAUDE.md` for guidance on working on the framework itself.

## License

MIT.
