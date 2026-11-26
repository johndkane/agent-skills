# dotnet-practices-reviewer

A read-only reviewer agent for .NET changesets. It inspects a working-tree
diff, a commit, or a branch diff for proper use of asynchrony and the other
advanced .NET mechanisms — async composition, cancellation, timers and
background work, streaming and disposal, I/O boundaries, concurrency shape,
and modern API selection — judged against current Microsoft guidance and
against the mechanisms the solution already builds in. It returns prioritized
findings and never edits files.

This agent ships as stock for a repository shaped like its home project: it
expects a root `AGENTS.md`, a `lode/` knowledge tree, and the built-in
mechanisms it names (a single `TimeProvider` owner, a cancellation convention
on Core contracts, database-enforced concurrency, a canonical hosted-service
pattern, factory-built HTTP clients, a storage streaming seam, a telemetry
single owner, and a plugin load contract). Copy it into a project that has
those anchors; in a different .NET repository, treat its built-in-mechanism
list as the template to fill in with that project's own.

## Install

Copy `dotnet-practices-reviewer.md` — the single file is the whole agent —
into the agent directory your app reads: `.zcode/agents/`, `.claude/agents/`,
or `.github/agents/`. In this repository the aliases under `.agents/agents`,
`.claude/agents`, and `.github/agents` already expose it to every app that
reads one of those locations, so nothing needs copying.

Its companion slash command, `dotnet-practices-review`, installs the same way
from `.zcode/commands/`.

## When it triggers

- "review my changes for async correctness", "check the cancellation handling"
- a .NET changeset touching async code, hosted services, timers, streams,
  `HttpClient`, or concurrency
- adopting or bypassing one of the project's built-in .NET mechanisms
- a second opinion on modern API selection in a diff

It is not for general correctness regressions, security posture, or test
coverage — other reviewers own those dimensions, and this agent flags only the
asynchrony and advanced-mechanism one.

## How a review runs

1. It reads the project's instruction files (`AGENTS.md`, the relevant `lode/`
   entries) so its judgement reflects recorded conventions.
2. It inspects the complete diff — read-only git commands only — plus enough
   surrounding code to understand each changed path.
3. It judges the change through lenses such as async composition, cancellation
   flow, background work and timers, streaming and disposal, I/O boundaries,
   concurrency shape, and modern API selection, continuing through the whole
   diff rather than stopping at the first issue.
4. Every finding is verified against the call sites and the built-in mechanism
   it bypasses, and names the Microsoft guidance behind it — a CA rule, a
   VSTHRD rule, or a documented recommendation.

Findings come back ordered by severity (`P0` release blocker through `P3`
modernization), one short paragraph each with the affected scenario and the
guidance cited. A clean review says `No findings.` rather than inventing one.
For a branch review it diffs from the merge base, so it reviews what would
actually merge.

## Requirements

| Need | Why |
| --- | --- |
| File read access | It reads the diff and surrounding code |
| Shell access, read-only git | `git diff`, `git status`, `git log`, `git blame` |

No browser, no network, no account.

## Safety

- Read-only by contract: it never edits files, stages, commits, pushes, or
  posts comments, and it does not delegate the review onward.
- Recorded design decisions are not findings — it flags only code that widens
  or bypasses one.
- The slash command carries a fallback for runtimes without subagents: the
  main agent reads the definition and executes the procedure itself, reporting
  in the same output format.

## Related

- [User guide](README.md) — choose a skill and what it needs
- [Invoking skills](invoking.md) — command syntax per host
- [Architecture](../operators/architecture.md) — how the agent files reach each app
