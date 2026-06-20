# 2nd Brain

A framework for an everyday, AI-powered personal assistant — built almost entirely from markdown
conventions (the one exception: an optional shell script that scaffolds new assistants, with a
markdown fallback). It targets any agent harness that supports the `AGENTS.md` and `SKILL.md`
standards and is agnostic of the underlying provider and model.

It is the synthesis of two ideas (see [docs/concepts.md](docs/concepts.md)):

- **The LLM Wiki** — knowledge that compounds: the assistant curates a persistent, interlinked wiki
  instead of re-deriving answers each time.
- **The Continual Harness** — capability that compounds: the assistant adapts its own memory and
  skills from its activity history.

## How it works

An assistant is a self-contained directory the harness boots from:

```
assistant/
├── AGENTS.md      # entrypoint: bootstrap, then act
├── memory/        # 4-layer memory — core · procedural · declarative · working
├── skills/        # SKILL.md playbooks — core/ · wiki/ · assistants/
├── sources/       # raw source pipeline — inbox → library/archive
├── templates/     # wiki page skeletons
├── wiki/          # the curated knowledge base
└── assistants/    # child nodes, each an identical assistant
```

- **Memory** is layered like human memory; the `reflect` skill consolidates activity upward into
  durable learnings. See [docs/memory.md](docs/memory.md).
- **Skills** are the operating procedures: `core/` (init, delegate, reflect), `wiki/` (ingest,
  query, lint), `assistants/` (create, remove). `memory/procedural.md` routes intent → skill.
- **Recursion** is structural: an assistant holds child assistants of the same shape, so an orchestrator can
  coordinate domain assistants to any depth. See [docs/recursion.md](docs/recursion.md).

## Getting started

1. Clone this repo — the clone *is* your assistant (clone again for a separate, independent one).
2. From the `assistant/` directory, run the `init` skill to set its identity, domain, and purpose.
3. Drop material into `sources/inbox/` and run `ingest`; ask questions with `query`.
4. Add specialized child assistants with the `create` skill when one domain isn't enough.

## License

MIT.
