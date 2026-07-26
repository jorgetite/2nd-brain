# Bundles

The assistant's knowledge lives in one or more **bundles** under `bundles/`. A bundle is an
[Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
(OKF v0.1) directory tree — portable, human- and agent-friendly markdown that needs no special
tooling to read or write. Managing several bundles — one per domain — is how a single assistant
covers multiple areas.

## Shape of a bundle

```
bundles/
├── index.md                  # catalog of all bundles (progressive disclosure)
└── <name>/                   # one OKF-compliant bundle
    ├── index.md                  # OKF listing; declares okf_version: "0.1"
    ├── log.md                    # change history, newest-first, ISO dates
    ├── templates/<type>.md       # binding per-type page format (tooling, not concepts)
    ├── references/               # optional: cited source copies
    └── <concept>.md              # concepts, organized into subdirectories as needed
```

## OKF conventions

- **Concepts.** Every non-reserved `.md` is a *concept* and MUST carry a `type:` in its YAML
  frontmatter. Recommended fields: `title`, `description`, `resource`, `tags`, `timestamp` (ISO
  8601). Conventional body sections: `# Schema`, `# Examples`, `# Citations`.
- **Reserved files.** Only `index.md` (a markdown-list listing for progressive disclosure) and
  `log.md` (a newest-first change history under `## YYYY-MM-DD` headings) have defined meaning. OKF
  allows an `index.md` at **any directory level**, so a large bundle can group concepts into
  subdirectories — each with its own `index.md`, linked from its parent — to stay progressively
  disclosed.
- **Links.** Relate concepts with the absolute bundle-relative form `[title](/path/to/concept.md)` —
  the leading `/` is relative to the **bundle root**. Links stay within a bundle (bundles are
  self-contained); connect across bundles via the `bundles/index.md` catalog, not links. Broken links
  are tolerated — a link to a not-yet-written concept is a useful work marker.
- **Conformance is minimal.** A bundle is conformant if every concept has parseable frontmatter with
  a non-empty `type`. Unknown fields and broken links must be tolerated, never rejected.

## Templates — the per-type page format

OKF leaves `type` a free string with no schema attached. A bundle pins its own down in
`templates/<type>.md`, which `create` writes, `ingest` and `query` write concepts from, and `lint`
audits against. Two rules make it binding:

1. **The structure is the format.** A concept of type `X` carries the frontmatter keys and the heading
   set and order of `templates/X.md`, with each `{{placeholder}}` filled. Sections are dropped only
   where the template says they may be. A type with no template gets no new concepts — the assistant
   asks rather than inventing a format.
2. **`# Authoring` is stripped.** A trailing `# Authoring` section holds the type's rules — anything
   the skeleton alone can't express (field conventions, a required structured record, what to do with
   partial information). The assistant obeys it while filling and deletes it, so it never reaches a
   concept page. `{{ }}` marks a slot to fill; `# Authoring` states a rule.

This is the customization surface: to change how a type's pages look, edit its template. Templates
are tooling rather than knowledge, so they're exempt from the concept conformance rule above.

## The operations

| Skill | Does |
|---|---|
| `bundles/create` | stand up a new bundle — its `index.md`, `log.md`, and per-type `templates/` — and register it in `bundles/index.md` |
| `bundles/import` | adopt an existing OKF bundle authored elsewhere — place it under `bundles/`, verify conformance, and register it |
| `bundles/remove` | retire a bundle — confirm, optionally preserve a copy, delete it, and deregister it (destructive, human-initiated) |
| `bundles/ingest` | absorb a source from `sources/inbox/` into the right bundle as concepts written from its `templates/`; update its `index.md` and `log.md`; relocate the source to `library/` |
| `bundles/query` | answer from the bundles and file valuable syntheses back as concepts |
| `bundles/lint` | audit a bundle for OKF conformance, index/log drift, broken links, orphans, contradictions, and stale claims |

Creating or removing a bundle is **human-initiated** — the assistant confirms the domain before adding
one, and confirms (and offers to preserve a copy) before the destructive `remove`. The
`bundles/index.md` catalog is loaded at bootstrap so the assistant knows which bundles it owns.

See also: [concepts](concepts.md), [memory model](memory.md).
