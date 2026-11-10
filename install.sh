#!/bin/sh
# install.sh — install a 2nd-brain assistant from the framework source (src/, this script's
# sibling) into <target>, or upgrade an existing one.
#
#   sh install.sh <target>            install into a new or empty <target>
#   sh install.sh --upgrade <target>  merge this framework version into an installed assistant
#
# Install is mechanical only: no personalization — run `brain-init` on the new instance afterward.
# <target> may be any relative or absolute path; missing parent directories are created.
#
# An installed assistant needs no git: it keeps a pristine copy of the framework it was installed
# from in `.framework/`. Upgrade writes the new framework to `.framework.new/` and compares each
# file three ways (old framework, new framework, live file): files only the framework changed are
# updated, files only the assistant changed are kept, and files both changed are left for the
# `brain-upgrade` skill to merge.
set -eu

usage() {
  echo "usage: sh install.sh <target>  |  sh install.sh --upgrade <target>" >&2
  exit 2
}

mode=install
if [ "${1:-}" = "--upgrade" ]; then
  mode=upgrade
  shift
fi
target="${1:-}"
[ -n "$target" ] || usage

# --- framework source (this script's sibling src/) ---------------------------
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC="$SCRIPT_DIR/src"
if [ ! -f "$SRC/AGENTS.md" ]; then
  echo "error: framework source not found at $SRC (install.sh must sit beside src/)" >&2
  exit 1
fi
src_rev=$(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)
if [ "$src_rev" != unknown ] && [ -n "$(git -C "$SCRIPT_DIR" status --porcelain -- src install.sh 2>/dev/null)" ]; then
  src_rev="$src_rev-dirty"
fi

# --- the framework snapshot: everything an install contains -----------------
write_snapshot() {
  dir=$1
  mkdir -p \
    "$dir/memory" \
    "$dir/skills" \
    "$dir/sources/inbox" \
    "$dir/sources/library" \
    "$dir/sources/archive" \
    "$dir/bundles" \
    "$dir/artifacts"

  # pristine source: AGENTS.md, blank memory contracts, and the skills — all from src/
  cp "$SRC/AGENTS.md" "$dir/AGENTS.md"
  cp "$SRC/memory/core.md" "$SRC/memory/procedural.md" "$SRC/memory/state.md" "$SRC/memory/journal.md" \
    "$dir/memory/"
  cp -R "$SRC/skills/." "$dir/skills/"

  # bundles/ starts with an empty catalog; `skills/bundle-create` adds a bundle
  cat > "$dir/bundles/index.md" <<'CATALOG'
# Bundles

Catalog of this assistant's OKF knowledge bundles. `skills/bundle-query` and `bundle-ingest` read it
to find the right bundle; `skills/bundle-create` and `bundle-import` add a row, `bundle-remove`
deletes one.

_(no bundles yet)_
CATALOG

  # Claude harnesses only (inert elsewhere): turn off Claude's auto memory so memory/ stays the
  # assistant's single store
  mkdir -p "$dir/.claude"
  cat > "$dir/.claude/settings.json" <<'SETTINGS'
{
  "autoMemoryEnabled": false
}
SETTINGS
}

# --- install -----------------------------------------------------------------
if [ "$mode" = install ]; then
  if [ -e "$target" ] && [ -n "$(ls -A -- "$target" 2>/dev/null)" ]; then
    echo "error: $target already exists and is not empty (to upgrade it: sh install.sh --upgrade $target)" >&2
    exit 1
  fi
  write_snapshot "$target"
  # the pristine copy later upgrades compare against
  write_snapshot "$target/.framework"

  echo "Installed assistant at: $target  (from $SRC, revision $src_rev)"
  echo "Next: run 'brain-init' scoped to $target to personalize it."
  exit 0
fi

# --- upgrade -----------------------------------------------------------------
if [ ! -d "$target/.framework" ]; then
  echo "error: $target has no .framework/ copy, so it cannot be upgraded in place" >&2
  echo "  (an assistant installed as a git repository can create one once:" >&2
  echo "   mkdir $target/.framework && git -C $target archive framework | tar -x -C $target/.framework)" >&2
  exit 1
fi
target=$(CDPATH= cd -- "$target" && pwd)
base="$target/.framework"
new="$target/.framework.new"
if [ -e "$new" ]; then
  echo "error: $target has an upgrade in progress; finish it with 'brain-upgrade' before upgrading again" >&2
  exit 1
fi
write_snapshot "$new"

# same A B: both files are missing, or both exist with identical content
same() {
  if [ -e "$1" ]; then [ -e "$2" ] && cmp -s "$1" "$2"; else [ ! -e "$2" ]; fi
}

changed=no
updated=""
conflicts=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  same "$base/$f" "$new/$f" && continue      # the framework left it alone
  changed=yes
  same "$target/$f" "$new/$f" && continue    # already matches the new framework
  if same "$target/$f" "$base/$f"; then      # the assistant left it alone: take the framework's
    if [ -e "$new/$f" ]; then
      mkdir -p "$(dirname -- "$target/$f")"
      cp "$new/$f" "$target/$f"
    else
      rm -f "$target/$f"
      rmdir "$(dirname -- "$target/$f")" 2>/dev/null || true   # drop the folder if now empty
    fi
    updated="$updated  $f
"
  else
    conflicts="$conflicts  $f
"
  fi
done <<FILES
$( (cd "$base" && find . -type f; cd "$new" && find . -type f) | sed 's|^\./||' | sort -u )
FILES

if [ "$changed" = no ]; then
  rm -rf "$new"
  echo "Already up to date: $target matches framework $src_rev."
  exit 0
fi
[ -z "$updated" ] || printf 'Updated from framework %s:\n%s' "$src_rev" "$updated"
if [ -z "$conflicts" ]; then
  rm -rf "$base"
  mv "$new" "$base"
  echo "Upgraded $target to framework $src_rev with no conflicts."
  echo "Next: run 'brain-upgrade' in the assistant to fill anything new and verify."
else
  printf 'Changed by both the framework and the assistant (to merge):\n%s' "$conflicts"
  echo "Next: run 'brain-upgrade' in the assistant to merge them and finish the upgrade."
  exit 3
fi
