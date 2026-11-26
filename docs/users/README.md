# User guide

A skill is a set of instructions your agent loads when your request matches it.
This guide helps you pick one, get it into your app, and use it. You don't need
to know anything about how this repository is built.

Never set up an AI assistant before? Start with
[From zero to your first skill](quickstart.md) — one fast, free path from a
fresh machine to a working skill, in plain language.

## The skills

| Skill | What it does for you | Full guide |
| --- | --- | --- |
| `twitter-followback` | Looks at your new followers on X and follows back the real, active people. Bots and marketing, adult, crypto, and impersonation accounts are skipped. It checks each follow before calling it done and keeps its progress on your machine, so a long session can resume later. Optional image, video-frame, and audio checks are off unless you turn them on. | [twitter-followback](twitter-followback.md) |
| `twitter-moot-radar` | Finds accounts worth following through your mutuals. You name your interests, it reads what your moots follow, and every suggestion comes with proof — the post that shows the match, a link to it, and a live check that you don't follow it yet. It can also look at one account you name, whatever its relationship to you. Nothing is followed without your approval, name by name. | [twitter-moot-radar](twitter-moot-radar.md) |
| `twitter-compatibility` | Scores how well you'd get along with accounts on X about the things you care about — your moots, people you follow, people who follow you, or one account you name. It reads both feeds, counts real posts and replies, and returns a 0–100 score with the evidence behind every point. Read-only: it never likes, replies, follows, or messages anyone. | [twitter-compatibility](twitter-compatibility.md) |
| `twitter-following-audit` | Reviews the accounts you already follow and suggests what to do with each: keep, unfollow, mute, or look again later. Optimistic by design — keep is the default, every other suggestion carries dated evidence, and unfollow is about fit, never a judgement of the person. Safety problems are flagged with evidence for you to decide. It only suggests; every action is yours. | [twitter-following-audit](twitter-following-audit.md) |
| `software-documentation` | Writes and keeps your project's documentation true — one audience per page, one home per fact, a terminology guide, and pages that say what the system does now, updated in the same change as the code. No browser or account needed. | [software-documentation](software-documentation.md) |
| `dotnet-practices-reviewer` | A read-only reviewer agent for .NET changesets. It judges async composition, cancellation, background work, streaming, I/O boundaries, concurrency shape, and modern API use against Microsoft guidance and the project's built-in mechanisms, and returns prioritized findings — it never edits files. | [dotnet-practices-reviewer](dotnet-practices-reviewer.md) |

The reviewer agent is a subagent definition rather than a skill: your app
loads it when a review is delegated to it, or when its
`/dotnet-practices-review` command runs.

## What they need to run

The X skills drive a real browser, so they need:

- an agent with browser control, and a browser already signed in to X;
- to run on your machine — cloud or sandboxed sessions can't run them;
- optionally, permission to save a small progress file in your home folder, so
  long sessions can pick up later. If you'd rather not, they keep going and
  show you their progress instead — you may just see some work repeated next
  time.

No browser control yet? You don't have to prepare anything: a skill that
can't get control offers to walk you through setting it up, step by step if
this is all new to you, using only your app's official documentation — see
[Setting up browser control](browser-setup.md).

Everything they learn stays on your machine and never enters this repository,
and everything they report links back to the page it came from. Every question
one of them asks stands on its own: plain words, the reason for asking, and
what your answer changes — nothing to decode. Any example a question gives
comes from your own profile, posts, or previous settings, offered for you to
confirm — never a canned one.

## Choose a skill

- **Follow back the right people** → `twitter-followback`.
- **Find new people through your own network** → `twitter-moot-radar`.
- **See who you'd click with, and about what** → `twitter-compatibility`.
- **Decide who still earns a place in your Following list** → `twitter-following-audit`.
- **Write or fix your project's documentation** → `software-documentation`.
- **Review a .NET changeset for async and modern-API correctness** → `dotnet-practices-reviewer`.

## Get and use it

Starting from nothing? [From zero to your first skill](quickstart.md) covers
the whole setup — install OpenCode, connect your browser, pick a free model,
and run a skill — in one pass. Otherwise:

1. [Get the skill](getting-skills.md) — ask your agent, or copy one folder.
2. [Use the skill](invoking.md) — how to call it up in Claude Code, Copilot,
   OpenCode, Codex, Cursor, and Gemini CLI.
