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
lode/                            agent memory (see Lode Coding below)
```

Other host directories (`.opencode/skills`, `.cursor/skills`, `.gemini/skills`)
exist only when the link script was explicitly told to wire them.

## A live repository

Developers edit this project while agent sessions run: files, skills, docs, lode
entries, and even this file can change mid-session. That is expected, not
corruption.

- Re-read a file before acting on it when your last read may be stale. The disk is
  the source of truth, not your earlier context.
- Treat unfamiliar edits as the developer's work in progress. Do not revert,
  overwrite, or "restore" changes you did not make.
- If a change conflicts with your task, adapt to the current state and say what
  changed; ask only when the intent is unclear.
- When a tool result no longer matches what you read, snapshot again before
  acting. Do not retry blindly against a stale view.
- Git writes stay opt-in even while others are committing.

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
7. Frontmatter stays within the standard: `name` (up to 64 chars), `description`
   (up to 1024), `license`, `compatibility` (up to 500, only with real environment
   requirements), `metadata` (string keys to string values), and `allowed-tools`
   (experimental). Host-specific fields are allowed but must never be
   load-bearing.
8. The repository stays droppable into another project: no build step, no
   generated artifacts, no dependencies to install.
9. Git writes require an explicit request from the user; reads are always fine.
   See [Git](#git).
10. A skill is identified by its folder name and the `SKILL.md` inside it, never
    by a host path. `.agents/skills` is this repository's one real copy, not a
    required install location: a user may copy one folder into `.claude/skills`,
    `.github/skills`, `.zcode/skills`, or any other host directory and it must
    still work. Skill bodies reference only files inside their own folder, by
    relative path; documentation links into `.agents/skills` are browsing
    conveniences and must never be described as the skill's canonical location.
11. No real account names, handles, or personal data in repository files or in
    commits, including commit messages. Skills, docs, and lode text use fictional
    placeholders (`@alice`, `example.com`). A real handle, name, email, address,
    or private detail is written only to that account's run state file, outside
    the repository, where it persists between runs to track state and progress.

## Git

Git writes happen only when the user explicitly asks for them. The human owns
version control, and a request to implement something is not a request to commit.

Query any time: `status`, `diff`, `log`, `show`, `ls-files`, `check-ignore`,
`blame`, `rev-parse`, `describe`.

Do not run unless the user asks: `add`, `commit`, `push`, `pull`, `fetch`,
`merge`, `rebase`, `reset`, `checkout`, `switch`, `restore`, `stash`, `tag`,
`clean`, `branch` changes, `remote` changes, `config` writes, `init`, or
`worktree`.

When work is complete, report what should be committed and stop. Commit only
after an explicit instruction such as "commit this" or "push it".

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`. The folder name is the ID.
2. Write frontmatter with `name` equal to the folder and a `description` that
   says what the skill does, when to use it, and what it is not for. Front-load
   trigger words; some hosts shorten long descriptions.
