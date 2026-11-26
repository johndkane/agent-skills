# Summary

This repository is a portable catalog of Agent Skills for AI assistants. A skill
is written once under `.agents/skills/<name>/SKILL.md`; relative symlinks at
`.claude` (whole directory) and `.github/skills` expose that tree to hosts that
cannot read it directly. OpenCode, Codex, Cursor, and Gemini CLI read `.agents/skills`
natively, so they need no link unless a project opts in. Two behaviourally
identical scripts, `scripts/link-skills.sh` and `scripts/link-skills.ps1`, create
or repair those links for the hosts a project names. Skills that share behavior
form groups: group-named central files live in `docs/skills/`, and the operative
rules are copied verbatim into each member. Subagent definitions and their slash
commands live in `.zcode/agents` and `.zcode/commands` with committed aliases
reaching Claude Code and GitHub Copilot. `AGENTS.md` is generic and reusable;
this lode holds the project-specific rules and rationale. `README.md` is the
high-level entry point, and `docs/` explains the repository to humans by audience.

Related: [lode-map](lode-map.md), [layout](layout/summary.md),
[documentation](documentation/summary.md), [skills](skills/summary.md),
[scripts](scripts/summary.md).
