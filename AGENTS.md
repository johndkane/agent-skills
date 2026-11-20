# AGENTS.md

Instructions for agents working in this repository. Read this before changing the
skill tree, the links, the scripts, or the README.

## Purpose

This repository is a portable catalog of Agent Skills. One real copy of every
skill lives in `.agents/skills/`; thin links make that same copy visible to hosts
that look elsewhere. The goal is a single tree that works in Claude Code and
Cowork, GitHub Copilot, OpenCode, Codex, Cursor, and Gemini CLI without
duplicating content.

Skills are task-scoped, not repo-scoped. A skill here may be a development
workflow, a research task, or a desktop procedure.

## Layout

```
.agents/skills/<name>/SKILL.md   the only copy of a skill
.claude/skills -> ../.agents/skills
.github/skills -> ../.agents/skills
scripts/link-skills.sh           macOS, Linux, Git Bash, WSL
scripts/link-skills.ps1          Windows PowerShell
CLAUDE.md                        imports AGENTS.md for older Claude Code
```

## Invariants

Breaking these breaks every host at once. Do not change them without an explicit
request.

1. `.agents/skills/<name>/SKILL.md` is the only copy. Never duplicate a skill
   into a host-specific directory.
2. `.claude/skills` and `.github/skills` are relative symlinks to
   `../.agents/skills`. Never replace them with real directories and never commit
   a copy of the tree.
3. Symlink targets stay relative. Git must record both as mode `120000`.
4. Never add `.agents/`, `.claude/skills`, or `.github/skills` to `.gitignore`.
5. Do not add `.opencode/skills`, `.cursor/skills`, `.codex/skills`, or
   `.gemini/skills`. Those hosts already read `.agents/skills`, and a second path
   surfaces every skill twice.
6. `name` matches the directory name exactly: lowercase kebab-case, 1-64 chars,
   no leading, trailing, or doubled hyphens.
7. Frontmatter stays within the standard: `name`, `description`, `license`,
   `compatibility`, `metadata`, `allowed-tools`. Host-specific fields are allowed
   but must never be load-bearing.
8. The repository stays droppable into another project: no build step, no
   generated artifacts, no dependencies to install.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`. The folder name is the ID.
2. Write frontmatter with `name` equal to the folder and a `description` that
   says what the skill does, when to use it, and what it is not for. Front-load
   trigger words; some hosts shorten long descriptions.
3. Keep the body under 500 lines. Move detail into `references/`, `scripts/`, or
   `assets/` beside `SKILL.md` and reference them by relative path.
4. Add a bullet under "The skills" in `README.md` with what it does, what
   triggers it, and what it needs to run.
5. Run the validation in the next section.
6. No link work is needed: both links point at the whole directory.

## Changing or removing a skill

- Rename by renaming the folder **and** the frontmatter `name`, then update the
  README bullet. Never leave them out of sync.
- Remove by deleting the folder and its README bullet.
- Never edit files through `.claude/skills` or `.github/skills`. They are links;
  edit the canonical path.

## Validation

Use the reference implementation, not judgement alone:

```bash
python -m venv .venv
.venv/bin/pip install "git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref"
.venv/bin/skills-ref validate .agents/skills/<name>
```

On Windows use `.venv\Scripts\pip` and `.venv\Scripts\skills-ref.exe`.
`validate` must report `Valid skill`. `read-properties` and `to-prompt` show
exactly what a host advertises.

## Checks before committing

- [ ] `name` matches the folder and is lowercase kebab-case.
- [ ] `description` states what, when, and the exclusions, within 1024 chars.
- [ ] `SKILL.md` is under 500 lines and `skills-ref validate` passes.
- [ ] The README bullet exists and matches the skill's real requirements.
- [ ] `git ls-files -s` still shows `120000` for both links.
- [ ] `bash -n scripts/link-skills.sh` passes and both scripts report `ok`.
- [ ] No secrets, `.env` files, or generated artifacts are staged.

## Direction

- Grow the catalog one folder per skill. Never restructure the tree per skill.
- Keep the README skill-agnostic above the list. Do not name a specific skill in
  the intro; the list is the catalog.
- Add a host directory only when that host genuinely cannot read
  `.agents/skills`. When you do, add a link, a README row, and a `.gitignore`
  note.
- Keep `link-skills.sh` and `link-skills.ps1` behaviourally identical: idempotent,
  `--force`/`-Force` to replace, and self-healing for placeholder files left by a
  `core.symlinks=false` checkout.
- Prefer portability over host-specific features, and describe limits in
  `compatibility` instead of assuming a capable runtime.

## Commands

```bash
./scripts/link-skills.sh      # macOS, Linux, Git Bash, WSL
./scripts/link-skills.ps1     # Windows PowerShell or pwsh
```
