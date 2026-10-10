---
name: artifact-export
description: Produce a deliverable for the human to take away or share — a report, summary, checklist, plan, slide deck, document, or a copy of a source — and write it to artifacts/. Use when the human wants an output file rather than knowledge filed into a bundle.
---

# Export

Produce a deliverable the human takes away. Exports land in `artifacts/` and are deliverables, not
knowledge — don't file them into a bundle; if the synthesis behind one is durable, file that
separately via `skills/bundle-query`.

**Shape it.** When the request leaves format or audience open, choose what suits the purpose and say
what you chose rather than asking; ask only when the answer would change the deliverable substantially
(a report for a doctor versus one for the human's own records). Apply the human's *Preferences* —
units, language, style.

**Fill it** from the bundles, `sources/`, and memory under the support rules of `skills/bundle-query`:
the human's own facts only from what is recorded, general knowledge marked as such, anything that
changes over time looked up and cited. Embed citations when the human asks for them.

**Render it.** Markdown and HTML need no tooling; for `.docx`, `.pptx`, `.xlsx`, or `.pdf`, use what the
harness provides, and if nothing is available produce Markdown or HTML and say so. When the harness can
open or render the result, check it as the human will see it — layout, tables, charts — and fix what's
off. Copying a source means copying the file out of `sources/` unchanged. Name the file in kebab-case,
date-prefixed when useful (`2026-07-23-q3-summary.md`).

**Mind what leaves.** An export is how private data leaves the assistant. Never include a secret; when
the deliverable is meant to be shared, point out any health, financial, or other personal details it
contains. Delivery beyond `artifacts/` (email, chat, upload) is outward-facing — confirm first.

Journal what the export was derived from — the bundles, concepts, or sources.

## Done when

The deliverable is in `artifacts/`, checked as rendered where the harness allows, and free of secrets;
the journal records what it came from; and the human knows where it is and what personal data it
contains.
