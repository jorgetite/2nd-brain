---
name: create
description: Create a new child assistant under assistants/ — a pristine instance built from the framework source (src/) — then personalize it via init. Use to spin up a specialized assistant for a sub-domain.
compatibility: the project build script scaffold.sh needs a POSIX shell (sh) and standard coreutils (cp, mkdir, grep); use the markdown fallback where those aren't available.
---

# Create

Add a new assistant to the tree. The new assistant is identical in shape and self-contained — it must
run standalone and as a child. This skill does the **mechanical scaffolding** from the framework
source; `init` does the **personalization**.

Creating an assistant is **human-initiated** — run this at the human's request. An assistant never
spins up a child on its own to handle a request; if no child fits, it handles the request itself.

## Steps

1. **Scaffold from source.** From this assistant's root, run the project build script `scaffold.sh`
   — at the repo root, the directory that contains `src/` — targeting `assistants/<name>`:

   ```sh
   sh <repo-root>/scaffold.sh assistants/<name>
   ```

   `<name>` is kebab-case. The script builds `assistants/<name>/` as a complete, **pristine** assistant
   from `src/` — `AGENTS.md`, blank memory contracts, and the skills; an empty `templates/`; a `wiki/`
   with only an empty `index.md`; empty sources and `assistants/`. It validates the name and refuses to
   overwrite.

2. **Personalize.** Run `skills/core/init` scoped to `assistants/<name>/` to set the new assistant's
   identity, domain, and purpose.

3. **Register.** Add a row to this assistant's `assistants/index.md` roster so `delegate` can route to
   the new child: `| <name> | <domain> | <one-line purpose> |`.

4. **Log it.** Append an entry to `memory/journal.md`.

## Fallback (no shell available)

If the harness can't run scripts, build `assistants/<name>/` by hand from the framework source (`src/`
at the repo root) for the same result:

- `AGENTS.md` and `memory/` (the four contracts) — copy from `src/`.
- `skills/` — copy `src/skills/` as-is.
- `wiki/index.md` — create empty; leave `templates/` empty.
- `sources/{inbox,library,archive}/` and `assistants/` — create empty.

Then continue with steps 2–4.

## Done when

`assistants/<name>/` is a complete, personalized assistant that bootstraps on its own, is listed in
`assistants/index.md`, and `delegate` can route to it.
