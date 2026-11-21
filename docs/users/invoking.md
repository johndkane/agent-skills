# Invoking skills

There are two ways a skill gets used. Your app can load it **automatically**
when your request sounds like what the skill is for, or you can **call it up by
name** yourself. The catch: each app has its own way of naming skills — the
same symbol means different things in different apps, and one app's skill
command is another app's settings menu.

This page shows the way that works in each app, so you never have to guess.

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

"Loads automatically" never means guaranteed. Automatic loading is your app
matching your request against the skill's description; calling it by name
removes the guesswork.

## Claude Code

Claude Code treats a skill like a command. Put the name at the start of the
message:

```text
/twitter-followback review my new followers
```

The same syntax works in the IDE extension and in headless runs, where Claude
Code expands the name inside the prompt string:

```bash
claude -p "/twitter-followback review my new followers"
```

You can also just ask in plain language ("review my new followers") and let the
description do the matching. Claude Code reads `.claude/skills` (and
`~/.claude/skills`).

## Claude Cowork

Cowork is account-based, not folder-based. Type `/` in the message box and
select a skill, or simply ask:

```text
Use the twitter-followback skill to review my new followers.
```

Cowork uses the skills enabled for your claude.ai account. It doesn't read
`~/.claude/skills` from your machine, so a skill that exists only in this
checkout needs to be switched on in **Customize > Skills** first. Once it's on,
it works everywhere Cowork does — desktop, web, and mobile.

## GitHub Copilot

Copilot has the widest spread of surfaces.

**VS Code chat.** Type `/` and pick the skill, or type the command directly:

```text
/twitter-followback review my new followers
```

You can add details after the command — for example,
`/twitter-followback for followers from the last 30 days`. Copilot also loads a
skill on its own when your request matches its description.

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

After adding a skill during a session, `/skills reload` saves you a restart.
From the terminal, `copilot skill list` and `copilot skill add <path>` do the
same outside a session.

**Copilot app.** Skills set up for your repositories or Copilot CLI are
available automatically. Manage them under **Customize > Skills**; sessions
load them by description.

**Cloud agent and code review.** These surfaces load project skills
automatically. Commit the skill to the repository (`.github/skills`,
`.claude/skills`, or `.agents/skills`); a skill sitting only on your laptop
won't reach a cloud sandbox unless the surface supports a synced location.

Visual Studio and JetBrains also find skills; slash-command support depends on
the IDE version, so count on automatic loading there.

## OpenCode

OpenCode is the one that catches people. **Skills are not slash commands.**
Type `@` and the skill ID:

```text
@twitter-followback review my new followers
```

The `@` mention attaches the skill to your message. `/` opens OpenCode's own
command menu (`/models`, `/agents`, `/new`, …), so `/twitter-followback`
correctly reports **No matching items** — it's looking for a command that
doesn't exist.

OpenCode also shows skills to the model and lets it call the `skill` tool by
ID. For `opencode run`, put the mention or a plain instruction in the prompt:

```bash
opencode run "@twitter-followback review my new followers"
opencode run "Use the twitter-followback skill to review my new followers."
```

Two version notes:

- Current builds use `@skill-id`; some versions also expose a `/skills` picker.
  `/skill-name` is not a command in OpenCode, so don't expect it in the `/`
  menu.
- V1 reads its configuration at startup. A skill added or edited while the app
  is running can stay invisible until you quit and relaunch. `opencode debug
  skill` lists what a fresh process discovers.

## Codex

In Codex CLI and the IDE extension, call a skill with `$`:

```text
$twitter-followback review my new followers
```

Or open the picker with `/skills` and choose it. The same syntax works in a
non-interactive run:

```bash
codex exec --full-auto 'Use the $twitter-followback skill to review my new followers.'
```

In the ChatGPT desktop app, where Codex skills are also available, type `@` and
select the skill instead. Codex notices skill changes on its own; restart it if
a new skill doesn't appear.

## Cursor

In Agent chat, type `/` and select the skill, or type its name:

```text
/twitter-followback review my new followers
```

Note that `@` in Cursor is the context picker: picking a skill with `@`
attaches it as context rather than running it. To keep a skill active for the
whole session, invoke it as a Custom Mode with **Option+Enter** on macOS or
**Alt+Enter** on Windows. The Cursor CLI uses the same `/` menu and Custom Mode
shortcut.

## Gemini CLI

Gemini CLI has no `/skill-name` command. The slash command manages skills; the
agent activates them through the `activate_skill` tool and asks for your OK
first:

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
workspace folder has to be trusted before its skills load.

## Prefix cheat sheet

| Prefix | Skill use | Also means |
| --- | --- | --- |
| `/` | Claude Code, Cowork, Copilot (VS Code and CLI), Cursor | OpenCode commands; Gemini CLI skill management |
| `@` | OpenCode (loads the skill), ChatGPT desktop (selects it), Cursor (attaches it as context) | Claude Code and Gemini CLI file/context mention |
| `$` | Codex CLI and IDE extension | — |

Don't assume a prefix carries over from one app to another. When in doubt, ask
for the skill by name in plain language — every app understands that.

## If a skill won't load

- **The skill's own settings.** `disable-model-invocation: true` makes a skill
  manual-only. `user-invocable: false` hides it from the command menu in Claude
  Code and Copilot. Cursor uses `disable-model-invocation: true` for
  slash-only skills. OpenCode additionally supports
  `metadata.opencode/autoinvoke: false`, which hides the skill from the model
  but still allows loading it by ID. Codex sets
  `policy.allow_implicit_invocation: false` in `agents/openai.yaml`.
- **Wrong folder.** Use the app's project skills directory or its personal one.
  Cowork and Copilot cloud load from your account or the project repository,
  not from a local folder.
- **Stale session.** Some apps read skills only at startup. Restart after
  adding or editing a skill when there's no reload command.
- **Permissions.** An app can block the `skill` tool or hide a skill with a
  permission rule, even though the files are there.
- **Wrong surface.** A skill available in the IDE isn't automatically available
  in the cloud agent, the desktop app, or Cowork.

To see what an app actually found, run `opencode debug skill` for OpenCode,
`gemini skills list --all`, `/skills list` in Copilot CLI, or `$` / `/skills`
in Codex.

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

Related: [User guide](README.md) · [Getting skills](getting-skills.md)
