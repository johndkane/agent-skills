# Adopting this repo

This repository is designed to be dropped into another project. Nothing here
builds, generates, or installs anything, so adoption is a copy and a link.

## Fast path

Point your agent at the repository:

> Clone `<repo-url>` into a temporary directory, copy `.agents/skills` into my
> project, then wire the hosts I use.

The agent copies the tree and runs the link script for the hosts you name. This
is the same path described in the [root README](../../README.md).

## What to copy

| Item | Why |
| --- | --- |
| `.agents/skills/` | The skills themselves; no placeholders, no symlinks |
| `scripts/link-skills.sh` | Wires the catalog on macOS, Linux, and Git Bash |
| `scripts/link-skills.ps1` | Wires the catalog on Windows |
| `.gitignore` rules | Protects the destination from agent-local state and secrets |
| `.gitattributes` | Normalises line endings so skill files stay stable |
| `AGENTS.md` | Generic agent guidance; it works unchanged in another repository |

Do not copy `docs/` or `lode/`. The docs describe this repository, and the lode is
this repository's project-specific agent memory. A host project should grow its
own.

## Merge, do not overwrite

If the destination already has a `.gitignore`, merge the agent rules into it.
Never overwrite the file wholesale, and keep the warning at the top: do not ignore
`.agents/` or any agent link, or the skills disappear from version control.

`AGENTS.md` is generic and can be taken as-is. Do not copy the lode: it describes
this repository. If the destination needs its own project rules, start a lode
there rather than merging this one.

## Wire the hosts

```bash
./scripts/link-skills.sh          # claude + copilot
./scripts/link-skills.sh cursor   # one host
```

```powershell
./scripts/link-skills.ps1 -All
```

See [Scripts](scripts.md) for environments, flags, and the recovery path when a
clone arrives without symlinks.

## Validate

```bash
.venv/bin/skills-ref validate .agents/skills/<name>
```

Every skill must report `Valid skill` before the change is committed.

## Related

- [Architecture](architecture.md) — why the copy-and-link model works
- [Skills](../skills/README.md) — the catalog and its rules
- [Scripts](scripts.md) — the wiring reference
