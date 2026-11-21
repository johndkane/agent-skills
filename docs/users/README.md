# User guide

Skills are task-scoped workflows an agent loads when your request matches them.
This section tells you which skill to choose, how to get it, and how to use it.
You do not need to know how the project behind the skills is built.

## Available skills

| Skill | What it does for you | Full guide |
| --- | --- | --- |
| `twitter-followback` | Reviews your new followers on X and follows back only real, active people, filtering bots, marketing, adult, crypto, and impersonation accounts. Keeps progress on your machine so long queues resume, or in-session when file write is declined. | [twitter-followback](twitter-followback.md) |
| `twitter-moot-radar` | Finds accounts worth following through your mutuals, ranked by how many of them follow each account and shown with a quoted post and proof you do not follow it yet. Nothing is followed without your approval. | [twitter-moot-radar](twitter-moot-radar.md) |

Both X skills need interactive browser control with a browser already signed in
to X, plus local file write for cross-run state when it is available. They run
locally; cloud, sandboxed, or headless sessions cannot run them. If you decline
file write, they continue on session state and print it for you to verify, so a
later run may repeat work. Their run state stays on your machine and never enters
the repository, and their output links the handles and posts they cite.

## Choose a skill

- **Clean up who you follow back** → `twitter-followback`.
- **Find people to follow through your network** → `twitter-moot-radar`.

## Get and use it

1. [Get the skill](getting-skills.md) — ask your agent, copy the folder, or
   enable it in your account.
2. [Use the skill](invoking.md) — explicit invocation in Claude Code, Copilot,
   OpenCode, Codex, Cursor, and Gemini CLI.
