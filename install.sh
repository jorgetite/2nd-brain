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
# Each installed assistant is a git repository whose `framework` branch holds only pristine
# framework snapshots. Upgrade commits a fresh snapshot there and merges it into the assistant's
# own branch, so framework changes land on top of what the assistant has learned. Conflicts are
# left for the `brain-upgrade` skill to resolve.
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

# commits made by this script carry a fixed identity, so they work without user git config
git_as_installer() {
  git -c user.name="2nd-brain install" -c user.email="install@localhost" "$@"
}

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

  # deliverables are disposable and may hold private data or large binaries: keep them out of history
  printf '/artifacts/\n' > "$dir/.gitignore"
}

# --- install -----------------------------------------------------------------
if [ "$mode" = install ]; then
  if [ -e "$target" ] && [ -n "$(ls -A -- "$target" 2>/dev/null)" ]; then
    echo "error: $target already exists and is not empty (to upgrade it: sh install.sh --upgrade $target)" >&2
    exit 1
  fi
  write_snapshot "$target"

  # version the instance so self-edits can be rolled back, and mark the pristine snapshot as
  # `framework` so later upgrades can merge against it
  if command -v git >/dev/null 2>&1; then
    git -C "$target" init -q
    git -C "$target" add -A
    git_as_installer -C "$target" commit -q -m "Install assistant from 2nd-brain $src_rev"
    git -C "$target" branch framework
    echo "Initialized a git repository in $target."
  else
    echo "git not found; skipping version control for $target (upgrades will not be possible)."
  fi

  echo "Installed assistant at: $target  (from $SRC, revision $src_rev)"
  echo "Next: run 'brain-init' scoped to $target to personalize it."
  exit 0
fi

# --- upgrade -----------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "error: upgrading needs git" >&2; exit 1; }
if ! git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
  echo "error: $target is not a git-versioned assistant; it cannot be upgraded in place" >&2
  exit 1
fi
target=$(CDPATH= cd -- "$target" && pwd)
if git -C "$target" rev-parse -q --verify MERGE_HEAD >/dev/null; then
  echo "error: $target has a merge in progress; finish it (brain-upgrade) before upgrading again" >&2
  exit 1
fi
if [ -n "$(git -C "$target" status --porcelain --untracked-files=no)" ]; then
  echo "error: $target has uncommitted changes to tracked files; commit them first" >&2
  exit 1
fi

# assistants installed before the framework branch existed: their first commit is the pristine install
if ! git -C "$target" rev-parse --verify -q refs/heads/framework >/dev/null; then
  root=$(git -C "$target" rev-list --max-parents=0 HEAD | tail -n 1)
  git -C "$target" branch framework "$root"
  echo "Created the framework branch at the original install commit ($(git -C "$target" rev-parse --short "$root"))."
fi

# write a fresh snapshot into a temporary worktree of the framework branch and commit it there
tmp=$(mktemp -d)
trap 'git -C "$target" worktree remove --force "$tmp/framework" >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT
git -C "$target" worktree add -q "$tmp/framework" framework
find "$tmp/framework" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
write_snapshot "$tmp/framework"
git -C "$tmp/framework" add -A
if git -C "$tmp/framework" diff --cached --quiet; then
  echo "Framework snapshot unchanged ($src_rev)."
else
  git_as_installer -C "$tmp/framework" commit -q -m "Framework snapshot from 2nd-brain $src_rev"
  echo "Committed a framework snapshot from 2nd-brain $src_rev."
fi

if git -C "$target" merge-base --is-ancestor framework HEAD; then
  echo "Already up to date: $target includes framework $src_rev."
  exit 0
fi
if git_as_installer -C "$target" merge -q --no-ff -m "Upgrade framework to 2nd-brain $src_rev" framework; then
  echo "Upgraded $target to framework $src_rev with no conflicts."
  echo "Next: run 'brain-upgrade' in the assistant to fill anything new and verify."
else
  echo "Merged framework $src_rev into $target, with conflicts in:"
  git -C "$target" diff --name-only --diff-filter=U | sed 's/^/  /'
  echo "Next: run 'brain-upgrade' in the assistant to resolve them and finish the upgrade."
  exit 3
fi
