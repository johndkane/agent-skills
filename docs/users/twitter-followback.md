# twitter-followback

Follows back the people behind an X account: real humans who follow the user,
post actively, and pass a character check. Bots, brands, funnels, and guesses are
skipped. It is personal account-keeping for a real person on their own account —
never engagement farming, marketing, or brand growth.

Install it by copying the `twitter-followback` folder into your skills directory;
see [Getting skills](getting-skills.md). Invoke it in plain language or with your
host's explicit syntax; see [Using skills](invoking.md).

## When it triggers

- "follow back my followers" or "follow back my mutuals"
- "review my new followers"
- "clean up my follow-back queue"
- "is this follower a bot?"
- "which followers are worth following back?"

It is explicitly **not** for mass-following, growth hacking, engagement farming,
marketing, or unfollowing.

## Requirements

| Need | Why |
| --- | --- |
| Interactive browser control | Every action happens through the real UI |
| A browser already signed in to X | The skill never handles credentials |
| A local session | Cloud, sandboxed, and headless sessions cannot complete it |
| Non-text evidence modes (optional) | Need a model and browser tool that return images, video frames, or an audio transcript; otherwise that mode is flagged unavailable and the run stays text-only |
| Local file write | Keeps progress and pending follow-ups in `~/.x-followback/` between runs; without it the run continues on session state |

These limits are declared in the skill's `compatibility` field, so a host can
skip it before loading. File write is not a hard stop: if you decline it or the
path cannot be written, the skill keeps running, holds the same state in the
session, and prints it for you to verify and save. Later runs then start fresh,
so some work may be repeated.

## How it works

1. **Prove control** — confirm the browser relay is connected and drive the real
   signed-in session before planning anything.
2. **Learn the UI** — the follow controls change often, so the skill observes the
   current button vocabulary, the lock icon on protected accounts, and row
   anatomy instead of assuming.
3. **Confirm criteria** — scope, recency threshold, exclusions, the
   protected-account policy, and a per-run budget are agreed up front and
   restated.
4. **Load state** — read the previous run's progress and any due follow-ups before
   scanning, so work is not repeated.
5. **Build the queue** — only follow-back rows (`Follow back`, or `Follow` on a
   row confirmed as a protected follower), deduplicated by handle and collected
   while scrolling the virtualised list. A `Follow` row without the protected
   marker is someone who no longer follows the user — a stranger, never queued.
   `Pending` rows are recorded, not queued.
6. **Research each candidate** — bio, join date, follower ratio, newest posts, with
   protected accounts limited to non-post evidence. When you opt in, it may also read
   the avatar and banner and a few image-only posts, labelled and capped.
7. **Follow with exact identity matching** — the control must be tied to that
   handle. Verification lasts until the control settles, which can take about
   two minutes: either `Following` or `Unfollow` proves a follow, while a
   protected account reads `Pending`.
8. **Handle timing and throttling** — X updates late, and flips have landed near
   two minutes after the press, so the control is re-read well past 30 seconds
   before a miss is believed. Never re-click inside the window. A real miss means
   throttled: wait, re-read, retry once, then stop for the run rather than
   looping.
9. **Move at a human cadence** — waits, scroll steps, pointer moves, and dwell
   times are drawn from ranges and scaled to the work: minimum dwell for passive
   checks, longer pauses while reading, and the longest pause before a
   state-changing click. Jitter applies to timing only; verification and throttle
   rules stay exact, and a challenge still ends the run.
10. **Persist and report** — save the cursor, verdicts, and follow-up dates;
    report new follows, pre-existing follows, pending requests, unverified
    clicks, and skips separately. Every handle the run lists — state line,
    question, or report — opens its X profile, and cited posts open their
    permalinks, so every claim is one click from its source.

## Protected accounts

A protected account hides its posts until it approves a follow request. The skill
asks up front whether to follow these accounts, because the activity and
character checks cannot be run and any follow is blind. The choices are skip and
report (the default), follow on non-post evidence only, or ask per account.

