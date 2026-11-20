# Skills

A skill is a folder containing a `SKILL.md` plus optional resources. Agents load
the body only when the skill is relevant, so a skill can hold a full procedure
without costing context on every prompt.

## Catalog

| Skill | What it does | Runs where |
| --- | --- | --- |
| [`twitter-followback`](twitter-followback.md) | Researches followers on X and follows back only real, active people, filtering bots, marketing, adult, crypto, and impersonation accounts | Local agent with browser control |

The full instructions for each skill live in its `SKILL.md`; these pages explain
the skill rather than replacing it.

## Anatomy

```
.agents/skills/<name>/
├── SKILL.md          required: frontmatter plus instructions
├── scripts/          optional executable helpers
├── references/       optional detail loaded on demand
└── assets/           optional templates, images, data
```

Reference sibling files by relative path from the skill root, one level deep from
`SKILL.md`.

## Rules a skill must follow

- **`name`** — required, lowercase kebab-case, 1–64 characters, no leading,
  trailing, or doubled hyphens, and identical to the folder name.
- **`description`** — required, at most 1024 characters. It is the only text most
  hosts read before deciding to load the skill, so state what the skill does,
  when to use it, and what it is not for. Front-load trigger words.
- **Frontmatter** — stay within the standard: `name`, `description`, `license`,
  `compatibility`, `metadata`, `allowed-tools`. Host-specific fields are ignored
  elsewhere and must never be load-bearing.
- **Size** — keep `SKILL.md` under 500 lines. Move detail into `references/`.
- **Runtime needs** — declare them in `compatibility` instead of assuming a
  capable environment.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`.
2. Write the frontmatter and instructions.
3. Add a row to the catalog table above and to [the root README](../../README.md).
4. Validate with the reference implementation.
5. Stop and report the change; the human commits. No link work is needed.

## Validation

```bash
python -m venv .venv
.venv/bin/pip install "git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref"
.venv/bin/skills-ref validate .agents/skills/<name>
```

On Windows use `.venv\Scripts\pip` and `.venv\Scripts\skills-ref.exe`.
`validate` must print `Valid skill`. `read-properties` and `to-prompt` show what
a host actually advertises.

## Related

- [Architecture](../architecture.md) — how the tree reaches each host
- [Scripts](../scripts.md) — wiring and recovery
- [Agent instructions](../agent-instructions.md) — the repo rules
