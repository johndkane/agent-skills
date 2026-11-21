# Report format

Read this before the first card of a run. It holds the header, summary table, card,
bridge matrix, and presentation rules.

## Header

```markdown
## Compatibility report — @me

Scope: moots · 12 associated accounts · 5 scored · 3 stale · 2 queued
Visual: off (text-only)
Rubric v1 · reply-first · 3 areas (Rust ×3, Postgres ×2, AI ×1)
Weights: subject 40 · conversation 25 · format 15 · voice 10 · recency 5 · access 5
Source sample: 74 items (Posts 38, Replies 24, Media 12)
Targets: 5 scored · 1 provisional · 1 insufficient · 1 unreadable
Date: 2026-11-21 · State: ~/.x-compatibility/<handle>.json
```

State one line about what the state file holds and whether this run is session-only.
Never dump the file. The `Visual` header reads `off (text-only)`, `on (images
readable)`, or `unavailable (text-only fallback)`.

## Summary table

```markdown
| # | Account | Category | Score | Band | Best area | Main gap | Conf. |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | [@alice](https://x.com/alice) | moot | `███████░░░` 74 | Good | Rust 92 | AI 25 | high |
| 2 | [@bob](https://x.com/bob) | following-only | `███████░░░` 71 | Good | Rust 76 | AI 20 | high |
| 3 | [@carol](https://x.com/carol) | followers-only | `██████░░░░` 58 | Workable | Postgres 80 | Rust 25 | medium |
```

The bar is ten cells: `round(score / 10)` filled with `█`, the rest `░`. Rank only
`high` and `medium` confidence. Put `low` in a provisional table after it, never at
a higher rank.

## Card

```markdown
### [@alice](https://x.com/alice) — 74/100 · Good · confidence high

`███████░░░` 74 · moot · reply-first

| Area | Score | Weight | Matched items |
| --- | --- | --- | --- |
| Rust and systems programming | 92 | 3 | 4 |
| PostgreSQL internals | 63 | 2 | 3 |
| AI tooling | 25 | 1 | 1 |

**Sample:** 24 items — 14 posts, 4 replies, 4 reposts, 2 captioned media; 8 matched
across the areas.

**Signals:** 4 replies to others; 6 questions; 2 threads; 1 quote post.

**Visual:** none in this card. When visual evidence is on, write
`3 image-only items read visually` and mark each quoted visual item `[visual]`.

**Components:** subject 71 · conversation 66 · format 85 · voice 86 · recency 100 ·
access 60.

**Why:** "still rewriting the scheduler in unsafe Rust" — [2026-11-14](https://x.com/alice/status/...);
reposted "the borrow checker finally clicked" — [2026-11-09](https://x.com/bob/status/...);
reply "try the arena allocator first" — [2026-11-02](https://x.com/alice/status/...).

**Fit:** replies to 4 accounts · short, question-led · text and image mix · active 4 days ago.

**Gap:** little AI tooling in the last 30 days (1 item).

**Entry point:** ["which profiling tool do you reach for first?"](https://x.com/alice/status/...) —
an open question in the strongest area; a reply could compare your own setup.

**Caution:** none.
```

The "Why" line carries two or three items, not a summary. The "Entry point" is the
newest matching post within 14 days that asks a question or invites a reply; if
none qualifies, write `none in this sample`. It names an angle, never a ready-to-send
message, and nothing is posted.

## Bridge matrix

```markdown
| Area | [@alice](https://x.com/alice) | [@bob](https://x.com/bob) | [@carol](https://x.com/carol) |
| --- | --- | --- | --- |
| Rust and systems programming | 92 | 76 | 25 |
| PostgreSQL internals | 63 | 55 | 80 |
| AI tooling | 25 | 20 | 45 |
```

Rows are the user's areas in weight order; columns are the top three ranked
accounts. It answers "shared on what?", not only "who is highest?".

## Lower and missing results

- **Provisional** — a table of `low` confidence scores, with the sample counts and
  the reason confidence is low. Never merged into the ranked table.
- **Thin or low** — high/medium-confidence scores below 55, one line each: handle,
  score, main gap.
- **Insufficient** — fewer than five readable items: handle, items read, what was
  missing.
- **Unreadable** — protected or notice-replaced pages: handle, what did not render.
  No score and no inference.
- **Out of scope** — handles in state whose live category no longer matches the
  chosen scope: handle, category, date. Keep the entry; no score this run.
- **Hidden** — handles the user asked to skip, with the reason and date.

An empty result is valid. Report the counts, then offer to widen the window, add
signal terms, or read the missing tab. Never pad the table with a weak match.

## Rules

- **Counts before adjectives.** Write `8 matched items, 6 questions`, not "very
  active". The evidence is the body of the card; the score summarizes it.
- **Quote and link.** Every cited item has visible text of 200 characters or fewer,
  its date, and a permalink read in this run. Every handle links to its profile.
  Never build a status URL from a handle.
- **Show the gap.** Every card names its weakest area or missing signal; a report
  with only strengths is not the score.
- **Scope and category are visible.** State the scope in the header and the category
  on every card and row; never mix categories silently. Category is reported, not
  scored.
- **Visual mode is visible.** The header says `off`, `on`, or `unavailable`; an
  unavailable session is text-only. Label visual items `[visual]`, describe only
  what is visible, and keep their lower weight. An unreadable image is noted and
  not counted.
- **Confidence is visible.** In each card heading, and as a column in the table.
- **No predictions.** Do not say someone will reply, will agree, is friendly, or is
  a good person. Do not describe a persona beyond the sampled items.
- **No actions.** End the report by saying nothing was liked, replied to, followed,
  or messaged.
- **Method note.** One short paragraph: sample sizes, window, rubric version, and
  that the score compares this sample under this rubric only.
