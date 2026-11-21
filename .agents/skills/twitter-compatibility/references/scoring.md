# Scoring model

Read this before the first score of a run. It holds the point values, formulas,
confidence rules, bands, and a worked example. The body names the steps; this file
is the arithmetic.

## Sample

| Side | Read | Default cap |
| --- | --- | --- |
| Source | own Posts, Replies, Media, Likes when visible | 40 / 30 / 15 / 15 |
| Target | Posts, Replies, Media, reposts visible in Posts | 30 / 20 / 10 |

One item is one URL. Deduplicate across tabs. A repost carries the repost marker
and the original author's words; weight it as amplification, never authorship.

An item is classifiable only if its readable text, caption, or alt text supports a
match. An image with none of those is 0 subject evidence in text-only mode; with
visual evidence on and proven, it follows the visual rule below. Either way it
counts for format fit.

## Scope

Scope is a population filter, not a scoring factor. The formulas are identical for
`moots`, `following-only`, `followers-only`, and `all`; the category changes which
associated accounts enter the run and what the report shows. A category is
confirmed from list membership and the live profile, never inferred from the score.
Access still uses `follows you` and `replied to you`, so a followers-only account
can score higher on access than a following-only account with the same content.

An account outside the chosen scope is not scored or reported this run; keep its
state entry for later. A scope change alone never invalidates a score.

## Area score

Match the frozen lexicon case-insensitively against item text, media captions, and
alt text. Never match a handle or display name.

| Item kind | Points |
| --- | --- |
| Original post | 3 |
| Reply | 2 |
| Quote post | 2 |
| Repost | 1.5 |
| Media with caption or alt text | 2 |
| Image-only, text-only mode or visual unavailable | 0 |
| Image-only, visual on, standard area | 1 |
| Image-only, visual on, `visual` area | 2 |

```text
areaScore = round(100 × min(1, points / 12))
```

Four original posts about an area reach 100; a single post reaches 25. An item
matching two areas counts in both: a cross-cutting post is legitimate evidence,
not a bonus. Cap each area at 12 points so one prolific thread cannot dominate.

Visual-only points are capped at 6 in a standard area and 12 in a `visual` area;
the area's overall 12-point cap still applies, so images can support a subject but
cannot carry a non-visual area alone.

```text
subject = round( Σ(areaScore × areaWeight) / Σ(areaWeight) )
```

Area weights are 1–5 and belong to the user.

## Visual evidence

Text is the default for two reasons: not every host returns image pixels to the
model, and visual subject matching is less reproducible than text. The user opts in
explicitly, and the skill proves image access before counting anything.

- `visualEvidence: off` — captions and alt text only. Image-only media is 0 subject
  evidence.
- `visualEvidence: on` — after the capability test, a legible image or video frame
  may support an area. Record a short observation, such as "image: Rust code with
  `impl Trait`", with its date and permalink.
- **Capability test** — screenshot a page and state one visible detail from the
  image that the page's text does not contain. If you cannot, or the tool returns
  only a path or metadata, set `visual: unavailable`, run text-only, and report it.
  A filename, URL, caption, or alt text is not proof you saw the image.
- **`visual: true` on an area** — for photography, illustration, design, or another
  area whose primary evidence is images. Image-only items then count 2 and cap at
  12; otherwise 1 and cap at 6.
- **Audio is not assessed.** A video thumbnail or visible frame is visual evidence;
  the soundtrack is not.
- An unreadable, blurry, cropped, or ambiguous image is 0 for that item and is noted;
  never guess at its subject.
- Visual-only matches cap confidence at `medium`; `high` needs at least three
  text-based or captioned matches.

## Conversation score

Count each surface in the target sample, cap each, then cap the sum at 100.

| Surface | Points each | Cap |
| --- | --- | --- |
| Reply to someone other than the source | 6 | 30 |
| Reply to the source | 10 | 20 |
| Post or reply containing a question or an explicit invitation | 5 | 25 |
| Quote post with own commentary | 4 | 16 |
| Thread root | 4 | 8 |
| Poll | 4 | 8 |

```text
conversation = min(100, Σ points)
```

A reply that asks a question counts twice; it is two observable surfaces. Do not
infer friendliness, openness, or willingness to talk from any of them.

## Format fit

Classify every source and target item into one bucket, in this order: thread,
video, image, link, text. Nothing is double-bucketed.

Choose the source sample once, in this order: Replies when at least five, else
Likes when visible and at least five, else Posts. This measures what the user
engages with, not only what they publish.

```text
formatFit = round(100 − 50 × Σ |sourceShare − targetShare|)
```

Identical distributions score 100; disjoint distributions score 0. If the source
sample has fewer than five items in every available tab, use 50 and drop confidence
to medium at best.

