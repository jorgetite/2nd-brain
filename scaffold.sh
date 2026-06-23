#!/bin/sh
# scaffold.sh — the project build tool. Instantiate a new assistant from the framework source
# (src/, this script's sibling) at <target>. Mechanical scaffolding only: no personalization —
# run `init` on the new instance afterward. Used for both the root build (target = assistant) and
# creating a child (target = <instance>/assistants/<name>). The new instance is always pristine.
# The target must live inside the project; a root-level instance is auto-added to .gitignore.
set -eu

target="${1:-}"

# --- validate target ---------------------------------------------------------
if [ -z "$target" ]; then
  echo "usage: sh scaffold.sh <target-path>   (basename must be kebab-case)" >&2
  exit 2
fi
case "$target" in
  *..*)
    echo "error: target must not contain '..'" >&2
    exit 2
    ;;
esac
base=$(basename -- "$target")
if ! printf '%s' "$base" | grep -Eq '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$'; then
  echo "error: '$base' is not kebab-case (^[a-z0-9]([a-z0-9-]*[a-z0-9])?\$)" >&2
  exit 2
fi

# --- project root (this script's dir) and framework source --------------------
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC="$SCRIPT_DIR/src"
if [ ! -f "$SRC/AGENTS.md" ]; then
  echo "error: framework source not found at $SRC (run scaffold.sh from the project root)" >&2
  exit 1
fi

# --- resolve target and confine it to the project -----------------------------
parent=$(dirname -- "$target")
if [ ! -d "$parent" ]; then
  echo "error: parent directory '$parent' does not exist" >&2
  exit 1
fi
parent_abs=$(CDPATH= cd -- "$parent" && pwd)
case "$parent_abs" in
  "$SCRIPT_DIR" | "$SCRIPT_DIR"/*) : ;;   # inside the project — ok
  *)
    echo "error: target must be inside the project ($SCRIPT_DIR)" >&2
    exit 1
    ;;
esac
target="$parent_abs/$base"   # normalized absolute path, under the project root

# --- refuse to clobber -------------------------------------------------------
if [ -e "$target" ]; then
  echo "error: $target already exists" >&2
  exit 1
fi

# --- scaffold ----------------------------------------------------------------
mkdir -p \
  "$target/memory" \
  "$target/skills" \
  "$target/sources/inbox" \
  "$target/sources/library" \
  "$target/sources/archive" \
  "$target/templates" \
  "$target/wiki" \
  "$target/assistants"

# pristine source: AGENTS.md, blank memory contracts, and the skills — all from src/
cp "$SRC/AGENTS.md" "$target/AGENTS.md"
cp "$SRC/memory/core.md" "$SRC/memory/procedural.md" "$SRC/memory/state.md" "$SRC/memory/journal.md" \
  "$target/memory/"
cp -R "$SRC/skills/." "$target/skills/"

# wiki starts with only an empty index.md; templates/ starts empty
: > "$target/wiki/index.md"

# assistants/ starts with an empty child roster
cat > "$target/assistants/index.md" <<'ROSTER'
# Assistants

Roster of this assistant's direct children. `skills/core/delegate` reads it to route a request;
`skills/assistants/create` adds a row, `skills/assistants/remove` deletes one.

| Assistant | Domain | Notes |
|---|---|---|
ROSTER

# --- a root-level instance (built directly under the project root) is gitignored
if [ "$parent_abs" = "$SCRIPT_DIR" ]; then
  entry="/$base/"
  gitignore="$SCRIPT_DIR/.gitignore"
  if [ ! -f "$gitignore" ] || ! grep -qxF "$entry" "$gitignore"; then
    printf '%s\n' "$entry" >> "$gitignore"
    echo "Added $entry to .gitignore"
  fi
fi

echo "Built new assistant at: $target  (from $SRC)"
echo "Next: run 'init' scoped to $target to personalize it."
