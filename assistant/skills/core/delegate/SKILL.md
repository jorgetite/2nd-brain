---
name: delegate
description: Hand a task to a child assistant under assistants/ and integrate its result. Use when a request falls in a child's domain rather than this assistant's own. Requires at least one child (see create).
---

# Delegate

Coordinate, don't do the child's domain work yourself. This is how an orchestrator drives the
recursive tree — and a child may delegate further down, same skill, next level.

## Steps

1. **Pick the child.** Match the task to a child in `assistants/` by its domain (read each child's
   `memory/core.md` Identity if unsure). If none fits, stop and consider `skills/assistants/create`.
2. **Invoke it scoped.** Launch the child as a sub-agent whose working directory is
   `assistants/<child>/`. It bootstraps from its own `AGENTS.md` and loads its own memory, skills,
   and wiki — pass only the task, not your context.
3. **Hand off cleanly.** State the goal and the success criteria. Let the child choose its own
   skills.
4. **Integrate the result.** Take what the child returns; record durable outcomes in this
   assistant's own memory (per the Recording table in `memory/procedural.md`). Do not copy the
   child's internal memory up.
5. **Log it.** Append a delegation entry to `memory/working.md`.

## Boundaries

- Never edit a child's `memory/` or `skills/` directly — delegate the task and let the child own
  its changes.
- If the task spans several children, delegate to each and synthesize; don't merge their domains.
