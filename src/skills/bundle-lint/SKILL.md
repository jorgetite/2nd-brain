---
name: bundle-lint
description: Audit one bundle or the whole catalog for OKF conformance, contradictions, stale claims, orphans, broken links, misplaced material, and index/log/catalog drift; fix what's clear and report the rest. Use periodically, or when the knowledge seems inconsistent.
---

# Lint

A bundle's bookkeeping pass. Keep it conformant and coherent so it stays trustworthy.

## Checks

Lint one named bundle, or — unscoped — every bundle in `bundles/index.md`. The checks marked
*(catalog)* are catalog-level and always run across all bundles, whatever the scope. For each
bundle in scope, scan its concepts, `index.md`, and `log.md` for:

- **OKF conformance** — every non-reserved `.md` has parseable YAML frontmatter with a non-empty
  `type:` (reserved `index.md`/`log.md` are exempt, as is everything under `templates/` — templates
  are tooling, not concepts). The bundle-root `index.md` declares `okf_version`.
- **Layout drift** — a concept not in the folder matching its `type:`. Concepts live at
  `<type>/<name>.md`, mirroring `templates/<type>.md`. (Imported bundles keep their authored layout —
  exempt them.)
- **Index drift** — concepts missing from `index.md`, or list entries pointing at moved/deleted
  concepts. Check **every directory's** `index.md`, not just the bundle root: each type folder should
  have an `index.md`, list its own concepts, and be linked from its parent index.
- **Log drift** — `log.md` missing recent changes, or not newest-first with `## YYYY-MM-DD` headings.
- **Broken links** — `[title](/path/to/concept.md)` links to concepts that don't exist (decide:
  create the concept, or fix the link — broken links are tolerated but worth resolving).
- **Orphans** — concepts nothing links to and that the index doesn't surface.
- **Contradictions** — concepts making incompatible claims; reconcile against their cited sources.
- **Stale claims** — facts contradicted by a newer source in `sources/library/`.
- **Untraced claims** — statements with no citation behind them: neither a `sources/library/<file>`
  path nor a sourceless form (`human — YYYY-MM-DD`, or cross-links to the concepts it derives from).
- **Template drift** — a concept whose frontmatter keys or heading set/order don't match its type's
  `templates/<type>.md`.
- **Missing template** — a `type:` in use with no `templates/<type>.md` to define its format.
- **Leaked scaffolding** — an unfilled `{{placeholder}}` or an `# Authoring` section inside a concept;
  both belong only to templates.
- **Convention drift** — non-kebab-case filenames.
- **Catalog drift** *(catalog)* — `bundles/index.md` missing a bundle, pointing at a removed one,
  carrying a row description that no longer conveys the bundle's current scope (its concept types /
  key topics), or a *Not here* boundary with no reciprocal clause on the other bundle's row — stale
  rows mis-route `bundle-query` and `bundle-ingest`.
- **Cross-bundle contradictions** *(catalog)* — for each `sources/library/<file>` cited by more than
  one bundle (grep every bundle's `# Citations`, as `skills/bundle-remove` step 4 does), the claims
  citing it must agree across those bundles; reconcile against the source.
- **Misplaced material** — concepts that a catalog boundary assigns to another bundle, and links
  that reach outside the bundle (bundles are self-contained). Report these; moving material between
  bundles is the human's call.

## Fix or report

**Fix the unambiguous**: index/log sync, obvious broken links, filename casing, a missing `type:`
where the intended type is clear, leaked `# Authoring` sections, and template drift that's pure
structure (a missing or misordered heading). Relocating a concept means moving the file **and**
rewriting every `](/old/path.md)` link pointing at it, plus both indexes — a bare move silently breaks
its inbound links.

**Report the judgment calls** — contradictions, stale claims, missing templates, misplaced material,
unfilled `{{placeholders}}` — to the human rather than guessing; they need a fact or a decision.

Bundles are independent, so when the harness supports sub-agents a whole-catalog lint can run one
per bundle in parallel, followed by a single pass over the catalog itself. Log a summary of what was
fixed and what needs a decision in `memory/journal.md`.

## Done when

Every concept is OKF-conformant, sits in its type's folder, and matches its type's template; each
bundle's `index.md`/`log.md` match its concepts; no dangling links remain unhandled; and open issues
are surfaced.
