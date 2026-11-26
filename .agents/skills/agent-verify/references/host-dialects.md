# Host Dialects

Per-host frontmatter tables for agent definition files, distilled from the
official specifications. Consulted 2026-11-25; re-read the official pages live
before relying on any field outside `name`, `description`, and `tools`, because
every vendor moves its docs.

## Claude Code — `.claude/agents/*.md`

| Field | Required | Rules |
| --- | --- | --- |
| `name` | Yes | Max 256 characters; no leading `-`; no `:` (reserved for plugin-scoped IDs). Identity comes from `name`, not the filename. |
| `description` | Yes | Tells the model when to delegate; "use proactively" encourages automatic delegation. Combined descriptions beyond 15,000 tokens trigger a startup warning. |
| `tools` | No | Comma-separated string or YAML list; omitted inherits all tools. Supports MCP entries (`mcp__server__*`). |
| `disallowedTools` | No | Denylist, same format; applied before `tools` resolution. |
| `model` | No | `sonnet`, `opus`, `haiku`, a full model ID, or `inherit`. |
| `permissionMode` | No | `default`, `acceptEdits`, `plan`, `bypassPermissions`, and siblings. |
| others | No | `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory`, `effort`, `isolation: worktree`, `color`, `background`, `omitClaudeMd`, `initialPrompt`, `autoCompactWindow`. |

Notes: multi-word fields are camelCase (`maxTurns`, `disallowedTools`);
unrecognized fields are silently ignored; the file is skipped entirely when
`name` is missing or YAML is unparsable. The body becomes the system prompt —
the subagent does not receive the main system prompt. Discovery walks up from
the working directory; project files are checked into version control.

## GitHub Copilot — `.github/agents/*.md` or `*.agent.md`

| Field | Required | Rules |
| --- | --- | --- |
| `description` | Yes | Purpose and capabilities. |
| `name` | No | Display name. |
| `target` | No | `vscode` or `github-copilot`; unset means both. |
| `tools` | No | Comma-separated string or YAML array; `["*"]` all, `[]` none. Aliases, case-insensitive: `execute`, `read`, `edit`, `search`, `agent`, `web`, `todo`; MCP namespacing `server-name/tool` or `server-name/*`. |
| `model` | No | Unset inherits the default model. |
| `disable-model-invocation` | No | `true` blocks automatic invocation; overrides the retired `infer`. |
| `user-invocable` | No | `false` hides from manual selection; default `true`. |
| `mcp-servers`, `metadata` | No | Ignored by IDE surfaces. |

Notes: the body is capped at 30,000 characters — the only hard body limit in
any dialect. The filename minus `.md`/`.agent.md` drives de-duplication;
lowest-level config wins. VS Code adds `model-policy` (`required`/
`preferred`) and `handoffs` (Local harness only); cloud agents ignore IDE-only
fields.

## OpenCode — `.opencode/agents/<name>.md`

| Field | Required | Rules |
| --- | --- | --- |
| `description` | Recommended | Shown to the model choosing a subagent. |
| `mode` | No | `primary`, `subagent`, or `all`; a new custom agent defaults to `primary`. |
| `model` | No | `provider/model`, optional `#variant`; subagents inherit the parent model. |
| `permissions` | No | Ordered `action`/`resource`/`effect` rules; last match wins. |
| others | No | `steps`, `hidden`, `color`, `disabled`, `request`. |

Notes: the agent ID is the filename, nested paths included. V2 deprecates the
legacy top-level fields — `tools`, `temperature`, `top_p`, `prompt`,
`permission`, `disable`, `maxSteps` — so a `tools` list written for Claude or
Copilot is dead weight in an OpenCode-targeted file. The body becomes the
system prompt.

## ZCode — `.zcode/agents/*.md`

No published specification in hand. The catalog's files follow the observed
shape: `name`, `description`, and a comma-separated `tools` string, matching
the Claude-family field names. Verify against ZCode's own documentation when
available; until then, treat `name`/`description`/`tools` as the supported
set and flag anything beyond them as unverified.
