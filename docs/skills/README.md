# Skills

A skill is a folder containing a `SKILL.md` plus optional resources. Agents load
the body only when the skill is relevant, so a skill can hold a full procedure
without costing context on every prompt.

## Catalog

| Skill | What it does | Runs where |
| --- | --- | --- |
| [`twitter-followback`](../users/twitter-followback.md) | Researches followers on X and follows back only real, active people, filtering bots, marketing, adult, crypto, and impersonation accounts; text by default with optional, capped image, frame, and transcript checks when you opt in; links handles and cited posts; stops on access failures; opens each run with its state summary | Local agent with browser control |
| [`twitter-moot-radar`](../users/twitter-moot-radar.md) | Asks for your interests, reads what your mutuals follow, and suggests matching accounts with quoted proof and live follow status — or assesses one named account directly, with moot overlap and follow-back shown as context. Optional image, frame, or transcript proof is labelled and lower-weight; every handle, moot, and quote is linked; stops on access failures; opens each run with its state summary | Local agent with browser control |
| [`twitter-compatibility`](../users/twitter-compatibility.md) | Asks for the scope — focus, moots, following-only, followers-only, or all — and which subjects and factors matter; reads your feed and each target's posts, replies, reposts, and media, optionally reads image, video-frame, or audio-transcript evidence when an opted-in mode is proven, and scores interaction compatibility 0–100 with counted evidence, confidence, per-area breakdowns, and a replyable entry point; a named focus account is scored whether or not it is associated; read-only, never acts on X | Local agent with browser control |
| [`twitter-following-audit`](../users/twitter-following-audit.md) | Asks for your interests and a slice of your Following list, reads each account's bio, newest post date, and recent posts, and suggests one verdict per account — keep, unfollow, mute, or recheck — with a decision table, reason tags, and ties that temper an unfollow toward mute or recheck; safety findings are a separate flag track with quoted evidence, and block and report stay the user's decisions; optimistic by design: keep needs no evidence, negatives need dated evidence, and every card leads with what the account gives you; suggests only, never acts | Local agent with browser control |
| [`skill-verify`](skill-verify.md) | Checks a skill folder against the catalog rules — including personal-data safety for online skills — and reports pass/fail with evidence | Local agent with file and shell access |

The full instructions for each skill live in its `SKILL.md`; these pages explain
the skill rather than replacing it.

Skills that drive the same product form a group with central files named for the
group. The browser-driven X skills are the first group: they are built for real
people on personal X accounts, never for engagement farming, marketing, or brand
work. Their contract is
[`twitter-core.md`](twitter-core.md), and their copy-ready operative rules are
[`twitter-shared.md`](twitter-shared.md), copied verbatim into each member's
`references/twitter-shared.md`. The [group index](skill-groups.md) lists the
members and central files. That shared file also carries the group's multimodal
evidence gate: text is the default, and each enabled image, video-frame, or
audio-transcript mode is capability-tested per run and reported `available` or
`unavailable` instead of being silently zeroed. It also carries the group's
asking rule: every question a run puts to the user stands alone — plain words,
the reason for asking, and what each answer changes — and every example in a
question comes from what the run has observed about that user, never a fixed
script.

Every skill that drives a browser follows the same
[human cadence](browser-cadence.md): jittered, proportional waits copied into
its own body, with verification and challenge handling left exact.

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

Keep the body terse and behavior-complete. The official recommendation is under
500 lines and ~5,000 tokens; that is the pass line. This catalog aims tighter, at
roughly 200–300 lines and ~3,000 tokens, but the tighter aim is advisory and
never fails a skill. Write instructions, not an essay — imperative bullets,
tables, and checklists; cut motivation prose, repeated rules, and restated
examples before cutting a rule.

Past that, move dense material — schemas, long tables, vendor lore, worked
examples — into `references/` and say when to read each file. Keep resource
files flat and focused: one level deep from `SKILL.md`, because some hosts
search only two levels and recognise a limited set of file types.

Some runtimes split the third layer into "read a resource" and "run a script",
which is why Microsoft documents four stages. The content model is the same.

## Skills and project instructions

`AGENTS.md` is generic agent guidance, and project-specific context lives in the
lode. A skill is a portable task workflow that must work where neither exists.
Keep project conventions out of the skill; a skill must not depend on `AGENTS.md`,
the lode, or this wiki.

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
- **Size** — pass at under 500 lines and ~5,000 tokens, the official
  recommendation. Aim tighter, at roughly 200–300 lines and ~3,000 tokens, as
  advisory guidance. Write terse instructions, not prose. Move dense detail into
  `references/`, executable helpers into `scripts/`, and static templates or data
  into `assets/`; name each file and when to read it.
- **Runtime needs** — declare them in `compatibility` instead of assuming a
  capable environment. A need the skill can proceed without, such as an optional
  state-file write, is a stated fallback, not a blocker: continue on session
  state, print it for the user to verify, and accept repeated work next run.
- **Self-contained** — a skill folder is installed on its own, so `SKILL.md` may
  reference only files inside that folder (`references/`, `scripts/`, `assets/`).
  Never link to `docs/`, `lode/`, `AGENTS.md`, another skill, or any repository
  path. Duplicating a rule is correct; a broken link is not. A repo-maintenance
  skill may name repository paths it checks, but never depends on them as
  resources.
- **No real identities** — skill text, docs, lode entries, and commit messages
  use fictional placeholders (`@example_alice`, `example.com`). A real handle, name,
  email, or private detail belongs only in the runtime state file the skill
  defines, outside the repository (or in the session output the user verifies
  when writing is unavailable). For an X/Twitter, browser-driven, or other online
  skill, the folder is instructions,
  not run memory: no saved quotes, permalinks, follower lists, screenshots, or
  state dumps.
- **Groups** — a skill that belongs to a group (currently the
  [X/Twitter group](twitter-core.md)) follows the group contract instead of
  inventing browser, timing, or state behaviour. Copy the group's
  `references/<group>-shared.md` into the member and point the body at it; the
  central file is where rules are agreed and changed. Update the whole group,
  index, and every copy together.

## Adding a skill

1. Create `.agents/skills/<name>/SKILL.md`.
2. Write the frontmatter and instructions. If the skill joins a group, read the
   group contract, copy `references/<group>-shared.md` from the central file, and
   point the body at it.
3. Keep the body lean; move dense detail into `references/` files one level deep.
4. Add a row to the catalog table above, a bullet to
   [the root README](../../README.md), a page in the audience section that fits
   (`docs/users/` for an end-user skill, this section for a maintenance skill),
   and a lode entry.
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
conventions, not the body: the official 500-line / ~5,000-token recommendation
and the one-level-deep links are review checks, not validator output.
`read-properties` and `to-prompt` show what a host actually advertises.

## Related

- [Invoking skills](../users/invoking.md) — explicit syntax for every host and surface
- [Architecture](../operators/architecture.md) — how the tree reaches each host
- [Scripts](../operators/scripts.md) — wiring and recovery
- [Agent instructions](../developers/agent-instructions.md) — the repo rules
