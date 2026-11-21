# skill-verify

The repository's verification gate for skills. It checks one or more skill
folders against the catalog rules and reports pass/fail with file evidence, so a
skill is not handed off because it "looks right".

Install by copying the `skill-verify` folder into the skills directory your host
reads; the `SKILL.md` inside it is the whole skill. This page explains it and is
not part of the install.

## When it triggers

- before handing off any skill creation or change
- "verify this skill", "check the skill", "review my skill"
- "is this skill ready?", "audit the skill folder"
- after a family-wide rule change, to confirm every member still conforms

It is not for authoring skill content, and it does not audit unrelated
repositories.

## Requirements

| Need | Why |
| --- | --- |
| Local file read and shell | It reads the folder and runs the checks |
| `skills-ref` | The official frontmatter and naming validator; `.venv` in the repo or on `PATH` |
| A git checkout | Scope detection and the `120000` link check |

Without a validator, the skill reports that check as unverified instead of
passing it.

## Validation sources

The frontmatter check is not hand-rolled. It calls `skills-ref`, the reference
validator published with the Agent Skills specification, which checks `name`,
`description`, `compatibility`, the allowed field set, and the directory match.

The rest of the gate is repository policy. No external validator knows this
catalog's canonical tree, README/docs/lode wiring, symlink modes, or size
targets, so those checks stay in the skill.

Two other sources exist and are deliberately not required:

- Anthropic's `skill-creator` is the official skill for authoring and evaluating
  skills. It targets Claude surfaces, uses Claude-only tools, and is not a
  pre-handoff repository gate, so it is not a cross-agent substitute here.
- `agent-ecosystem/skill-validator` is a third-party CLI with broader structural,
  link, and token checks. It runs only when already on `PATH`; the skill never
  installs it and never treats its absence as a failure.

## What it checks

1. **Frontmatter** — folder and `name` match, kebab-case rules, description
   limits and trigger words, `compatibility` ≤500, standard fields only.
2. **Self-containment and personal data** — no links or dependencies outside the
   skill folder, no host or repository paths, every reference one level deep and
   resolvable. Examples use placeholders; the folder holds no real handles,
   names, emails, phones, addresses, account IDs, or private details. For
   X/Twitter, browser-driven, and other online skills it also fails saved post
   quotes, permalinks, profile excerpts, follower lists, screenshots, state
   dumps, credentials, cookies, or session tokens: instructions are not run
   memory. A placeholder URL such as `https://x.com/<handle>` is fine; a specific
   profile or status URL from a run is not.
3. **Shape and size** — line and token targets, flat focused references,
   scripts and assets named, closing checklist, no duplicated rules.
4. **Catalog wiring** — root README bullet, docs catalog row and page, lode entry
   and map row, terminology where a concept is new.
5. **Validation** — `skills-ref validate`, advertised properties, link
   resolution, link modes, and the shell syntax check when those files changed.

## Output

A table of check, result, and evidence; failures first with `file:line` and the
exact fix; and an explicit list of anything that could not be checked. It is
read-only unless the user asked for fixes, in which case the affected checks are
re-run afterwards.

## Limits

The token figure is an estimate from character count, not a tokenizer. The skill
knows this repository's layout by design — the one exception to the
self-containment rule — but it still links only inside its own folder, so a
copied folder works. `skills-ref` accepts Unicode letters in `name`, while this
repository requires ASCII kebab-case, so the stricter rule wins when they
disagree. Personal-data detection is judgement-based: the check lists every
handle and image and confirms placeholders, but it cannot prove a handle is
fictional, so an unfamiliar one is a finding rather than a pass.

## Related

- [Shared core for X skills](twitter-core.md) — the family contract example
- [Skills catalog](README.md)
- [Agent instructions](../agent-instructions.md) — the rule set it enforces
