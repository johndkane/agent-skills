# Terminology

- **Agent Skill** — a folder containing `SKILL.md` plus optional resources, loaded by a host when relevant.
- **SKILL.md** — the required entry file: YAML frontmatter plus instructions.
- **Canonical tree** — `.agents/skills`, the only real copy of every skill in this repository; it is not a required install location.
- **Skill family** — skills that share behavior under one contract page, mirrored into each body and never linked to at runtime.
- **Repo-maintenance skill** — a skill that checks or changes this repository; it may name repo paths it checks, but still links only inside its own folder.
- **Progressive disclosure** — loading `name` and `description` at startup, the `SKILL.md` body on activation, and `references/`, `scripts/`, or `assets/` files only when the body names them.
- **Reference file** — a focused document under `references/` holding detail too dense for the body; named by `SKILL.md`, one level deep.
- **Install copy** — one skill folder copied into a host's skills directory; it must work with no other file from this repository present.
- **Skill identity** — the folder name plus the `SKILL.md` inside it; the directory a host installs it into is never part of its identity.
- **Host** — an assistant or agent product that reads skills from disk.
- **Agent link** — a relative symlink to `../.agents/skills` placed where a host looks.
- **Wiring** — creating those links for a chosen set of hosts.
- **Default wiring** — `claude` plus `copilot`, the hosts that cannot rely on `.agents/skills`.
- **Opt-in host directory** — a native host directory created only when named or when `--all` is used.
- **Frontmatter** — the YAML block at the top of `SKILL.md`.
- **Description** — the frontmatter field hosts read before deciding to load a skill.
- **skills-ref** — the official reference validator from the Agent Skills project; it checks frontmatter and naming only.
- **Repo gate** — a skill that enforces this repository's catalog rules on top of the official validator; `skill-verify` is the only one.
- **Docs** — `docs/`, the human wiki.
- **Lode** — `lode/`, this agent-owned memory.
- **Protected account** — an X account that hides its posts until it approves a follow request.
- **Moot** — a person the user follows who follows back; the only source for `twitter-moot-radar`.
- **Overlap** — the count of distinct moots following a candidate; it ranks a suggestion, never proves an interest.
- **Interest profile** — the user's named areas plus strictness, overlap bar, and exclusions; it gates and ranks suggestions.
- **Source set** — the moots whose Following lists surfaced a candidate; it grows during a harvest and is reused across interest changes.
- **Proof standard** — a quoted post or bio line with date and permalink, the moots behind it, and a live `Follow` control reading; no suggestion without it.
- **Near miss** — a high-overlap candidate without readable interest evidence, listed separately so the user can overrule the rubric.
- **Pending** — the control state after requesting to follow a protected account; a request, not a follow.
- **Settle window** — the period after a click before judging whether the UI changed: checkpoints through roughly 30 seconds, then re-reads near 60 and 120 seconds, because a flip can land near two minutes.
- **Unreadable** — a page that rendered a notice instead of a profile, such as a sensitive-content interstitial; recorded as a verdict with a reason, never inferred from.
- **Follow-up pass** — the start-of-run check of due pending requests and unverified clicks.
- **Run state file** — per-account local JSON at `~/.x-<skill>/` holding the criteria or interests in force, cursor, queue, verdicts, and follow-ups; it persists between runs and is the only place a real handle or private detail is written.
- **Placeholder handle** — a fictional handle such as `@alice` used in skill text, docs, and examples; real handles exist only in the run state file.
- **Human cadence** — jittered waits, scroll steps, pointer moves, and dwell times drawn from ranges so a run does not read as a fixed click rhythm.
- **X core contract** — [`docs/skills/twitter-core.md`](../docs/skills/twitter-core.md), the authoring home for rules shared by every browser-driven X skill; skill bodies mirror it and never link to it.

Related: [summary](summary.md), [practices](practices.md).
