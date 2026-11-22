# Report format

Read before the first card. The report opens, summarizes, cards the negative
verdicts, flags safety findings separately, lists the keeps, and closes.

## Opening

One block: the scope and its counts, the interests and windows in force, the
strictness, the evidence modes and capability, the audit version, and the
state line.

## Verdict summary

| Handle | Category | Verdict | Reason | Newest post | Confidence |
| --- | --- | --- | --- | --- | --- |

- Handle linked to `https://x.com/<handle>`; category `moot` or
  `following-only`; reason tag, or `—` for keep; newest post date read this
  run; confidence from the sample.

## Cards for unfollow, mute, and recheck

```text
@example_alice — unfollow (outside-interests) · moot · confidence high
Gives: weekly Rust posts in past audits; follows you; replied last month.
Changed: newest post 2026-08-02 (outside the 90-day window); 0 of 12 items in
the window match an area.
Would return to keep: a post in Rust and systems programming.
Alternative: mute keeps the tie and quiets the feed.
```

Rules:

- "Gives" leads the card: the tie, the matched history from state, or the bio
  value — one line, factual.
- "Changed" carries the dated fact: dormancy, zero matched items, the feed-fit
  counts, or the quoted item with its date and permalink.
- "Would return to keep" names the concrete thing that flips the verdict back:
  posting in an area, becoming active again.
- For mute: say what mute does — the tie stays, the posts leave the feed.
- For recheck: name the follow-up date.
- Where the decision table offers the user's call, the card leads with the
  optimistic verdict and names the other in one line.

## Safety flags

Flagged accounts come after the verdict cards, in their own section — a flag
never mixes with a verdict. For each:

```text
@example_alice — safety flag (impersonation)
Evidence: copied display name and avatar of an existing account; post on
2026-11-02 offering a fake giveaway — quoted with date and permalink.
Your options: block (severs contact and also unfollows), report to X, or
unfollow alone (feed removal only). This run performed nothing.
```

- Quote every piece of safety evidence with dates and permalinks.
- Name the options with the calibration: block for harassment or
  impersonation, and for scams or bots that interact with the user; unfollow
  alone for a harmful account that never interacts; report where platform
  rules are implicated.
- The user decides; this run performed nothing.

## Keeps

One line each: linked handle and what earns the slot — the matched area with
the item's date, or the tie. No card, no score, no qualification.

## Closing

- Held, unreadable, and overridden handles separately, one line each, with
  their reason.
- Counts: audited, kept, one count per non-keep verdict, flagged, held,
  unreadable, remaining in queue, and the resume point.
- The line that nothing was changed on X.
- The next run: the queue continues, or the scheduled rechecks.

An empty result or an all-keep result is valid and normal; report the counts.

No real handles in skill text or saved examples: the template uses
`@example_alice`, and run output links the handles it read.
