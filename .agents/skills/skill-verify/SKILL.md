---
name: skill-verify
description: >-
  Verify a skill in this repository before handoff: folder and name match,
  frontmatter limits, self-containment, personal-data safety, progressive
  disclosure and size, reference layout, catalog wiring, and the official
  skills-ref validator. Use before creating or changing any skill, or when asked
  to verify, review, check, or audit a skill; reports pass/fail with file evidence
  and exact fixes. Not for authoring skill content or auditing unrelated
  repositories.
compatibility: >-
  Requires local file read and shell access. The frontmatter validator is
  .venv/skills-ref or skills-ref on PATH; without either, that check is manual
  and reported as unverified.
---

# Skill Verify

Run before handing off any skill creation or change. Report pass/fail with
evidence; never mark a check passed from memory.

This is this repository's gate, not a reimplementation of the standard. It
delegates the frontmatter check and keeps only the catalog checks that no
external validator covers.

## Validation sources

| Source | Role | Used |
| --- | --- | --- |
| `skills-ref` (Agent Skills project) | Official validator: frontmatter, naming, directory match | Required in Step 5 |
| Anthropic `skill-creator` | Official skill for authoring and evaluating skills | No: authoring scope and Claude-only tools |
| `skill-validator` (agent-ecosystem) | Third-party structure, link, token, orphan checks | Optional, only if already on `PATH` |

Never install a source silently; a missing source makes its check unverified.

## Rules

- Read-only unless the user asked for fixes. Fixing a failure belongs to the
  change under review, not to the check.
- Cite evidence: path and line, or command output.
- An unused optional folder is a pass; a missing required item is a fail.
- A skill is its folder: resolve links and references from that root.
- If a check cannot run, report it unverified, never passed.

## Step 0 — Scope

1. Resolve the repository root; do not assume the current directory.
2. Skill folders: those named in the request, else directories under
   `.agents/skills` that are untracked or modified per `git status --short`.
3. Read each `SKILL.md` fully; note every path it references.

## Step 1 — Frontmatter

- `name` — present, 1–64 chars, `[a-z0-9-]`, no leading/trailing/double hyphen,
  equal to the folder name.
- `description` — present, 1–1024 chars, states what, when, and what it is not
  for.
- `compatibility` — optional, ≤500 chars, only real environment requirements.
- `license`, `metadata` (string map), `allowed-tools` (experimental) only; no
  host-specific field is load-bearing.

`skills-ref` accepts Unicode letters in `name`; this repository requires ASCII
`[a-z0-9-]`. Apply the stricter rule.

Quote the advertised values; use the validator's `read-properties` when present.

## Step 2 — Self-containment and personal data

- Search the body for `../`, `docs/`, `lode/`, `AGENTS.md`, `.agents/`, and host
  directories (`.claude/`, `.github/`, `.zcode/`, `.cursor/`, `.opencode/`,
  `.gemini/`). A link or dependency is a fail. A repo-maintenance skill may name
  these paths as things it checks, never as a resource it reads.
- Every relative link and image resolves inside the skill folder.
- A group member points only at `references/<group>-shared.md` inside its own
  folder, never at `docs/skills/<group>-shared.md`, a central path, another
  member's copy, or an include syntax the spec does not define. The copy is the
  whole rule set; the body names it with when to read it.
- Every referenced file is one level deep from `SKILL.md`; no nested chains.
- No absolute local paths or `file://` links.
- No personal data anywhere in the folder. Examples use obvious placeholders
  (`@alice`, `@bob`, `@me`, `<handle>`, `example.com`); a real handle, name,
  email, phone, address, account ID, or private detail belongs only in the
  runtime state file.
