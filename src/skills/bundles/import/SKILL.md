---
name: import
description: Add an existing, populated OKF-compliant bundle to this assistant — place it under bundles/, verify OKF conformance, and register it in the catalog. Use to adopt a bundle authored elsewhere (a shared repo, tarball, or subdirectory).
---

# Import

Adopt an existing OKF bundle authored elsewhere. Unlike `skills/bundles/create` (which generates a
fresh, empty bundle), import brings in **already-populated** content and neither invents nor rewrites
it — the bundle's concepts, `index.md`, `log.md`, and `templates/` were authored elsewhere and are
treated here as immutable.

## Steps

1. **Locate the source bundle** — a path to an existing OKF bundle directory already on disk (cloned,
   unpacked, or otherwise present). Confirm a kebab-case `<name>` for it under `bundles/`.
2. **Place it** at `bundles/<name>/` if it isn't already there — copy the directory in as-is. Do not
   edit its contents; it is authored elsewhere.
3. **Verify OKF conformance** — run the conformance checks from `skills/bundles/lint`: every
   non-reserved `.md` carries a non-empty `type:`; `index.md` and `log.md` are present and valid; the
   bundle-root `index.md` declares `okf_version`. If it fails, report the problems and **stop** —
   don't silently rewrite a bundle you didn't author; fixing is the human's call or a follow-up
   `lint`. Only a passing bundle proceeds.
4. **Register** the bundle — add a row to `bundles/index.md`, drawing the description from the
   bundle's own `index.md`: `* [<name>](<name>/) - <description>`. Make the description convey the
   bundle's **scope** (its concept types / key topics), not just a bare label, so a query can tell from
   the catalog alone whether this bundle is relevant. Remove the `_(no bundles yet)_` placeholder if
   present.
5. **Log it.** Append an entry to `memory/journal.md` naming the bundle and where it came from. Leave
   the bundle's own `log.md` untouched — it is the bundle's authored history, not the assistant's.

## Done when

The bundle lives under `bundles/<name>/`, passed OKF conformance, and is listed in `bundles/index.md`.
