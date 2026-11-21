# Suggestion card and report format

Read this before writing the first suggestion of a run. It holds the card
template and the presentation rules; Step 7 decides the order.

## Card

```markdown
[@handle](https://x.com/handle) — Display name
Interest: Rust and systems programming
Moots: [@a](https://x.com/a), [@b](https://x.com/b) (2)
Evidence: "spent the week rewriting the scheduler in unsafe Rust" — [2026-11-14](https://x.com/handle/status/...)
Bio: [systems engineer, ex-embedded](https://x.com/handle)
Status: not followed · follows you
Why: writes about low-level Rust, and two of your Rust moots follow them
Caution: none
```

A focus account uses the same card with `Moots: none` (or the actual count) and a
`Focus: named by you` line. Overlap is context, never a gate.

When an evidence mode is on and proven, a non-text match may replace the quoted
line:
`[image] "Rust code with impl Trait" — [2026-11-14](https://x.com/<handle>/status/<id>)`,
`[video] "…"`, or `[audio] "…"`. Label it, rank it below text proof, and never
describe more than the pictured subject or legible words. Open the report with
`Evidence: text+images (available)` or the `unavailable — text-only` form.

Placeholders come from the profile reading in this run. Never fill a line from
memory, from a previous run, or from the follow relationship.

## Rules for the presentation

- **Evidence before adjectives.** The quote, date, and permalink come first; the
  one-sentence "why" only connects them to the interest the user named.
- **Label non-text proof.** `[image]`, `[video]`, or `[audio]` marks lower-weight
  evidence read under an opted-in mode; it never outranks a quoted post or proves a
  real person.
- **Name the moots.** `@a, @b (2)` is the social proof; do not summarise it as
  "several moots". For a focus account, `none` is a valid count and carries no
  judgement.
- **State the relationship honestly.** `follows you` is a bonus, not a reason;
  `not followed` must come from the control read in this run.
- **Flag the thin ones.** Protected, brand-adjacent, or single-post evidence gets
  a `Caution` line rather than a silent ranking boost.
- **Keep a near-miss list.** High-overlap candidates without readable interest
  evidence, with a one-line reason each, so the user can overrule the rubric.
- **No invented fits.** Do not describe an account as an expert, a founder, or a
  practitioner unless the profile says so.

## Report order

1. Target: whole moot graph or named focus account, and the interests, overlap
   bar, and exclusions in force.
2. Suggestions grouped by interest, strongest first; a focus account presented
   singly, with moot overlap as context.
3. Near misses, with reasons.
4. Filtered counts by reason.
5. Protected accounts excluded.
6. Follow outcomes, if any, separated into verified, pending, and unverified.

An empty suggestion list is valid; report the counts and offer to widen the
brief rather than padding.
