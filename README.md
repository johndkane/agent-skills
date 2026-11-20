# Agent Skills

Portable [Agent Skills](https://agentskills.io/specification) for coding agents —
Claude Code, GitHub Copilot, OpenCode, Codex, Cursor, and Gemini CLI.

## The skills

Everything lives in **[`.agents/skills/`](.agents/skills)**. One folder per skill,
each with a `SKILL.md` and optional `scripts/`, `references/`, and `assets/`:

| Skill | What it does |
| --- | --- |
| [`twitter-followback`](.agents/skills/twitter-followback/SKILL.md) | Researches followers on X and follows back only real, active people; filters bots, marketing, adult, crypto, and impersonation accounts. |

No build step and no dependencies. To use a skill, copy its folder into your
agent's skills directory:

| Agent | Copy the folder into | Also reads |
| --- | --- | --- |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` | — |
| GitHub Copilot | `.github/skills/`, `.claude/skills/`, or `.agents/skills/` | `~/.copilot/skills/`, `~/.agents/skills/` |
| OpenCode | `.opencode/skills/` | `.claude/skills/`, `.agents/skills/`, `~/.config/opencode/skills/` |
| OpenAI Codex | `.agents/skills/` (walks up to the repo root) | `~/.agents/skills/`, `/etc/codex/skills/` |
| Cursor | `.cursor/skills/` or `.agents/skills/` | `~/.cursor/skills/`, `~/.agents/skills/`, `.claude/skills/` |
| Gemini CLI | `.gemini/skills/` or `.agents/skills/` | `~/.gemini/skills/`, `~/.agents/skills/` |

Keep the folder name as-is: the spec requires the frontmatter `name` to match it,
and that name is how each agent addresses the skill (`/twitter-followback`,
`$twitter-followback`, or by description match).

A `git clone` gives you the whole set wired up for every agent below. A ZIP
download works too for individual skills — the skill folders themselves contain
no symlinks.

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
│   └── link-skills.ps1               # recreates the links
└── README.md
```

Adding a skill means creating `.agents/skills/<name>/SKILL.md`. Nothing else —
both links point at the whole directory, so every agent sees it immediately.

Deliberately **not** created: `.opencode/skills`, `.cursor/skills`,
`.codex/skills`, `.gemini/skills`. Each of those tools already reads
`.agents/skills`, and a second path would surface the same skill twice.

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
- **Git** stores the links as `120000` entries. Check that
  `git config core.symlinks` is `true`; if it is `false`, Git writes a text file
  containing `../.agents/skills` and no agent will find any skills. Linux and
  macOS check clones out correctly by default.
- **If a clone came down without symlinks**, run `scripts/link-skills.ps1`. It
  recognises those placeholder files and replaces them with real links without
  needing `-Force`.
- **Hosts that read both roots** (OpenCode, Cursor, Copilot) may enumerate a
  skill twice, once through a link and once through `.agents/skills`. The
  content is byte-identical and hosts deduplicate by name or resolved real path,
  so it is harmless.

Repair or recreate the links:

```powershell
pwsh ./scripts/link-skills.ps1
```

On macOS or Linux the same result is one command per link:

```bash
mkdir -p .claude .github
ln -sfn ../.agents/skills .claude/skills
ln -sfn ../.agents/skills .github/skills
```
