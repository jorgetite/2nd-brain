---
name: delegate
description: Route a request to one or more direct child assistants via the assistants/index.md roster, dispatch the parts in parallel or sequence, and merge the results. Use when a request fits a child's domain better than this assistant's own.
---

# Delegate

Coordinate; don't do the child's domain work yourself. This drives the recursive tree — a child may delegate further down (same skill, next level).

## When to delegate

**Default: handle the request yourself.** Delegate only to a child that **already exists** in
`assistants/index.md` (you know your children from bootstrap) and whose domain owns the request:

- **One child clearly owns it** → delegate to it.
- **The request spans domains, or several children fit** → decompose and delegate the parts (see Dispatch).
- **You have no children, or none fits** → **handle it yourself.** Never create a child to satisfy a request — creating an assistant is a human-initiated action, not something `delegate` does.

## Steps

1. **Select from the roster.** Read `assistants/index.md` (name → domain) and pick the **direct**
   child(ren) whose domain matches. Only direct children — a child owns its own subtree and delegates deeper itself.
2. **Dispatch (adaptive).** Decompose the request into subtasks and dispatch by their dependencies:
   - **Independent** subtasks → dispatch in **parallel**.
   - **Dependent** subtasks (one needs another's output) → dispatch in **sequence**, feeding each
     result into the next.

   Invoke each child **scoped**: a fresh context rooted at `assistants/<child>/`, so it bootstraps from
   its own `AGENTS.md` and loads its own memory, skills, and wiki. Pass only the task and its success
   criteria — not your context. (The launch mechanism is harness-provided — a sub-agent/task, or a
   session rooted at the child's directory; this skill specifies the intent, not a specific API.)
3. **Merge.** Combine the children's results into one answer. If a child failed or returned nothing, say so plainly — don't paper over a gap.
4. **Record.** Keep durable outcomes in this assistant's own memory (per the Recording table in
   `memory/procedural.md`). Do not copy a child's internal memory up.
5. **Log it.** Append a delegation entry to `memory/journal.md`.

## Boundaries

- Delegate only to **direct** children; never reach into a grandchild — that is the child's job.
- Never edit a child's `memory/` or `skills/` — delegate the task and let the child own its changes.
- Keep domains separate: synthesize the children's results; don't merge their domains.
