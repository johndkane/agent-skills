# Agent instructions

This repository is maintained by agents as much as by people, so its rules are
written down in a file every agent loads at session start.

## The files

| File | Role |
| --- | --- |
| [`AGENTS.md`](../AGENTS.md) | The canonical instructions. Loaded by OpenCode, Codex, Cursor, Copilot CLI, and Claude Code (v2.1.277+) |
| [`CLAUDE.md`](../CLAUDE.md) | A single `@AGENTS.md` import, for older Claude Code and sessions that cannot read `AGENTS.md` directly |

`CLAUDE.md` is deliberately not a symlink. Claude Code's Edit and Write tools
refuse to write through a symlink, and a symlink checked out on Windows without
`core.symlinks` becomes a text file. The import avoids both problems, and Claude
does not read the content twice.

## What AGENTS.md covers

- **Purpose** — one canonical skill tree, linked for each host.
- **Invariants** — the rules that keep the repo portable: single copy, relative
  links at mode `120000`, no host-specific copies, standard frontmatter.
- **Adding and changing skills** — the exact steps, including the README row and
  the folder/`name` pairing.
- **Validation** — the `skills-ref` commands.
- **Checks** — what to verify before committing.
- **Direction** — how the catalog is meant to grow.
- **Lode Coding** — the knowledge-management method described on the
  [Lode page](lode/system-prompt.md).

## Editing instructions

- Change repo rules in `AGENTS.md`. Leave `CLAUDE.md` as the import unless a
  Claude-only rule is genuinely needed.
- Keep `AGENTS.md` concrete and testable: "run `skills-ref validate`" beats "make
  sure the skill is valid".
- Do not duplicate the [skills pages](skills/README.md) or the
  [script reference](scripts.md) inside `AGENTS.md`. Link to them instead, so a
  rule has one home.

## Docs and lode are different things

| Directory | Owner | Purpose |
| --- | --- | --- |
| `docs/` | Humans | Explain the project to readers |
| `lode/` | Agents | Persistent project memory across sessions |

Do not move lode content into `docs/`, and do not turn `docs/` into an agent
scratchpad. When the project changes, update the human docs for accuracy and the
lode for agent recall.

## Related

- [Lode Coding](lode/system-prompt.md) — the full system prompt
- [Architecture](architecture.md) — the layout the invariants protect
- [Skills](skills/README.md) — what agents add here
