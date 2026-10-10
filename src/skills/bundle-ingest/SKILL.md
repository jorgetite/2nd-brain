---
name: bundle-ingest
description: Absorb new material into the right bundle(s) — files from sources/inbox (notes, documents, PDFs, photos, receipts, manuals) or a fact handed off by memory-remember or memory-reflect — as template-conformant, cross-linked concepts, mirroring time-sensitive facts into state and filing the source in library/. Use when the human adds something to the inbox, shares material to keep, or asks to process the inbox.
---

# Bundle ingest

Turn raw material into durable, interlinked OKF concepts. Knowledge compounds: integrate into
existing concepts rather than adding duplicates. With no specific source named, process everything
in `sources/inbox/`.

## Steps

Order matters: citations point at a source's final path, and nothing leaves the inbox until its
knowledge is filed.

1. **Read the source** without editing it (*Sources are immutable*). Read documents, PDFs, and images
   directly; for dense or scanned pages, crop or zoom when the harness allows, and mark what you
   can't read rather than guessing. From a long source such as a manual, extract what's durable for
   the human, not a transcript. If the same source is already in `sources/library/` (same name or
   content), treat this as an update of it. A hand-off with no file — a fact from
   `skills/memory-remember` or a learning from `skills/memory-reflect` — is cited by its own source
   form (Source-citations convention, `memory/procedural.md`) and skips steps 2 and 8.
2. **Name its library home** now — kebab-case, date-prefixed when useful, unique in
   `sources/library/`. Every concept will cite it as `library:<file>`.
3. **Route.** Choose the owning bundle from `bundles/index.md`, honouring each row's *Not here*
   boundaries. A source spanning domains (a receipt for a camera and a router) gives each bundle its
   own slice, all citing the same library path. Material that fits two bundles equally, or none,
   is set aside as a question (step 9).
4. **Find what exists.** In each target bundle, read the relevant type indexes and search for the
   names, models, or serials the material mentions — batching reads that don't depend on each
   other — so you update existing concepts instead of duplicating them. Material that needs a type
   the bundle lacks is set aside as a question too.
5. **File the knowledge.**
   - New concept → fill `templates/<type>.md`. The template is **binding**: keep its frontmatter keys
     and heading set and order (drop a section only where it says so), replace every
     `{{placeholder}}`, obey the `# Authoring` rules and then delete that section. Save it as
     `<type>/<name>.md` in kebab-case. (An imported bundle keeps its authored layout and OKF version;
     follow them.)
   - Existing concept → integrate in place and bring the page up to its template if the template has
     gained sections. When the new material contradicts the page, keep the newer fact, note the old
     value with its date where history matters (a firmware version, a weight), and flag it if it's
     unclear which is right. Something the human no longer has or uses (a sold camera, a retired
     host) becomes `status: deprecated` rather than being deleted, so its links and history survive.
   - Record provenance in frontmatter: add the source to `sources` (the step 2 file as
     `library:<file>`) and end each claim it supports with that entry's footnote (`[^id]`). Set
     `generated` to this assistant and the current time; set `stale_after` from the type's horizon;
     add `verified` by `human:<id>` only for content the human stated or confirmed.
   - Cross-link within the bundle with `[title](/path/to/concept.md)`.
   - Never copy a secret into a concept — passwords, keys, tokens, full card or account numbers.
     Record where it lives instead (*Discretion*); the source keeps the original.
6. **Update the index and log** — each new or renamed concept in its `<type>/index.md` (the root
   `index.md` changes only for a new type folder), and a `* **Creation**`/`* **Update**` bullet under
   today's `## YYYY-MM-DD` heading in the bundle's `log.md`, newest first.
7. **Mirror time-sensitive facts** — deadlines, appointments, renewals, recurring maintenance (with its
   `Repeats` interval), active-task status — into `memory/state.md`, tagged with the bundle. The
   durable facts stay in the bundle.
8. **Relocate** the source from `sources/inbox/` to its step 2 path once all of its material is filed;
   a source with material still waiting on a question stays in the inbox. If a concept needs a local
   copy of the source, place it under the bundle's `references/`.
9. **Ask, then report.** Put every set-aside question to the human in one message, each with a
   proposal — the bundle you'd choose, or a draft template via *Adding a type to an existing bundle*
   in `skills/bundle-create`. Journal one line per source: the source, the bundles, the concepts
   touched.

## Many sources

When the inbox holds several sources and the harness supports sub-agents, route everything yourself
first (steps 1–3), then hand each bundle's share to one sub-agent — one per bundle, so no two agents
edit the same concepts. Before relocating any source, check the sub-agents' concepts against their
templates with a fresh-context review; finish state, relocation, questions, and the journal yourself.

## Done when

Every source is either in `sources/library/` with its knowledge filed as conformant concepts (no
`{{placeholder}}` or `# Authoring` left, no secret copied), or still in the inbox with its open
question put to the human; each touched bundle's indexes and `log.md` are in sync; time-sensitive
facts are in `state.md`; and the human has a per-source summary of what was filed where.
