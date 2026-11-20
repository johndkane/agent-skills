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
docs/                            human wiki (this file's companion)
lode/                            agent memory, created on request (see Lode Coding below)
```

Other host directories (`.opencode/skills`, `.cursor/skills`, `.gemini/skills`)
exist only when the link script was explicitly told to wire them.

## Invariants

Breaking these breaks every host at once. Do not change them without an explicit
request.

1. `.agents/skills/<name>/SKILL.md` is the only copy. Never duplicate a skill
   into a host-specific directory.
2. Every agent link is a relative symlink to `../.agents/skills`. Never replace
   one with a real directory and never commit a copy of the tree.
3. Symlink targets stay relative. Git must record every link as mode `120000`.
4. Never add `.agents/` or any agent link to `.gitignore`.
5. Default wiring is `claude` + `copilot`. `.opencode/skills`, `.cursor/skills`,
   and `.gemini/skills` are opt-in, because those hosts already read
   `.agents/skills` and a second path surfaces every skill twice. Never commit an
   opt-in link without a reason.
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
6. No link work is needed: the links point at the whole directory.

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
- [ ] `git ls-files -s` still shows `120000` for every link.
- [ ] `bash -n scripts/link-skills.sh` passes and both scripts report `ok`.
- [ ] No secrets, `.env` files, or generated artifacts are staged.

## Direction

- Grow the catalog one folder per skill. Never restructure the tree per skill.
- Keep the README skill-agnostic above the list. Do not name a specific skill in
  the intro; the list is the catalog.
- Add a host directory only when that host genuinely cannot read
  `.agents/skills`. When you do, add a link, a README row, and a `.gitignore`
  note.
- Keep `link-skills.sh` and `link-skills.ps1` behaviourally identical: the same
  environment names and aliases, `claude` + `copilot` by default, `--all`/`-All`
  for every host, `--force`/`-Force` to replace, and self-healing for placeholder
  files left by a `core.symlinks=false` checkout.
- Prefer portability over host-specific features, and describe limits in
  `compatibility` instead of assuming a capable runtime.

## Lode Coding

You are responsible for managing project knowledge using the
[Lode Coding](https://fjzeit.github.io/coding/lode-coding) method.

Lode Coding: all persistent project memory lives in a structured, AI-owned
markdown repository called the Lode at `lode/`. The Lode is the AI's perfect
memory and the only way to stay aligned over weeks and months.

### Core principles you never break

- The human owns the code and makes final decisions. You are the memory and
  high-speed executor.
- Anything worth implementing is worth permanently recording in the Lode.
- The Lode is for YOU (the AI). Summarize lode contents rather than dumping them
  verbatim, unless the user requests a specific file by path.

### Authority inside lode/

- You may freely create, update, rename, move, or delete files.
- You may create new top-level directories when the project evolves.
- You may delete a file only if it exists in the repo and has no uncommitted
  changes.
- All diagrams must be Mermaid only.
- If lode content contradicts actual code, summarize the disparity, prioritize
  the code as the source of truth, and ask the user to confirm your suggested
  lode fix.

### Mandatory structure (create missing parts as needed)

```text
lode/
    summary.md               # one-paragraph living snapshot
    terminology.md           # short (term - meaning) lines for the domain language
    practices.md             # patterns and practices relevant to this project
    lode-map.md              # hierarchical index of all lode files
    plans/                   # roadmaps & TODOs
    tmp/                     # git-ignored session scraps
    [any-domain]/            # e.g. scripts/, skills/, layout/
        summary.md + *.md    # one focused topic per file (kebab-case)
```

### Every lode file must

- cover exactly one topic
- contain concrete examples and Mermaid diagrams
- link to related lodes with relative paths
- document invariants, contracts, rationale, and lessons learned
- stay under 250 lines; if larger, decompose into focused sub-files

### Mandatory workflow (gently enforce)

1. Seed sessions with the most relevant lode files.
2. Use chat mode for exploration and design; never jump straight to code.
3. Implement only after a clear decision.
4. The instant the user says "looks good / ship it / this is final", immediately
   update or create the corresponding lode entries so the Lode reflects reality.
5. After big changes, check whether the lode structure still mirrors the codebase
   and refactor if needed.

### Recurring nudges you should use naturally

- "Let's capture this design in `lode/` before implementing."
- "Per Lode Coding, chat-mode first, then agent-mode."
- "Now that this is settled, I'll update the lode so we never forget."

### Important behaviours

- Session scraps go in `lode/tmp/` (git-ignored).
- Only permanent learnings go in the main lode files.
- If you are documenting something needed in future sessions, it goes in the
  lode. If it is just how you solved today's problem, it stays in chat.
- The lode describes the current state of the system. Do not leave summaries of
  completed work; update the lode to match reality.
- Your performance over time is determined by the quality of your code and the
  Lode.
- After completing any request that modifies behaviour or structure, immediately
  update the corresponding lode file before moving to the next task.
- Your success is measured by lode accuracy after each session: the lode must
  reflect current system state, not a history of changes.

Example entry after adding retry logic to an API client:

```text
BAD (changelog style):
  "Added retry logic to api-client.ts on 2024-01-15. Previously requests would
   fail immediately. Now they retry 3 times with exponential backoff."

GOOD (current state):
  "The API client retries failed requests up to 3 times with exponential
   backoff (100ms, 200ms, 400ms). Retries apply only to 5xx and network errors;
   4xx responses fail immediately."
```

If you need to capture changelog-style information, save it in `lode/tmp/`.

### Session handovers

When the user requests a handover, create a handover document in `lode/tmp/`
capturing current task state, decisions made, approaches tried, blockers, and
next steps, so a fresh session can continue without losing momentum.

At session start, read `lode/lode-map.md`, `lode/terminology.md`, and
`lode/summary.md`. Before exploring the codebase or searching for files, ALWAYS
check `lode/lode-map.md` first; it is the index to all project documentation.
When the session starts, briefly show that you have domain knowledge before
attending to the first request.

If `lode/` does not exist, ask the user whether you should create one.

### This repository

- `docs/` is the human wiki. `lode/` is agent memory. Do not mix them.
- `lode/tmp/` is git-ignored.
- The Lode describes this repository: the canonical skill tree, the links, the
  scripts, and the rules in this file.

## Commands

```bash
./scripts/link-skills.sh                  # claude + copilot (default)
./scripts/link-skills.sh cursor           # one host
./scripts/link-skills.sh --all --force    # every host, replace anything odd
```

```powershell
./scripts/link-skills.ps1 -All
./scripts/link-skills.ps1 claude cursor -Force
```
