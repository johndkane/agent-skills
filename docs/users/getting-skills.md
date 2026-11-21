# Getting skills

A skill is just a folder of instructions. "Getting" one means putting that
folder where your agent looks — that's the whole installation. Nothing else to
change or configure.

## Ask your agent

The easiest way: point your agent at the skill and ask.

> Install `<skill-name>` for me.

Your agent reads the skill's `SKILL.md` and copies the folder to wherever its
own app looks for skills. This works for any app that reads a skills directory.

## Copy the folder yourself

If you already have the skill folder, copy it into your app's skills directory:

| App | Put the folder in |
| --- | --- |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` |
| GitHub Copilot | `.github/skills/`, `.claude/skills/`, or `.agents/skills/` |
| OpenCode | `.opencode/skills/` or `.claude/skills/` |
| OpenAI Codex | `.agents/skills/` (it searches up to the project root) |
| Cursor | `.cursor/skills/`, `.agents/skills/`, or `.claude/skills/` |
| Gemini CLI | `.gemini/skills/` or `.agents/skills/` |

Copy the folder whole and keep its name — the name inside the skill file has to
match the folder name, and that name is how you and your agent refer to it.

## Account-based surfaces

Claude Cowork and cloud sessions don't read folders from your machine. They use
the skills enabled for your claude.ai account: turn the skill on under
**Customize > Skills**, and it's available on desktop, web, and mobile without
copying anything.

## Next

- [Using skills](invoking.md) — how to call a skill up in each app
- [User guide](README.md) — which skill to choose and what it needs
