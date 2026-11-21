---
name: twitter-compatibility
description: >-
  Score how compatible you are with your associated accounts on X (Twitter) —
  moots, the accounts you follow, and the accounts that follow you — for subjects
  you choose: asks for the scope and interest areas first, reads both your own feed
  and each target's posts, replies, reposts, and media, optionally reads image-only
  media when you opt in and the session can view images, and returns a 0-100
  compatibility score with the counted evidence behind every point, a ranked table,
  per-area breakdowns, and a recent post worth replying to. Use when asked who you
  should interact with, which accounts fit you, how compatible you are with
  someone, who to reply to, or to score your moots, follows, or followers on a
  topic. Read only: it never likes, replies, follows, or messages. Not for growth,
  engagement farming, or judging people.
compatibility: >-
  Needs interactive browser control and a browser session already signed in to X,
  plus optional local file write for cross-run state. For optional visual evidence,
  the model and browser tool must return readable images; otherwise the run stays
  text-only. Must run locally on the user's machine; cloud, sandboxed, or headless
  sessions without browser access cannot complete it.
---

# X/Twitter Compatibility

Score how compatible you are with your **associated accounts** on X, on the subjects
you name. An associated account is a moot, an account you follow that does not
follow you back, or an account that follows you that you do not follow. Ask the
scope up front — `moots`, `following-only`, `followers-only`, or `all` — then score
only that subset.

## Group rules

Read [references/twitter-shared.md](references/twitter-shared.md) before starting.
It carries the rules shared by every X skill — state line, linked evidence, human
cadence, access failures, and privacy — and it is part of this skill.

## Rules

- Scope comes from the user up front: `moots` (you follow and they follow you),
  `following-only` (you follow, they do not follow you), `followers-only` (they
  follow you, you do not follow them), or `all` associated accounts. Never infer it
  from state or from who happens to be in the queue.
- An account in neither the user's Following nor Followers list is not associated;
  ask before adding it, and record the exception.
- Read both sides fresh every run: the source user's own Posts, Replies, Media, and
  visible Likes, and the target's Posts, Replies, Media, and reposts. State is
  memory, never evidence.
- Interests and factors come from the user. Restate the areas, signal terms, area
  weights, component weights, targets, and budget before scoring.
- A score needs a sample. Fewer than five readable target items is `insufficient`,
  not zero; a protected or notice-replaced page is `unreadable`.
- Every point is traceable: show the counts behind it and quote the items behind
  the strongest, weakest, and entry-point signals.
- Replies, quotes, reposts, threads, polls, and captioned or alt-texted media
  count. A repost is amplification, not authorship, and weighs less.
- Text is the default. Image-only media is 0 subject evidence unless the user opts
  into visual evidence and the session proves it can see images; then it is
  lower-weight, capped, and never enough for high confidence alone.
- Confidence sits beside every score. A low-confidence score is provisional and
  never outranks a high-confidence score in the summary.
- A high score means more shared, replyable material in this sample — not
  friendship, agreement, or a guaranteed reply.
- Read only: no like, reply, repost, follow, block, report, or message, not even as
  a test. The output is a report and an optional entry point for the user.
- Cadence and privacy follow the shared rules. Keep quotes short and infer nothing
  from hidden content.

## Step 0 — Confirm browser control

1. Check the tool's status: connection, pairing, tabs. No tabs is fine — open one.
2. Open X in a tab you created and keep; keep it visible, since hidden tabs pause
   rendering.
3. Prove control: navigate, read the title or visible text, screenshot.

If control is missing, stop and give the prerequisites — pair the relay, open the
signed-in browser, name the profile — then wait. Hand off login, 2FA, passkey,
captcha, or payment; never enter credentials.

## Step 1 — Read the current UI

1. Confirm the signed-in handle; several accounts may share one browser. This is
   the **source user**.
2. Open the source profile and record the visible tabs: Posts, Replies, Media,
   Likes when present, Following, and Followers. X changes these; read what is
   there now.
3. Note the markers for original post, reply, quote post, repost, thread, poll,
   image, video, link card, alt text, pinned post, `Follows you`, and the follow
   control's exact label.
