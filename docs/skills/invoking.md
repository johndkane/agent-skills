# Invoking skills

A skill has two entry points. The host can load it **automatically** when your
request matches the skill's `description`, or you can invoke it **explicitly**.
Explicit syntax is host-specific: the same prefix does different things in
different apps, and one host's skill command is another host's command menu.

## Quick reference

| Host | Surface | Explicit invocation |
| --- | --- | --- |
| Claude Code | Terminal, IDE extension | `/skill-name` at the start of a message |
| Claude Code | Headless (`claude -p`) | Include `/skill-name` in the prompt string |
| Claude Cowork | Desktop, web, mobile | Type `/` and select the skill, or name it in plain language |
| GitHub Copilot | VS Code chat | Type `/` and select the skill, or type `/skill-name` |
| GitHub Copilot | Visual Studio, JetBrains | Loads automatically; slash support depends on the IDE version |
| GitHub Copilot CLI | Terminal | `/skill-name` anywhere in the prompt |
| GitHub Copilot app | Desktop app | Loads automatically; manage under **Customize > Skills** |
| GitHub Copilot cloud agent and code review | GitHub.com | Loads automatically from the repository |
| OpenCode | TUI, desktop, `opencode run` | `@skill-id` — **not** `/skill-id` |
| Codex | CLI and IDE extension | `$skill-name`, or the `/skills` picker |
| Codex | ChatGPT desktop app | Type `@` and select the skill |
| Cursor | Agent chat, IDE and CLI | `/skill-name`, or `@` to attach it as context |
| Gemini CLI | Terminal | No direct name command; ask and approve activation; `/skills` manages skills |

“Loads automatically” never means guaranteed. Auto-selection is a description
match; explicit invocation is how you remove the guesswork.

## Claude Code

Claude Code treats a skill as a command. Put the name at the start of the
message:

```text
/twitter-followback review my new followers
```

The same syntax works in the IDE extension and in headless runs, where Claude
Code expands the name inside the prompt string:

```bash
claude -p "/twitter-followback review my new followers"
```

You can also let the description trigger it ("review my new followers"). Claude
Code reads `.claude/skills` (and `~/.claude/skills`), which is why this repository
links `.claude/skills` to the canonical tree.

## Claude Cowork

Cowork is account-based, not checkout-based. Type `/` in the message box and
select a skill, or name it in plain language:

```text
Use the twitter-followback skill to review my new followers.
```

Cowork loads the skills enabled for your claude.ai account. It does not read
`~/.claude/skills` from the machine running the session, so a skill that exists
only in this checkout must be enabled in **Customize > Skills** before Cowork
can see it. Once enabled, it works across Cowork on desktop, web, and mobile.

## GitHub Copilot

Copilot has the widest spread of surfaces.

**VS Code chat.** Type `/` and select the skill, or type the command directly:

```text
/twitter-followback review my new followers
```

Skills can add context after the command, for example
`/twitter-followback for followers from the last 30 days`. Copilot also loads a
skill automatically when the description matches.

**Copilot CLI.** Put the skill name in the prompt, preceded by a slash:

```text
Use the /twitter-followback skill to review my new followers.
```

The CLI also has management commands:

```text
/skills list
/skills info twitter-followback
/skills reload
```

After adding a skill during a session, `/skills reload` avoids a restart. From
the terminal, `copilot skill list` and `copilot skill add <path>` do the same
outside a session.

**Copilot app.** Skills configured for your repositories or Copilot CLI are
available automatically. Manage them under **Customize > Skills**; sessions load
them by description.

**Cloud agent and code review.** These surfaces load project skills
automatically. Commit the skill to the repository (`.github/skills`,
`.claude/skills`, or `.agents/skills`); a personal skill on your laptop is not
available to a cloud sandbox unless the surface supports a synced location.

Visual Studio and JetBrains also discover skills; slash-command support depends
on the IDE version, so treat automatic loading as the baseline there.

## OpenCode

OpenCode is the exception that catches people. **Skills are not slash
commands.** Type `@` and the skill ID:

```text
@twitter-followback review my new followers
```

The prompt is the message; the mention attaches the skill. `/` opens OpenCode's
command menu (`/models`, `/agents`, `/new`, …), so `/twitter-followback`
correctly reports **No matching items** — it is looking for a command that does
not exist.

OpenCode also advertises skills to the model and lets it call the `skill` tool by
ID. For `opencode run`, put the mention or a plain instruction in the prompt:

```bash
opencode run "@twitter-followback review my new followers"
opencode run "Use the twitter-followback skill to review my new followers."
```

