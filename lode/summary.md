# Summary

This repository is a portable catalog of Agent Skills for AI assistants. A skill
is written once under `.agents/skills/<name>/SKILL.md`; relative symlinks at
`.claude/skills` and `.github/skills` expose that same tree to hosts that cannot
read it directly. OpenCode, Codex, Cursor, and Gemini CLI read `.agents/skills`
natively, so they need no link unless a project opts in. Two behaviourally
identical scripts, `scripts/link-skills.sh` and `scripts/link-skills.ps1`, create
or repair those links for the hosts a project names. Skills that share behavior
form groups: group-named central files live in `docs/skills/`, and the operative
rules are copied verbatim into each member. `docs/` explains the repository to
humans; this lode is the agent's memory of why it is built this way.

Related: [lode-map](lode-map.md), [layout](layout/summary.md),
[skills](skills/summary.md), [scripts](scripts/summary.md).