4. Open one target profile and confirm the same tabs and markers. A missing tab is
   a named gap, not a zero.
5. A protected profile or a "potentially sensitive content" notice is unreadable:
   no bio, no posts, no score. Record `unreadable` and move on.

## Step 2 — Load state and give the state line

1. Read [references/state-file.md](references/state-file.md), then the file at
   `~/.x-compatibility/<handle>.json` (`%USERPROFILE%\.x-compatibility\<handle>.json`
   on Windows, with the `@` dropped).
2. Say one state line: the path, scope, visual mode, rubric version with its areas
   and weights, current versus stale targets, and the last write. No file means the
   run starts fresh.
3. Ask once for file-write access. If it is refused or unavailable, say so in the
   state line and run on session state per the shared fallback.
4. Never present a saved score as current. Older than 14 days, or from another
   rubric version, is stale until re-read.

## Step 3 — Confirm the scoring brief

Ask, then restate in one paragraph. The scope is asked first; never infer areas
from the accounts themselves.

1. **Scope** — ask first, with no silent default: `moots` (you follow and they
   follow you), `following-only` (you follow, they do not follow you),
   `followers-only` (they follow you, you do not follow them), or `all` associated
   accounts (the union, each account once). Restate the scope and its counts. If
   the user says "use your judgement", propose `all`.
2. **Areas** — 3 to 8 concrete, checkable subjects. Push back once on vague ones:
   "tech" is not checkable; "Rust and systems programming" is.
3. **Signal terms** — 5 to 12 lowercase words or short phrases per area (tools,
   projects, jargon, names) that count as a match. Propose them, then get a yes.
   This lexicon is the measuring instrument and is frozen in state.
4. **Area weights** — 1 to 5 each, default 3.
5. **Factors** — the six component weights, defaulted by mode. Any weight may
   change; normalize and report the final set.

   | Mode | Subject | Conversation | Format | Voice | Recency | Access |
   | --- | --- | --- | --- | --- | --- | --- |
   | `reply-first` (default) | 40 | 25 | 15 | 10 | 5 | 5 |
   | `quote-first` | 40 | 15 | 15 | 15 | 10 | 5 |
   | `observe-only` | 50 | 10 | 15 | 10 | 10 | 5 |

6. **Visual evidence** — default `off`. Text is the portable default; visual is
   lower-weight and less reproducible. If the user turns it on, ask which areas, if
   any, are primarily visual (photography, illustration, design); those count
   image-only items at 2 and cap at 12, while other areas count 1 and cap at 6. The
   session must prove it can see images before any visual item is counted (Step 6).
   If it cannot, run text-only and flag `visual: unavailable`.
7. **Targets** — named handles, or a slice of the chosen scope. A named account
   outside the scope is scored only after the user confirms. Collect more handles
   than the batch and let the user pick.
8. **Exclusions** — default none, because the user chose these accounts. Offer to
   exclude categories or handles by name and record the reason.
9. **Window and budget** — default the last 30 days, with a 90-day look-back for
   low-volume accounts; default 3 targets per run, maximum 6, plus the source; 45
   minutes wall-clock.

If the user says "use your judgement", propose the whole brief and get a yes. A
materially changed brief, including visual mode or a `visual` area flag, bumps the
rubric version (Step 9); a scope change does not, because scores are content-based
and category is reported separately.

## Step 4 — Read the source feed

Read the source in this run; do not score from last run's copy.

1. From the source profile, sample up to 40 Posts, 30 Replies, 15 Media, and 15
   Likes when visible. Deduplicate by URL.
2. Capture per item: kind, visible text (≤280 characters), date, permalink,
   has-media, question mark, first-person language, emoji, thread position. Do not
   store text in state.
3. Compute source metrics: median length, question rate, first-person rate, emoji
   rate, and format shares.
4. Format fit uses the source's Replies first when there are at least five, then
   visible Likes, then Posts: it measures what the user engages with.
5. Collect continuously while scrolling; rows and cards are virtualised. Two empty
   stops end the tab.
