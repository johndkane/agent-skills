# Architecture

How one skill directory serves every agent host without being copied.

## The problem

Each assistant looks for skills in its own place. There is no single directory
that all of them read, and the overlapping ones overlap differently.

## The model

```
.agents/                 the only real copy: skills, agents, commands
.claude         ->  .agents
.github/skills  ->  ../.agents/skills
```

`.agents` is the canonical tree. It is also the location most hosts read
natively, which is why it was chosen over any vendor-specific name. The links
exist only to close the gaps.

The links are **relative**, so a clone works at any path, and they point at
whole directories rather than individual skills. Adding a skill or an agent
needs no link work.

## Repository tree

```
agent-skills/
├── .agents/
│   ├── skills/                       # canonical skill tree
│   │   ├── twitter-followback/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   ├── twitter-moot-radar/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   ├── twitter-compatibility/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   ├── twitter-following-audit/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   ├── skill-verify/
│   │   │   └── SKILL.md
│   │   └── software-documentation/
│   │       └── SKILL.md
│   ├── agents -> ../.zcode/agents    # agent alias
│   └── commands -> ../.zcode/commands  # command alias
├── .zcode/
│   ├── agents/                       # real agent files
│   │   └── dotnet-practices-reviewer.md
│   ├── commands/                     # real command files
│   │   └── dotnet-practices-review.md
│   └── plans/                        # session-plan scratch; retained by placeholder
│       └── .gitignore
├── .claude -> .agents                # Claude Code: one link for skills, agents, commands
├── .github/
│   ├── skills -> ../.agents/skills   # GitHub Copilot
│   ├── agents -> ../.agents/agents   # GitHub Copilot custom agents
│   └── copilot-instructions.md -> ../AGENTS.md
├── agents/                           # cross-app *.agent.md definitions; placeholder kept
│   └── .gitignore
├── prompts/                          # agent-method prompt sources; placeholder kept
│   └── .gitignore
├── scripts/
│   ├── link-skills.sh                # macOS, Linux, Git Bash
│   └── link-skills.ps1               # Windows
├── docs/                             # human documentation, by audience
├── lode/                             # agent memory (Lode Coding)
├── AGENTS.md                         # generic agent guidance
├── CLAUDE.md                         # imports AGENTS.md for older Claude Code
└── README.md                         # high-level project overview
```

## Agents and commands

Skills are not the only artifact. Subagent definitions live in
`.zcode/agents/*.md` and their slash commands in `.zcode/commands/*.md` — the
directories ZCode reads natively and the one real copy. The same alias pattern
fans them out:

```
.zcode/agents/               the only real copy
.agents/agents    ->  ../.zcode/agents
.agents/commands  ->  ../.zcode/commands
.claude           ->  .agents               # whole directory, Claude Code
.github/agents    ->  ../.agents/agents     # Copilot custom agents
```

Every link is relative and committed, so Claude Code reaches the agents and
commands through the same `.claude -> .agents` symlink that serves its skills,
and GitHub Copilot reads them through `.github/agents` — a clone anywhere
resolves identically. The link scripts create and repair the `.claude` link;
the `.agents` and `.github/agents` aliases are committed directly and are not
script-managed. OpenCode, Codex, Cursor, and Gemini CLI have no subagent
directory in this layout; the command file also carries the fallback — a
runtime without subagents reads the agent definition and follows its procedure
directly.

## What each host reads

| Host | Native project location | Reads `.agents/skills` | Link needed |
| --- | --- | --- | --- |
| Claude Code | `.claude/skills` | No | Yes — `.claude -> .agents`, wired by default |
| GitHub Copilot | `.github/skills` | Yes | Preferred for code review |
| OpenCode | `.opencode/skills` | Yes | No |
| Codex | `.agents/skills` | Yes (walks to repo root) | No |
| Cursor | `.cursor/skills` | Yes | No |
| Gemini CLI | `.gemini/skills` | Yes (alias wins) | No |

Claude Code has no `.agents/skills` support at all, so its link is mandatory;
the whole-directory `.claude` symlink serves its skills, agents, and commands
at once. Copilot reads `.agents/skills` too, but its GitHub-hosted surfaces
look in `.github/skills`, so that link is the safe default.

The other host directories are deliberately **not** created by default. Those
hosts already read `.agents/skills`, and a second path means every skill can be
listed twice. See [Scripts](scripts.md) for opting in per host.

## Why not copy the tree

A copy per host is the obvious alternative and the wrong one:

- edits drift between copies, and nothing detects it;
- validation only proves one copy is correct;
- the repository gains noise that looks like content.

One tree plus links keeps a single source of truth that every host reads.

## Symlink mechanics

Git stores a symlink as a blob with mode `120000` and the target path as its
content. That is why the target must be relative; the [link scripts](scripts.md) check the
mode.

| Platform | Behaviour |
| --- | --- |
| Linux, macOS | Symlinks work out of the box; `link-skills.sh` creates them |
| Windows | Needs Developer Mode or elevation; the PowerShell script falls back to a directory junction |
| Any, `core.symlinks=false` | Git writes the target as a plain text file, so no skill is found |
| Archives, ZIP downloads | Links are flattened; re-run a link script after extracting |

### Recovering a clone without symlinks

A bad checkout leaves each link as a one-line text file holding its target:
`.claude` containing `.agents`, `.github/skills` containing
`../.agents/skills`. Both scripts recognise those placeholders and replace them
without a force flag:

```bash
./scripts/link-skills.sh
```

```powershell
./scripts/link-skills.ps1
```

See [Scripts](scripts.md) for the full option set.

## Related

- [Skills](../skills/README.md) — the catalog and the rules a skill must follow
- [Scripts](scripts.md) — wiring, flags, and recovery
- [Adopting this repo](adopting.md) — taking this layout into another project