- For an X/Twitter, browser-driven, or other online skill, the whole folder —
  `SKILL.md`, `references/`, `scripts/`, and `assets/` — is instructions, never
  run memory. Fail a saved post quote, permalink, profile excerpt, follower list,
  screenshot, state dump, credential, cookie, or session token. List every `@`
  token and every image, and say which are placeholders; an image showing an
  identifiable profile is a fail. A placeholder URL such as
  `https://x.com/<handle>` is fine; a specific profile or status URL from a run is
  not.
- Runtime state points outside the folder, for example `~/.<name>/`; a state
  file, database, or export inside the folder is a fail.
- A skill that writes runtime state must say what happens when the write is
  refused or unavailable: continue on session state, print it for the user to
  verify, and accept repeated work next run. Stopping a run for missing
  persistence, or presenting session state as a saved file, is a fail.

## Step 3 — Shape and size

- Measure lines and estimate tokens as characters / 4. Pass at ≤500 lines and
  ≤5,000 tokens, the official recommendation; fail above. Treat the catalog's
  200–300 line / ~3,000-token aim as advisory lean-up advice, never a failure.
  State that the token figure is an estimate.
- `references/` files are flat `.md`, one topic each, named in the body with
  when to read them.
- `scripts/` files are self-contained or declare dependencies; `assets/` files
  are static.
- The body ends with a checklist and contains no motivation prose, repeated
  rules, or restated examples.
- A rule duplicated between the body and a reference is a fail; keep one copy.

## Step 4 — Catalog wiring

- A bullet under "The skills" in the root `README.md` with what it does, its
  triggers, and what it needs.
- A row in the catalog table in `docs/skills/README.md`.
- A `docs/skills/<name>.md` page: install sentence, behavior, triggers,
  requirements, safety, related links. It must not call the repository path
  canonical.
- `lode/skills/<name>.md` and a row in `lode/lode-map.md`.
- If the skill is a group member per `docs/skills/skill-groups.md`, its
  `references/<group>-shared.md` is byte-identical to
  `docs/skills/<group>-shared.md`, and the body names it with when to read it. A
  mismatch is a fail; report the first differing line.
- Docs and lode describe current behavior, not a changelog.
- New domain terms have a `lode/terminology.md` entry.

## Step 5 — Validate

From the repository root:

1. Run `skills-ref validate .agents/skills/<name>` with
   `.venv/Scripts/skills-ref.exe` on Windows, `.venv/bin/skills-ref` elsewhere,
   else `skills-ref` on PATH. Require `Valid skill`. This is the official check;
   a hand read never replaces it.
2. If `skill-validator` (agent-ecosystem) is already on `PATH`, run
   `skill-validator check <skill-folder>` and fold its structure, link, orphan,
   and token findings into Steps 2 and 3. Its findings are advisory; never
   install it to make a check pass.
3. Run `read-properties` and compare with the frontmatter.
4. Resolve every relative link in touched `docs/` and `lode/` files; report
   missing targets.
5. If links or scripts changed: `git ls-files -s` shows `120000` for
   `.claude/skills` and `.github/skills`, and `bash -n scripts/link-skills.sh`
   exits 0.
6. Without a validator, mark it unverified and give the install command; do not
   install silently.

## Step 6 — Report

- Table of check, result (pass / fail / unverified), and evidence.
- Failures first, each with `file:line` and the exact fix.
- List what could not be checked and why.
- Pass only when every required check passes; otherwise state the remaining
  action.
- Re-run affected checks after a fix.

## Checklist

- [ ] Folder and `name` match; frontmatter within limits.
- [ ] No repo or host path in the body; links stay inside the folder.
- [ ] No real handles, names, emails, or private details; examples are placeholders.
- [ ] Online skills carry no run data: no saved quotes, permalinks, screenshots, or state.
- [ ] Within 500 lines and ~5,000 tokens; references flat and named; closing
      checklist present.
- [ ] README bullet, docs row and page, lode entry and map row.
- [ ] Group members carry a byte-identical shared copy; the index lists the group.
- [ ] Validator reports `Valid skill`; links resolve.
- [ ] Report gives pass/fail with evidence.
