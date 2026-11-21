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
- Frontmatter stays within the Agent Skills standard: `name`, `description`,
  `license`, `compatibility` (max 500), `metadata` (string map), `allowed-tools`
  (experimental). Host-specific fields are allowed but never load-bearing.

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

## Skill identity

- A skill is its folder: the folder name is the ID and `SKILL.md` is the entry
  point. The install directory is never part of its identity.
- `.agents/skills` is this repository's one real copy, not a required install
  location. A user may copy one folder into `.claude/skills`, `.github/skills`,
  `.zcode/skills`, or any other host directory, and it must still work.
- A copied skill must work with no other file from this repository. Body links
  point only inside the folder (`references/…`, `scripts/…`, `assets/…`), never to
  `docs/`, `lode/`, `AGENTS.md`, another skill, or a repository path.
- A skill's docs page explains, not instructs: it opens with how to install the
  folder and treats links into this repository as browsing conveniences, never as
  the skill's location.
- Runtime data never lives in the skill folder — not as a state file, example,
  reference, script fixture, or screenshot. Keep it outside the repository, one
  file per user or account, with no secrets and no bulk personal data. Skill text
  uses fictional placeholders; a real handle, name, quote, or private detail
  exists only in the runtime state file.
- A skill must not depend on this repository's conventions. `AGENTS.md` governs
  how agents work; the skill must work where no `AGENTS.md` exists. A
  repo-maintenance skill may check this layout but must still link only inside its
  own folder.

## Shape

- The pass line is the official recommendation: 500 lines and ~5,000 tokens. Aim
  tighter, at roughly 200–300 lines and ~3,000 tokens, as advisory lean-up
  guidance that never fails a skill. Move dense material into focused reference
  files.
- Reference files are flat, one level deep, `.md`, named for their content
  (`state-file.md`, `ui-vocabulary.md`). One topic per file; no nested chains.
- Executable helpers go in `scripts/`; static templates or data in `assets/`.
- Name every resource in the body and say when to read or run it.
- End with a short checklist of observable outcomes.

## Writing

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

## Behavior

Generic working behavior — confirm the brief, observe the live environment,
verify before claiming, persist progress, stop cleanly — is in
[`AGENTS.md`](../../AGENTS.md). These rules are specific to skills:

- Browser-action skills pace like people: copy the ranges from
  [browser cadence](../../docs/skills/browser-cadence.md) into the body or the
  group's shared reference and apply them proportionally — readiness before the
  wait, long dwells for reading, an upper-range pause and hover before
  state-changing clicks, no padding for passive checks. Jitter timing, never
  verification; a challenge stops the run.
- An online skill stops on an access failure instead of inferring account state.
  Record an unreadable page as a verdict with a reason.
- Persistence is never a hard stop. When the state-file write is refused or
  unavailable, the run continues on session state of the same shape, prints it for
  the user to verify, and says plainly that the next run starts fresh and may
  repeat work.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`. The folder name is the ID.
2. Write frontmatter with `name` equal to the folder and a `description` that
   says what the skill does, when to use it, and what it is not for. Front-load
   trigger words; some hosts shorten long descriptions.
3. Apply the rules above: self-contained, progressive disclosure, terse
   agent-first writing, size targets, and a closing checklist.
4. If the skill joins a group, follow [groups](groups.md), copy its
   `references/<group>-shared.md` from the central file, and point the body at it.
5. Ship the full set: a bullet under "The skills" in `README.md`, a row in
   `docs/skills/README.md`, a page in the audience section that fits (`docs/users/`
   for an end-user skill, `docs/skills/` for a maintenance skill), and a lode
   entry.
6. Validate with `skills-ref` (see [validation](#validation)).
7. Run the `skill-verify` skill and fix every failure.
8. No link work is needed: the links point at the whole directory.

## Changing or removing a skill

- Rename by renaming the folder **and** the frontmatter `name`, then update the
  README bullet. Never leave them out of sync.
- Remove by deleting the folder and its README bullet.
- Never edit files through `.claude/skills` or `.github/skills`. They are links;
  edit the canonical path.

## Groups

A group shares behavior and carries group-named central files. The rules for
naming, copying, and keeping members aligned are in [groups](groups.md). The live
X group is [twitter-group](twitter-group.md).

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
      rules, within 500 lines and ~5,000 tokens (the official recommendation),
      and every detail file it names is one level deep inside the skill folder.
- [ ] A group change reached the central files, the index, and every member copy
      in the same change (see [groups](groups.md)).
- [ ] A browser-action skill carries the proportional cadence from
      [browser cadence](../../docs/skills/browser-cadence.md) in its body or
      group-shared reference, with verification and challenge handling left
      exact.
- [ ] The `skill-verify` skill ran and reported every required check passing.
- [ ] The README bullet exists and matches the skill's real requirements.
- [ ] Online skills keep run data — handles, quotes, screenshots, state — outside
      the skill folder.
- [ ] A state-writing skill states the session-only fallback and does not stop
      when file write is unavailable.

## Catalog state

The X skills follow the progressive-disclosure shape: state schemas live in
`references/state-file.md`, and the follow-back UI ladder, the suggestion card, and
the compatibility scoring, multimodal-evidence, and report files live in their own
references. Their shared rules live in `references/twitter-shared.md`, copied
verbatim from
[`docs/skills/twitter-shared.md`](../../docs/skills/twitter-shared.md); the group
index is [`docs/skills/skill-groups.md`](../../docs/skills/skill-groups.md). All
open a run with a brief state line, link every handle and cited source in their
output, and stop on an access failure instead of inferring state. Text is the
default evidence mode; every member offers the same opt-in image, video-frame, and
audio-transcript gate from the shared file, tests each enabled mode per run, and
reports `unavailable` instead of zeroing it.

The catalog's browser-driven X skills share
[`docs/skills/twitter-core.md`](../../docs/skills/twitter-core.md) as their
contract. `twitter-followback` is documented in
`docs/users/twitter-followback.md` with its run-state contract in
[twitter-followback.md](twitter-followback.md); `twitter-moot-radar` in
`docs/users/twitter-moot-radar.md` with its entry in
[twitter-moot-radar.md](twitter-moot-radar.md); `twitter-compatibility` in
`docs/users/twitter-compatibility.md` with its rubric entry in
[twitter-compatibility.md](twitter-compatibility.md).

Invocation syntax is host-specific: Claude Code, Copilot, and Cursor use
`/skill-name`, OpenCode uses `@skill-id`, Codex uses `$skill-name`, and Gemini CLI
activates skills through the agent with consent. OpenCode's `/` menu is commands
only. The full matrix is
[`docs/users/invoking.md`](../../docs/users/invoking.md).

Related: [groups](groups.md), [layout](../layout/summary.md),
[practices](../practices.md).
