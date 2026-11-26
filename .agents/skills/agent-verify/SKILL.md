---
name: agent-verify
description: Verify an agent definition or command file in this repository before handoff — frontmatter against the official host specs, identity and naming, tools portability, personal-data safety, body shape, catalog wiring, and the committed alias chain. Use before creating or changing any agent or command file, or when asked to verify, review, check, or audit one; reports pass/fail with evidence and exact fixes. Not for skills (skill-verify owns that) or for authoring agent content.
compatibility: Requires local file read and shell access. No official validator exists for agent files; every frontmatter check is manual against the distilled specs in references/host-dialects.md.
---

# Agent Verify

Run before handing off any agent or command file creation or change. Report
pass/fail with evidence; never mark a check passed from memory.

This is the agent layer's gate. The Agent Skills specification and `skills-ref`
cover only skills, so no official validator exists for agent files: every check
here compares the file against the official host specifications distilled in
[references/host-dialects.md](references/host-dialects.md). Read it before Step 1.

## Rules

- Read-only unless the user asked for fixes. Fixing a failure belongs to the
  change under review, not to the check.
- Cite evidence: path and line, or command output.
- A missing required item is a fail; an unused optional field is a pass.
- An agent is its file. A repo-scoped agent may name repository paths it reads
  (`lode/`, source trees, `AGENTS.md`) — that is its contract, not a
  self-containment failure. Secrets, real identities, and run memory still fail.
- If a check cannot run, report it unverified, never passed.

## Validation sources

| Source | Role | Used |
| --- | --- | --- |
| Claude Code subagents documentation | official spec for `.claude/agents` | Yes |
| GitHub Copilot custom agents reference | official spec for `.github/agents` | Yes |
| VS Code custom agents documentation | official spec, IDE-side fields | Yes |
| OpenCode agents documentation | official spec for `.opencode/agents` | Yes |
| ZCode agent definitions | native host of `.zcode/agents`; no published spec in hand | Observed shape only |
| `skills-ref` | official validator | No: skills only |

Re-read the official pages live that run when a check fails or when a
host-specific field is load-bearing. Dated source links live on the
agent-verify docs page and expire like any vendor link.

## Step 0 — Scope

1. Resolve the repository root; do not assume the current directory.
2. Files: those named in the request; else agent and command files untracked or
   modified per `git status --short` under `.zcode/agents`, `.zcode/commands`,
   and `agents/`.
3. Read each file fully; note every frontmatter field it sets and every path it
   references.

## Step 1 — Frontmatter

- `name` — required by Claude Code and ZCode; an optional display name for
  Copilot; unused by OpenCode, which keys on the filename. This repository
  applies the strictest useful rule everywhere: lowercase ASCII `[a-z0-9-]`,
  1–64 characters, no leading, trailing, or doubled hyphen, and equal to the
  file stem without its `.md` or `.agent.md` extension.
- `description` — required (Claude Code, Copilot), recommended for subagents
  (OpenCode). It states what the agent does, when to use it, and what it is
  not for.
- `tools` — optional everywhere; comma-separated string or YAML list. Tool
  names are host vocabularies, not a standard: `Read, Grep, Glob, Bash` are the
  Claude family, `read/edit/search/execute` are Copilot aliases, and OpenCode
  deprecates agent-level `tools` outright. Verify every tool name against the
  target host's vocabulary; a name a host cannot resolve silently narrows the
  allowlist there. A dialect-only field on a multi-host file is a flag, not a
  fail.
- Dialect-specific fields (`model`, `mode`, `target`, `permissionMode`,
  `handoffs`, `permissions`, and the rest) — check against the host tables in
  [references/host-dialects.md](references/host-dialects.md). Unrecognized
  fields are ignored by design; a field only one host defines is dead weight on
  the others unless the file targets that host.

## Step 2 — Safety

- No secrets, credentials, tokens, `.env` contents, or private keys anywhere in
  the file; one is a fail and is reported, never copied.
- No real handles, names, emails, phones, addresses, or account IDs; examples
  use obvious placeholders (`@example_alice`, `example.com`).
- Instructions are not run memory: a saved quote, permalink, profile excerpt,
  follower list, screenshot reference, state dump, or session log is a fail.
- An absolute local path is a portability finding, not a privacy one — flag it.

## Step 3 — Body shape

- The body is the system prompt: imperative, behavior-complete, no motivation
  prose and no restated examples.
- A read-only reviewer agent states the never-edit contract — no file edits, no
  staging, committing, pushing, or comments posted, no delegation onward — and
  names its scope boundary against sibling reviewers.
- An output contract exists: finding format, severity ladder or equivalent, and
  an honest empty result (`No findings.` — never an invented one).
- A paired command file: frontmatter `description` and `argument-hint`; names
  its agent; carries the no-subagent fallback (read the definition, run the
  procedure, report in its format); keeps the scope placeholder (`$ARGUMENTS`).
- Size: no official limit except Copilot's 30,000-character body ceiling. Pass
  at ≤30,000 characters; treat roughly 300 lines as advisory lean-up advice and
  state both counts.

## Step 4 — Catalog wiring

- A row in the catalog table in `lode/agents/summary.md`: agent, command, scope.
- A docs page at `docs/users/<stem>.md` for a catalog agent: install sentence,
  behavior, triggers, requirements, safety, related links.
- A mention in the agents paragraph of the root `README.md`.
- New domain terms have a `lode/terminology.md` entry.
- Docs and lode describe current behavior, not a changelog.

## Step 5 — Wiring and links

- The alias chain resolves from every committed reader: `.agents/agents` and
  `.github/agents` list the file; `.claude/agents` lists it through the
  whole-directory link (`readlink .claude` → `.agents`).
- `git ls-files -s` records the committed links as mode `120000`:
  `.agents/agents`, `.agents/commands`, `.github/agents`,
  `.github/copilot-instructions.md`, `.claude`.
- The command file sits in `.zcode/commands` with a stem matching its agent.
- Resolve every relative link in touched `docs/` and `lode/` files; report
  missing targets.

## Step 6 — Report

- Table of check, result (pass / fail / unverified), and evidence.
- Failures first, each with `file:line` and the exact fix.
- List what could not be checked and why — including spec pages not read live.
- Pass only when every required check passes; otherwise state the remaining
  action.
- Re-run affected checks after a fix.

## Checklist

- [ ] `name` equals the file stem, lowercase ASCII kebab-case, within limits.
- [ ] `description` states what, when, and what it is not for.
- [ ] Every `tools` value is meaningful on the target host; dialect-only fields
      flagged.
- [ ] No secrets, real identities, or run memory; placeholders only.
- [ ] Read-only reviewers carry the never-edit contract and scope boundaries;
      the output contract is honest.
- [ ] Command file pairs with its agent and states the no-subagent fallback.
- [ ] Lode catalog row, docs page, and README mention exist.
- [ ] Alias chain resolves; committed links are mode `120000`.
- [ ] Report gives pass/fail with evidence.
