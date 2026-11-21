# Agent instructions

This repository is maintained by agents as much as by people. The instruction
surface is split in two: `AGENTS.md` holds generic guidance that works in any
repository, and `lode/` holds the rules that are specific to this project.

## The files

| File | Role |
| --- | --- |
| [`AGENTS.md`](../../AGENTS.md) | Generic, repository-agnostic agent guidance. Loaded by OpenCode, Codex, Cursor, Copilot CLI, and Claude Code (v2.1.277+) |
| [`CLAUDE.md`](../../CLAUDE.md) | A single `@AGENTS.md` import, for older Claude Code and sessions that cannot read `AGENTS.md` directly |
| [`lode/lode-map.md`](../../lode/lode-map.md) | Index of the project-specific guidance and agent memory |

`CLAUDE.md` is deliberately not a symlink. Claude Code's Edit and Write tools
refuse to write through a symlink, and a symlink checked out on Windows without
`core.symlinks` becomes a text file. The import avoids both problems, and Claude
does not read the content twice.

## What lives where

| Topic | Home |
| --- | --- |
| Working with the human, verification, git, secrets, documentation surfaces | [`AGENTS.md`](../../AGENTS.md) |
| Repository layout, links, invariants, link checks | [`lode/layout/summary.md`](../../lode/layout/summary.md) |
| Skill contract, design rules, authoring, validation, checks | [`lode/skills/summary.md`](../../lode/skills/summary.md) |
| Skill groups and the copy rule | [`lode/skills/groups.md`](../../lode/skills/groups.md) |
| Link scripts | [`lode/scripts/summary.md`](../../lode/scripts/summary.md) |
| Documentation surfaces and audiences | [`lode/documentation/summary.md`](../../lode/documentation/summary.md) |
| Open directions | [`lode/plans/roadmap.md`](../../lode/plans/roadmap.md) |
| Per-app technical limits | [Host differences](hosts.md) |
| Skill authoring reference | [Skills](../skills/README.md) |

## Why the split

`AGENTS.md` can be copied into another repository unchanged. Anything that only
makes sense here — the canonical skill tree, the host links, the link scripts,
the catalog rules, the validation commands — belongs in the lode. An agent reads
`AGENTS.md` at session start, then loads the relevant lode entries from the map.

## Editing instructions

- Add a generic rule to `AGENTS.md`.
- Add a project rule to the lode entry that owns the topic, then register the file
  in `lode/lode-map.md`.
- Do not put project details in `AGENTS.md`, and do not duplicate the
  [skills pages](../skills/README.md) or the
  [script reference](../operators/scripts.md) in either place. Link instead, so a
  rule has one home.
- If a user or operator page needs a project rule, state it in human terms and
  link to the developer page that owns the explanation. Do not link it into the
  lode.
- Keep `AGENTS.md` terse: it loads every session, and the embedded Lode prompt is
  fixed. Compress wording, never a rule, and move any detail that grows into the
  lode.
- The Lode Coding prompt is embedded verbatim in `AGENTS.md`; do not paraphrase
  it. It is generic, so it belongs there.

## A live repository

The project can change while an agent is working. A developer may edit a file,
rewrite this page, add a rule, or commit in parallel. Agents re-read before
acting on a stale view, treat unfamiliar edits as work in progress, and adapt to
the current state rather than reverting it. See
[`AGENTS.md`](../../AGENTS.md#working-rules) for the full rule.

## Git is read-only by default

Agents may inspect history and state at any time. They change repository state
only when the user explicitly asks for a write operation; a task request is not a
commit request. The query and write lists are in
[`AGENTS.md`](../../AGENTS.md#git).

## No secrets or personal data

Repository files and commit messages use fictional placeholders such as `@example_alice`
or `example.com`. Real identity and account data belong in runtime state outside
the repository. The full rule is in
[`AGENTS.md`](../../AGENTS.md#secrets-and-personal-data).

## Documentation surfaces

| Surface | Owner | Purpose |
| --- | --- | --- |
| [`AGENTS.md`](../../AGENTS.md) | Agents | Generic working rules, independent of project contents. |
| [`README.md`](../../README.md) | Visitors | High-level overview: what the repo is, what it contains, and where to start. |
| [`docs/`](../README.md) | Humans | All generated documentation for users, operators, and developers. |
| [`lode/`](../../lode/lode-map.md) | Agents | Project-specific guidance and persistent memory. |

- `README.md` answers "what is this?" in a screen or two and links into `docs/`.
  Deep detail never returns to it; it goes on the audience page that owns it.
- `docs/` is organized by audience: `users/` for choosing, getting, and using
  skills; `operators/` for layout, wiring, and adoption; `developers/` for repo
  rules, lode, and technical host detail; and `skills/` for the authoring
  reference.
- A behavior has one home in `docs/`. Other pages link to it instead of
  restating it, so a change updates one page.
- User and operator pages link only to human pages. They never link into `lode/`
  or `AGENTS.md`; a developer page may, to explain an agentic mechanism or
  practice.
- `lode/` starts at `lode/lode-map.md`. Do not move lode content into `docs/`, and
  do not turn `docs/` into an agent scratchpad.
- When the project changes, update the human docs for accuracy and the lode for
  agent recall.

## Related

- [Lode Coding](lode-coding.md) — the full system prompt
- [Architecture](../operators/architecture.md) — the layout the invariants protect
- [Skills](../skills/README.md) — what agents add here
