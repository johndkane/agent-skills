#!/usr/bin/env bash
#
# Creates the per-agent links that expose .agents/skills to hosts that do not
# read that location natively.
#
# .agents/skills is the canonical source of truth. Claude Code only reads
# .claude/skills and GitHub Copilot prefers .github/skills, so both are links
# to the canonical tree.
#
# Idempotent: an existing correct link is left alone, a real directory is never
# deleted unless --force is supplied, and the placeholder file left behind by a
# `core.symlinks=false` checkout is replaced automatically.
#
# Usage:
#   ./scripts/link-skills.sh [--force]
#
set -euo pipefail

script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -P -- "$script_dir/.." && pwd)"
source_dir="$repo_root/.agents/skills"

force=0
case "${1:-}" in
    "")
        ;;
    -f|--force)
        force=1
        ;;
    -h|--help)
        cat <<'EOF'
Usage: link-skills.sh [--force]

Creates the per-agent links that expose .agents/skills to hosts that do not
read that location natively.

  --force   Replace an existing directory, or a link that points elsewhere.

Without --force, an existing correct link is left alone and anything unexpected
is reported instead of being deleted.
EOF
        exit 0
        ;;
    *)
        echo "error: unknown option: $1" >&2
        echo "usage: $0 [--force]" >&2
        exit 2
        ;;
esac

if [ ! -d "$source_dir" ]; then
    echo "error: canonical skills directory not found: $source_dir" >&2
    exit 1
fi

# resolve_target <absolute base dir> <target as written>
# Prints the absolute real path of a link target, or nothing if it is missing.
resolve_target() {
    local base="$1" target="$2"
    ( cd -P -- "$base" 2>/dev/null && cd -- "$target" 2>/dev/null && pwd -P )
}

count_entries() {
    find "$1/" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' '
}

links="
.claude/skills|../.agents/skills|Claude Code
.github/skills|../.agents/skills|GitHub Copilot
"

while IFS='|' read -r rel_path rel_target label; do
    [ -n "$rel_path" ] || continue

    link_path="$repo_root/$rel_path"
    parent="$(dirname -- "$link_path")"
    mkdir -p -- "$parent"

    expected="$(resolve_target "$parent" "$rel_target" || true)"
    if [ -z "$expected" ]; then
        echo "error: link target does not exist: $rel_target (from $rel_path)" >&2
        exit 1
    fi

    if [ -L "$link_path" ]; then
        raw="$(readlink "$link_path")"
        case "$raw" in
            /*) current="$(resolve_target "$(dirname -- "$raw")" "$(basename -- "$raw")" || true)" ;;
            *)  current="$(resolve_target "$parent" "$raw" || true)" ;;
        esac

        if [ "$current" = "$expected" ]; then
            echo "ok      $rel_path -> $rel_target"
            continue
        fi

        if [ "$force" -ne 1 ]; then
            echo "warn: $rel_path points at ${current:-<missing>}; expected $expected. Re-run with --force." >&2
            continue
        fi

        rm -f -- "$link_path"
    elif [ -e "$link_path" ]; then
        # A checkout with core.symlinks=false writes the target as a plain file.
        placeholder=0
        if [ -f "$link_path" ] && [ "$(tr -d '\r\n' < "$link_path")" = "$rel_target" ]; then
            placeholder=1
        fi

        if [ "$force" -ne 1 ] && [ "$placeholder" -ne 1 ]; then
            echo "warn: $rel_path exists and is not a link. Re-run with --force." >&2
            continue
        fi

        rm -rf -- "$link_path"
    fi

    if ! ln -s "$rel_target" "$link_path"; then
        echo "error: could not create the link at $rel_path." >&2
        echo "       On Windows use scripts/link-skills.ps1. A filesystem without" >&2
        echo "       symlink support cannot host this layout." >&2
        exit 1
    fi
    echo "linked  $rel_path -> $rel_target  [$label]"

    link_count="$(count_entries "$link_path")"
    source_count="$(count_entries "$source_dir")"
    if [ "$link_count" -ne "$source_count" ]; then
        echo "warn: $rel_path exposes $link_count entries; canonical tree has $source_count." >&2
    fi
done <<< "$links"

echo "Canonical source: $source_dir"
