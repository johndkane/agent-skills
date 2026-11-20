#!/usr/bin/env bash
#
# Wires the skill catalog into the directories each agent host reads. Every link
# points at the canonical .agents/skills tree.
#
# With no environment argument, claude and copilot are wired: the two hosts that
# cannot rely on .agents/skills alone. --all wires every supported host.
#
set -euo pipefail

script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -P -- "$script_dir/.." && pwd)"
source_dir="$repo_root/.agents/skills"

# key|path|label -- an empty path means the host reads .agents/skills natively.
hosts="
claude|.claude/skills|Claude Code
copilot|.github/skills|GitHub Copilot
opencode|.opencode/skills|OpenCode
cursor|.cursor/skills|Cursor
gemini|.gemini/skills|Gemini CLI
codex||Codex
"

usage() {
    cat <<'EOF'
Usage: link-skills.sh [environment ...] [--all] [--force]

Wires the catalog into the directories each agent host reads. Every link points
at the canonical .agents/skills tree, so there is still only one real copy.

Environments:
  claude     .claude/skills      wired by default
  copilot    .github/skills      wired by default
  opencode   .opencode/skills
  cursor     .cursor/skills
  gemini     .gemini/skills
  codex      none; reads .agents/skills natively

With no environment, claude and copilot are wired. --all wires every environment
above, including the hosts that already read .agents/skills.

Options:
  -a, --all     wire every supported environment
  -f, --force   replace an existing directory or a link pointing elsewhere
  -h, --help    show this help

Examples:
  ./scripts/link-skills.sh
  ./scripts/link-skills.sh cursor
  ./scripts/link-skills.sh claude copilot cursor
  ./scripts/link-skills.sh --all --force
EOF
}

normalize_host() {
    case "$1" in
        claude|claude-code|claudecode) printf '%s' claude ;;
        copilot|github|github-copilot) printf '%s' copilot ;;
        opencode|open-code) printf '%s' opencode ;;
        cursor) printf '%s' cursor ;;
        gemini|gemini-cli) printf '%s' gemini ;;
        codex|openai-codex) printf '%s' codex ;;
        *) return 1 ;;
    esac
}

force=0
all=0
requested=""

while [ $# -gt 0 ]; do
    case "$1" in
        -f|--force)
            force=1
            ;;
        -a|--all)
            all=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "error: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            if ! normalized="$(normalize_host "$1")"; then
                echo "error: unknown environment: $1" >&2
                echo "valid: claude copilot opencode cursor gemini codex" >&2
                exit 2
            fi
            requested="$requested $normalized"
            ;;
    esac
    shift
done

if [ ! -d "$source_dir" ]; then
    echo "error: canonical skills directory not found: $source_dir" >&2
    exit 1
fi

should_wire() {
    local key="$1"

    if [ "$all" -eq 1 ]; then
        return 0
    fi

    if [ -z "$requested" ]; then
        case "$key" in
            claude|copilot) return 0 ;;
            *) return 1 ;;
        esac
    fi

    case " $requested " in
        *" $key "*) return 0 ;;
        *) return 1 ;;
    esac
}

resolve_target() {
    local base="$1" target="$2"
    ( cd -P -- "$base" 2>/dev/null && cd -- "$target" 2>/dev/null && pwd -P )
}

count_entries() {
    find "$1/" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' '
}

wired=0

while IFS='|' read -r key rel_path label; do
    [ -n "$key" ] || continue
    should_wire "$key" || continue

    if [ -z "$rel_path" ]; then
        echo "native  $key -> .agents/skills (no link needed)  [$label]"
        wired=$((wired + 1))
        continue
    fi

    link_path="$repo_root/$rel_path"
    parent="$(dirname -- "$link_path")"
    mkdir -p -- "$parent"

    expected="$(resolve_target "$parent" "../.agents/skills" || true)"
    if [ -z "$expected" ]; then
        echo "error: link target does not exist: ../.agents/skills (from $rel_path)" >&2
        exit 1
    fi

    if [ -L "$link_path" ]; then
        raw="$(readlink "$link_path")"
        case "$raw" in
            /*) current="$(resolve_target "$(dirname -- "$raw")" "$(basename -- "$raw")" || true)" ;;
            *)  current="$(resolve_target "$parent" "$raw" || true)" ;;
        esac

        if [ "$current" = "$expected" ]; then
            echo "ok      $rel_path -> ../.agents/skills  [$label]"
            wired=$((wired + 1))
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
        if [ -f "$link_path" ] && [ "$(tr -d '\r\n' < "$link_path")" = "../.agents/skills" ]; then
            placeholder=1
        fi

        if [ "$force" -ne 1 ] && [ "$placeholder" -ne 1 ]; then
            echo "warn: $rel_path exists and is not a link. Re-run with --force." >&2
            continue
        fi

        rm -rf -- "$link_path"
    fi

    if ! ln -s "../.agents/skills" "$link_path"; then
        echo "error: could not create the link at $rel_path." >&2
        echo "       On Windows use scripts/link-skills.ps1. A filesystem without" >&2
        echo "       symlink support cannot host this layout." >&2
        exit 1
    fi
    echo "linked  $rel_path -> ../.agents/skills  [$label]"
    wired=$((wired + 1))

    link_count="$(count_entries "$link_path")"
    source_count="$(count_entries "$source_dir")"
    if [ "$link_count" -ne "$source_count" ]; then
        echo "warn: $rel_path exposes $link_count entries; canonical tree has $source_count." >&2
    fi
done <<< "$hosts"

if [ "$wired" -eq 0 ]; then
    echo "nothing wired; see --help" >&2
    exit 1
fi

echo "Canonical source: $source_dir"
