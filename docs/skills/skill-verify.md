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
| `skills-ref` | Frontmatter validation; `.venv` in the repo or on `PATH` |
| A git checkout | Scope detection and the `120000` link check |

Without a validator, the skill reports that check as unverified instead of
passing it.

## What it checks

1. **Frontmatter** — folder and `name` match, kebab-case rules, description
   limits and trigger words, `compatibility` ≤500, standard fields only.
2. **Self-containment** — no links or dependencies outside the skill folder, no
   host or repository paths, every reference one level deep and resolvable.
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
copied folder works.

## Related

- [Shared core for X skills](twitter-core.md) — the family contract example
- [Skills catalog](README.md)
- [Agent instructions](../agent-instructions.md) — the rule set it enforces
