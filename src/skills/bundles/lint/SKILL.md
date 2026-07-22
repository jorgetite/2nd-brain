---
name: lint
description: Audit a bundle for OKF conformance plus contradictions, stale claims, orphans, broken links, and index/log drift; fix what's clear and report the rest. Run periodically to keep a knowledge base healthy.
---

# Lint

A bundle's bookkeeping pass. Keep it conformant and coherent so it stays trustworthy.

## Checks

For each bundle in `bundles/index.md`, scan its concepts, `index.md`, and `log.md` for:

- **OKF conformance** — every non-reserved `.md` has parseable YAML frontmatter with a non-empty
  `type:` (reserved `index.md`/`log.md` are exempt). The bundle-root `index.md` declares
  `okf_version`.
- **Index drift** — concepts missing from `index.md`, or list entries pointing at moved/deleted
  concepts. Check **every directory's** `index.md`, not just the bundle root: each subdirectory should
  list its own concepts and be linked from its parent index.
- **Log drift** — `log.md` missing recent changes, or not newest-first with `## YYYY-MM-DD` headings.
- **Broken links** — `[title](/path/to/concept.md)` links to concepts that don't exist (decide:
  create the concept, or fix the link — broken links are tolerated but worth resolving).
- **Orphans** — concepts nothing links to and that the index doesn't surface.
- **Contradictions** — concepts making incompatible claims; reconcile against their cited sources.
- **Stale claims** — facts contradicted by a newer source in `sources/library/`.
- **Untraced claims** — statements with no source behind them.
- **Convention drift** — non-kebab-case filenames, wrong template/type usage.
- **Catalog drift** — `bundles/index.md` missing a bundle or pointing at a removed one.

## Steps

1. Run the checks above.
2. **Fix the unambiguous** (index/log sync, obvious broken links, filename casing, missing `type:`
   where the intended type is clear).
3. **Report the judgment calls** (contradictions, stale claims) to the human rather than guessing.
4. **Log it.** Append a summary of what was fixed and what needs a decision to `memory/journal.md`.

## Done when

Every concept is OKF-conformant, each bundle's `index.md`/`log.md` match its concepts, no dangling
links remain unhandled, and open issues are surfaced.
