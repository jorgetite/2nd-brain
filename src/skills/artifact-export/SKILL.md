---
name: artifact-export
description: Produce a deliverable for the human — a summary, report, checklist, slide outline, or a copy of a source — and write it to artifacts/. Use when the human wants something to take away rather than knowledge filed into a bundle.
---

# Export

Produce a deliverable the human takes away. Exports land in `artifacts/` and are **deliverables, not
knowledge** — don't file them into a bundle. (If the underlying synthesis is also durable knowledge,
file that separately via `skills/bundle-query` or `bundle-ingest`.)

Clarify what to produce, its format, and whether citations should be embedded when the request
leaves that open. Gather the material from bundles (via `skills/bundle-query`), `sources/`, or memory,
and ground every claim in what they support — *Truth over invention*.

Prefer Markdown or HTML, which need no tooling; for richer formats (`.pptx`, `.pdf`, `.docx`) use
whatever the harness provides, and if nothing is available produce Markdown/HTML and say so. Copying
a source means copying the file out of `sources/` unchanged. Name the file in kebab-case, date-prefixed
when useful (`2026-07-23-q3-summary.md`); `artifacts/` persists until the human prunes it.

Delivery beyond `artifacts/` (email, chat, upload) is outward-facing — confirm first (*Reversible by
default*).

## Done when

The deliverable exists in `artifacts/`, `memory/journal.md` records what it was derived from (which
bundles, concepts, or sources), and the human knows where to find it.
