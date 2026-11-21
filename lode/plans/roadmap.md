# Roadmap

Open directions, not commitments. Keep entries short and remove them when done.

## Catalog

- Grow the catalog one folder per skill. Never restructure the tree per skill.
- Keep `SKILL.md` lean and terse: aim for ~200–300 lines and under ~3,000 tokens.
  Grow `references/` with focused, one-level-deep files instead of letting the
  body pass 500 lines or 5,000 tokens.
- Keep the README skill-agnostic above the list. Do not name a specific skill in
  the intro; the list is the catalog.
- Prefer portability over host-specific features, and describe limits in
  `compatibility` instead of assuming a capable runtime.

## Wiring

- Keep default wiring at `claude` + `copilot`; add a host only when it cannot
  read `.agents/skills`. When you do, add a link, a README row, and a
  `.gitignore` note.
- Keep the two link scripts behaviourally identical as hosts are added: the same
  environment names and aliases, `claude` + `copilot` by default, `--all`/`-All`
  for every host, `--force`/`-Force` to replace, and self-healing for placeholder
  files left by a `core.symlinks=false` checkout.

## Repository

- Keep the embedded Lode prompt verbatim with upstream when it changes.
- Keep `AGENTS.md` generic and reusable; project rules belong in `lode/`.

Related: [lode-map](../lode-map.md), [practices](../practices.md),
[layout](../layout/summary.md).
