# twitter-compatibility

Scores how compatible you are with accounts on X, for the subjects you care
about. By default that means your **associated accounts**: a moot, someone you
follow who does not follow you back, or someone who follows you whom you do not
follow. You can also name one account — whether or not it follows you back or
belongs to those groups — and score it directly, with its relationship shown as
context. It asks for the scope first — focus, moots, following-only,
followers-only, or all — then reads your own feed and the target's, and returns a
0–100 score with the counted evidence behind every point. It can optionally read
image, video-frame, and audio-transcript evidence when you opt in and the session
proves it can. It is not a personality guess and not a prediction that someone
will reply. It serves a real person on their own personal account — never
engagement farming, marketing, or brand growth.

Install it by copying the `twitter-compatibility` folder into your skills
directory; see [Getting skills](getting-skills.md). Invoke it in plain language or
with your host's explicit syntax; see [Using skills](invoking.md).

## When it triggers

- "who should I interact with on X?"
- "which accounts fit me?"
- "how compatible am I with `@example_alice`?"
- "score my moots on Rust"
- "score the people I follow who don't follow back"
- "score my followers I don't follow back"
- "score everyone in my network on Postgres and systems programming"
- "include image-only posts, video frames, or audio transcripts in the score"
- "who would be easy to reply to about this?"

It is read-only: it never likes, replies, reposts, follows, or messages. It is
**not** for growth, engagement farming, marketing, or judging people.

## Requirements

| Need | Why |
| --- | --- |
| Interactive browser control | Every read happens in the real UI |
| A browser already signed in to X | The skill never handles credentials |
| A local session | Cloud, sandboxed, and headless sessions cannot complete it |
| Following and Followers lists | Classify moots, following-only, followers-only, and all; a focus account is classified from its live profile instead |
| Non-text evidence modes (optional) | Need a model and browser tool that return images, video frames, or an audio transcript; otherwise that mode is flagged unavailable and the run stays text-only |
| Local file write | Keeps the scope, evidence modes, rubric, scores, and queue in `~/.x-compatibility/`; without it the run continues on session state |

File write is not a hard stop: if you decline it or the path cannot be written, the
skill keeps running, holds the same state in the session, and prints it for you to
verify. Later runs then start fresh, so some work may be repeated.

## How it works

1. **Prove control** — confirm the browser relay and drive the signed-in session
   before planning.
2. **Read the UI** — confirm the signed-in handle, the profile tabs that exist now,
   and the markers for posts, replies, quotes, reposts, threads, polls, media, and
   the `Follows you` relationship.
3. **Ask for the scope and brief** — scope first, then 3–8 areas, the signal terms
   that count as a match, area weights, the six factor weights, evidence modes and
   any visual areas, an interaction mode, targets, exclusions, and a budget.
   Everything is restated before scoring.
4. **Read your feed** — your own Posts, Replies, Media, and Likes when visible. This
   is read fresh every run; your replies and likes show what you engage with, which
   is what format fit measures.
5. **Pick targets** — the accounts you named in a focus run, or a slice of the
   chosen list scope. List membership plus the live `Follows you` marker classify
   each account as a moot, following-only, followers-only, or not-associated. You
   confirm the batch when the skill sampled it; a handle you named needs no
   confirmation.
6. **Read each target** — bio, join date, category, newest posts, replies, reposts,
   quotes, media, captions or alt text, and image-only media, video frames, or audio
   transcripts when those modes are on and proven. Each item is classified and
   matched against your frozen signal lexicon.
7. **Score** — subject overlap, conversation surface, format fit, voice fit,
   recency, and access, combined with the weights you approved. Every component
   carries its counts.
8. **Report** — a ranked table with each account's category, a card per account with
   per-area scores and quoted evidence, a bridge matrix of areas, and a recent post
   that invites a reply.
9. **Persist** — the scope, rubric, scores, and queue survive between runs, so only
   stale or new targets are read next time.

## Scope

Ask for it first; there is no silent default.

| Scope | Who it includes | Confirmed by |
| --- | --- | --- |
| `focus` | The accounts you name, whatever their relationship | The live profile; `not-associated` when in neither list |
| `moots` | You follow them and they follow you | Both lists, or `Follows you` while you follow them |
| `following-only` | You follow them; they do not follow you | In Following; no `Follows you` (or absent from Followers when that list is read) |
| `followers-only` | They follow you; you do not follow them | In Followers; `Follows you` and control not `Following`/`Unfollow` (or absent from Following when that list is read) |
| `all` | The union, each account once | Both lists, deduplicated |

The live profile wins when a list row and the profile disagree. A named account is
scored even when it is in neither list; it is labelled `not-associated`, which is
context rather than an error, and the skill never asks you to justify a handle you
supplied. A category is reported on every row and card, but it does not change the
score formula — it selects the population and feeds the access component.

## Visual and multimodal evidence

Text is the default, because not every host passes image pixels to the model and
visual subject matching is less reproducible. Every extra mode is opt-in, costs
more tokens than text, and is read only where a decision turns on it.

- **Text (default)** — captions, alt text, and link text only. An image-only post
  scores 0 for subject, though it still counts for format fit.
