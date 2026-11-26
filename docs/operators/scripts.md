# Scripts

Two scripts wire the catalog into the directories agent hosts read. They are
behaviourally identical; pick the one your shell can run.

| Script | Runs on |
| --- | --- |
| [`link-skills.sh`](../../scripts/link-skills.sh) | macOS, Linux, Git Bash, WSL |
| [`link-skills.ps1`](../../scripts/link-skills.ps1) | Windows PowerShell or pwsh |

Every link they create is relative and points into the canonical `.agents`
tree — the skill hosts at `../.agents/skills`, Claude Code at `.agents` itself —
so the repository still works if it is cloned somewhere else.

The scripts wire **skills only**. The agent and command links (`agents` and
`commands` under `.agents/`, `.claude/`, and `.github/`) are committed directly
in the repository and are neither created nor repaired here — see
[Architecture](architecture.md#agents-and-commands) for that alias chain.

## Usage

```bash
./scripts/link-skills.sh                    # claude + copilot
./scripts/link-skills.sh cursor             # only .cursor/skills
./scripts/link-skills.sh claude copilot cursor
./scripts/link-skills.sh --all              # every host
./scripts/link-skills.sh --all --force      # replace anything unexpected
```

```powershell
./scripts/link-skills.ps1                   # claude + copilot
./scripts/link-skills.ps1 cursor
./scripts/link-skills.ps1 claude copilot cursor
./scripts/link-skills.ps1 -All
./scripts/link-skills.ps1 -All -Force
```

## Environments

| Name | Path wired | Default |
| --- | --- | --- |
| `claude` | `.claude -> .agents` (whole directory: skills, agents, commands) | Yes |
| `copilot` | `.github/skills` | Yes |
| `opencode` | `.opencode/skills` | No |
| `cursor` | `.cursor/skills` | No |
| `gemini` | `.gemini/skills` | No |
| `codex` | none, reads `.agents/skills` natively | Reports and skips |

The default is the two hosts that cannot rely on `.agents/skills` alone. The
opt-in hosts already read the canonical tree; wiring them is for a host or CI job
that only inspects its native directory.

Aliases are accepted: `claude-code`, `github`, `github-copilot`, `open-code`,
`gemini-cli`, `openai-codex`.

## Options

| Option | Purpose |
| --- | --- |
| `--all` / `-All` | Wire every environment above, including the native ones |
| `--force` / `-Force` | Replace a real directory or a link pointing elsewhere |
| `--help` / `-?` | Show usage |

## Behaviour

- **Idempotent** — a correct existing link reports `ok` and is left alone.
- **Safe by default** — a real directory is never deleted without the force flag.
- **Self-healing** — a plain file containing `../.agents/skills`, which is what a
  `core.symlinks=false` checkout produces, is replaced automatically.
- **Junction fallback** — on Windows, when symbolic links are refused, the
  PowerShell script creates a directory junction instead.
- **Sanity check** — after linking, the script compares entry counts against the
  canonical tree and warns on a mismatch.

Exit status is `0` on success, `1` for an environment problem such as a missing
canonical tree, and `2` for a usage error such as an unknown environment.

## Adding a host

When a new host needs a link:

1. Add a row to the `hosts` table in both scripts, using the same key and path.
2. Add an alias if the host has a common short name.
3. Add the row to the environment table on this page.
4. If it is a default, update the default-wiring rule and the
   [architecture](architecture.md) page.
5. Test `--help`, the default run, the new name, and `--all`.

## Related

- [Architecture](architecture.md) — why the links exist
- [Skills](../skills/README.md) — the catalog they expose
- [Agent instructions](../developers/agent-instructions.md) — repo rules and checks
