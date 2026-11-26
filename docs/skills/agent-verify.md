# agent-verify

The repository's verification gate for the agent layer. It checks an agent
definition (`.zcode/agents/*.md`) or its paired command file
(`.zcode/commands/*.md`) against the official host specifications and the
catalog rules, and reports pass/fail with file evidence, so an agent is not
handed off because it "looks right".

Install by copying the `agent-verify` folder into the skills directory your
host reads; the `SKILL.md` inside it is the whole skill. This page explains it
and is not part of the install.

## When it triggers

- before handing off any agent or command file creation or change
- "verify this agent", "check the agent file", "review my subagent"
- "is this agent ready?", "audit the commands folder"

It is not for skills (`skill-verify` owns that gate) and it does not author
agent content.

## Requirements

| Need | Why |
| --- | --- |
| Local file read and shell | It reads the files and runs the wiring checks |
| A git checkout | Scope detection and the `120000` link check |

There is deliberately no validator step: no official validator exists for
agent files. The Agent Skills project publishes `skills-ref` for skills only.

## What it checks

1. **Frontmatter** — `name` and `description` required and honest; the
   repository's strictest-useful identity rule (ASCII kebab-case `name` equal
   to the file stem) applied across hosts; every `tools` value checked against
   the target host's vocabulary; dialect-only fields flagged as dead weight
   elsewhere rather than failed.
2. **Safety** — no secrets, real identities, or run memory; an absolute local
   path is a portability finding. Unlike skills, an agent body may name
   repository paths it reads — that is the project-scoped contract, not a
   violation.
3. **Body shape** — imperative system prompt; read-only reviewers carry the
   never-edit contract and scope boundaries; the output contract is honest; a
   command file pairs with its agent and states the no-subagent fallback.
4. **Catalog wiring** — lode catalog row, docs page, README mention,
   terminology where a concept is new.
5. **Wiring and links** — the alias chain resolves from every committed
   reader, the committed links are mode `120000`, and relative links in touched
   docs and lode files resolve.

## Spec sources

The skill distills the official specifications into
`references/host-dialects.md`, carried inside the folder so a copied install
keeps them. Consulted 2026-11-25; these links are dated conveniences and
expire:

- [Agent Skills specification](https://agentskills.io/specification) — confirms
  the spec covers skills only; no agent section exists
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents) —
  `.claude/agents` format and field set
- [GitHub Copilot custom agents reference](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
  and the [custom agents concept](https://docs.github.com/en/copilot/concepts/customizations/custom-agents)
  — `.github/agents` fields, tool aliases, body cap
- [VS Code custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents)
  — IDE-side fields, `.agent.md` naming
- [OpenCode agents](https://opencode.ai/docs/agents/) — `.opencode/agents`
  format, modes, deprecated V1 fields

ZCode publishes no specification in hand; its `.zcode/agents` dialect is the
observed `name`/`description`/`tools` shape, marked unverified in the
reference file. When a check fails or a host-specific field is load-bearing,
re-read the official page live that run.

## Output

A table of check, result, and evidence; failures first with `file:line` and
the exact fix; and an explicit list of anything that could not be checked,
including spec pages not read live. It is read-only unless the user asked for
fixes, in which case the affected checks are re-run afterwards.

## Limits

The token and character figures are estimates, not tokenizer output. The
distilled dialect tables can go stale — they record what the official pages
said on the consultation date, and the skill instructs a live re-read before
relying on anything outside `name`, `description`, and `tools`. Identity is
judgement-based at the edges: the gate proves the file matches the repository
rule mechanically, but "would this host actually resolve this tool name" is a
vocabulary check against a moving target.

## Related

- [Skills catalog](README.md) — the rules it enforces on the skill side
- [skill-verify](skill-verify.md) — the skills gate, its sibling
- [Agent instructions](../developers/agent-instructions.md) — the rule set
