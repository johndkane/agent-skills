# Setting up browser control

The X skills in this catalog work by seeing and clicking the real X app in
**your own browser**, in a session **you** are signed in to. So your agent
needs browser control: the ability to open tabs, read pages, and click for you
while you watch. If your setup already has it, the skill just proves it and
starts — this page is mostly for when it doesn't.

You don't need to know any of this in advance, and you don't need to wait
for a skill to hit the problem: just ask your assistant — "help me set up
browser control" — and it will walk you through the choices. A run that
can't get control stops and offers the same help on its own: a step-by-step
walkthrough (good if this is all new to you), a short version, or you can
set it up yourself while it waits. Here is what it will do, and why.

## What the skill will do

- **Tell you where you are.** It names the app you're running it in, or asks
  you which app that is.
- **Read the official guide with you.** It opens the documentation your app's
  maker publishes — their own website, never a random tutorial — and checks
  it is current before following it. If a page has moved, it searches the
  vendor's own site instead of trusting an old link.
- **Offer you real choices.** Your app's own built-in browser control first;
  then, if your app supports MCP — a standard way to plug browser control
  into an assistant — the browser maker's own official version. Each option
  comes with a one-line "what this does" before you pick.
- **Ask before changing anything.** Every install, settings change, or
  restart is proposed first, in plain words, with why it's needed. Nothing
  happens without your yes.
- **Leave signing in to you.** It never types your X password, a 2FA code, or
  a passkey — those screens are yours, always.
- **Prove it works before starting.** Setup counts as done only when it
  actually opens X, reads it back to you, and takes a screenshot. If it can't
  prove that, it says exactly what worked and what didn't, and stops cleanly
  — it never improvises a workaround.

## What a working setup looks like

- A **real, visible browser on your machine** that you can see and interact
  with — not a hidden window.
- **You are signed in to X in it**, with your own password and 2FA. The skill
  never touches credentials.
- **A browser you can watch.** You can see what the agent does and take the
  browser over at any moment. A browser on your own machine is the normal
  case. A browser on the agent's side — for example a cloud agent's built-in
  browser — works too, but only if the skill asks first and you say yes for
  that run: your X session then lives on that machine while it works, and
  signing in from a datacenter can draw more login checks. A headless browser
  you can't see can't run these skills at all.

## Finding the official guide yourself

If you'd rather set it up yourself, look for two things, in this order:

1. **Your app's own browser feature.** Open the documentation site your app's
   maker publishes — their own domain — and search it for "browser".
2. **Your browser maker's MCP server.** If your app has no built-in browser
   control but supports MCP, look for the official MCP server published by
   the maker of your browser, or by the browser-automation tool's publisher.

Trust only pages on the vendor's own site or official repository. Tutorials,
blogs, and forum posts go stale or get details wrong; the vendor's page is
the one that is true today.

## Starting points (accurate when written, November 2026)

These were the official pages when this was written. Vendors move pages
often — if a link is dead, search the vendor's own site for the feature
instead of trusting the old link.

| Your app | Where to look | Official page |
| --- | --- | --- |
| ZCode (Z.ai) | Settings → MCP Servers; bundled browser automation | zcode.z.ai/en/docs |
| Claude Code (Anthropic) | Claude in Chrome, or MCP servers | code.claude.com/docs/en/chrome, code.claude.com/docs/en/mcp |
| Codex CLI (OpenAI) | Official Chrome extension, or MCP servers | developers.openai.com/learn/codex, developers.openai.com/codex/mcp |
| Devin (Cognition) | Built-in browser: watch and take over from the session; you sign in; profiles can be saved | docs.devin.ai/work-with-devin/devin-session-tools, docs.devin.ai/work-with-devin/browser-auth |
| ChatGPT desktop app (OpenAI) | Built-in browser tool (separate profile — sign in inside the task) | learn.chatgpt.com/docs/browser |
| Gemini CLI (Google) | MCP servers | github.com/google-gemini/gemini-cli |
| OpenCode | MCP servers in config | opencode.ai/docs/config |
| Cursor | Tools & Integrations → MCP | cursor.com/docs/mcp |
| VS Code + Copilot (Microsoft) | "MCP: Add Server" command | code.visualstudio.com/docs/copilot/chat/mcp-servers |
| Chrome (browser side) | Chrome DevTools MCP | github.com/ChromeDevTools/chrome-devtools-mcp |
| Multi-browser automation | Playwright MCP | github.com/microsoft/playwright-mcp |

## Common hiccups

- **"The browser opened but isn't signed in to X"** — normal for a fresh
  setup. Sign in yourself; the skill waits and never asks for your password.
- **"Pages won't load"** — a hidden or background tab pauses rendering. Keep
  the browser window visible.
- **"It says browser control is blocked"** — the app's sandbox or approval
  settings are stopping the browser, a known situation. The skill should name
  what is blocked and walk you through the fix — a setting or your app's
  official browser extension — and never try to sneak past it. If it still
  can't get control, run it where browser control works.
- **"It asks to install something"** — read the one-line description first;
  installs happen only with your yes, and you can always say no and set it
  up yourself instead.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
