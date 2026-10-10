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
├── skills/        # SKILL.md playbooks — brain-* · memory-* · bundle-* · artifact-*
├── sources/       # raw source pipeline — inbox → library/archive
├── bundles/       # OKF knowledge bundles (index.md catalogs them)
└── artifacts/     # generated deliverables (exports) — not versioned
```

- **Memory** is layered like human memory; the `memory-reflect` skill consolidates activity upward into
  durable learnings. See [docs/memory.md](docs/memory.md).
- **Skills** are the operating procedures, one folder each under `skills/`: `brain-init`,
  `memory-*` (remember, reflect), `bundle-*` (create, import, remove, ingest, query, lint),
  `artifact-export`. `memory/procedural.md` routes intent → skill.
- **Bundles** hold the knowledge: each is an OKF-compliant markdown tree for one domain, and the
  assistant manages as many as it needs. See [docs/bundles.md](docs/bundles.md).

## Quick Start

1. Clone this repo.
2. **Install** the working assistant from the source: `sh ./install.sh ~/brain` (any path, relative
   or absolute). The installed directory is its own git repository, so the assistant's self-edits can
   be rolled back.
3. Point your harness to the installed directory and run the `brain-init` skill to set its name,
   purpose, and the areas of life it covers — and optionally stand up one bundle per area.
4. Create more bundles with `bundle-create` as needed, drop material into `sources/inbox/` and run
   `bundle-ingest`; ask questions with `bundle-query`.

> `src/` is the only version-controlled part of this repo; an installed instance is a runtime artifact
> that evolves as you use it. Reinstall or reset any time from `src/`. The repo gitignores
> `assistant/` for an in-repo install, but see the note below before using one with Claude.

## Running on Claude (Claude Code, Cowork)

The framework stays harness-agnostic; these are the Claude-specific settings that make it work well.

- **Install outside this repo.** Claude Code reads `AGENTS.md` only when there is no `CLAUDE.md` in the
  working directory or any directory above it. An in-repo `assistant/` sits under this repo's
  `CLAUDE.md` (the guide for developing the framework), which would load instead of the assistant's
  `AGENTS.md`. If you do install in-repo, exclude that file in the instance's
  `.claude/settings.local.json`: `{"claudeMdExcludes": ["**/2nd-brain/CLAUDE.md"]}`.
- **Keep one memory.** The assistant's memory is `memory/` (plus its bundles), and three layers keep
  it that way:
  1. `AGENTS.md` carries a *Memory boundary* rule: never use harness-provided memory for this
     assistant.
  2. `install.sh` writes `.claude/settings.json` with `{"autoMemoryEnabled": false}`, which turns off
     Claude Code's auto memory for the instance (other harnesses ignore the file).
  3. Where the harness has project instructions (a Cowork or claude.ai project), paste this pointer —
     keep it a pointer, so the real rules live in one place:

     ```text
     Before anything else, read and follow AGENTS.md in this directory. Store memory and knowledge
     only in this assistant's memory/ and bundles/, never in harness-provided memory.
     ```

     Claude Code has no per-project prompt field; to add it there, pass the same text with
     `claude --append-system-prompt "…"` (e.g. via a shell alias).
- **Skills.** `memory/procedural.md` routes each request to the right `skills/<name>/SKILL.md`, so no
  setup is needed. For native `/bundle-query`-style invocation, link them into Claude's skill
  directory: `mkdir -p .claude && ln -s ../skills .claude/skills`.
- **Model and effort.** Claude Opus 5.5 at its default `medium` effort suits everyday questions and
  notes. Use `high` for `bundle-ingest`, `bundle-lint`, and `memory-reflect`, and consider Claude Fable
  5.1 for a whole-catalog lint or a long reflect.

In Cowork, open the installed directory as the task's working directory (or a project pointing at it)
and type `run brain-init` to initialize the assistant.

## Common Commands

### Add Sources

Add sources to the `sources/inbox/` directory to provide context for the assistant.
Type `run bundle-ingest` to process the inbox and file sources into the right bundle. Ingested sources are permanently stored in the `sources/library/` directory.

### Query & Search

Type your query `<query text>` or `run bundle-query <query_text>` to search the bundles for relevant knowledge.

### Ask the Assistant

Type your query `<query text>` to ask the assistant a question. The assistant will respond with a relevant answer based on its memory and the concepts in its bundles.

### Take Notes

Type `remember <fact>` (or `run memory-remember <fact>`). The `memory-remember` skill files it by kind — durable facts about your things into a bundle, dated or short-lived items into `state`, preferences into `core` — asking when it's unclear. It also handles "remind me", corrections, and "forget that", and never stores a secret's value.

## Running Skills

To run a skill, use the `run` command followed by the skill name and any required arguments. For example:

```
run <skill_name> <arg1> <arg2> ...
```

Available skills:

| Skill | Run | What it does |
|---|---|---|
| `brain-init` | `run brain-init` | One-time setup — set the assistant's name, purpose, and the areas it covers, and optionally stand up a bundle per area. |
| `brain-upgrade` | `run brain-upgrade` | Merge a newer framework version into this assistant, keeping what it has learned; resolves conflicts and fills anything new. |
| `memory-remember` | `run memory-remember <fact>` | Keep, correct, or forget a fact — filed by kind: a bundle, state, or preferences — asking when unclear. |
| `bundle-create` | `run bundle-create <name>` | Create a new OKF knowledge bundle for a domain. |
| `bundle-import` | `run bundle-import <path>` | Adopt an existing OKF bundle authored elsewhere — verify it and register it. |
| `bundle-remove` | `run bundle-remove <name>` | Retire a bundle — confirms first, offers to preserve a copy, then deletes and deregisters it, archiving its unshared backing sources to `sources/archive/`. |
| `bundle-ingest` | `run bundle-ingest` | Pull new material from `sources/inbox/` into the right bundle, then file the source into `sources/library/`. |
| `bundle-query` | `run bundle-query <text>` | Answer a question from the bundles and save useful new findings back as concepts. |
| `bundle-lint` | `run bundle-lint` | Audit bundles for OKF conformance, broken links, leaked secrets, contradictions, and stale or aging facts; fixes the mechanical issues and proposes resolutions for the rest. |
| `memory-reflect` | `run memory-reflect` | Consolidate recent activity into durable memory and prune stale state (self-improvement). |
| `artifact-export` | `run artifact-export <what>` | Produce a deliverable (summary, report, slide outline, copied source) into `artifacts/` — not filed into a bundle. |

## Upgrading Your Assistant

An installed assistant keeps an untouched copy of the framework it came from on its `framework` git
branch. To take a newer framework without losing what the assistant has learned, pull this repo, then:

```
sh ./install.sh --upgrade ~/brain
```

It commits the new framework snapshot to that branch and merges it into the assistant: files the
assistant never changed update cleanly, its own edits and skills survive, and your bundles and sources
are never touched. Then run `brain-upgrade` in the assistant — it resolves any conflicts (your memory
content always wins), fills new setup fields, and verifies. Upgrades change code, not data: if a
framework change alters a format your bundles use, `brain-upgrade` tells you what would need
converting.

A few things to know:

- **Commit first.** The upgrade refuses while the assistant has uncommitted changes to tracked files
  (new files in `sources/inbox/` are fine). The assistant normally commits its own edits; if not,
  commit in the assistant's directory and rerun.
- **Read how it ends.** The script reports one of three outcomes: a clean merge (run `brain-upgrade`
  anyway to fill new fields and verify), *already up to date* (nothing to do), or a list of conflicted
  files (run `brain-upgrade` to resolve them).
- **Older assistants work too.** One installed before the `framework` branch existed gets it created
  automatically from its original install commit.
- **Expect a `core.md` conflict** whenever the framework adds an identity field: your filled-in lines
  sit next to the new one. `brain-upgrade` keeps yours and adds the new field for `brain-init` to fill.

## Customizing Your Assistant

Everything the assistant is and does lives in editable markdown under `assistant/`:

- **Identity & principles** — edit `memory/core.md` (or re-run `brain-init`) to change the assistant's name, scope, purpose, and core principles.
- **Routing & conventions** — edit `memory/procedural.md` to add skill routes, operating rules, or conventions.
- **Knowledge structure** — a bundle's concept types live in its `templates/` (created for you by `bundle-create`). A template *is* the page format for its type: edit its frontmatter and headings to change how those pages look, and put per-type rules in its `# Authoring` section, which the assistant obeys and then strips. Each type also gets its own folder — a `recipe` concept lands in `recipe/` — so the bundle's layout mirrors its templates.
- **Add a skill** — create `skills/<name>/SKILL.md` (Agent Skills format; `name:` matches the folder), with `scripts/` or `assets/` if it needs them, then add a route for it in `memory/procedural.md`.

