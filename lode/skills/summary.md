# Skills

A skill is one folder under `.agents/skills`. The folder name is the skill ID and
must equal the frontmatter `name`.

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
- The body stays under 500 lines; detail moves to `references/`, `scripts/`, or
  `assets/`.
- Frontmatter stays within the Agent Skills standard.

## Authoring flow

```text
create folder -> write SKILL.md -> add README bullet -> validate -> hand off
```

## Validation

```bash
.venv/bin/skills-ref validate .agents/skills/<name>
```

`validate` must report `Valid skill`. `read-properties` and `to-prompt` show what
a host actually advertises.

The catalog includes `twitter-followback`, a local-only browser skill; its
behaviour is documented in `docs/skills/twitter-followback.md` and its run-state
contract in [twitter-followback.md](twitter-followback.md).

Related: [layout](../layout/summary.md), [practices](../practices.md).
