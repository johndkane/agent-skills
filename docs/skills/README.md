# Skills

A skill is a folder containing a `SKILL.md` plus optional resources. Agents load
the body only when the skill is relevant, so a skill can hold a full procedure
without costing context on every prompt.

## Catalog

| Skill | What it does | Runs where |
| --- | --- | --- |
| [`twitter-followback`](twitter-followback.md) | Researches followers on X and follows back only real, active people, filtering bots, marketing, adult, crypto, and impersonation accounts | Local agent with browser control |
| [`twitter-moot-radar`](twitter-moot-radar.md) | Asks for your interests, reads what your mutuals follow, and suggests matching accounts with quoted proof and live follow status | Local agent with browser control |
| [`skill-verify`](skill-verify.md) | Checks a skill folder against the catalog rules and reports pass/fail with evidence | Local agent with file and shell access |

The full instructions for each skill live in its `SKILL.md`; these pages explain
the skill rather than replacing it.

Skills that drive the same product share a contract so they cannot drift apart.
The browser-driven X skills are the first family: every one is built from and
extends [the shared core](twitter-core.md) — browser control, exact-handle
matching, settle-and-verify timing, human-cadence jitter, state shape, and
reporting honesty — and a new principle is written there before it reaches the
individual skills.

## Anatomy

```
.agents/skills/<name>/
├── SKILL.md          required: frontmatter plus instructions
├── scripts/          optional executable helpers
├── references/       optional detail loaded on demand
└── assets/           optional templates, images, data
```

Reference sibling files by relative path from the skill root, inside the skill
folder and one level deep from `SKILL.md`. Never reference `docs/`, `lode/`, or
another skill: those paths only exist in this repository, not in a copied skill.

## What "the skill" means

A skill is **its folder, addressed by the folder name**. `SKILL.md` inside that
folder is the entire install; `references/`, `scripts/`, and `assets/` are
optional neighbours, referenced only by relative path from `SKILL.md`.

No skill document names an install location. Copy the folder into whatever
directory the host reads — `.claude/skills`, `.github/skills`,
`.opencode/skills`, `.cursor/skills`, `.gemini/skills`, `.zcode/skills`, or that
host's equivalent — and keep the folder name, because the frontmatter `name` must
match it.

Links in this wiki point into `.agents/skills` because that is this repository's
one real copy. They are browsing conveniences, not the skill's address: a copied
folder works the same anywhere, and nothing inside the skill depends on those
links.

## Progressive disclosure

Agents load a skill in three layers, so size is a design constraint:

| Layer | What loads | When |
| --- | --- | --- |
| Metadata | `name` and `description` (~100 tokens) | At startup, for every skill |
| Instructions | the whole `SKILL.md` body | When the skill activates |
| Resources | files under `references/`, `scripts/`, `assets/` | Only when `SKILL.md` points at them |

Keep the body terse and behavior-complete: roughly 200–300 lines and under
~3,000 tokens. Write instructions, not an essay — imperative bullets, tables,
and checklists; cut motivation prose, repeated rules, and restated examples
before cutting a rule. 500 lines and 5,000 tokens are the ceiling, not the goal.

Past that, move dense material — schemas, long tables, vendor lore, worked
examples — into `references/` and say when to read each file. Keep resource
files flat and focused: one level deep from `SKILL.md`, because some hosts
search only two levels and recognise a limited set of file types.

Some runtimes split the third layer into "read a resource" and "run a script",
which is why Microsoft documents four stages. The content model is the same.

## Skills and AGENTS.md

`AGENTS.md` is repository context: how this project is built and maintained. A
skill is a portable task workflow that must work where no `AGENTS.md` exists.
Keep project conventions in `AGENTS.md` and task procedure in the skill; a skill
must not depend on either `AGENTS.md` or this wiki.

## Rules a skill must follow

- **`name`** — required, lowercase kebab-case, 1–64 characters, no leading,
  trailing, or doubled hyphens, and identical to the folder name.
- **`description`** — required, at most 1024 characters. It is the only text most
  hosts read before deciding to load the skill, so state what the skill does,
  when to use it, and what it is not for. Front-load trigger words.
- **Frontmatter** — stay within the standard: `name` (≤64 characters),
  `description` (≤1024), `license`, `compatibility` (≤500 characters, only when
  the skill has real environment requirements), `metadata` (string keys to
  string values), and `allowed-tools` (experimental; support varies). Host-
  specific fields are ignored elsewhere and must never be load-bearing.
- **Size** — aim for roughly 200–300 lines and under ~3,000 tokens; 500 lines
  and ~5,000 tokens are the ceiling. Write terse instructions, not prose. Move
  dense detail into `references/`, executable helpers into `scripts/`, and static
  templates or data into `assets/`; name each file and when to read it.
- **Runtime needs** — declare them in `compatibility` instead of assuming a
  capable environment.
- **Self-contained** — a skill folder is installed on its own, so `SKILL.md` may
  reference only files inside that folder (`references/`, `scripts/`, `assets/`).
  Never link to `docs/`, `lode/`, `AGENTS.md`, another skill, or any repository
  path. Duplicating a rule is correct; a broken link is not. A repo-maintenance
  skill may name repository paths it checks, but never depends on them as
  resources.
- **Families** — a skill that belongs to a family (currently the
  [X/Twitter skills](twitter-core.md)) follows the family contract instead of
  inventing browser, timing, or state behaviour. Its body carries the rules it
  needs; the core is where they are agreed and changed. Update the whole family
  together.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`.
2. Write the frontmatter and instructions. If the skill joins a family, read the
   family contract first and build from it.
3. Keep the body lean; move dense detail into `references/` files one level deep.
4. Add a row to the catalog table above, a bullet to
   [the root README](../../README.md), a page beside this one, and a lode entry.
5. Validate with the reference implementation.
6. Run [`skill-verify`](skill-verify.md) and fix every failure.
7. Stop and report the change; the human commits. No link work is needed.

## Validation

```bash
python -m venv .venv
.venv/bin/pip install "git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref"
.venv/bin/skills-ref validate .agents/skills/<name>
```

On Windows use `.venv\Scripts\pip` and `.venv\Scripts\skills-ref.exe`.
`validate` must print `Valid skill`. It checks the frontmatter and naming
conventions, not the body: the 500-line / 5,000-token guidance and the
one-level-deep links are review checks, not validator output. `read-properties`
and `to-prompt` show what a host actually advertises.

## Related

- [Invoking skills](invoking.md) — explicit syntax for every host and surface
- [Architecture](../architecture.md) — how the tree reaches each host
- [Scripts](../scripts.md) — wiring and recovery
- [Agent instructions](../agent-instructions.md) — the repo rules
