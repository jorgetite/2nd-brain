#!/bin/sh
# scaffold.sh — create a new assistant under this assistant's assistants/.
# Mechanical scaffolding only: no personalization. Run `init` on the child afterward.
set -eu

name="${1:-}"

# --- validate name -----------------------------------------------------------
if [ -z "$name" ]; then
  echo "usage: sh scaffold.sh <name>   (kebab-case)" >&2
  exit 2
fi
case "$name" in
  */* | *..*)
    echo "error: name must not contain '/' or '..'" >&2
    exit 2
    ;;
esac
if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$'; then
  echo "error: '$name' is not kebab-case (^[a-z0-9]([a-z0-9-]*[a-z0-9])?\$)" >&2
  exit 2
fi

# --- resolve paths -----------------------------------------------------------
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ASSISTANT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../../../.." && pwd)  # scripts -> create -> assistants -> skills -> root
ASSETS=$(CDPATH= cd -- "$SCRIPT_DIR/../assets" && pwd)            # create/assets/
CHILD="$ASSISTANT_ROOT/assistants/$name"

# --- refuse to clobber -------------------------------------------------------
if [ -e "$CHILD" ]; then
  echo "error: $CHILD already exists" >&2
  exit 1
fi

# --- scaffold ----------------------------------------------------------------
mkdir -p \
  "$CHILD/memory" \
  "$CHILD/skills" \
  "$CHILD/sources/inbox" \
  "$CHILD/sources/library" \
  "$CHILD/sources/archive" \
  "$CHILD/templates" \
  "$CHILD/wiki" \
  "$CHILD/assistants"

# memory: blank contracts from this skill's assets/
cp "$ASSETS/core.md" "$ASSETS/procedural.md" "$ASSETS/state.md" "$ASSETS/journal.md" \
  "$CHILD/memory/"

# skills: inherit the parent's current skills (incl. create/ and its assets/)
cp -R "$ASSISTANT_ROOT/skills/." "$CHILD/skills/"

# bootstrap entrypoint copied from the parent
cp "$ASSISTANT_ROOT/AGENTS.md" "$CHILD/AGENTS.md"

# wiki starts with only an empty index.md; templates/ starts empty
: > "$CHILD/wiki/index.md"

# assistants/ starts with an empty child roster
cat > "$CHILD/assistants/index.md" <<'ROSTER'
# Assistants

Roster of this assistant's direct children. `skills/core/delegate` reads it to route a request;
`skills/assistants/create` adds a row, `skills/assistants/remove` deletes one.

| Assistant | Domain | Notes |
|---|---|---|
ROSTER

echo "Created new assistant at: $CHILD"
echo "Next: run 'init' scoped to assistants/$name to personalize it."
