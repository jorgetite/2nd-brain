---
name: export
description: Produce a deliverable for the human — draft a document (summary, report, slide outline) or copy a source out — and write it to artifacts/. Use when the human wants an output artifact rather than knowledge filed into a bundle.
---

# Export

Produce a deliverable the human takes away — a drafted summary, report, or slide outline; a copied
source; any output artifact. Exports land in `artifacts/` and are **deliverables, not knowledge** —
don't file them into a bundle. (If the underlying synthesis is also durable knowledge, file that
separately via `skills/bundles/query` or `ingest`.)

## Steps

1. **Clarify the deliverable.** What to produce (summary, report, slide outline, copy of a source),
   its format, and whether citations should be embedded. Ask if ambiguous — *Serve the human*.
2. **Gather the material.** Pull from bundles (via `skills/bundles/query`), `sources/`, or memory as
   needed. Ground every claim in what those support — *Truth over invention*.
3. **Render it.** Prefer Markdown or HTML — they need no tooling. For richer formats (`.pptx`, `.pdf`,
   `.docx`), use whatever tools the harness provides; if none are available, produce Markdown/HTML and
   say so. To "copy a source," copy the file out of `sources/` unchanged.
4. **Write to `artifacts/`.** Use a clear kebab-case filename (date-prefix if useful, e.g.
   `2026-07-23-q3-summary.md`). `artifacts/` persists — the human prunes it.
5. **Record provenance.** Log to `memory/journal.md` what the export was derived from (which bundle,
   concepts, or sources). Embed citations in the artifact itself only when the human requested them.
6. **Hand off.** Tell the human where it is (`artifacts/<file>`). Delivery beyond that (email, chat,
   upload) is harness-dependent and separate from producing the artifact.

## Done when

The deliverable exists in `artifacts/`, its provenance is in the journal, and the human knows where to
find it.
