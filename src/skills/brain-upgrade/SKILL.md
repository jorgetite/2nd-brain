---
name: brain-upgrade
description: Bring this assistant up to a newer version of the 2nd-brain framework without losing what it has learned — merge the framework's changes into its skills and memory, resolve conflicts with its own edits, and fill in anything new. Use when the human wants to upgrade or update the assistant from the framework source, or after install.sh --upgrade reports conflicts.
---

# Brain upgrade

This assistant is a git repository whose `framework` branch holds the pristine framework it was
installed from. An upgrade commits a new pristine snapshot there and merges it into the assistant's
own branch, so the framework's changes land on top of what the assistant has learned instead of
replacing it. Bundles and sources are never part of a framework snapshot, so an upgrade can't touch
them.

## Steps

1. **Merge.** Run `sh <framework repo>/install.sh --upgrade <this assistant's root>`, asking the human
   where the framework repo is if you don't know. It refuses while tracked files have uncommitted
   changes, so commit first. It reports either a clean merge, nothing new, or the conflicted files.
   If the human already ran it, start from its report.
2. **Resolve conflicts**, file by file. In each, the base is the previous framework version, *ours* is
   this assistant, and *theirs* is the new framework:
   - **Memory content is the human's** — identity and preferences in `core.md`, `state.md`,
     `journal.md`, and the bundle catalog. Keep ours, taking only the framework's changes to the
     headings and format text around it.
   - **Skills and `procedural.md`** — keep both intents: the framework's new structure and rules,
     and this assistant's learned edits. Where they genuinely contradict, show the human both with a
     proposal.
   - **A file the framework deleted that this assistant changed** — ask the human.

   Commit the merge once no file holds a conflict marker.
3. **Catch up.** Review what the framework changed (`git diff framework~1 framework`). If `core.md`
   gained `{{placeholders}}`, run `skills/brain-init` for just those. If a change alters a format that
   existing bundles or memory already use, tell the human what would need converting — upgrades don't
   convert data on their own.
4. **Verify.** Re-read `core.md` and `procedural.md`; your in-context copies are stale. Run the
   mechanical checks in `skills/bundle-lint`. Journal the upgrade — the framework revision and the
   conflicts resolved — and commit.

## Done when

The merge is committed with no conflict markers left anywhere; the assistant's learned edits survive
alongside the framework's changes; new placeholders are filled; the human knows of any format change
their data needs; and the upgrade is journaled.
