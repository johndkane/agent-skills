# Agent Skills

Portable [Agent Skills](https://agentskills.io/specification) for AI assistants —
coding agents, IDEs, CLIs, and cowork or desktop modes: Claude Code and Cowork,
GitHub Copilot, OpenCode, Codex, Cursor, and Gemini CLI.

A skill is task-scoped, not repo-scoped: it may be a development workflow, a
research task, or a desktop procedure. What a skill is for comes from its
`description`, which is the only part an agent reads before deciding to load it.

Full documentation lives in [`docs/`](docs/README.md).

## The skills

Everything lives in **[`.agents/skills/`](.agents/skills)**. One folder per skill,
each with a `SKILL.md` and optional `scripts/`, `references/`, and `assets/`.

- **[`twitter-followback`](.agents/skills/twitter-followback/SKILL.md)** —
  researches your followers on X and follows back only real, active people,
  filtering bots, marketing, adult, crypto, and impersonation accounts. Handles
  protected accounts, keeps run state outside the repository so long queues
  resume, links its evidence, and paces itself at a human cadence. Text is the
  default; optional image and frame checks are capped and labelled.
  [Read more](docs/users/twitter-followback.md)

- **[`twitter-moot-radar`](.agents/skills/twitter-moot-radar/SKILL.md)** — finds
  accounts worth following through your mutuals, ranked by how many moots follow
  them and shown with a quoted post, its permalink, and live proof you do not
  follow them yet. Or assesses one account you name — even one no moot follows and
  one that does not follow you back — with its relationship shown as context.
  Optional image, video-frame, or transcript proof is labelled and lower-weight.
  Nothing is followed without per-handle approval.
  [Read more](docs/users/twitter-moot-radar.md)

- **[`twitter-compatibility`](.agents/skills/twitter-compatibility/SKILL.md)** —
  scores how compatible you are with accounts on X — moots, accounts you follow,
  accounts that follow you, all of them, or one account you name whether or not it
  is associated — on subjects you name. Asks for the scope first, reads both feeds,
  counts posts, replies, reposts, and media, and can optionally read image,
  video-frame, or audio-transcript evidence when the session proves it can. Returns
  a 0–100 score with its evidence, per-area breakdowns, and a post worth replying
  to. Read-only: no likes, replies, follows, or messages.
  [Read more](docs/users/twitter-compatibility.md)

- **[`skill-verify`](.agents/skills/skill-verify/SKILL.md)** — this repository's
  verification gate: checks a skill's frontmatter, self-containment, personal-data
  safety, size, reference layout, and catalog wiring, then reports pass/fail with
  file evidence. [Read more](docs/skills/skill-verify.md)

The X/Twitter skills are for real people tending their own personal accounts —
never for engagement farming, marketing, or brand growth.

Skills that share behavior form a group with central files named for the group;
the [group index](docs/skills/skill-groups.md) lists the members and the shared
rules copied into each.

No build step, no package installs, and no need to copy anything by hand.

## Get started

Point your agent at this repository and tell it to get the skill:

> Clone `<repo-url>` and install `<skill-name>` for me.

The agent reads `.agents/skills/<skill-name>/SKILL.md` and copies the folder into
whichever directory its own host reads. The folder is the install unit; keep its
name. The host-by-host table is under
[Getting skills](docs/users/getting-skills.md).

To wire a whole checkout instead:

```bash
./scripts/link-skills.sh          # claude + copilot
./scripts/link-skills.sh --all    # every host
```

```powershell
./scripts/link-skills.ps1 -All
```

See [Scripts](docs/operators/scripts.md) for Windows, flags, and recovery when a
clone arrives without symlinks.

## How it works

`.agents/skills` is the closest thing to a shared project location: OpenCode,
Copilot, Codex, Cursor, and Gemini CLI all read it natively. Claude Code does not,
and Copilot's GitHub-hosted surfaces prefer `.github/skills`, so the repo keeps one
real copy and links the two gaps:

```
.agents/skills/                     # canonical source of truth
.claude/skills -> ../.agents/skills # Claude Code
.github/skills -> ../.agents/skills # GitHub Copilot
```

Adding a skill means creating `.agents/skills/<name>/SKILL.md` and a bullet above.
Nothing else for host wiring — the links point at the whole directory, so every
agent sees it immediately. See
[Architecture](docs/operators/architecture.md) for why the tree is shaped this way
and what each host reads.

## Documentation

| You are | Start here |
| --- | --- |
| Using a skill | [User guide](docs/users/README.md) → [Getting skills](docs/users/getting-skills.md) → [Invoking skills](docs/users/invoking.md) |
| Running a checkout | [Architecture](docs/operators/architecture.md) → [Scripts](docs/operators/scripts.md) → [Adopting this repo](docs/operators/adopting.md) |
| Changing the repository | [Agent instructions](docs/developers/agent-instructions.md) → [Lode Coding](docs/developers/lode-coding.md) → [Host differences](docs/developers/hosts.md) |
| Adding a skill | [Skills](docs/skills/README.md) → [Skill groups](docs/skills/skill-groups.md) → [skill-verify](docs/skills/skill-verify.md) |
| Writing a browser-driven X skill | [X skill contract](docs/skills/twitter-core.md) → [Shared X rules](docs/skills/twitter-shared.md) → [Browser cadence](docs/skills/browser-cadence.md) |

## Using this as a skeleton

This repo is meant to be dropped into another project, not only used standalone.
Alongside `.agents/skills/` and the two links, take `.gitignore` (agent-local
state and secrets) and `.gitattributes` (stable line endings), then recreate the
links with either script. See [Adopting this repo](docs/operators/adopting.md).

Maintaining this repository? See the
[developer documentation](docs/developers/agent-instructions.md) for the agent
instruction model, repository rules, and validation.