Two version notes:

- Current builds use `@skill-id`; some versions also expose a `/skills` picker.
  `/skill-name` is not a command in OpenCode, so do not expect it in the `/`
  menu.
- V1 loads configuration at startup. A skill added or edited while the app is
  running can be absent until you fully quit and relaunch. `opencode debug skill`
  lists what a fresh process discovers.

## Codex

In Codex CLI and the IDE extension, invoke a skill with `$`:

```text
$twitter-followback review my new followers
```

Or open the picker with `/skills` and choose it. The same syntax works in a
non-interactive run:

```bash
codex exec --full-auto 'Use the $twitter-followback skill to review my new followers.'
```

In the ChatGPT desktop app, where Codex skills are also available, type `@` and
select the skill instead. Codex detects skill changes automatically; restart it
if a new skill does not appear.

## Cursor

In Agent chat, type `/` and select the skill, or type its name:

```text
/twitter-followback review my new followers
```

`@` is the context picker in Cursor; selecting a skill with `@` attaches it as
context rather than running it as a command. To keep a skill active for the whole
session, invoke it as a Custom Mode with **Option+Enter** on macOS or
**Alt+Enter** on Windows. The Cursor CLI uses the same `/` menu and Custom Mode
shortcut.

## Gemini CLI

Gemini CLI does not document a `/skill-name` command. The slash command manages
skills; the agent activates them through the `activate_skill` tool and asks for
your consent:

```text
/skills list
Use the twitter-followback skill to review my new followers.
```

Approve the activation prompt when it appears. Related commands:

```text
/skills enable twitter-followback
/skills disable twitter-followback
/skills reload
```

From the terminal, `gemini skills list --all` inspects the same set. Workspace
skills are discovered from `.gemini/skills` or the `.agents/skills` alias; a
workspace folder must be trusted before its skills load.

## Prefix cheat sheet

| Prefix | Skill use | Also means |
| --- | --- | --- |
| `/` | Claude Code, Cowork, Copilot (VS Code and CLI), Cursor | OpenCode commands; Gemini CLI skill management |
| `@` | OpenCode (loads the skill), ChatGPT desktop (selects it), Cursor (attaches it as context) | Claude Code and Gemini CLI file/context mention |
| `$` | Codex CLI and IDE extension | — |

Do not generalize a prefix from one host to another. When in doubt, ask for the
skill by name in plain language; every host understands that.

## Why a skill may not be invokable

- **Frontmatter policy.** `disable-model-invocation: true` makes a skill manual
  only. `user-invocable: false` hides it from the command menu in Claude Code and
  Copilot. Cursor uses `disable-model-invocation: true` for slash-only skills.
  OpenCode additionally supports `metadata.opencode/autoinvoke: false`, which
  hides the skill from the model but still allows explicit loading by ID.
  Codex sets `policy.allow_implicit_invocation: false` in `agents/openai.yaml`.
- **Wrong directory.** Use the host's project location, or the linked
  `.claude/skills` / `.github/skills` in this repository. Cowork and Copilot
  cloud are account- or repository-based, not local-checkout-based.
- **Stale session.** Some builds load skills once at startup. Restart after
  adding or editing a skill when the host does not offer a reload command.
- **Permissions.** A host can deny the `skill` tool or hide a skill through an
  agent-specific permission rule even when the file is discovered.
- **Wrong surface.** A skill available in the IDE is not automatically available
  in the cloud agent, the desktop app, or Cowork.

For this repository's inventory, run `opencode debug skill` for OpenCode,
`gemini skills list --all`, `/skills list` in Copilot CLI, or `$` / `/skills` in
Codex.

## Sources

- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [Claude skills overview](https://claude.com/docs/skills/overview) and
  [Cowork overview](https://claude.com/docs/cowork/overview)
- [Copilot agent skills](https://docs.github.com/en/copilot/concepts/customizations/agent-skills),
  [Copilot CLI skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills),
  and [VS Code skills](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [OpenCode skills](https://opencode.ai/docs/skills/)
- [Codex skills](https://learn.chatgpt.com/docs/build-skills)
- [Cursor skills](https://cursor.com/docs/skills) and
  [Cursor CLI](https://cursor.com/docs/cli/using)
- [Gemini CLI skills](https://geminicli.com/docs/cli/skills/) and
  [commands](https://geminicli.com/docs/reference/commands/)

Related: [Skills](README.md) · [Architecture](../architecture.md) ·
[Scripts](../scripts.md) · [Agent instructions](../agent-instructions.md)
