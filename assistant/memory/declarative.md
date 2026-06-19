# Layer 3 — Declarative Memory

Current-state facts: what is true _right now_ about the user, active tasks, and context.
Every entry has limited life. `skills/core/reflect` prunes entries past their expiry and
promotes anything that proves durable into Core (L1) or into the `wiki/`.

This layer is for transient operational state, not durable knowledge — lasting facts for the
user belong in `wiki/`.

## Entries

Format, most recent first:

`- [recorded: YYYY-MM-DD] [expires: YYYY-MM-DD | review] — <fact>`

Use `review` instead of a date when an entry should be re-evaluated at the next reflect rather
than auto-pruned.

_(none yet)_
