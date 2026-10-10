---
name: bundle-lint
description: Audit one bundle or the whole catalog for structural conformance, contradictions, stale or aging facts, leaked secrets, misplaced material, and index/log/catalog drift; fix what's mechanical and put the judgment calls to the human. Use periodically, after a large ingest, or when the knowledge seems inconsistent.
---

# Bundle lint

A bookkeeping pass that keeps bundles conformant and trustworthy. Lint the bundle the human names,
or every bundle in `bundles/index.md`; checks marked *(catalog)* always cover all bundles.

## Mechanical checks — find by search, fix directly

Run these as searches over the files (grep, find) rather than reading every page:

- **OKF conformance** — every non-reserved `.md` outside `templates/` has frontmatter with a non-empty
  `type:`; the root `index.md` declares `okf_version`.
- **Layout** — each concept sits at `<type>/<name>.md` matching its `type:` (imported bundles keep
  their authored layout).
- **Indexes** — every type folder has an `index.md` that lists exactly its concepts and is linked from
  the root index.
- **Log** — newest-first `## YYYY-MM-DD` headings, with recent changes present.
- **Links** — `[title](/path/to/concept.md)` links that don't resolve, and links reaching outside the
  bundle.
- **Templates** — every `type:` in use has a template; each concept's frontmatter keys and heading set
  and order match it; no `{{placeholder}}` or `# Authoring` is left in a concept.
- **Filenames** — kebab-case.
- **Secrets** — passwords, keys, tokens, private-key blocks, full card or account numbers.
- **Catalog** *(catalog)* — every bundle listed and none missing; *Not here* boundaries reciprocal.

Fix these directly: sync indexes and logs, fix obvious links, rename to kebab-case, add a `type:` where
the intent is clear, strip leaked scaffolding, and restore missing or misordered template headings.
Moving a concept means rewriting every `](/old/path.md)` link to it and both indexes — a bare move
breaks its inbound links. Replace a leaked secret with a note of where it lives, and tell the human it
remains in the git history.

## Judgment checks — read, then report

These need reading and a decision. Unless the human asks for a full pass, cover the concepts changed
since the last lint (from the bundle's `log.md`, or the last `bundle-lint` journal entry) and those
citing library sources added since:

- **Contradictions** — within a bundle, and *(catalog)* across bundles citing the same
  `sources/library/<file>`; reconcile against the source.
- **Stale claims** — facts a newer source contradicts.
- **Aging facts** — versions, prices, ownership, or status on pages untouched for a long time (a
  template's `# Authoring` may set the horizon); verify with a lookup when the harness allows,
  otherwise list them for review.
- **Untraced claims** — statements with no citation: a `sources/library/<file>` path,
  `human — YYYY-MM-DD`, `<URL> — retrieved YYYY-MM-DD`, or cross-links to the concepts they derive
  from.
- **Misplaced material** — concepts that a catalog boundary assigns to another bundle.
- **Scope drift** *(catalog)* — a catalog row that no longer describes the bundle's current types and
  topics, which mis-routes `bundle-query` and `bundle-ingest`.
- **Isolated concepts** — pages no other concept links to where a relation clearly exists.

Put these to the human in one message, grouped by bundle and most consequential first, each with a
proposed resolution so they can approve in a batch. Moving material between bundles is always the
human's call.

## Wrap up

Re-run the mechanical checks to confirm the fixes held, commit them, and journal one line per bundle:
what was fixed and what awaits a decision. When the harness supports sub-agents, a whole-catalog lint
can give each bundle to one sub-agent, followed by a single pass over the catalog.

## Done when

The mechanical checks come back clean, the fixes are committed, and every judgment call is in front of
the human with a proposed resolution.