The assistant also customizes itself over time: `memory-reflect` promotes durable learnings from its activity log into its memory and skills.

## Managing Bundles

Knowledge lives in one or more OKF bundles under `bundles/` — one per domain. The assistant manages as many as it needs; the `bundles/index.md` catalog lists them all.

1. `run bundle-create <name>` — stands up a new `bundles/<name>/` with its `index.md`, `log.md`, and per-type `templates/` (see `skills/bundle-create`). Or `run bundle-import <path>` to adopt an existing OKF bundle authored elsewhere (see `skills/bundle-import`).
2. Drop material into `sources/inbox/` and `run bundle-ingest` — it files concepts into the right bundle.
3. `run bundle-query <text>` answers from the bundles; `run bundle-lint` keeps a bundle OKF-conformant and healthy.
4. `run bundle-remove <name>` retires a bundle you no longer need (destructive — confirms first; archives its unshared backing sources to `sources/archive/`).

See [docs/bundles.md](docs/bundles.md) for the full model.

## Architecture

The framework is markdown conventions only, so there is no build step or runtime.

- **Multiple bundles.** The assistant covers several domains by managing multiple OKF knowledge bundles under `bundles/` — one per domain — rather than a single wiki. See [docs/bundles.md](docs/bundles.md).
- **Four-layer memory.** `core` (identity & principles) · `procedural` (layout, routes, conventions) · `state` (short-lived state) · `journal` (append-only activity log). `memory-reflect` consolidates upward and is the self-improvement loop. See [docs/memory.md](docs/memory.md).
- **Skills** are self-contained `SKILL.md` procedures under `skills/<name>/`, routed from `memory/procedural.md`. They follow the [Agent Skills spec](https://agentskills.io/specification).
- **Knowledge vs. memory.** `bundles/` hold durable, user-facing knowledge (OKF concepts) curated from `sources/`; `memory/` is the assistant's own operating state. The two are kept separate.
- **Source vs. instance (dev/install split).** `src/` is the only version-controlled tree — `AGENTS.md`, the blank `memory/` contracts, and `skills/`. A working instance is installed from it by `install.sh` into any target path (the repo gitignores `assistant/` for the common in-repo case); it evolves its own memory, skills, and bundles at runtime without touching `src/`, and takes later framework versions through `install.sh --upgrade`, which merges them in without losing its learned edits.

See also [docs/concepts.md](docs/concepts.md) for the two foundational ideas, and `CLAUDE.md` for guidance on working on the framework itself.

## License

MIT.
