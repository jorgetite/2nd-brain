---
name: create
description: Create a new OKF knowledge bundle under bundles/ — its index.md, log.md, and per-type concept templates — then register it in the bundles catalog. Use to stand up a knowledge base for a fresh domain.
---

# Create

Stand up a new [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
bundle: a directory tree of markdown concepts. This skill sets up the empty, conformant shell;
`skills/bundles/ingest` fills it with concepts as sources arrive.

Creating a bundle is **human-initiated** — confirm the domain with the human before adding one.

## Steps

1. **Name the bundle.** Pick a kebab-case `<name>` and a one-line description of the domain it owns.
2. **Decide the concept types** this domain needs — the key kinds of thing it will track (e.g. a
   recipes bundle: `recipe`, `ingredient`; a contacts bundle: `person`, `company`). For each, ask
   whether it has a required page format or rules (extra sections, a structured record, field
   conventions) — those become the template's shape and its `# Authoring` section. Ask; do not
   invent — *Truth over invention*.
3. **Create the bundle directory** `bundles/<name>/` with:
   - **`index.md`** — the OKF listing. Give it frontmatter declaring the format version, then a row
     per type folder (step 2's types) — the root index is a table of contents **by type**, not a flat
     list of concepts:

     ```markdown
     ---
     okf_version: "0.1"
     title: <name>
     description: <one-line domain description>
     ---

     # <name>

     * [<type>](/<type>/) - <what this type holds>
     ```
   - **`log.md`** — the OKF change history (newest-first, ISO dates):

     ```markdown
     # <name> — Update Log

     ## YYYY-MM-DD
     * **Initialization**: Created the bundle.
     ```
   - **`<type>/index.md`** — one folder per concept type from step 2, each with its own OKF listing.
     Concepts of that type live here (see `skills/bundles/ingest`), so the bundle's layout mirrors its
     `templates/` one-to-one. Start each empty:

     ```markdown
     ---
     title: <type>
     description: <what this type holds>
     ---

     # <type>

     _(no concepts yet)_
     ```
   - **`templates/<type>.md`** — one skeleton per concept type from step 2. A template is the
     **binding format** for its type: its frontmatter keys and its heading set and order are what a
     concept of that type looks like, with each `{{placeholder}}` filled at ingest. A trailing
     `# Authoring` section carries the type's rules — obeyed when filling, then deleted, so it never
     appears in a concept page.

     ```markdown
     ---
     type: <type>
     title: {{title}}
     description: {{description}}
     resource: {{resource-uri-or-omit}}
     tags: []
     timestamp: {{YYYY-MM-DD}}
     ---

     {{summary}}

     # Schema
     {{structured description — omit the section if not applicable}}

     # Examples
     {{examples — omit if not applicable}}

     # Citations
     {{[1] [Source](path) — filled at ingest}}

     # Authoring
     _Rules for filling this template. Not part of a concept page — delete this section when filling._
     {{per-type rules, or omit the section if the skeleton alone is enough}}
     ```

     Shape each template to its type: add, rename, or drop sections and frontmatter fields to match
     what step 2 established. The block above is the starting point, not a ceiling.
4. **Register the bundle.** Add a row to `bundles/index.md` so `query` and `ingest` can find it:
   `* [<name>](<name>/) - <description>`. Make the description convey the bundle's **scope** — the
   kinds of thing it covers (its concept types / key topics) — not just a bare label, so a query can
   tell from the catalog alone whether this bundle is relevant. Remove the `_(no bundles yet)_`
   placeholder if present.
5. **Log it.** Append an entry to `memory/journal.md`.

## Done when

`bundles/<name>/` holds a conformant `index.md` (with `okf_version`), a `log.md` with an
Initialization entry, and at least one type — its `templates/<type>.md` paired with a `<type>/index.md`
the root index links to; and the bundle is listed in `bundles/index.md`.
