# Architecture

How one skill directory serves every agent host without being copied.

## The problem

Each assistant looks for skills in its own place. There is no single directory
that all of them read, and the overlapping ones overlap differently.

## The model

```
.agents/skills/          the only real copy
.claude/skills  ->  ../.agents/skills
.github/skills  ->  ../.agents/skills
```

`.agents/skills` is the canonical tree. It is also the location most hosts read
natively, which is why it was chosen over any vendor-specific name. The links
exist only to close the gaps.

The links are **relative**, so a clone works at any path, and they point at the
whole `skills` directory rather than an individual skill. Adding a skill needs no
link work.

## Repository tree

```
agent-skills/
├── .agents/
│   └── skills/                       # canonical source of truth
│       ├── twitter-followback/
│       │   ├── SKILL.md
│       │   └── references/
│       ├── twitter-moot-radar/
│       │   ├── SKILL.md
│       │   └── references/
│       └── skill-verify/
│           └── SKILL.md
├── .claude/
│   └── skills -> ../.agents/skills   # Claude Code
├── .github/
│   └── skills -> ../.agents/skills   # GitHub Copilot
├── scripts/
│   ├── link-skills.sh                # macOS, Linux, Git Bash
│   └── link-skills.ps1               # Windows
├── docs/                             # human documentation, by audience
├── lode/                             # agent memory (Lode Coding)
├── AGENTS.md                         # generic agent guidance
├── CLAUDE.md                         # imports AGENTS.md for older Claude Code
└── README.md                         # high-level project overview
```

## What each host reads

| Host | Native project location | Reads `.agents/skills` | Link needed |
| --- | --- | --- | --- |
| Claude Code | `.claude/skills` | No | Yes |
| GitHub Copilot | `.github/skills` | Yes | Preferred for code review |
| OpenCode | `.opencode/skills` | Yes | No |
| Codex | `.agents/skills` | Yes (walks to repo root) | No |
| Cursor | `.cursor/skills` | Yes | No |
| Gemini CLI | `.gemini/skills` | Yes (alias wins) | No |

Claude Code has no `.agents/skills` support at all, so its link is mandatory.
Copilot reads `.agents/skills` too, but its GitHub-hosted surfaces look in
`.github/skills`, so that link is the safe default.

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

A bad checkout leaves `.claude/skills` as a one-line text file containing
`../.agents/skills`. Both scripts recognise that placeholder and replace it
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
