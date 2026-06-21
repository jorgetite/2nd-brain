---
name: create
description: Create a new assistant under assistants/ — blank memory from this skill's assets and skills inherited from the parent — then personalize it via init. Use to spin up a specialized assistant for a sub-domain.
compatibility: scripts/scaffold.sh needs a POSIX shell (sh) and standard coreutils (cp, mkdir, grep); use the markdown fallback where those aren't available.
---

# Create

Add a new assistant to the tree. The new assistant is identical in shape and self-contained — it
must run standalone and as a child. This skill does the **mechanical scaffolding**; `init` does the **personalization**.

Creating an assistant is **human-initiated** — run this at the human's request. An assistant never
spins up a child on its own to handle a request; if no child fits, it handles the request itself.

## Steps

1. **Scaffold.** Run this skill's `scripts/scaffold.sh` (from the assistant root):

   ```sh
   sh skills/assistants/create/scripts/scaffold.sh <name>
   ```

   `<name>` is kebab-case. The script creates `assistants/<name>/` as a complete new assistant —
   blank memory from this skill's `assets/`; `skills/` and `AGENTS.md` copied from this
   assistant; an empty `templates/`; a `wiki/` holding only an empty `index.md`; empty sources and
   `assistants/`. It validates the name and refuses to overwrite an existing assistant.

2. **Personalize.** Run `skills/core/init` scoped to `assistants/<name>/` to set the new assistant's identity, domain, and purpose.

3. **Register.** Add a row to this assistant's `assistants/index.md` roster so `delegate` can route to the new child: `| <name> | <domain> | <one-line purpose> |`.

4. **Log it.** Append an entry to `memory/journal.md`.

## Fallback (no shell available)

If the harness can't run scripts, build `assistants/<name>/` by hand for the same result:

- `memory/` — copy the four files from this skill's `assets/` (blank contracts).
- `skills/` — copy this assistant's `skills/` as-is (the new assistant inherits current capabilities).
- `AGENTS.md` — copy from this assistant.
- `wiki/index.md` — create empty; leave `templates/` empty.
- `sources/{inbox,library,archive}/` and `assistants/` — create empty.

Then continue with steps 2–4.

## Done when

`assistants/<name>/` is a complete, personalized assistant that bootstraps on its own, is listed in
`assistants/index.md`, and `delegate` can route to it.
