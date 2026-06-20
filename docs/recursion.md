# Recursion

An **assistant is a self-contained directory** with the same shape at every level:

```
<assistant>/
├── AGENTS.md      # bootstrap
├── memory/        # core, procedural, declarative, working
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
| `assistants/create` | scaffold a new assistant (script + `assets/`): blank memory, skills inherited from this assistant, personalize via `init` |
| `assistants/remove` | retire a child (confirm + salvage first; irreversible) |
| `core/delegate` | route a task to a child as a directory-scoped sub-agent |

`delegate` works identically at every level, so a task can flow root → child → grandchild, each
assistant loading only its own context. Self-containment is the rule: an assistant runs standalone
*and* as a child, and edits only its own memory and skills.

See also: [concepts](concepts.md), [memory model](memory.md).