6. If the source profile itself is unreadable, stop: there is no second side.

## Step 5 — Build the target queue for the chosen scope

1. Read the lists the scope needs: Following and Followers for `moots` and `all`;
   Following for `following-only`; Followers for `followers-only`. Collect handle,
   display name, bio excerpt, and `Follows you`; dedupe.
2. Classify each row:
   - `moot` — in Following and Followers when both lists were read, or `Follows you`
     on a profile the user follows.
   - `following-only` — in Following; no `Follows you` on a readable profile, or
     absent from Followers when that list was read.
   - `followers-only` — in Followers; `Follows you` present and the control is not
     `Following`/`Unfollow`, or absent from Following when that list was read.
   The live profile wins when a list row and the profile disagree.
3. Named handles: classify from the profile pair. An account in neither the
   Following nor the Followers list is not associated; ask before adding it, and
   record the exception.

   | `Follows you` | Control | Category |
   | --- | --- | --- |
   | present | `Following` / `Unfollow` | `moot` |
   | present | `Follow` / `Follow back` | `followers-only` |
   | absent | `Following` / `Unfollow` | `following-only` |
   | absent | `Follow` / `Follow back` | not associated — ask |

4. Present the sampled handles with their categories and counts; let the user
   choose the batch. List order is a sample, not a ranking.
5. Prefer stale, insufficient, and unreadable handles, then new ones. A current
   handle is read only when the user asks to re-score or wants it in this report;
   every target in the report is read in this run.
6. Queue the rest, with its category, for the next run.
7. Never score a suggestion module, "who to follow" strip, or search result as an
   associated account.

## Step 6 — Read each target feed

For each target, in queue order:

1. Open the profile; confirm the exact `@handle`, display name, and category. Note
   bio, join date, follower/following counts, `Follows you`, lock icon, and pinned
   post. If the live category no longer matches the selected scope, keep the state
   entry but leave it out of this run.
2. Sample up to 30 Posts, 20 Replies, 10 Media, and reposts visible in Posts.
   Deduplicate by URL; one item is one row.
3. If visual evidence is on, prove image access once per run before the first
   image-only item: screenshot a page and state one visible detail from the image
   that the page's text does not contain — a color, layout, or pictured object. If
   you cannot, or the tool returns only a path or metadata, set `visual:
   unavailable`, run text-only, and flag it in the report.
4. Classify each item and mark area matches against the frozen lexicon. Match text,
   captions, and alt text; when visual evidence is on and proven, also match a
   legible image or video frame and record a short visual observation with date and
   permalink. Never a handle, display name, filename, or URL alone. An unreadable,
   blurry, or ambiguous image is 0 for that item and noted, never guessed.
5. Count conversation surfaces, and take voice metrics from original and quote
   posts only (not reposts).
6. Record the strongest matching item, the weakest area, and any caution — brand,
   automated, engagement bait, or thin sample.
7. Stop at the batch, wall-clock limit, end of tabs, or two empty scroll stops.
   Write state after each target.

If the 30-day window yields fewer than five readable items, extend the same tabs to
90 days once, say so, and then score or record `insufficient`.

An image with no caption or alt text is 0 subject evidence in text-only mode or when
`visual: unavailable`. With visual evidence on and proven, it counts per the scoring
rules; it always counts for format fit. Never describe an image you did not see.

## Step 7 — Score

Read [references/scoring.md](references/scoring.md) before the first score; it holds
point values, formulas, confidence, and a worked example.

1. Score each area from matched items; combine areas by the user's weights into the
   subject component.
2. Score conversation, format, voice, recency, and access from counted signals.
3. Combine the six components by the confirmed weights, round once, and assign the
   band and confidence.
4. Fewer than five readable items: no score; record `insufficient` and what was
   missing.
5. Image-only items follow the visual rule: 0 in text-only mode; 1 point in a
   standard area and 2 in a `visual` area when visual evidence is on and the session
   can see images. Visual-only points cap at 6 and 12 per area, and visual-only
   matches cap confidence at `medium`.
