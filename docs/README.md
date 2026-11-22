# Documentation

Human documentation for the `agent-skills` repository, grouped by audience. Every
page links to its neighbours, so you can read in any order.

## Start here

Starting from scratch — no AI assistant installed yet? Follow
[From zero to your first skill](users/quickstart.md): install OpenCode, connect
it to the browser you already use so it can see your X session, pick one of its
free models, and ask it to install and run a skill. Plain language throughout,
about fifteen minutes end to end.

## Users

For people who want a skill for their own account. No repository knowledge is
needed: choose a skill, get it, and use it.

| Page | What it explains |
| --- | --- |
| [Quickstart](users/quickstart.md) | From a fresh machine to your first skill in one pass: OpenCode, browser, free model, one prompt |
| [User guide](users/README.md) | Which skill to choose and what it needs |
| [Getting skills](users/getting-skills.md) | Ask your agent, copy the folder, or enable it in your account |
| [Invoking skills](users/invoking.md) | Explicit syntax for each host, TUI, CLI, and app — and why `/` is not universal |
| [twitter-followback](users/twitter-followback.md) | Follow back real, active followers |
| [twitter-moot-radar](users/twitter-moot-radar.md) | Find accounts worth following through your mutuals, or assess one account you name |
| [twitter-compatibility](users/twitter-compatibility.md) | Score how compatible you are with your associated accounts, or one account you name — moots, following, followers, all, or focus — on subjects you choose |
| [twitter-following-audit](users/twitter-following-audit.md) | Review the accounts you already follow and get a keep, unfollow, mute, or recheck suggestion for each, with safety problems flagged for you — optimistic, evidence-first, read-only |

## Operators

For people who manage a repository checkout: layout, links, wiring, and adoption.

| Page | What it explains |
| --- | --- |
| [Architecture](operators/architecture.md) | The canonical tree, host links, and recovery |
| [Scripts](operators/scripts.md) | `link-skills.sh` and `link-skills.ps1`: environments, flags, behaviour |
| [Adopting this repo](operators/adopting.md) | Using the repo as a skeleton in another project |

## Developers

For people who understand and contribute to this project, including the technical
detail an operator does not need.

| Page | What it explains |
| --- | --- |
| [Agent instructions](developers/agent-instructions.md) | `AGENTS.md`, `CLAUDE.md`, and how this repo is maintained |
| [Lode Coding](developers/lode-coding.md) | The knowledge-management method and its full system prompt |
| [Host differences](developers/hosts.md) | Per-app limits: frontmatter, collisions, surface behaviour |
| [Skills reference](skills/README.md) | The catalog, the spec rules, and how to add a skill |
| [Skill groups](skills/skill-groups.md) | Group-named central files, their members, and the copy rule |
| [Shared core for X skills](skills/twitter-core.md) | The contract every browser-driven X skill is built from |
| [Shared rules for X skills](skills/twitter-shared.md) | Operative rules copied verbatim into each X skill |
| [Browser cadence](skills/browser-cadence.md) | How browser-action skills pace themselves with jittered, proportional waits |
| [skill-verify](skills/skill-verify.md) | The repository's skill verification gate |

## Where things live

```
README.md                        high-level overview for visitors
docs/
├── users/                       choose, get, and use skills
├── operators/                   repository layout, wiring, adoption
├── developers/                  repo rules, lode, host detail
└── skills/                      skill authoring reference
.agents/skills/<name>/SKILL.md   the only real copy of a skill
.claude/skills                   link for Claude Code
.github/skills                   link for GitHub Copilot
scripts/                         link scripts for every platform
AGENTS.md                        generic agent guidance
lode/                            project-specific guidance and agent memory
```

Two short rules explain the shape:

1. A skill is written once, in `.agents/skills`.
2. Host paths are links, not copies. Group rules are the one deliberate copy: a
   central file is mirrored verbatim into each member so a copied skill works
   alone.

## Reading order

Using a skill: [Quickstart](users/quickstart.md) →
[User guide](users/README.md) → [Getting skills](users/getting-skills.md) →
[Invoking skills](users/invoking.md).

Managing a checkout: [Architecture](operators/architecture.md) →
[Scripts](operators/scripts.md) → [Adopting this repo](operators/adopting.md).

Contributing: [Agent instructions](developers/agent-instructions.md) →
[Lode Coding](developers/lode-coding.md) → [Skills reference](skills/README.md) →
[Host differences](developers/hosts.md).
