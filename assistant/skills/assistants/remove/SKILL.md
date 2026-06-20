---
name: remove
description: Remove a child assistant under assistants/. Confirm first and optionally preserve its knowledge — this is irreversible. Use to retire a child that is no longer needed.
---

# Remove

Prune an assistant from the tree. *Reversible by default* does not apply here — deletion is
permanent, so confirm before acting.

## Steps

1. **Identify** the child at `assistants/<name>/`. If it has its own children, stop and surface that
   — removing it removes the whole subtree.
2. **Confirm with the human.** State exactly what will be deleted. Do not proceed without explicit
   approval.
3. **Preserve if valuable.** Offer to salvage the child's knowledge first — `ingest` its useful
   `wiki/` pages or `sources/library/` into this assistant, or copy them aside. Skip only if the
   human declines.
4. **Delete** `assistants/<name>/`.
5. **Clean up references.** Remove any routes or notes that pointed at the child from
   `memory/procedural.md` and `memory/declarative.md`.
6. **Log it.** Append an entry to `memory/working.md` recording what was removed and what was
   preserved.

## Done when

The child and its references are gone, and any knowledge worth keeping has been salvaged.