6. Show the arithmetic: counts per component, strongest and weakest area, visual
   count, and tab counts. A score without its counts is not reportable.
7. Access carries at most 5 points of weight by default and never carries the
   score; `follows you` is a bonus, not a reason.
8. Category is reported, not scored; access still uses `follows you` and
   `replied to you`.

## Step 8 — Present

Read [references/report-format.md](references/report-format.md) before the first
card.

1. Open with the scope and its counts, visual mode and capability, the rubric, final
   weights, mode, sample sizes, date, and state line.
2. Ranked table: rank, linked handle, category, score with a ten-cell bar, band,
   strongest area, main gap, confidence.
3. A card for each target at or above the card floor (default 55), strongest first:
   category, per-area scores, counted signals, visual count, two or three quoted
   items with dates and permalinks, fit, gap, and one entry point when a recent
   matching post invites a reply.
4. A bridge matrix: areas as rows, the top three accounts as columns.
5. Lower scores, provisional, `insufficient`, `unreadable`, and out-of-scope
   handles separately, one line each. An empty or thin result is valid; report
   counts and offer to widen the sample or lexicon.
6. Link every handle and cited item per the shared rules; never invent a status URL.
7. Never describe a person as an expert, friend, or fit beyond the sampled items,
   and make no claims about personality, politics, health, or private life. Never
   describe an image or non-text content you did not actually see.

## Step 9 — Persist and report

1. Write after each target and before the run ends: scope, visual mode and area
   flags, rubric version, lexicon and weights, source metrics, per-target category,
   scores and counts, visual counts, queue, hidden handles, and follow-ups.
2. A changed rubric, visual mode, or `visual` area flag bumps the version; a scope
   change does not. Mark old scores stale and keep them only as a labelled previous
   score. Never mix versions in one ranking.
3. Record `scored`, `stale`, `insufficient`, `unreadable`, `hidden`, and `excluded`
   with a date and a short reason, plus each target's category. A target outside the
   current scope keeps its entry but is not reported.
4. Report what was read, what was missing, where the run stopped, and what remains.
5. Say plainly that nothing was liked, replied to, followed, or messaged.

## Limits

- The sample is public or self-visible posts, not private intent. A busy thread can
  lift one area; the counts make that visible.
- Reposts reflect amplification, not authorship.
- Voice fit compares observable style ratios, not personality.
- Visual evidence is lower-weight and less reproducible; image-only matches cannot
  lift a score to `high` confidence.
- Scores compare only within one rubric and one run.
- Protected accounts and notice-replaced pages cannot be scored, whatever the
  relationship.

## Safety

- Only the user's own account, only the confirmed scope.
- Read only: no like, reply, repost, follow, block, report, or message.
- No credentials; hand off challenges. A challenge ends the run.
- No DMs, no private data, no inference from hidden content.
- Never claim to see an image or non-text content you cannot; flag
  `visual: unavailable` and run text-only.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Done checklist

- [ ] Control proven; source and target identities confirmed; tabs read this run.
- [ ] State loaded or started fresh; state line given; rubric version and scope
      recorded.
- [ ] Scope chosen up front from moots / following-only / followers-only / all;
      counts restated.
- [ ] Visual mode confirmed; image access proven, or `visual: unavailable` flagged
      and the run kept text-only.
- [ ] Areas, signal terms, both weight sets, targets, and budget confirmed and
      restated.
- [ ] Source feed read in this run; source metrics computed from it.
- [ ] Every target has a confirmed category and a counted sample, or a named
      `insufficient`/`unreadable` reason.
- [ ] Image-only items counted only under the confirmed visual rule; visual-only
      matches labelled and capped at `medium` confidence.
- [ ] Every score shows its counts, confidence, band, strongest and weakest area.
- [ ] Every cited item has a date and permalink from this run; every handle is
      linked.
- [ ] Entry points are grounded in a quoted post; no action was taken.
- [ ] State written, or session state printed for verification; stale scores
      labelled.
- [ ] Report separates scored, thin, provisional, insufficient, unreadable,
      out-of-scope, and hidden.
- [ ] Cadence jittered; access failures flagged, not scored.
