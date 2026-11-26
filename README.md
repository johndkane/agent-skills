# Agent Skills

Ready-to-use [Agent Skills](https://agentskills.io/specification) for AI
assistants — the coding agents and AI apps you already use: Claude Code and
Cowork, GitHub Copilot, OpenCode, Codex, Cursor, and Gemini CLI.

A skill teaches your agent one job. When your request matches what a skill is
for, your agent loads its instructions and gets to work. Each skill opens with
a short description of what it does, and that description is all an agent reads
when deciding whether to load it — so a skill only shows up when it's actually
relevant.

Full documentation lives in [`docs/`](docs/README.md).

## The skills

The skills live in **[`.agents/skills/`](.agents/skills)** — one folder per
skill. The folder holds a `SKILL.md` (the instructions) plus optional helpers,
and the whole folder is what gets copied into whichever app you use.

- **[`twitter-followback`](.agents/skills/twitter-followback/SKILL.md)** —
  looks at your new followers on X and follows back the real, active people.
  Bots and marketing, adult, crypto, and impersonation accounts are skipped.
  It checks each follow in the app before calling it done, keeps its progress
  in a file on your machine so a long session can pick up where it left off,
  and shows its work — every account and post it mentions links back to X. It
  paces itself like a person would, and optional image, video-frame, and audio
  checks stay off unless you turn them on.
  [Read more](docs/users/twitter-followback.md)

- **[`twitter-moot-radar`](.agents/skills/twitter-moot-radar/SKILL.md)** —
  finds accounts worth following through your mutuals: you name the topics you
  care about, it reads what your moots follow, and it only suggests accounts
  with real proof — the post that shows the match, a link to it, who follows
  it, and a live check that you don't follow it yet. You can also ask it to
  look at one account by name, even one none of your moots follow or one that
  doesn't follow you back. Nothing gets followed without your say-so, name by
  name.
  [Read more](docs/users/twitter-moot-radar.md)

- **[`twitter-compatibility`](.agents/skills/twitter-compatibility/SKILL.md)** —
  scores how well you'd get along with accounts on X about the things you care
  about: your moots, people you follow, people who follow you, or one account
  you name. It reads your feed and theirs, counts real posts and replies, and
  gives a 0–100 score with the evidence behind every point. It only reads — it
  never likes, replies, follows, or messages anyone.
  [Read more](docs/users/twitter-compatibility.md)

- **[`twitter-following-audit`](.agents/skills/twitter-following-audit/SKILL.md)** —
  reviews the accounts you already follow and suggests what to do with each:
  keep, unfollow, mute, or look again later. It's optimistic by design —
  keep is the default, every other suggestion carries dated evidence, and
  unfollow is about fit (a quiet account, a changed focus, drifted interests),
  never a judgement of the person. Anything that looks like a bot, scam, or
  impersonator is flagged separately with the evidence — blocking stays your
  call. It only suggests — you take every action.
  [Read more](docs/users/twitter-following-audit.md)

- **[`software-documentation`](.agents/skills/software-documentation/SKILL.md)** —
  writes and keeps a software project's documentation true: one audience per
  page, one home per fact, a central terminology guide, and pages that describe
  the system as it is now — updated in the same change as the code they
  describe. Works on any project; no browser or account needed.
  [Read more](docs/users/software-documentation.md)

- **[`skill-verify`](.agents/skills/skill-verify/SKILL.md)** — the housekeeping
  skill for this repository: it checks that a skill is put together correctly
  (frontmatter, links, size, privacy) and reports what passes and what doesn't,
  with evidence. [Read more](docs/skills/skill-verify.md)

- **[`agent-verify`](.agents/skills/agent-verify/SKILL.md)** — the housekeeping
  skill for the agent layer: it checks an agent or command file against the
  official host specs (identity, tools portability, privacy), the catalog
  wiring, and the alias chain, and reports pass/fail with evidence. No official
  validator exists for agents, so its spec checks are manual and honest about
  it. [Read more](docs/skills/agent-verify.md)

The X/Twitter skills are for real people tending their own personal accounts —
never for engagement farming, marketing, or brand growth.

Skills that share behavior form a group with central files named for the group;
the [group index](docs/skills/skill-groups.md) lists the members and the shared
rules copied into each.

The catalog also carries **agents**: read-only subagent definitions in
`.zcode/agents/` with their slash commands in `.zcode/commands/`, aliased under
`.agents/`, `.claude/`, and `.github/` so Claude Code, GitHub Copilot, and ZCode
all see the same files. The first is
[`dotnet-practices-reviewer`](docs/users/dotnet-practices-reviewer.md) — a
read-only reviewer for .NET asynchrony and modern-API use in repositories that
keep its project's conventions.

No build step, no package installs, and no need to copy anything by hand.

## Get started

Starting from scratch — nothing installed yet? [From zero to your first
skill](docs/users/quickstart.md) takes a fresh machine to a working skill in
one pass: install OpenCode, connect your browser, pick a free model, and ask
for a skill.

Already use an AI assistant? Point it at this repository and ask for a skill
by name:

> Install `twitter-followback` for me, then review my new followers.

That's the whole install: your agent copies that skill's folder into the
directory its own app looks at. The folder is the whole skill; keep its name.
Which folder each app reads is in [Getting skills](docs/users/getting-skills.md),
and exact per-app syntax is in [Invoking skills](docs/users/invoking.md).

Plain language works in every app. Once a skill is installed, try:

| Say something like | Skill |
| --- | --- |
| "Follow back my followers" or "review my new followers" | [twitter-followback](docs/users/twitter-followback.md) |
| "Who do my moots follow that I don't?" | [twitter-moot-radar](docs/users/twitter-moot-radar.md) |
| "How compatible am I with @example_alice?" | [twitter-compatibility](docs/users/twitter-compatibility.md) |
| "Audit my follows" or "review my following list" | [twitter-following-audit](docs/users/twitter-following-audit.md) |

Each skill confirms its rules with you before it acts, so there is nothing to
set up in advance. The X skills need a browser your agent can drive, signed in
to your own account — see [what they need](docs/users/README.md).

To set up a whole checkout at once:

```bash
./scripts/link-skills.sh          # claude + copilot
./scripts/link-skills.sh --all    # every host
```

```powershell
./scripts/link-skills.ps1 -All
```

See [Scripts](docs/operators/scripts.md) for Windows, flags, and what to do if
a clone arrives without its links.

## How it works

`.agents/skills` is the one real skill copy that most apps read directly:
OpenCode, Codex, Cursor, and Gemini CLI all look there. Agents and commands live
in `.zcode/agents/` and `.zcode/commands/`, aliased under `.agents/`. Claude
Code reads none of those, and Copilot's GitHub-hosted surfaces prefer
`.github/skills`, so the repo keeps one copy of everything and links the gaps:

```
.agents/                            # the real tree: skills, agents, commands
.claude -> .agents                  # Claude Code (one link for all three)
.github/skills -> ../.agents/skills # GitHub Copilot
```

Adding a skill means creating `.agents/skills/<name>/SKILL.md` and a bullet
above — nothing else. The links point at the whole directory, so every agent
sees it immediately. [Architecture](docs/operators/architecture.md) explains
why the tree is shaped this way and what each app reads.

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
Alongside `.agents/skills/`, the host links, and the `.zcode/` agent tree, take
`.gitignore` (agent-local state and secrets) and `.gitattributes` (consistent
line endings), then recreate the links with either script. The `agents/`,
`prompts/`, and `.zcode/plans/` folders carry an empty `.gitignore` placeholder
so a fresh clone keeps them. See
[Adopting this repo](docs/operators/adopting.md).

Maintaining this repository? See the
[developer documentation](docs/developers/agent-instructions.md) for the agent
instruction model, repository rules, and validation.
