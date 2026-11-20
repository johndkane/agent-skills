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
  researches followers on X and follows back only real, active people; filters
  bots, marketing, adult, crypto, and impersonation accounts.
  - **Triggers** on "follow back my followers", "clean up my follow-back queue",
    or "which followers are worth following back".
  - **Needs** interactive browser control with a browser already signed in to X.
    Local only — cloud, sandboxed, or headless sessions cannot run it.

No build step, no package installs, and no need to copy anything by hand.

**Easiest:** point your agent at this repository and tell it to get the skill.

> Clone `<repo-url>` and install `<skill-name>` for me.

The agent reads `.agents/skills/<skill-name>/SKILL.md` and copies the folder into
whichever directory its own host reads. Ask it to run `scripts/link-skills.sh` if
you want the whole catalog wired up instead of a single copied skill.

**Manual:** copy the skill's folder into your agent's skills directory:

| Agent | Copy the folder into | Also reads |
| --- | --- | --- |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` | — |
| GitHub Copilot | `.github/skills/`, `.claude/skills/`, or `.agents/skills/` | `~/.copilot/skills/`, `~/.agents/skills/` |
| OpenCode | `.opencode/skills/` | `.claude/skills/`, `.agents/skills/`, `~/.config/opencode/skills/` |
| OpenAI Codex | `.agents/skills/` (walks up to the repo root) | `~/.agents/skills/`, `/etc/codex/skills/` |
| Cursor | `.cursor/skills/` or `.agents/skills/` | `~/.cursor/skills/`, `~/.agents/skills/`, `.claude/skills/` |
| Gemini CLI | `.gemini/skills/` or `.agents/skills/` | `~/.gemini/skills/`, `~/.agents/skills/` |

Some surfaces do not read a folder at all. Claude Cowork and cloud sessions load
the skills enabled for your claude.ai account, so a skill has to be enabled there
rather than copied into a repository.

Keep the folder name as-is: the spec requires the frontmatter `name` to match it,
and that name is how each agent addresses the skill (`/<skill-name>`,
`$<skill-name>`, or by description match).

A clone gives you the whole set wired up for every agent. A ZIP download works
for individual skills, since the skill folders themselves contain no symlinks —
but the two agent links do not survive an archive.

## Why this layout

`.agents/skills` is the closest thing to a shared project location: OpenCode,
Copilot, Codex, Cursor, and Gemini CLI all read it natively. Claude Code does
not, and Copilot's GitHub-hosted surfaces prefer `.github/skills`.

So the repo keeps one real copy and links the two gaps:

```
agent-skills/
├── .agents/
│   └── skills/                       # canonical source of truth
│       └── twitter-followback/
│           └── SKILL.md
├── .claude/
│   └── skills -> ../.agents/skills   # Claude Code
├── .github/
│   └── skills -> ../.agents/skills   # GitHub Copilot
├── scripts/
│   ├── link-skills.sh                # recreates the links (macOS, Linux, Git Bash)
│   └── link-skills.ps1               # recreates the links (Windows)
├── docs/                             # human wiki
├── lode/                             # agent memory (Lode Coding)
├── AGENTS.md                         # repository rules for agents
├── CLAUDE.md                         # imports AGENTS.md for older Claude Code
└── README.md
```

Adding a skill means creating `.agents/skills/<name>/SKILL.md` and a bullet in
the list above. Nothing else — the links point at the whole directory, so every
agent sees it immediately.

Not created by default: `.opencode/skills`, `.cursor/skills`, `.gemini/skills`.
Each of those tools already reads `.agents/skills`, so a second path would
surface the same skill twice. The link script can add one anyway when a host or
CI job only looks at its native directory — name the environment or pass `--all`.

## Nuances per app

Same files, different rules. These are the differences that actually bite.

**All hosts**

- `name` must be lowercase kebab-case (`[a-z0-9-]`, 1–64 chars, no leading,
  trailing, or doubled hyphens) and must match the directory name.
- `description` is required and capped at 1024 chars. Front-load the use case and
  trigger words; this is the only text most agents see before activating a skill.
- `SKILL.md` is loaded in full on activation. Keep it under 500 lines and move
  detail into `references/`.
- Name collisions resolve differently everywhere (Claude Code: enterprise →
  personal → project; OpenCode: later source wins; Codex: both are listed). Keep
  names unique.

**Claude Code**

- Reads only `.claude/skills`, in the repo and every parent directory, plus
  `.claude/skills` in any `--add-dir` directory. `.agents/skills` alone is
  invisible to it.
- Symlinked skill folders are officially supported and loaded once even when
  several paths point at the same target.
- `description` + `when_to_use` are truncated at 1,536 chars in the skill list.
- Supports extra frontmatter the others ignore: `allowed-tools`,
  `disable-model-invocation`, `when_to_use`, `context: fork`, `paths`, `model`.

**Claude Cowork and cloud sessions**

- These do not read `~/.claude/skills` on your machine. They load the skills
  enabled for your claude.ai account, synced to `~/.claude/skills/synced/`.
- A repository's `.claude/skills` is not available in a project's cloud threads.
  Desktop scheduled tasks run locally and do load local skills.
- Synced skills are not executed with local privileges: `!` command injection,
  `@` file references, and `${CLAUDE_PROJECT_DIR}` placeholders reach the model
  as literal text in terminal and VS Code sessions. Write skills that still make
  sense without them.

**GitHub Copilot**

- Accepts `.github/skills`, `.claude/skills`, and `.agents/skills` in a repo;
  `~/.copilot/skills` and `~/.agents/skills` for personal skills.
- Copilot code review and the cloud agent read `.github/skills` by convention —
  that is why the link exists even though Copilot also reads `.agents/skills`.
- The file must be named exactly `SKILL.md`.
- `allowed-tools: shell` removes the confirmation prompt before running terminal
  commands. Only set it for skills you have fully reviewed.

**OpenCode**

- Native location is `.opencode/skills`; `.claude/skills` and `.agents/skills` are
  compatibility sources with lower precedence.
- The skill ID is the path, not the frontmatter `name`, and it is case-sensitive.
- A flat `skills/<name>.md` also works, but the directory form is needed for
  supporting files.

**OpenAI Codex**

- Scans `.agents/skills` from the working directory up to the repository root,
  and supports symlinked skill folders.
- The initial skill list is capped at ~2% of the context window, so long
  descriptions get shortened or dropped. Put trigger words first.
- Optional `agents/openai.yaml` adds display metadata and
  `policy.allow_implicit_invocation`.

**Cursor**

- Reads `.agents/skills` and `.cursor/skills`, plus `.claude/skills` and
  `.codex/skills` for compatibility.
- Walks skill directories recursively, so category folders are allowed; the
  folder containing `SKILL.md` is the skill.
- Extra frontmatter: `paths` (glob scoping), `icon`, `color`.

**Gemini CLI**

- Reads `.gemini/skills` or the `.agents/skills` alias; within a tier the alias
  wins.
- Activation requires a user consent prompt before the skill body is injected.

## Maintaining the links

The links are relative, so the repo works after a clone at any path.

- **Windows** needs Developer Mode (or an elevated shell) to create symbolic
  links. `scripts/link-skills.ps1` falls back to directory junctions if symlinks
  are refused; junctions store absolute targets, so re-run it if the repo moves.
- **macOS and Linux** allow symlinks without extra setup, so
  `scripts/link-skills.sh` is all that is needed there. Git Bash and WSL on
  Windows can run the same script.
- **Git** stores the links as `120000` entries. Check that
  `git config core.symlinks` is `true`; if it is `false`, Git writes a text file
  containing `../.agents/skills` and no agent will find any skills. Linux and
  macOS check clones out correctly by default.
- **If a clone came down without symlinks**, run either script. Both recognise
  those placeholder files and replace them with real links without a force flag.
- **Hosts that read both roots** (OpenCode, Cursor, Copilot) may enumerate a
  skill twice, once through a link and once through `.agents/skills`. The
  content is byte-identical and hosts deduplicate by name or resolved real path,
  so it is harmless.

Wire the catalog with the script for the platform. With no arguments it wires
`claude` and `copilot`, the two hosts that cannot rely on `.agents/skills`
alone. Name environments to wire only those, or use `--all` for every host:

```bash
./scripts/link-skills.sh                    # claude + copilot
./scripts/link-skills.sh cursor             # only .cursor/skills
./scripts/link-skills.sh claude copilot cursor
./scripts/link-skills.sh --all --force      # every host, replace anything odd
```

```powershell
./scripts/link-skills.ps1                   # claude + copilot
./scripts/link-skills.ps1 -All
./scripts/link-skills.ps1 claude cursor -Force
```

| Environment | Path wired |
| --- | --- |
| `claude` | `.claude/skills` |
| `copilot` | `.github/skills` |
| `opencode` | `.opencode/skills` |
| `cursor` | `.cursor/skills` |
| `gemini` | `.gemini/skills` |
| `codex` | none — reads `.agents/skills` natively |

Both scripts are idempotent, take a force flag (`--force` / `-Force`) to replace
something unexpected, and heal the placeholder files left by a checkout without
symlink support. Without a script, the equivalent is one command per link:

```bash
mkdir -p .claude .github
ln -sfn ../.agents/skills .claude/skills
ln -sfn ../.agents/skills .github/skills
```

## Using this as a skeleton

This repo is meant to be dropped into another project, not only used standalone.
Alongside `.agents/skills/` and the two links, two files are worth taking even if
the destination keeps its own layout:

- **`.gitignore`** — protects the *target* repo, not only this one. Agents write
  machine-local state (`.claude/settings.local.json`, `CLAUDE.local.md`,
  `.claude/worktrees/`, Aider history, `.specstory/`) and `.env` files wherever
  they run. If the destination already has a `.gitignore`, merge these rules
  rather than replacing it, and carry over the warning: never ignore `.agents/`,
  `.claude/skills`, or `.github/skills`.
- **`.gitattributes`** — normalises line endings to LF, so skill files do not
  flip between CRLF and LF depending on who checked them out.

In the destination, copy `.agents/skills/` and recreate the links with
`scripts/link-skills.sh` (macOS, Linux, Git Bash) or `scripts/link-skills.ps1`
(Windows).

Maintaining this repository? See [`AGENTS.md`](AGENTS.md) for the invariants,
validation steps, and pre-handoff checks.
