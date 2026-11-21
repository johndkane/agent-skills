# Skills

A skill is one folder, addressed by its folder name. In this repository those
folders live under `.agents/skills`; when installed, a folder is copied into
whatever directory the host reads, and the folder name still equals the
frontmatter `name`.

## Contract

```yaml
---
name: kebab-case-name
description: What it does, when to use it, and what it is not for.
compatibility: Optional runtime requirements.
---
```

Rules:

- `name` is lowercase kebab-case, 1-64 characters, no leading, trailing, or
  doubled hyphens, and matches the folder.
- `description` is at most 1024 characters and front-loads trigger words.
- The body is terse and behavior-complete: aim ~200–300 lines and under ~3,000
  tokens; 500 lines / 5,000 tokens is the ceiling. Cut motivation prose,
  repetition, and restated examples before cutting a rule. Dense detail moves to
  `references/`, executable helpers to `scripts/`, static templates to `assets/`.
- Frontmatter stays within the Agent Skills standard: `name`, `description`,
  `license`, `compatibility` (max 500), `metadata` (string map), `allowed-tools`
  (experimental).
- A folder is a complete install. Index files reference only files inside it, by
  relative path from `SKILL.md`; no host path or repository path appears in a
  skill body, because the skill may be copied somewhere else entirely.

## Progressive disclosure

```text
startup    -> name + description (~100 tokens per skill)
activation -> the whole SKILL.md body
on demand  -> references/, scripts/, assets/, only when SKILL.md names them
```

The body is not a container for everything. Schemas, long tables, vendor lore,
and worked examples move to a focused `references/` file, one level deep, with a
line in `SKILL.md` saying what it holds and when to read it. Flat files, not
nested chains: some hosts search two levels and discover a limited set of
extensions.

The two X skills follow this shape: state schemas live in
`references/state-file.md`, and the follow-back UI ladder and the suggestion card
live in their own reference files.

## Authoring flow

```text
create folder -> write SKILL.md -> add README bullet -> validate -> hand off
```

## Validation

```bash
.venv/bin/skills-ref validate .agents/skills/<name>
```

`validate` must report `Valid skill`. `read-properties` and `to-prompt` show what
a host actually advertises.

The catalog's browser-driven X skills share
[`docs/skills/twitter-core.md`](../../docs/skills/twitter-core.md) as their
contract. `twitter-followback` is documented in
`docs/skills/twitter-followback.md` with its run-state contract in
[twitter-followback.md](twitter-followback.md); `twitter-moot-radar` in
`docs/skills/twitter-moot-radar.md` with its entry in
[twitter-moot-radar.md](twitter-moot-radar.md).

Invocation syntax is host-specific: Claude Code, Copilot, and Cursor use
`/skill-name`, OpenCode uses `@skill-id`, Codex uses `$skill-name`, and Gemini CLI
activates skills through the agent with consent. OpenCode's `/` menu is commands
only. The full matrix is
[`docs/skills/invoking.md`](../../docs/skills/invoking.md).

Related: [layout](../layout/summary.md), [practices](../practices.md).
