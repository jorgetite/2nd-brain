---
name: lint
description: Audit the wiki for contradictions, stale claims, orphans, broken cross-links, and index drift; fix what's clear and report the rest. Run periodically to keep the knowledge base healthy.
---

# Lint

The wiki's bookkeeping pass. Keep it coherent so it stays trustworthy.

## Checks

Scan `wiki/` pages and `wiki/index.md` for:

- **Index drift** — pages missing from `index.md`, or index entries pointing at moved/deleted pages.
- **Broken cross-links** — `[[links]]` to pages that don't exist (decide: create the page, or fix
  the link).
- **Orphans** — pages nothing links to and that the index doesn't surface.
- **Contradictions** — pages making incompatible claims; reconcile against their cited sources.
- **Stale claims** — facts contradicted by a newer source in `sources/library/`.
- **Untraced claims** — statements with no source behind them.
- **Convention drift** — non-kebab-case filenames, wrong template/page-type usage.

## Steps

1. Run the checks above.
2. **Fix the unambiguous** (index sync, obvious broken links, filename casing).
3. **Report the judgment calls** (contradictions, stale claims) to the human rather than guessing.
4. **Log it.** Append a summary of what was fixed and what needs a decision to `memory/journal.md`.

## Done when

The index matches the pages, no dangling links remain unhandled, and open issues are surfaced.