Following one produces `Pending`, not `Following`. The skill records a request,
schedules a check-in about seven days out, and never claims it as a follow. If
the request is accepted later, the posts become readable and the check-in can
flag anything that would have been skipped — without unfollowing. If it is still
pending after about a month, the skill reports it as unresolved and stops
checking.

## Visual and multimodal checks

Text is the default. Image, video-frame, and audio-transcript evidence is opt-in,
because not every host returns pixels and visual matching is less reproducible; a
text-only run also costs less. When you turn a mode on, the skill proves the mode
once per run before reading anything, then caps itself at one profile image pair and
three media items per candidate, and 12 non-text reads per run.

- **Avatar and banner** — a stock photo, watermark, legible text-in-image, generated
  look, or a persona that clashes with the bio is a caution, not a verdict.
- **Image-only recent post** — supports activity recency only, never character. A
  photo is not proof that the account is a real person, so a non-text-only borderline
  candidate stays your call.
- **Legible text in an image** — may support a bio or link signal and is quoted as
  `[image] "…"` with its date and permalink.
- **Audio transcript** — only when the host returns one; it may support a bio or
  link signal and is tagged `[audio]`, never a claim about voice or identity.
- **Mode on but unproven** — the report says `unavailable`, the run stays text-only,
  and the missing evidence is not scored as a zero or a skip reason.
- **Limits** — no identity from a photo, and no inference about race, ethnicity,
  gender, age, disability, health, religion, or sexuality from an image.

## Unreadable profiles

A "potentially sensitive content" interstitial can replace the whole profile: no
header, bio, posts, or follow control. The skill records the handle as
`unreadable`, with a follow-up, and reports it separately from skips. Nothing is
inferred from the missing page — not the interest, the activity, or the
relationship — because the notice is not the account. A later visit may render
normally; until it does, the account stays out of both the queue and the report's
judgements.

## Connectivity and access failures

A page that did not render is treated as an access failure, not as an account
state. That covers a disconnected browser relay, a closed tab, DNS or timeout
errors, an X error page or blank shell, an expired session, and a login wall. A
tab that worked earlier and then stops rendering mid-run is the same failure.

The skill stops and flags what failed, where, how many items remain, and the
resume point. An item whose page never loaded gets no verdict, so the next run
retries it instead of recording a false "skipped" or "not followed". A click
already made when the page fails is recorded `unverified` with a follow-up,
because it may have landed. Login, 2FA, captcha, and checkpoints are handed to
the user. A profile-level sensitive-content notice stays `unreadable`, and a
visible rate-limit notice stays a throttle.

## Across runs

The Followers tab can hold hundreds of rows, and X throttles follows after a
short burst, so one pass is not expected to finish. The skill keeps one state
file per signed-in account at `~/.x-followback/<handle>.json`
(`%USERPROFILE%\.x-followback\<handle>.json` on Windows), in your home directory.

Each run opens by naming that file and summarizing what it holds — criteria,
evidence modes, queue and verdict counts, due follow-ups, and resume point — or
saying that it starts fresh. When writing is unavailable, the file is not created: the run keeps
the same state in the session, prints it for you to verify and save, and the next
run starts fresh.

It records the scan cursor, the pending queue, a verdict per handle, and a
`followUps` list for pending requests and unverified clicks. Later runs drain the
queued handles, continue from the cursor, skip handles already processed, and
check due follow-ups first. The live UI always wins over the file: a saved
`followed` is never reported as a follow without re-reading the control.

## Safety boundaries

- Only the user's own account, only with the confirmed scope.
- Never unfollow, block, report, or message.
- Never follow accounts from suggestion modules or search results.
- Hand off for login, 2FA, captcha, or payment.
- Never claim to see an image, frame, or transcript the session cannot return; that
  mode is flagged `unavailable` and the run stays text-only.
- Never identify a person from a photo or infer sensitive traits from an image.
- Real handles and private details stay in the local state file, or in the session
  state you verify when writing is unavailable; never in the repository. Examples
  use fictional placeholders.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [twitter-moot-radar](twitter-moot-radar.md) — find accounts to follow through your mutuals
- [twitter-compatibility](twitter-compatibility.md) — score who you interact with easily, and on what
