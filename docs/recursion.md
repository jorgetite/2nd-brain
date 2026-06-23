# Recursion

An **assistant is a self-contained directory** with the same shape at every level:

```
<assistant>/
├── AGENTS.md      # bootstrap
├── memory/        # core, procedural, state, journal
├── skills/        # core/, wiki/, assistants/
├── sources/       # inbox → library/archive
├── templates/     # wiki page skeletons
├── wiki/          # curated knowledge
└── assistants/    # child assistants — each an identical assistant
```

Because an assistant contains an `assistants/` slot holding more assistants of the identical shape,
trees nest to any depth.

## Roles, not structures

- **Orchestrator** — an assistant whose `assistants/` is populated; its "domain" is coordination.
- **Domain assistant** — a leaf (`assistants/` empty) that owns one area.

The difference is only the `AGENTS.md` / identity and whether `assistants/` has children. Any
assistant can be both: a child orchestrator under a higher one.

## The three operations

| Skill | Does |
|---|---|
| `assistants/create` | scaffold a new assistant **pristine from the framework source `src/`** (blank memory + skills from `src/`), personalize via `init`, register in `assistants/index.md` |
| `assistants/remove` | retire a child (confirm + salvage first; deregister; irreversible) |
| `core/delegate` | route a request to direct children via the `assistants/index.md` roster — parallel for independent parts, sequential for dependent ones — as directory-scoped sub-agents |

Children are tracked in each assistant's `assistants/index.md` roster (name → domain), loaded at
bootstrap; `delegate` routes by it, `create` adds a row, `remove` removes one. By default an
assistant **handles a request itself** — it delegates only when a roster child owns the domain, and
**never creates a child** to satisfy a request (creating one is human-initiated). `delegate` works
identically at every level, so a request flows root → child → grandchild, each assistant loading
only its own context. A built assistant runs standalone, but *building* a new one (root or child)
reads from the framework source `src/`. Self-containment is the rule: an assistant runs standalone
*and* as a child, and edits only its own memory and skills.

See also: [concepts](concepts.md), [memory model](memory.md).
