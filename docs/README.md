# Documentation

Wiki for the `agent-skills` repository. Every page links to its neighbours, so
you can read in any order.

## Contents

| Page | What it explains |
| --- | --- |
| [Architecture](architecture.md) | Why there is one canonical tree and how each agent finds it |
| [Skills](skills/README.md) | The skill catalog, the spec rules, and how to add a skill |
| [Shared core for X skills](skills/twitter-core.md) | The contract every browser-driven X skill is built from |
| [Invoking skills](skills/invoking.md) | Explicit syntax for each host, TUI, CLI, and app — and why `/` is not universal |
| [Scripts](scripts.md) | `link-skills.sh` and `link-skills.ps1`: environments, flags, behaviour |
| [Agent instructions](agent-instructions.md) | `AGENTS.md`, `CLAUDE.md`, and how this repo is maintained |
| [Lode Coding](lode-coding.md) | The knowledge-management method and its full system prompt |
| [Adopting this repo](adopting.md) | Using the repo as a skeleton in another project |

## Where things live

```
.agents/skills/<name>/SKILL.md   the only real copy of a skill
.claude/skills                   link for Claude Code
.github/skills                   link for GitHub Copilot
scripts/                         link scripts for every platform
docs/                            this wiki
AGENTS.md                        repo rules loaded by agents
lode/                            agent-owned project memory (see Lode Coding)
```

Two short rules explain the shape:

1. A skill is written once, in `.agents/skills`.
2. Everything else is a link or a description. Nothing is copied.

## Quick start

Point your agent at this repository and ask for a skill by name:

> Clone `<repo-url>` and install `<skill-name>` for me.

The agent reads `.agents/skills/<skill-name>/SKILL.md` and places it where its
own host looks. To wire a whole checkout instead, run
[`scripts/link-skills.sh`](scripts.md#usage) or
[`scripts/link-skills.ps1`](scripts.md#usage).

## Reading order

New to the repo: [Architecture](architecture.md) →
[Skills](skills/README.md) → [Scripts](scripts.md).

Maintaining it: [Agent instructions](agent-instructions.md) →
[Lode Coding](lode-coding.md) →
[Adopting this repo](adopting.md).
