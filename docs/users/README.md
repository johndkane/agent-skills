# User guide

Skills are task-scoped workflows an agent loads when your request matches them.
This section tells you which skill to choose, how to get it, and how to use it.
You do not need to know how the project behind the skills is built.

## Available skills

| Skill | What it does for you | Full guide |
| --- | --- | --- |
| `twitter-followback` | Reviews your new followers on X and follows back only real, active people, filtering bots, marketing, adult, crypto, and impersonation accounts. Text is the default; optional image and frame checks are capped and labelled. Keeps progress on your machine so long queues resume, or in-session when file write is declined. | [twitter-followback](twitter-followback.md) |
| `twitter-moot-radar` | Finds accounts worth following through your mutuals, ranked by how many of them follow each account and shown with a quoted post and proof you do not follow it yet. Optional image, frame, or transcript proof is labelled and lower-weight. Nothing is followed without your approval. | [twitter-moot-radar](twitter-moot-radar.md) |
| `twitter-compatibility` | Scores how compatible you are with your associated accounts on X — moots, accounts you follow, accounts that follow you, or all — on subjects you choose, with a 0–100 score, counted evidence, per-area breakdowns, and a post worth replying to. Asks for the scope first; text is the default and image, video-frame, or audio-transcript evidence is opt-in. Read-only. | [twitter-compatibility](twitter-compatibility.md) |

The X skills need interactive browser control with a browser already signed in
to X, plus local file write for cross-run state when it is available. They run
locally; cloud, sandboxed, or headless sessions cannot run them. If you decline
file write, they continue on session state and print it for you to verify, so a
later run may repeat work. Their run state stays on your machine and never enters
the repository, and their output links the handles and posts they cite.

## Choose a skill

- **Clean up who you follow back** → `twitter-followback`.
- **Find people to follow through your network** → `twitter-moot-radar`.
- **See who you would interact with easily, and on what** →
  `twitter-compatibility`.

## Get and use it

1. [Get the skill](getting-skills.md) — ask your agent, copy the folder, or
   enable it in your account.
2. [Use the skill](invoking.md) — explicit invocation in Claude Code, Copilot,
   OpenCode, Codex, Cursor, and Gemini CLI.
