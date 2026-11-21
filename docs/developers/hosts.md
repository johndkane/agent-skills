# Host differences

The same skill files behave differently in each app. These are the differences
that change what you write, where you put it, and how you invoke it.

Explicit invocation is host-specific: Claude Code, Copilot, and Cursor use
`/skill-name`, Codex uses `$skill-name`, and OpenCode uses `@skill-id` — its `/`
menu is commands only. The full syntax table is on
[Invoking skills](../users/invoking.md).

## All hosts

- `name` must be lowercase kebab-case (`[a-z0-9-]`, 1–64 chars, no leading,
  trailing, or doubled hyphens) and must match the directory name.
- `description` is required and capped at 1024 chars. Front-load the use case and
  trigger words; this is the only text most agents see before activating a skill.
- `SKILL.md` is loaded in full on activation. Keep it under 500 lines and
  ~5,000 tokens, and move detail into `references/`.
- Name collisions resolve differently everywhere (Claude Code: enterprise →
  personal → project; OpenCode: later source wins; Codex: both are listed). Keep
  names unique.

## Claude Code

- Reads only `.claude/skills`, in the repo and every parent directory, plus
  `.claude/skills` in any `--add-dir` directory. `.agents/skills` alone is
  invisible to it.
- Symlinked skill folders are officially supported and loaded once even when
  several paths point at the same target.
- `description` + `when_to_use` are truncated at 1,536 chars in the skill list.
- Supports extra frontmatter the others ignore: `allowed-tools`,
  `disable-model-invocation`, `when_to_use`, `context: fork`, `paths`, `model`.

## Claude Cowork and cloud sessions

- These do not read `~/.claude/skills` on your machine. They load the skills
  enabled for your claude.ai account, synced to `~/.claude/skills/synced/`.
- A repository's `.claude/skills` is not available in a project's cloud threads.
  Desktop scheduled tasks run locally and do load local skills.
- Synced skills are not executed with local privileges: `!` command injection,
  `@` file references, and `${CLAUDE_PROJECT_DIR}` placeholders reach the model
  as literal text in terminal and VS Code sessions. Write skills that still make
  sense without them.

## GitHub Copilot

- Accepts `.github/skills`, `.claude/skills`, and `.agents/skills` in a repo;
  `~/.copilot/skills` and `~/.agents/skills` for personal skills.
- Copilot code review and the cloud agent read `.github/skills` by convention —
  that is why this repository keeps that link even though Copilot also reads
  `.agents/skills`.
- The file must be named exactly `SKILL.md`.
- `allowed-tools: shell` removes the confirmation prompt before running terminal
  commands. Only set it for skills you have fully reviewed.

## OpenCode

- Native location is `.opencode/skills`; `.claude/skills` and `.agents/skills` are
  compatibility sources with lower precedence.
- The skill ID is the path, not the frontmatter `name`, and it is case-sensitive.
- A flat `skills/<name>.md` also works, but the directory form is needed for
  supporting files.
- Invoke with `@skill-id` in the prompt. The `/` menu is for commands, not
  skills; `/skill-name` will not match.

## OpenAI Codex

- Scans `.agents/skills` from the working directory up to the repository root,
  and supports symlinked skill folders.
- The initial skill list is capped at ~2% of the context window, so long
  descriptions get shortened or dropped. Put trigger words first.
- Optional `agents/openai.yaml` adds display metadata and
  `policy.allow_implicit_invocation`.

## Cursor

- Reads `.agents/skills` and `.cursor/skills`, plus `.claude/skills` and
  `.codex/skills` for compatibility.
- Walks skill directories recursively, so category folders are allowed; the
  folder containing `SKILL.md` is the skill.
- Extra frontmatter: `paths` (glob scoping), `icon`, `color`.

## Gemini CLI

- Reads `.gemini/skills` or the `.agents/skills` alias; within a tier the alias
  wins.
- Activation requires a user consent prompt before the skill body is injected.

## Related

- [Getting skills](../users/getting-skills.md) — where each host reads a folder
- [Invoking skills](../users/invoking.md) — explicit syntax and why `/` is not universal
- [Skills](../skills/README.md) — the catalog and the spec rules
