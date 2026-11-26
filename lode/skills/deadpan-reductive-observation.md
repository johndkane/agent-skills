# deadpan-reductive-observation

The catalog's style skill: it rewrites a supplied observation as one concise
deadpan reductive one-liner, and on request researches the subject to generate
genuinely different alternatives. The first member here with no X, browser,
runtime-state, or file surface: the default rewrite needs only a capable model.
Canonical instructions:
[`SKILL.md`](../../.agents/skills/deadpan-reductive-observation/SKILL.md);
human page:
[`docs/users/deadpan-reductive-observation.md`](../../docs/users/deadpan-reductive-observation.md).
Imported from its standalone upstream repository
(`deadpan-reductive-observation--agent-skill`), which can drift from this copy;
this catalog's copy is the one this repository documents. The upstream folder's
`README.md` and `agents/openai.yaml` (Codex display metadata) were not carried:
catalog skills are `SKILL.md` plus optional `references/`, `scripts/`,
`assets/`, and the human readme role belongs to the docs page.

## Rules the skill carries

- **Core style** — reframe the subject as an unexpectedly mundane, literal, or
  absurd description of what it effectively consists of; humor comes from the
  accuracy of the reduction, never an explicit joke or punchline.
- **Rewrite loop** — identify the underlying behavior, contradiction, ritual,
  inconvenience, or social dynamic; strip the conventional framing; reduce to
  what people are actually doing; keep the smallest surprising description
  that stays recognizably true; write one concise, confident, deadpan sentence.
- **Research mode** — only when the user asks for alternatives, stronger,
  more topical, or better versions: research the subject for recognizable
  habits, recurring frustrations, stereotypes grounded in observable behavior,
  distinctive terminology, current references, and commonly discussed
  experiences; prefer primary or credible current sources; use research to
  find comedic angles, never to paraphrase results; avoid obscure references
  unless they materially improve the line; never invent facts for humor.
- **Alternatives** — genuinely different angles, not minor rewrites, across
  dimensions such as social behavior, logistics, money, technology,
  relationships, bureaucracy, local culture, recurring rituals, and
  expectation-versus-reality; strongest straightforward reduction first; each
  option independently understandable.
- **Voice rules** — usually one sentence; concrete over abstract;
  understatement; obvious in retrospect; never explain or label the joke; no
  setup/punchline structure; puns and elaborate metaphors out (puns only when
  unusually natural); no forced `just`/`mostly just`/`basically` framing;
  casual social-media language; lowercase styling allowed; output only the
  rewritten observation unless alternatives, explanation, or research was
  requested.
- **Quality gate** — before returning a line: recognizably true, unexpected
  reduction, a concrete human behavior inside, nothing removable, sounds
  observed rather than written, explaining it would make it worse; otherwise
  rewrite.

## Identity

- Not a group member: no browser, no group-shared file, no runtime state, no
  `compatibility` requirements — web search is optional and only serves
  researched alternatives.
- Self-contained: the body names no file outside its folder and carries no
  links.
- Its examples are generic situations (weekend trips, dogs, video meetings,
  grocery runs); no identities, handles, or personal data.

## Catalog wiring

README bullet under "The skills"; catalog row in `docs/skills/README.md`; row
in `docs/README.md` users table and `docs/users/README.md`; page at
`docs/users/deadpan-reductive-observation.md`; the terminology entry "Deadpan
reductive one-liner"; tree lines in [layout](../layout/summary.md) and
`docs/operators/architecture.md`; this file and its `lode-map.md` row.

Related: [skills summary](summary.md), [skill-verify](skill-verify.md),
[group rules](groups.md).
