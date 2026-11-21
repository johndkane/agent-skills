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
- **Skill design rules** — portability, progressive disclosure, terse writing,
  runtime data, and behavior standards for every skill.
- **Skill families** — one contract page, copied into every member body, updated
  in one change.
- **Verifying skill changes** — run the `skill-verify` skill before handoff.
- **Validation** — the `skills-ref` commands.
- **Checks** — what to verify before handing off.
- **Git** — read-only by default: query allowed; writes only on explicit request.
- **Direction** — how the catalog is meant to grow.
- **Lode Coding** — the upstream system prompt, embedded verbatim from
  <https://raw.githubusercontent.com/fjzeit/lode/refs/heads/main/prompts/SystemPrompt.txt>
  so it needs no network access. Explained on the [Lode page](lode-coding.md).

## Editing instructions

- Change repo rules in `AGENTS.md`. Leave `CLAUDE.md` as the import unless a
  Claude-only rule is genuinely needed.
- Keep `AGENTS.md` concrete and testable: "run `skills-ref validate`" beats "make
  sure the skill is valid".
- Do not duplicate the [skills pages](skills/README.md) or the
  [script reference](scripts.md) inside `AGENTS.md`. Link to them instead, so a
  rule has one home.
- The Lode Coding prompt is the one exception: it is embedded verbatim, because
  agents must have it in every session. Do not paraphrase it.

## Git is read-only by default

Agents may inspect history and state at any time. They change repository state
only when the user explicitly asks for a write operation; a task request is not a
commit request.

- **Query any time:** `status`, `diff`, `log`, `show`, `ls-files`, `check-ignore`,
  `blame`, `rev-parse`, `describe`.
- **Only when asked:** `add`, `commit`, `push`, `pull`, `fetch`, `merge`,
  `rebase`, `reset`, `checkout`, `switch`, `restore`, `stash`, `tag`, `clean`,
  `branch` changes, `remote` changes, `config` writes, `init`, `worktree`.

When work is done, report what should be committed and stop, unless the user
asked for the commit.

## Docs and lode are different things

| Directory | Owner | Purpose |
| --- | --- | --- |
| `docs/` | Humans | Explain the project to readers |
| `lode/` | Agents | Persistent project memory across sessions |

The lode starts at `lode/lode-map.md`.

Do not move lode content into `docs/`, and do not turn `docs/` into an agent
scratchpad. When the project changes, update the human docs for accuracy and the
lode for agent recall.

## Related

- [Lode Coding](lode-coding.md) — the full system prompt
- [Architecture](architecture.md) — the layout the invariants protect
- [Skills](skills/README.md) — what agents add here
