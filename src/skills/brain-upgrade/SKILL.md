---
name: brain-upgrade
description: Bring this assistant up to a newer version of the 2nd-brain framework without losing what it has learned — merge the framework's changes into its skills and memory, resolve conflicts with its own edits, and fill in anything new. Use when the human wants to upgrade or update the assistant from the framework source, or after install.sh --upgrade reports conflicts.
---

# Brain upgrade

This assistant keeps an untouched copy of the framework it was installed from in `.framework/`. An
upgrade compares each framework file three ways — that copy (the *base*), the live file (*ours*), and
the new framework (*theirs*, staged in `.framework.new/`) — so the framework's changes land on top of
what the assistant has learned instead of replacing it. Bundles and sources are never part of a
framework snapshot, so an upgrade can't touch them.

## Steps

1. **Stage.** Run `sh <framework repo>/install.sh --upgrade <this assistant's root>`, asking the human
   where the framework repo is if you don't know. It takes every file only the framework changed,
   keeps every file only this assistant changed, and reports one of three things: nothing new, a clean
   upgrade (with the files it updated), or the files both sides changed. If the human already ran it,
   start from its report; if `.framework.new/` already exists, an earlier upgrade is unfinished — go
   to step 2.
2. **Merge each file both sides changed.** Compare `diff .framework/<f> <f>` (this assistant's edits)
   with `diff .framework/<f> .framework.new/<f>` (the framework's), and write the merged result to
   `<f>`:
   - **Memory content is the human's** — identity and preferences in `core.md`, `state.md`,
     `journal.md`, and the bundle catalog. Keep ours, taking only the framework's changes to the
     headings and format text around it.
   - **Skills and `procedural.md`** — keep both intents: the framework's new structure and rules,
     and this assistant's learned edits. Where they genuinely contradict, show the human both with a
     proposal.
   - **A file the framework deleted that this assistant changed** — ask the human.

   Once every file is merged, make the new framework the base for next time:
   `rm -rf .framework && mv .framework.new .framework`.
3. **Catch up.** Review what the framework changed — the files the script updated and the ones you
   merged. If `core.md` gained `{{placeholders}}`, run `skills/brain-init` for just those. If a change
   alters a format that existing bundles or memory already use, tell the human what would need
   converting — upgrades don't convert data on their own.
4. **Verify.** Re-read `core.md` and `procedural.md`; your in-context copies are stale. Run the
   mechanical checks in `skills/bundle-lint`. Journal the upgrade — the framework revision and the
   files merged.

## Done when

Every file both sides changed is merged and `.framework.new/` is gone; the assistant's learned edits
survive alongside the framework's changes; new placeholders are filled; the human knows of any format
change their data needs; and the upgrade is journaled.
