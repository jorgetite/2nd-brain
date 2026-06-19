# Recursion

An **assistant is a node** — a self-contained directory with the same shape at every level:

```
<node>/
├── AGENTS.md      # bootstrap
├── memory/        # core, procedural, declarative, working
├── skills/        # core/, wiki/, assistants/
├── sources/       # inbox → library/archive
├── templates/     # wiki page skeletons
├── wiki/          # curated knowledge
└── assistants/    # child nodes — each an identical <node>
```

Because a node contains an `assistants/` slot holding more nodes of the identical shape, trees nest
to any depth.

## Roles, not structures

- **Orchestrator** — a node whose `assistants/` is populated; its "domain" is coordination.
- **Domain assistant** — a leaf node (`assistants/` empty) that owns one area.

The difference is only the `AGENTS.md` / identity and whether `assistants/` has children. Any node
can be both: a child orchestrator under a higher one.

## The three operations

| Skill | Does |
|---|---|
| `assistants/add` | scaffold a child node, seed its skills from this node, personalize via `init` |
| `assistants/remove` | retire a child (confirm + salvage first; irreversible) |
| `core/delegate` | route a task to a child as a directory-scoped sub-agent |

`delegate` works identically at every level, so a task can flow root → child → grandchild, each node
loading only its own context. Self-containment is the rule: a node runs standalone *and* as a child,
and edits only its own memory and skills.

See also: [concepts](concepts.md), [memory model](memory.md).
