# Terminology

- **Agent Skill** — a folder containing `SKILL.md` plus optional resources, loaded by a host when relevant.
- **SKILL.md** — the required entry file: YAML frontmatter plus instructions.
- **Canonical tree** — `.agents/skills`, the only real copy of every skill.
- **Host** — an assistant or agent product that reads skills from disk.
- **Agent link** — a relative symlink to `../.agents/skills` placed where a host looks.
- **Wiring** — creating those links for a chosen set of hosts.
- **Default wiring** — `claude` plus `copilot`, the hosts that cannot rely on `.agents/skills`.
- **Opt-in host directory** — a native host directory created only when named or when `--all` is used.
- **Frontmatter** — the YAML block at the top of `SKILL.md`.
- **Description** — the frontmatter field hosts read before deciding to load a skill.
- **skills-ref** — the reference validator from the Agent Skills project.
- **Docs** — `docs/`, the human wiki.
- **Lode** — `lode/`, this agent-owned memory.
- **Protected account** — an X account that hides its posts until it approves a follow request.
- **Pending** — the control state after requesting to follow a protected account; a request, not a follow.
- **Settle window** — the up-to-30-second pause after a click before judging whether the UI changed.
- **Follow-up pass** — the start-of-run check of due pending requests and unverified clicks.
- **Run state file** — per-account local JSON at `~/.x-followback/` holding the cursor, pending queue, verdicts, and follow-ups.

Related: [summary](summary.md), [practices](practices.md).
