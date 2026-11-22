# twitter-compatibility

Scores how well you'd get along with accounts on X about the things you care
about. By default that means the accounts already around you: your moots
(people you follow who follow you back), people you follow who don't follow
back, and people who follow you. You can also name one account — whatever its
relationship to you — and score it directly, with that relationship shown as a
fact rather than a test.

It asks what you want to look at first — one named account, your moots, people
you follow, your followers, or all of them — then reads your feed and theirs,
and returns a 0–100 score with the actual counted posts behind every point.
It can also read images, video frames, and audio transcripts, but only if you
ask and only if the session proves it really can. It's not a personality guess
and not a prediction that anyone will reply. It serves a real person on their
own personal account — never engagement farming, marketing, or brand growth.

Install it by copying the `twitter-compatibility` folder into your skills
directory; see [Getting skills](getting-skills.md). Then ask for it in plain
language or use your app's skill syntax; see [Using skills](invoking.md).

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

## What it needs

| Need | Why |
| --- | --- |
| Browser control | Every read happens in the real X app, in your browser |
| A browser already signed in to X | The skill never touches passwords or codes |
| A local session | Cloud, sandboxed, and headless sessions can't run it |
| Following and Followers lists | Needed to sort accounts into moots, following-only, followers-only, or all; a named account is checked on its own profile instead |
| Image, video, and audio checks (optional) | Need a setup that can actually show images, video frames, or produce transcripts; if yours can't, the skill says so and works with text only |
| A progress file on your machine | Keeps the agreed settings, scores, and waiting list in `~/.x-compatibility/`; without one it still works, it just can't resume |

The progress file isn't a hard requirement: if you say no, or the folder can't
be written, the skill keeps going and shows you its progress so you can save it
yourself. The next run then starts fresh, so some work may be repeated.

## Set up browser control

The skill works in your own browser, in a session you're signed in to. If your
agent doesn't have browser control yet, you don't have to prepare anything:
the skill notices at the start, offers to walk you through it — step by step
if this is all new to you — and reads only your app's official documentation.
Nothing is installed or changed without your yes, and signing in to X is
always yours. See [Setting up browser control](browser-setup.md).

## How it works

1. **Checks it can drive the browser** — confirms it's really controlling your
   signed-in X session before doing anything.
2. **Learns the current screen** — confirms your handle and which tabs and post
   types exist on profiles today, since X changes them often.
3. **Agrees the recipe with you** — the scope, then 3–8 concrete subjects, the
   words that count as a match for each, how much each subject matters, how
   much each factor counts, whether images or transcripts count, and how many
   accounts to score this run. Everything is read back to you before any
   scoring, and every question comes in plain words with the reason for
   asking and what your answer changes.
4. **Reads your feed** — your own posts, replies, media, and likes, fresh every
   run. Your replies and likes show what you actually engage with, which is
   what the format factor measures.
5. **Picks the accounts** — the ones you named, or a slice of the group you
   chose. Each account is labelled moot, following-only, followers-only, or
   not-associated, based on the lists and the live "follows you" marker. You
   confirm the batch when the skill picked it; a handle you named needs no
   approval.
6. **Reads each account** — bio, join date, recent posts, replies, reposts,
   quotes, media, and captions or alt text — plus images, video frames, or
   transcripts when those modes are on and proven. Every item is checked
   against your agreed list of match words. Rows X injects into a feed —
   promoted posts and "you might like" blocks — are never counted as the
   account's.
7. **Scores** — shared subjects, conversation, format fit, voice fit, recency,
   and access, combined with the weights you approved. Every part of the score
   carries its counts.
8. **Reports** — a ranked table with each account's label, a card per account
   with its per-subject scores and quoted evidence, a small grid of which
   accounts match which subjects best, and a recent post worth replying to.
9. **Remembers between runs** — the settings, scores, and waiting list survive,
   so next time only stale or new accounts are read.

## The scope

Ask for it first; there's no silent default.