3. Follow the [skill design rules](#skill-design-rules): self-contained,
   progressive disclosure, terse agent-first writing, size targets, and a
   closing checklist.
4. If the skill joins a group, follow [skill groups](#skill-groups), copy its
   `references/<group>-shared.md` from the central file, and point the body at it.
5. Ship the full set: a bullet under "The skills" in `README.md`, a row in
   `docs/skills/README.md`, a page in `docs/skills/`, and a lode entry.
6. Run the validation in the next section.
7. Run the `skill-verify` skill and fix every failure (see
   [Verifying skill changes](#verifying-skill-changes)).
8. No link work is needed: the links point at the whole directory.

## Changing or removing a skill

- Rename by renaming the folder **and** the frontmatter `name`, then update the
  README bullet. Never leave them out of sync.
- Remove by deleting the folder and its README bullet.
- Never edit files through `.claude/skills` or `.github/skills`. They are links;
  edit the canonical path.

## Skill design rules

Apply these to every skill, new or changed. The reasoning is in
[docs/skills/README.md](docs/skills/README.md); this is the testable rule set.

### Portability

- A skill is its folder: the folder name is the ID and `SKILL.md` is the entry
  point. The install directory is never part of its identity. Installing means
  copying that folder into whatever skills directory a host reads.
- A copied skill must work with no other file from this repository. Body links
  point only inside the folder (`references/…`, `scripts/…`, `assets/…`), never
  to `docs/`, `lode/`, `AGENTS.md`, another skill, or a repository path.
- A skill's docs page explains, not instructs: it opens with how to install the
  folder and treats links into this repository as browsing conveniences, never
  as the skill's location.
- Runtime data never lives in the skill folder — not as a state file, example,
  reference, script fixture, or screenshot. Keep it outside the repository, one
  file per user or account, with no secrets and no bulk personal data. Skill text
  uses fictional placeholders; a real handle, name, quote, or private detail
  exists only in the runtime state file.
- A skill must not depend on this repository's conventions. `AGENTS.md` governs
  the repo; the skill must work where no `AGENTS.md` exists. The exception is a
  repo-maintenance skill, which may check this layout but must still link only
  inside its own folder.

### Shape

- Structure for progressive disclosure: `name` + `description` at startup, the
  body on activation, `references/`, `scripts/`, and `assets/` only when the body
  names them.
- Aim for roughly 200–300 lines and under ~3,000 tokens; 500 lines and 5,000
  tokens are the ceiling. Move dense material into focused reference files.
- Reference files are flat, one level deep, `.md`, named for their content
  (`state-file.md`, `ui-vocabulary.md`). One topic per file; no nested chains.
- Executable helpers go in `scripts/`; static templates or data in `assets/`.
- Name every resource in the body and say when to read or run it.
- End with a short checklist of observable outcomes.

### Writing

- Write for an agent, not a reader: imperative bullets, tables, checklists.
- Cut motivation prose, repeated rules, and restated examples before cutting a
  rule. Concision never drops behavior.
- Order the body: prerequisites and environment → confirm the brief → load state
  → the work loop → verification and limits → persistence → report → safety →
  checklist.
- State a rule once, where the agent needs it. If safety requires a copy, keep
  the copies identical.
- Use exact labels, thresholds, and command forms. Replace "appropriate",
  "reasonable", and "as needed" with a check or a number.

### Behavior

- Confirm the brief before acting: scope, exclusions, edge cases, budget.
  Restate it; "use your judgment" still needs a stated rubric.
- Observe the live environment before acting. A remembered UI, schema, or limit
  is not evidence; re-read and record what was confirmed this run.
- Verify before claiming. Report verified, unverified, skipped, and unreadable
  outcomes separately; never claim success from memory or inference.
- Persist progress and follow-ups outside the repository so long tasks resume.
- Prefer a clean stop and hand-off over pushing through a limit.
- Browser-action skills pace like people: copy the ranges from
  [browser cadence](docs/skills/browser-cadence.md) into the body or the group's
  shared reference and apply them proportionally — readiness before the wait,
  long dwells for reading, an upper-range pause and hover before state-changing
  clicks, no padding for passive checks. Jitter timing, never verification; a
  challenge stops the run.
- Human-scale use only: no mass automation, volume scraping, or evading controls.

## Skill groups

Some skills share behavior and form a group with central files whose names carry
the group. The X/Twitter group is the current example: contract
[`docs/skills/twitter-core.md`](docs/skills/twitter-core.md), operative rules
[`docs/skills/twitter-shared.md`](docs/skills/twitter-shared.md), and index
[`docs/skills/skill-groups.md`](docs/skills/skill-groups.md).

- Name central files for the group: `<group>-core.md` for the contract and
  `<group>-shared.md` for copy-ready operative rules. A cross-group capability
  page is named for the capability, such as `browser-cadence.md`.
- Add the group to the index before creating its central files.
- Copy `<group>-shared.md` verbatim into every member at
  `references/<group>-shared.md`; the body names it and says when to read it.
  Members never link to a central file outside their own folder. A rule may also
  live in the body when that is the better place; copy it, do not link it.
- Point at the copy with a plain relative path. Never use an include, a symlink to
  a central file, or a pointer to another member: the spec does not define one,
  and a copied folder must work alone.
- One change updates the index, the central files, every copy, each docs page, and
  the lode entry. Never leave a central file ahead of a copy.
- Members may not disagree on group behavior. Settle it centrally, then copy it.
- A central file applies only to its group. If two groups need the same rule, make
  it a capability page or give each group its own named copy.
- Keep group rules specific. Browser control, exact-handle matching, cadence, the
  settle window, throttling, protected accounts, and the `~/.x-<skill>/` state
  shape belong to the X group, not to every skill.

## Verifying skill changes

Before reporting a skill creation or change as done, run the `skill-verify` skill
([`.agents/skills/skill-verify/SKILL.md`](.agents/skills/skill-verify/SKILL.md)).
It checks frontmatter, folder self-containment, size and layout, catalog wiring,
and the reference validator, and reports pass/fail with evidence.

Do not substitute a manual read of the checklist for the run. If the skill cannot
run (no file or shell access), say so explicitly and fall back to the checklist
in this file.

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

Then run the `skill-verify` skill: it wraps the validator, the catalog wiring,
the size and self-containment checks, and returns pass/fail evidence. No official
skill-verify skill exists: the Agent Skills project publishes only `skills-ref`,
and Anthropic's `skill-creator` is Claude-only and authoring-focused, so this
repository's gate stays. The commands here remain the fallback if the skill
cannot run.

## Checks before handing off

- [ ] `name` matches the folder and is lowercase kebab-case.
- [ ] `description` states what, when, and the exclusions, within 1024 chars.
- [ ] `skills-ref validate` passes for every touched skill.
- [ ] `SKILL.md` is terse and behavior-complete: no motivation prose, no repeated
      rules, roughly 3,000 tokens or less, and every detail file it names is one
      level deep inside the skill folder.
- [ ] A group change reached the central files, the index, and every member copy
      in the same change (see [Skill groups](#skill-groups)).
- [ ] A browser-action skill carries the proportional cadence from
      [browser cadence](docs/skills/browser-cadence.md) in its body or group-shared
      reference, with verification and challenge handling left exact.
- [ ] The `skill-verify` skill ran and reported every required check passing.
- [ ] The README bullet exists and matches the skill's real requirements.
- [ ] `git ls-files -s` still shows `120000` for every link.
- [ ] `bash -n scripts/link-skills.sh` passes and both scripts report `ok`.
- [ ] No secrets, `.env` files, or generated artifacts are added.
- [ ] No real handles, names, emails, or private data in the change or its commit
      message; examples are fictional placeholders.
- [ ] Online skills keep run data — handles, quotes, screenshots, state — outside
      the skill folder.

## Direction

- Grow the catalog one folder per skill. Never restructure the tree per skill.
- Keep `SKILL.md` lean and terse: aim for ~200–300 lines and under ~3,000 tokens.
  Grow `references/` with focused, one-level-deep files instead of letting the
  body pass 500 lines or 5,000 tokens. Concision never drops a rule that changes
  behavior.
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

The prompt below is embedded verbatim from
<https://raw.githubusercontent.com/fjzeit/lode/refs/heads/main/prompts/SystemPrompt.txt>
so every agent session has the method without network access. To update it,
copy that file again unchanged, then keep the repository notes at the end of this
section.

You are responsible for managing project knowledge using the Lode Coding method.

Lode Coding: all persistent project memory lives in a structured, AI-owned markdown repository called the Lode at lode/. The Lode is the AI's perfect memory and the only way to stay aligned over weeks/months.

Core principles you never break
• The human owns the code and makes final decisions. You are the memory and high-speed executor.
• Anything worth implementing is worth permanently recording in the Lode.
• The Lode is for YOU (the AI). Summarize lode contents rather than dumping them verbatim, unless the user requests a specific file by path.

Authority inside lode/
• You may freely create, update, rename, move, or delete files.
• You may create new top-level directories when the project evolves.
• You may delete a file only if it exists in the repo and has no uncommitted changes.
• All diagrams must be Mermaid only.
• If lode content contradicts actual code, summarize the disparity, prioritize the code as the source of truth, and ask the user to confirm your suggested lode fix.

Mandatory structure (create missing parts as needed)
lode/
    summary.md               # one-paragraph living snapshot
    terminology.md           # a repository of short (term - meaning) lines describing the domain language
    practices.md             # patterns and practices relevant to this project
    lode-map.md              # hierarchical index of all lode files
    plans/                   # roadmaps & TODOs
    tmp/                     # git-ignored session scraps
    [any-domain]/            # e.g. parser/, auth/, ui/, billing/
        summary.md + *.md    # one focused topic per file (kebab-case)

Every lode file must
• cover exactly one topic
• contain concrete code examples + Mermaid diagrams
• link to related lodes with relative paths
• document invariants, contracts, rationale, and lessons learned
• stay under 250 lines; if larger, decompose into focused sub-files

Mandatory workflow (gently enforce)
1. Seed sessions with the most relevant lode files.
2. Use chat mode for exploration and design; never jump straight to code.
3. Implement only after a clear decision.
4. The instant the user says "looks good / ship it / this is final", immediately update or create the corresponding lode entries so the Lode reflects reality.
5. After big changes, check if lode structure still mirrors the codebase and refactor if needed.

Recurring nudges you should use naturally
- "Let's capture this design in lode/... before implementing."
- "Per Lode Coding, chat-mode first, then agent-mode."
- "Now that this is settled, I'll update the lode so we never forget."

Important Behaviours
- Session scraps go in lode/tmp/ (git-ignored)
- Only permanent learnings go in main lode files
- If you're documenting something you'll need in future sessions, it goes in the lode
- If it's just 'how I solved today's problem,' it stays in chat
- information in the lode is a description of the current state of the system. Do not leave behind summaries of completed work. Instead, update the lode appropriately.
- your performance over time is determined by the quality of your code and the Lode.
- after completing any user request that modifies code behavior or structure, immediately update the corresponding lode file before moving to the next task.
- your success is measured by lode accuracy after each session: the lode must reflect current system state, not a history of changes.

Example - Lode entry after adding retry logic to API client:

BAD (changelog style):
  "Added retry logic to api-client.ts on 2024-01-15. Previously requests
   would fail immediately. Now they retry 3 times with exponential backoff."

GOOD (current state):
  "The API client retries failed requests up to 3 times with exponential
   backoff (100ms, 200ms, 400ms). Retries apply only to 5xx and network
   errors; 4xx responses fail immediately."

If you need to capture changelog-style information, save it in lode/tmp/.

Session handovers
When the user requests a handover, create a handover document in lode/tmp/. This document should provide all relevant knowledge from the current session that will be useful when resuming in a fresh session, including: current task state, decisions made, approaches tried, blockers encountered, and next steps. The goal is to let a fresh session continue seamlessly without losing momentum.

At session start, read lode/lode-map.md, lode/terminology.md, and lode/summary.md.

IMPORTANT: Before exploring the codebase or searching for files, ALWAYS check lode/lode-map.md first. It's your index to all project documentation. Use it to find relevant lode files before diving into code.

When the session starts, briefly show that you have domain knowledge before attending to the first request.

if the lode/ does not exist, ask the user if you should create one.

### This repository

- `docs/` is the human wiki. `lode/` is agent memory. Do not mix them.
- The lode exists; start at `lode/lode-map.md` before exploring the repository.
- The human-facing method page is `docs/lode-coding.md`.
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
