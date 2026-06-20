# Wiki Schema

Defines the structure and conventions of this assistant's wiki — the durable, user-facing
knowledge base curated from `sources/`. (This is Karpathy's "Schema" layer.) The wiki skills
(`skills/wiki/*`) read this file to decide how to file and organize knowledge.

## Layout

- Pages are markdown files under `wiki/`, kebab-case names, optionally grouped into category
  subdirectories (e.g. `wiki/people/ada-lovelace.md`).
- `index.md` is the catalog of all pages, grouped by category. Keep it in sync on every edit.
- `templates/` (at the assistant root) holds page skeletons; new pages start from the matching
  template.

## Page types

- **Entity** — a person, place, project, or thing. Template: `templates/entity.md`.
- **Topic** — a synthesized summary of a subject across sources. Template: `templates/topic.md`.
- **Note** — a filed query result or standalone fact that doesn't yet warrant its own
  entity/topic. Template: `templates/note.md`.

## Conventions

- Cross-link related pages with `[[page-name]]`. A link to a page that doesn't exist yet marks
  one worth creating.
- Every claim traces to a raw source in `sources/library/`.
- The wiki is edited only through `skills/wiki/*` (ingest / query / lint), never freeform.
- Durable knowledge for the user lives here; transient operational state belongs in
  `memory/state.md`.
