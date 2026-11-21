# Getting skills

A skill is a folder an agent loads when your request matches it. Getting one
means putting that folder where your agent looks. You do not need to change
anything else.

## Ask your agent

Point your agent at the skill and ask it to install it:

> Install `<skill-name>` for me.

Your agent reads the skill's `SKILL.md` and copies the folder into whichever
directory its own host reads. This works for any host that reads a skills
directory.

## Copy the folder yourself

If you already have the skill folder, copy it into your agent's skills directory:

| Agent | Put the folder in |
| --- | --- |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` |
| GitHub Copilot | `.github/skills/`, `.claude/skills/`, or `.agents/skills/` |
| OpenCode | `.opencode/skills/` or `.claude/skills/` |
| OpenAI Codex | `.agents/skills/` (walks up to the project root) |
| Cursor | `.cursor/skills/`, `.agents/skills/`, or `.claude/skills/` |
| Gemini CLI | `.gemini/skills/` or `.agents/skills/` |

The folder is the install unit. Keep its name: the frontmatter `name` must match
it, and that name is how the agent addresses the skill.

## Account-based surfaces

Claude Cowork and cloud sessions load the skills enabled for your claude.ai
account. Enable the skill in **Customize > Skills**; it is then available on
desktop, web, and mobile without copying a folder.

## Next

- [Using skills](invoking.md) — how to invoke a skill in each app
- [User guide](README.md) — which skill to choose and what it needs