## Voice fit

Measure original posts and quote posts only; exclude replies and reposts. Require
at least five items on each side, else use 50 and lower confidence.

Compute four ratios on each side: median character length, question rate,
first-person rate (`I`, `my`, `me`, `we`, `our`), and emoji rate.

```text
lenFit     = 100 − min(100, |medianSource − medianTarget| / 2)
questionFit= 100 − min(100, |questionSource − questionTarget| × 250)
firstFit   = 100 − min(100, |firstSource − firstTarget| × 250)
emojiFit   = 100 − min(100, |emojiSource − emojiTarget| × 400)
voice      = round(mean(lenFit, questionFit, firstFit, emojiFit))
```

A 200-character length gap, a 40-point question or first-person gap, or a 25-point
emoji gap reaches zero. These are style signals, not personality.

## Recency and cadence

Use the newest original post, not a reply or repost.

| Age | Recency |
| --- | --- |
| ≤ 2 days | 100 |
| ≤ 7 days | 85 |
| ≤ 14 days | 65 |
| ≤ 30 days | 45 |
| ≤ 90 days | 20 |
| older or none | 0 |

| Original posts per week, last 30 days | Cadence |
| --- | --- |
| ≥ 5 | 100 |
| 2 – 4.9 | 75 |
| 0.5 – 1.9 | 50 |
| > 0 – 0.49 | 25 |
| 0 | 0 |

```text
recency = round((recencyScore + cadenceScore) / 2)
```

## Access and relationship

| Signal | Points |
| --- | --- |
| Target follows the source (`Follows you`) | 40 |
| Target replied to the source in the sampled Replies tab | 30 |
| Profile is public and readable | 20 |

```text
access = min(100, Σ points)
```

This component is a bonus, not a verdict: at the default 5% weight it can move the
total by at most five points. A protected account is `unreadable`, so it never
reaches this formula.

## Total

```text
score = round( Σ(component × weight) / Σ weights )
```

Normalize whatever weights the user confirmed; report the final set. Round only at
the end. Never adjust a score by hand.

## Bands

| Score | Band | Meaning |
| --- | --- | --- |
| 85–100 | Strong | Many shared subjects and open conversation surfaces |
| 70–84 | Good | A clear shared area with some replyable material |
| 55–69 | Workable | Partial overlap, or one area with a thin surface |
| 40–54 | Thin | Weak overlap; mostly a different feed |
| 0–39 | Low | Little shared subject or interaction surface |

## Confidence

Confidence is separate from the score and always displayed.

| Level | Requires | Treatment |
| --- | --- | --- |
| `high` | ≥20 target items, ≥2 tabs, ≥3 text-based matched items, ≥20 source items | Ranked |
| `medium` | ≥10 target items, ≥1 matched item, ≥10 source items | Ranked |
| `low` | ≥5 target items | Provisional block, never ranked above ranked scores |
| `insufficient` | <5 readable target items | No score; state what was missing |
| `unreadable` | Profile or posts did not render | No score; no inference |

A missing Replies or Media tab caps confidence at `medium`. A score with no
matched items can still be reported as `low` with "no shared subject in the
sample"; the lexicon, not the person, may be the limit. A target whose only matches
are visual caps at `medium`.

## Worked example

Rubric: Rust ×3 (12 points), Postgres ×2 (6 points), AI ×1 (0 points). Visual
evidence is off in this example.

```text
subject    = round((100×3 + 50×2 + 0×1) / 6) = 67
conversation: 3 replies to others (18) + 5 questions (25) + 2 quotes (8)
              + 1 thread (4) = 55
format     = 90 from a 0.20 total share difference
voice      = mean(95, 90, 75, 80) = 85
recency    = mean(85 for 3 days, 75 for 3 posts/week) = 80
access     = 40 follows you + 20 public = 60
```

Default `reply-first` weights 40 / 25 / 15 / 10 / 5 / 5:

```text
(67×40 + 55×25 + 90×15 + 85×10 + 80×5 + 60×5) / 100 = 69.55 → 70
```

70 is `Good`, with `high` confidence from 38 target items, 14 matches, and 74
source items. The report shows every count above; the number alone is not the
result.

## Rules

- Same rubric, same sample, same score. If two runs disagree, compare the counts
  before the totals.
- Never score a tab you did not read, or a lexicon you did not confirm.
- Never count a visual item you did not see; a caption or filename is not visual
  evidence.
- A score from another rubric version or an older sample is stale, not comparable.
- Do not translate a score into a prediction, a personality claim, or a reason to
  follow, like, or message.
- Report the counts that produced the score, including the zero areas.
