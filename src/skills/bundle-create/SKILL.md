---
name: bundle-create
description: Create a new OKF knowledge bundle for an area of the human's life or work — or add a concept type to an existing bundle — with its index, log, per-type templates, and a catalog row stating its scope and boundaries. Use when the human wants to start tracking a new domain, or a new kind of thing within one.
---

# Bundle create

Stand up an empty, conformant [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
bundle, or extend one with a new concept type; `skills/bundle-ingest` fills it with concepts later.
Creating a bundle is human-initiated, so confirm before adding one — a plan the human already
approved (for example in `skills/brain-init`) is that confirmation: build from it without re-asking
what it settled.

## Design

Settle these with the human by proposing a draft for them to correct, not by asking open questions:

- **Name and scope** — a kebab-case name and one line on what the bundle covers.
- **Boundaries** — read `bundles/index.md` and, for each bundle whose scope overlaps, agree which
  material goes where. Bundles never link to each other, so if the new domain would constantly
  reference an existing one, propose extending that bundle instead.
- **Concept types** — the kinds of thing it tracks, each with a draft template: the frontmatter fields
  and content headings that suit it (a `camera`: mount, sensor, serial, firmware, purchase; a
  `maintenance-task`: interval, last done, procedure) and any rules for its `# Authoring` section —
  including how long its facts stay current (firmware or prices: months; a finished build: never),
  which sets each concept's `stale_after`. Proposing a format is design, not invention — facts about
  the human's things still come only from sources or the human. A type name becomes a folder, so
  `index`, `log`, `templates`, and `references` are unavailable. For a running record (workouts, measurements, maintenance history), prefer one
  concept per period or plan over one per entry, so the folder stays browsable.

## Build

Write the files in one batch — none depends on another — from the skeletons in `assets/`:

- `bundles/<name>/index.md` from `assets/bundle-index.md` — its only frontmatter is `okf_version`, and
  it lists one row per type folder with what the type holds (a table of contents by type, not by
  concept);
- `bundles/<name>/log.md` from `assets/bundle-log.md`, with an Initialization entry dated today;
- per type, `<type>/index.md` from `assets/type-index.md` (OKF index files carry no frontmatter) and
  `templates/<type>.md` from `assets/concept-template.md`, shaped to the agreed design. The skeleton is a starting point, not a
  ceiling; the finished template is binding for its type (Concept templates convention,
  `memory/procedural.md`).

Register the bundle with a row in `bundles/index.md`:
`* [<name>](<name>/) - <scope>. Not here: <material> → <other bundle>`. Name its concept types or key
topics so a query can judge relevance from the catalog alone; omit *Not here* when nothing overlaps;
add the reciprocal clause to the other bundle's row; remove `_(no bundles yet)_` if present. Log the
creation in `memory/journal.md`.

## Adding a type to an existing bundle

When the human or `skills/bundle-ingest` needs a new type, agree its template as above, then add
`templates/<type>.md` and `<type>/index.md`, a row in the bundle's root `index.md`, an **Update** entry
in its `log.md`, and widen the bundle's catalog scope if the type extends it. An imported bundle keeps
its own layout — follow it.

## Done when

The bundle (or new type) has a conformant root `index.md` declaring `okf_version`, a `log.md` entry,
and for every type a `templates/<type>.md` paired with a `<type>/index.md` that the root index links
to — no type named `index`, `log`, `templates`, or `references`; and `bundles/index.md` lists the
bundle with its scope and reciprocal boundaries.
