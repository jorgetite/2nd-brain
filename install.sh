#!/bin/sh
# install.sh — install a 2nd-brain assistant from the framework source (src/, this script's
# sibling) into <target>. Mechanical install only: no personalization — run `brain-init` on the new
# instance afterward. <target> may be any relative or absolute path; missing parent directories
# are created. The install refuses to overwrite a non-empty target.
set -eu

target="${1:-}"

# --- validate target ---------------------------------------------------------
if [ -z "$target" ]; then
  echo "usage: sh install.sh <target-path>" >&2
  exit 2
fi

# --- framework source (this script's sibling src/) ---------------------------
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC="$SCRIPT_DIR/src"
if [ ! -f "$SRC/AGENTS.md" ]; then
  echo "error: framework source not found at $SRC (install.sh must sit beside src/)" >&2
  exit 1
fi

# --- refuse to overwrite a non-empty target ----------------------------------
if [ -e "$target" ] && [ -n "$(ls -A -- "$target" 2>/dev/null)" ]; then
  echo "error: $target already exists and is not empty" >&2
  exit 1
fi

# --- install -----------------------------------------------------------------
mkdir -p \
  "$target/memory" \
  "$target/skills" \
  "$target/sources/inbox" \
  "$target/sources/library" \
  "$target/sources/archive" \
  "$target/bundles" \
  "$target/artifacts"

# pristine source: AGENTS.md, blank memory contracts, and the skills — all from src/
cp "$SRC/AGENTS.md" "$target/AGENTS.md"
cp "$SRC/memory/core.md" "$SRC/memory/procedural.md" "$SRC/memory/state.md" "$SRC/memory/journal.md" \
  "$target/memory/"
cp -R "$SRC/skills/." "$target/skills/"

# bundles/ starts with an empty catalog; `skills/bundle-create` adds a bundle
cat > "$target/bundles/index.md" <<'CATALOG'
# Bundles

Catalog of this assistant's OKF knowledge bundles. `skills/bundle-query` and `bundle-ingest` read it
to find the right bundle; `skills/bundle-create` and `bundle-import` add a row, `bundle-remove`
deletes one.

_(no bundles yet)_
CATALOG

# Claude harnesses only (inert elsewhere): turn off Claude's auto memory so memory/ stays the
# assistant's single store
mkdir -p "$target/.claude"
cat > "$target/.claude/settings.json" <<'SETTINGS'
{
  "autoMemoryEnabled": false
}
SETTINGS

# deliverables are disposable and may hold private data or large binaries: keep them out of history
printf '/artifacts/\n' > "$target/.gitignore"

# version the instance so the assistant's self-edits (memory/, skills/) can be rolled back
if command -v git >/dev/null 2>&1; then
  git -C "$target" init -q
  git -C "$target" add -A
  git -C "$target" -c user.name="2nd-brain install" -c user.email="install@localhost" \
    commit -q -m "Install assistant from 2nd-brain src/"
  echo "Initialized a git repository in $target."
else
  echo "git not found; skipping version control for $target."
fi

echo "Installed assistant at: $target  (from $SRC)"
echo "Next: run 'brain-init' scoped to $target to personalize it."