- **Images** — still images, image-only posts, profile avatar and banner, and
  legible text inside an image. The skill first proves it can see an image: it
  screenshots a page, reads back the image rather than a path, and states a visible
  detail the page text does not contain. If that fails, it reports `unavailable`,
  runs text-only, and never scores the absence as a silent zero.
- **Video** — a few paused frames from a video or GIF, with `images` on. A poster
  image alone is not video evidence.
- **Audio** — only a transcript the host returns, at lower weight; no claim about
  voice, tone, or identity. A soundtrack the host cannot transcribe is not assessed.
- **Weight** — an image or frame counts 1 point in a normal area, or 2 in an area
  you mark `visual` (photography, illustration, design); an audio transcript counts
  1 and caps at 6 in any area. Non-text points cap at 6 per normal area and 12 per
  visual area, and non-text-only matches cannot raise confidence above `medium`.
- **Limits** — at most 1 profile image pair and 3 media items per target, and 12
  non-text reads per run; each read counts against the budget. Blurry, cropped, or
  ambiguous images count 0 and are flagged. The skill never identifies a person from
  a photo or infers race, ethnicity, gender, age, disability, health, religion, or
  sexuality from an image.

## The score

The default is a 0–100 weighted total:

| Factor | Default | What it counts |
| --- | --- | --- |
| Subject overlap | 40 | Matched posts, replies, quotes, reposts, and captioned media per area |
| Conversation surface | 25 | Replies to others and to you, questions, invitations, commentary quotes, threads, polls |
| Format fit | 15 | How closely your engaged-with formats match the target's |
| Voice fit | 10 | Style ratios: length, questions, first person, emoji |
| Recency and cadence | 5 | Newest original post and posts per week |
| Access and relationship | 5 | Follows you, has replied to you, public profile |

Choose `quote-first` or `observe-only` for a different default set, or set any
weight yourself. Areas carry their own 1–5 weights, so "Rust matters twice as much
as AI" is part of the rubric. Scope changes who is scored, not how: the category is
shown on every row and card, and the access component uses the live relationship.
Image and frame matches follow the evidence mode: 0 when off, 1 when on, or 2 for a
`visual` area, capped per area; an audio transcript counts 1.

Bands: **Strong** 85–100, **Good** 70–84, **Workable** 55–69, **Thin** 40–54,
**Low** 0–39. Confidence is shown separately: `high`, `medium`, `low`,
`insufficient`, or `unreadable`. A low-confidence score is provisional and is never
ranked above a confirmed one.

## What the score is not

- It is not a prediction that someone will reply, agree, or become a friend.
- It is not a personality, political, or mental-health assessment.
- It is not comparable across rubric versions or old samples.
- It is not a reason to mass-follow, mass-reply, or game someone's feed.
- It does not see images, frames, or transcripts unless you turn those modes on and
  the session proves it can; non-text matches are lower-weight and cap at `medium`
  confidence.
- A high score means "more shared, replyable material in this sample"; the sample
  sizes and counts are always on the report.

## Across runs

State lives at `~/.x-compatibility/<handle>.json`
(`%USERPROFILE%\.x-compatibility\<handle>.json` on Windows), in your home
directory. It holds the scope in force, any focus handles, evidence modes, area
flags, the rubric and signal lexicon, your aggregate source metrics, each target's
category, score and component counts, the queue, hidden handles, and re-read dates.
It holds no post quotes, permalinks, images, or private details.

Each run opens by naming that file and summarizing what it holds — scope, evidence
modes, rubric version, areas and weights, scored and stale counts, last write — or
saying that it starts fresh. When writing is unavailable, the file is not created:
the run keeps the same state in the session, prints it for you to verify and save,
and the next run starts fresh.

A score is current for 14 days. Changing an area, a signal term, a weight, the
mode, the window, an evidence mode, or a visual area flag is a new rubric: every old
score becomes stale and is re-read before it is ranked again. Changing only the
scope does not invalidate scores; it changes which accounts are reported, and a
target outside the scope keeps its entry without being ranked. Your own feed is
re-read every run; it is never scored from last run's copy.

## Connectivity and access failures

A page that did not render is an access failure, not a score. That covers a
disconnected browser relay, a closed tab, DNS or timeout errors, an X error page or
blank shell, an expired session, and a login wall. A tab that worked earlier and
then stops rendering is the same failure.

The skill stops and flags what failed, where, how many targets remain, and the
resume point. An item whose page never loaded gets no verdict, so the next run
retries it. Login, 2FA, captcha, and checkpoints are handed to the user. A protected
profile, or a "potentially sensitive content" notice standing in for one, is
reported `unreadable`: no score and no inference from what did not render.

## Safety boundaries

- Only your own account, only with the confirmed scope.
- Read only: no like, reply, repost, follow, block, report, or message.
- No credentials; hand off challenges. A challenge ends the run.
- No DMs, no hidden-content inference, no claims beyond the sampled items.
- Never claim to see an image, frame, or transcript you cannot; that mode is flagged
  `unavailable` and the run stays text-only.
- Never identify a person from a photo or infer race, ethnicity, gender, age,
  disability, health, religion, or sexuality from an image.
- Real handles and private details stay in the local state file, or in the session
  state you verify when writing is unavailable; never in the repository. Examples
  use fictional placeholders.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [twitter-moot-radar](twitter-moot-radar.md) — find accounts to follow
- [twitter-followback](twitter-followback.md) — follow back real, active followers
