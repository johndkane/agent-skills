---
name: software-documentation
description: Write and keep software documentation true — one audience per page, one home per fact, a central terminology guide, current-state-only currency, diagrams beside the page that owns them, plain portable markdown, and code-level doc comments. Use when writing, restructuring, or refreshing documentation content for a software project. Not for changelogs, decision records, or run logs — durable pages carry the current state only. Default placement is docs/ with users/, operators/, and developers/ subfolders unless the repository or the user specifies otherwise.
---

# Software Documentation

How to write and maintain documentation for a software project: structure rules that serve the reader, ownership rules that prevent drift, and currency rules that keep pages true.

## Placement

- Default when a repository has no established layout: `docs/` with one subfolder per audience, indexed by `docs/README.md` with one row per document:
  - `docs/users/` — people using the software.
  - `docs/operators/` — people operating a deployment in production: running it day to day, monitoring and troubleshooting it, and upgrading, backing up, and recovering it.
  - `docs/developers/` — people building and changing the codebase.
- An existing repository layout, or a shape the user specifies, overrides the default; keep the split that exists rather than reshaping to the template.

## One Audience Per Page

- Decide who a page serves before writing: a person using the software, operating a deployment, building or changing the codebase, or deciding about it. One audience per document and per section.
- Never blend audiences. Where another audience needs a fact, link to their page instead of restating it. A fact several audiences need is rewritten for each audience at its own home — never copied, never allowed to drift into variants.
- `README.md` is a visitor-level introduction: what the project is and a first run. Never a manual, an index, or a scratch area.
- Index pages are scannable tables — one row per document, one line of contents — linking onward. A hub page serves one audience and links across only where the other audience owns the fact.

## Configuration

- Deployment configuration is the operator's burden: operator pages own the full reference — every key, its effect, precedence, defaults, and secret handling — so an operator can configure a deployment without reading the codebase.
- The configuration system the codebase develops is developer knowledge, documented in full where developers work: options structure, binding and precedence mechanics, validation and startup-failure behavior, and how new settings join — never reduced to a pointer at the operator reference. The two audiences' pages rewrite per audience and link across.

## One Home Per Fact

- Every fact, definition, procedure, and diagram is stated completely once, on the page that owns the knowledge. Everything else links to it.
- Durable documentation never carries duplicate manuals: link to the manual; never restate a subset of it beside it.
- Terms are defined once, in the central terminology guide.

## Terminology

- A central terminology guide owns the project's terms — default `docs/terminology.md`, beside the audience folders — and every documented term is defined there exactly once.
- Spell acronyms out at first use in a document — "International Business Machines (IBM)" — then the acronym alone.
- Expand vague or ambiguous jargon at first use the same way: a bare "rail" is opaque to a new reader, so introduce it as the fuller name or define it in the guide before relying on it.
- Definitions are positive: the guide always says what a term or acronym is, never what it is not — a clear definition makes disambiguation-by-negation unnecessary.

## External References

- Any reference to external documentation always links and cites: the exact page's URL plus the source named in the prose — a bare link or an unnamed paraphrase is neither. The citation lets the claim read with its backing in place and survive link rot.
- Provenance order: official vendor sources first; when none exists for the subject, well-known trusted sources.

## Current State Only

- Documentation describes the system as it is: no changelogs, no decision history in durable pages, no run-specific counts, no stale completion claims from past changes.
- When documentation and source disagree, source and executable tests establish behavior — reconcile the documentation in the change that discovered it.
- Plans, proposals, and research records are separate documents, grounded in the implemented codebase, carrying an explicit status (governing / executed / archived) that is updated when the work lands. Session scratch and handovers go to ignored directories, never durable documentation.

## Write With The Change

- A behavior change updates the knowledge it touches in the same change: the owning pages, the indexes listing them, and any diagram showing the changed component. Stale diagrams are drift like stale prose.
- A structural change — projects, modules, scripts, tools, instruction artifacts — updates everything that names those things in the same change. Where the repository ships a mechanical checker for its knowledge corpus, run it.

## Diagrams

- Mermaid embedded in the markdown itself, beside the page that owns the knowledge; portrait (top-down) orientation.
- A diagram conveying a significant concept should be included in the documentation of every audience whose readers fall under that concept's purview — rewritten per audience like any other fact, never left prose-only just because prose could struggle through alone.
- Usefulness is the bar: a diagram that only restates adjacent prose is deleted, not maintained.
- Examples are welcome where they explain something but carry no standing expectation; significant-concept diagrams do.

## Markdown Style

- Plain and portable: one block per source line, relative links to sibling files without heading fragments, no wikilinks, no vendor-specific extensions.
- No banners restating a title; no commentary restating the code or the obvious.

## Code-Level Documentation

- Documentation comments on meaningful public contracts; comments elsewhere only for non-obvious constraints. Never a comment that restates the code.

## Verification

- Documentation-only changes need link and consistency checks, not the build or test suite.

- [ ] Every referenced path resolves.
- [ ] Every index entry names what is on disk.
- [ ] The audience boundaries hold.
