# software-documentation

The documentation-writing skill for any software project. It writes new
documentation, restructures a docs tree that grew out of control, or refreshes
pages that drifted from the code — with one audience per page, one home per
fact, and a strict rule that pages describe the system as it is now.

Install by copying the `software-documentation` folder into the skills
directory your host reads; the `SKILL.md` inside it is the whole skill. This
page explains it and is not part of the install.

## When it triggers

- "write documentation for this feature / module / project"
- "restructure our docs", "reorganize the documentation"
- "refresh the docs", "these pages are out of date"
- "set up a docs folder" for a repository that has none

It is not for changelogs, decision records, or run logs: durable pages carry
current state only, and history lives elsewhere.

## What it does

| Rule | What it enforces |
| --- | --- |
| One audience per page | Every page serves one reader — a user, an operator, a developer, or a decision-maker. Another audience gets a link to their page, never a restatement. |
| A place for everything | A project without a docs layout gets `docs/` split into `users/`, `operators/`, and `developers/`, indexed by `docs/README.md`. A layout that already exists stays as it is. |
| One home per fact | Every fact, procedure, and diagram is stated completely once, on the page that owns it; everything else links to it. |
| Terminology guide | Terms are defined exactly once, in a central guide beside the audience folders. |
| Cited sources | Every external reference carries the link and the source's name in the prose; official vendor sources first. |
| Current state only | Pages say what the system does now — no changelogs, no decision history, no stale completion claims. |
| Write with the change | A behavior change updates the pages, indexes, and diagrams it touches in the same change. |
| Diagrams beside their page | Mermaid embedded in the markdown, portrait orientation, rewritten per audience, deleted when they only repeat the prose. |
| Plain markdown | One block per source line, relative links, no wikilinks or vendor-specific extensions. |
| Code comments | Documentation comments on meaningful public contracts; never a comment that restates the code. |

When documentation and code disagree, the code wins: the skill reconciles the
documentation in the change that discovered the drift.

## Requirements

| Need | Why |
| --- | --- |
| File access | It reads your code and writes markdown |

No browser, no shell, no network, no account: it works in any host that can
read and edit files.

## Safety

- It edits documentation, never code. Where docs and code disagree it fixes the
  docs to match the code's real behavior and tells you what it found.
- An existing repository layout, or a shape you name, overrides its default —
  it keeps your split instead of reshaping to the template.
- For a large restructure, agree on the brief first: what moves, what stays,
  and what the new indexes should hold.

## Related

- [User guide](README.md) — choose a skill and what it needs
- [Invoking skills](invoking.md) — how to call it in your host
- [Skills reference](../skills/README.md) — the catalog rules behind every skill