| Scope | Who it includes | Confirmed by |
| --- | --- | --- |
| `focus` | The accounts you name, whatever their relationship | Their live profile; "not-associated" when they're in neither of your lists |
| `moots` | You follow them and they follow you | Both lists, or the "follows you" marker while you follow them |
| `following-only` | You follow them; they don't follow you | In your Following list; no "follows you" (or missing from Followers when that's read) |
| `followers-only` | They follow you; you don't follow them | In your Followers list; "follows you" and the button isn't `Following`/`Unfollow` (or missing from Following when that's read) |
| `all` | The union, each account once | Both lists, deduplicated |

What the live profile says wins when a list row and the profile disagree. An
account you name is scored even when it's in neither list — it's labelled
"not-associated", which is context, not an error, and the skill never asks you
to justify a handle you supplied. Every account's label is shown, but the label
never changes the score — it only decides who gets scored and what the report
says about them.

## Image and video evidence

Text is the default, because not every setup can show pictures to the model,
and text is cheaper and more reproducible. Every extra mode is opt-in, and the
skill proves it can really see what you asked for before counting anything.

- **Text (default)** — captions, alt text, and link text only. An image-only
  post scores 0 for subjects, though it still counts for format fit.
- **Images** — still images, image-only posts, avatars and banners, and
  readable text inside an image. The skill first proves it can see an image: it
  screenshots a page, reads the picture back, and states a detail the page text
  doesn't contain. If that fails, it reports `unavailable`, works with text
  only, and never quietly scores a zero.
- **Video** — a few paused frames from a video or GIF, with `images` on. A
  poster image alone isn't video evidence.
- **Audio** — only a transcript the session can actually produce, at lower
  weight; never a claim about voice, tone, or identity.
- **Weight** — an image or frame counts 1 point in a normal subject, or 2 in
  one you mark as visual (photography, illustration, design); a transcript
  counts 1. Non-text points cap at 6 per normal subject and 12 per visual
  subject, and matches supported only by pictures can't lift confidence above
  "medium".
- **Limits** — at most one profile image pair and three media items per
  account, and twelve non-text reads per run. Blurry, cropped, or ambiguous
  images count 0 and are flagged. The skill never identifies a person from a
  photo or guesses race, ethnicity, gender, age, disability, health, religion,
  or sexuality from an image.

## The score

The default is a 0–100 weighted total:

| Factor | Default | What it counts |
| --- | --- | --- |
| Subject overlap | 40 | Matched posts, replies, quotes, reposts, and captioned media per subject |
| Conversation | 25 | Replies to others and to you, questions, invitations, commentary quotes, threads, polls |
| Format fit | 15 | How closely the formats you engage with match theirs |
| Voice fit | 10 | Style ratios: length, questions, first person, emoji |
| Recency | 5 | Newest original post and posts per week |
| Access | 5 | Follows you, has replied to you, public profile |

You can pick `quote-first` or `observe-only` for a different starting set, or
set any weight yourself. Subjects carry their own 1–5 weights too, so "Rust
matters twice as much as AI" is part of the recipe. The scope changes who gets
scored, not how. Image and frame points follow the evidence mode: 0 when off,
1 when on, 2 for a visual subject, capped per subject; a transcript counts 1.

Bands: **Strong** 85–100, **Good** 70–84, **Workable** 55–69, **Thin** 40–54,
**Low** 0–39. Confidence is shown separately: `high`, `medium`, `low`,
`insufficient`, or `unreadable`. A low-confidence score is provisional and is
never ranked above a confirmed one.

## What the score is not

- It is not a prediction that someone will reply, agree, or become a friend.
- It is not a personality, political, or mental-health assessment.
- It is not comparable across different settings or old samples.
- It is not a reason to mass-follow, mass-reply, or game someone's feed.
- It doesn't see images, frames, or transcripts unless you turn those modes on
  and the session proves it can; matches supported only by pictures are
  lower-weight and cap at "medium" confidence.
- A high score means "more shared, replyable material in this sample"; the
  sample sizes and counts are always on the report.

## Between runs

Progress lives at `~/.x-compatibility/<handle>.json`
(`%USERPROFILE%\.x-compatibility\<handle>.json` on Windows), in your home
directory. It holds the scope in force, any accounts you've named, the evidence
modes, the recipe (subjects, match words, weights), your own feed's summary
numbers, each account's label, score, and counts, the waiting list, and any
accounts you've hidden. It holds no post quotes, links, images, or private
details.

Each run opens by naming that file and summarizing what it holds — or saying
it starts fresh. If you declined file writing, no file is created: the run
keeps the same information in the session, prints it for you to verify and
save, and the next run starts fresh.

A score is current for 14 days. Changing a subject, a match word, a weight,
the window, or an evidence mode is a new recipe: every old score becomes stale
and is re-read before it's ranked again. Changing only the scope doesn't
invalidate scores; it just changes which accounts are reported. Your own feed
is re-read every run; it's never scored from last time's copy.

## When a page won't load

A page that didn't render is a hiccup, not a score: dropped browser
connection, closed tab, network errors, an X error page or blank screen, an
expired session, a login wall, or a tab that freezes mid-run.

The skill stops and tells you what failed, where, how many accounts were left,
and where to pick up. An account whose page never loaded gets no verdict, so
the next run tries it again. Login, 2FA, and verification challenges are handed
to you. A protected profile, or a "potentially sensitive content" warning
standing in for one, is reported unreadable: no score, and nothing guessed
from what didn't render.

## Safety boundaries

- Only your own account, only within the rules you confirmed.
- Read only: no like, reply, repost, follow, block, report, or message.
- Hands off for login, 2FA, captcha, or payment — a challenge ends the run.
- No DMs, no guessing from hidden content, no claims beyond what was sampled.
- Never claims to see an image, frame, or transcript the session can't produce;
  that mode is flagged unavailable and the run stays text-only.
- Never identifies a person from a photo or guesses sensitive traits from an
  image.
- Real handles and private details stay in the progress file on your machine,
  or in the session output you verify; never in this repository. Examples use
  invented handles like `@example_alice`.
- Stops and asks whenever identity, scope, or the screen doesn't look as
  expected.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [Setting up browser control](browser-setup.md) — get browser control working first
- [twitter-moot-radar](twitter-moot-radar.md) — find accounts to follow
- [twitter-followback](twitter-followback.md) — follow back real, active followers
