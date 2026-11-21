# twitter-moot-radar

Suggests accounts to follow on X by listening to the user's mutuals. It asks for
areas of interest, reads what each moot follows, and returns only accounts that
match — each one carrying the quote that proves the match, the permalink, the
moots who follow them, and a live check that the user does not already follow
them.

Install it by copying the `twitter-moot-radar` folder into your skills directory;
see [Getting skills](getting-skills.md). Invoke it in plain language or with your
host's explicit syntax; see [Using skills](invoking.md).

## When it triggers

- "find people I should follow"
- "who do my moots follow that I don't?"
- "find accounts like the ones I follow"
- "build me a follow list from my network"
- "what are people in my circles following?"

It is explicitly **not** for mass-following, growth hacking, or unfollowing, and
it does not follow anything without per-handle approval.

## Requirements

| Need | Why |
| --- | --- |
| Interactive browser control | Every read and action happens through the real UI |
| A browser already signed in to X | The skill never handles credentials |
| A local session | Cloud, sandboxed, and headless sessions cannot complete it |
| Non-text evidence modes (optional) | Need a model and browser tool that return images, video frames, or an audio transcript; otherwise that mode is flagged unavailable and the run stays text-only |
| Local file write | Keeps the moot roster, harvested sources, and verdicts in `~/.x-moot-radar/`; without it the run continues on session state |

File write is not a hard stop: if you decline it or the path cannot be written,
the skill keeps running, holds the same state in the session, and prints it for
you to verify and save. Later runs then start fresh, so some work may be
repeated.

## How it works

1. **Prove control** — confirm the browser relay and drive the signed-in session
   before planning.
2. **Learn the UI** — read the current labels for `Follow`, `Following`,
   `Unfollow`, `Follows you`, and `Pending`, plus the row anatomy of a Following
   list. `Following` and `Unfollow` are the same already-followed state.
3. **Ask for interests** — 3–8 checkable areas, optional signal words,
   strictness, an overlap bar, exclusions, evidence modes, moot scope, and a
   budget, all restated before any harvesting.
4. **Build the moot roster** — a moot is someone the user follows who follows
   back, confirmed by the `Follows you` marker before their list is used. Moots
   are ordered by how relevant their own topic is to the named interests.
5. **Harvest Following lists** — collect handles with bio excerpts from moots'
   Following tabs only, counting how many distinct moots follow each candidate.
   Nothing is harvested from "Who to follow", Explore, or search.
6. **Filter early** — drop obvious bots, brands, funnels, and already-decided
   handles at the row level, so profile visits go to plausible people.
7. **Research the shortlist** — bio, recent posts, recency, follower ratio, and
   the live follow control. A candidate needs a quoted post or a stated bio line
   that matches an interest. With an evidence mode on and proven, an unambiguous
   image-only post or video frame may serve as labelled, lower-weight proof.
8. **Present with proof** — grouped by interest, ranked by overlap and evidence
   strength, each line showing quote, date, permalink, moots, and follow state.
   High-overlap candidates with no evidence go to a near-miss list.
9. **Follow only on approval** — named handles only, with exact identity matching
   and settle-window verification.
10. **Move at a human cadence** — waits, scroll steps, pointer moves, and dwell
    times are drawn from ranges and scaled to the work: minimum dwell for
    passive checks, longer pauses while reading, and the longest pause before a
    state-changing click. Jitter applies to timing only; verification and
    throttle rules stay exact, and a challenge still ends the run.
11. **Persist and report** — the roster and harvested graph survive interest
    changes; ranking is redone instead of re-harvesting.

## Why overlap is the signal

A moot is a person the user already chose to follow and who chose them back, so
their follows are a proxy for taste rather than for reach. Two or more moots
following the same account is a meaningful coincidence; one moot is a lead. The
skill ranks on that count, but never treats it as proof of an interest — only the
candidate's own posts and bio can do that.

## Proof standard

Every suggestion must show:

- a quoted post of 200 characters or fewer, with its date and a permalink that is
  linked, or a linked bio line that states the interest;
- the moots who follow the account, by handle and count, each handle linked to
  its profile;
- a live `Follow @handle` control reading, confirming the user does not already
  follow them;
- an optional `follows you` note, which is a bonus rather than a reason.

Text is the default and the cheapest. With an evidence mode on and proven, a
non-text match may stand in for the quoted line: `[image] "Rust code with impl
Trait"`, `[video] "…"`, or `[audio] "…"`, with date and permalink. It is labelled,
ranks below text proof, and caps that suggestion at medium confidence. The skill reads at most three media items per candidate and 12
non-text reads per run; a mode that is on but unproven is reported `unavailable` and
the run stays text-only. It never identifies a person from a photo, never infers
race, ethnicity, gender, age, disability, health, religion, or sexuality from an
image, and never treats a photo as proof of a real person.

The candidate handle links to its profile. Every handle the run lists — in the
state line, a question, or the report — plus every cited moot or quote, is one
click from the page it came from. Only pages read in the run are linked; a status
URL is never built from a handle.

If the posts are unreadable — a protected account, or a "potentially sensitive
content" interstitial standing in for the profile — there is no suggestion. The
account is reported as unreadable instead of guessed at, and nothing is inferred
from what did not render.

An empty result is a valid result: the skill reports the filtered counts and
offers to widen the interests, lower the overlap bar, or extend the harvest rather
than padding the list with weak matches.

## Connectivity and access failures

A page that did not render is treated as an access failure, not as an account
state. That covers a disconnected browser relay, a closed tab, DNS or timeout
errors, an X error page or blank shell, an expired session, and a login wall. A
tab that worked earlier and then stops rendering mid-run is the same failure.

The skill stops and flags what failed, where, how many items remain, and the
resume point. An item whose page never loaded gets no verdict, so the next run
retries it instead of recording a false `no_evidence` or "not followed". A click
already made when the page fails is recorded `unverified` with a follow-up,
because it may have landed. Login, 2FA, captcha, and checkpoints are handed to
the user. A profile-level sensitive-content notice stays `unreadable`, and a
visible rate-limit notice stays a throttle.

## Across runs

State lives at `~/.x-moot-radar/<handle>.json`
(`%USERPROFILE%\.x-moot-radar\<handle>.json` on Windows), in your home directory.
It holds the interest profile in force, its evidence modes, confirmed moots with
their topic, the harvested source sets, the per-moot cursor, the queue, and a
verdict per handle.

Each run opens by naming that file and summarizing what it holds — interests,
moot and source counts, queue and verdict counts, last write — or saying that it
starts fresh. When writing is unavailable, the file is not created: the run keeps
the same state in the session, prints it for you to verify and save, and the next
run starts fresh.

Moots and sources are interest-independent, so changing interests re-ranks the
existing graph instead of re-reading it. A `suggested` verdict cools down for
about 30 days unless new moots start following that account; `dismissed` is
permanent unless the user asks to revisit.

## Safety boundaries

- Only the user's own account, only with the confirmed scope.
- Nothing is followed without per-handle approval; no unfollow, block, report, or
  message.
- Never harvest from suggestion modules, Explore, or search results.
- Hand off for login, 2FA, captcha, or payment, and never try to pass a challenge
  to keep a run going.
- Never claim to see an image, frame, or transcript the session cannot return; that
  mode is flagged `unavailable` and the run stays text-only.
- Never identify a person from a photo or infer sensitive traits from an image.
- Never describe a protected account's interests.
- Real handles and private details stay in the local state file, or in the session
  state you verify when writing is unavailable; never in the repository. Examples
  use fictional placeholders.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [twitter-followback](twitter-followback.md) — follow back real, active followers
- [twitter-compatibility](twitter-compatibility.md) — score who you interact with easily, and on what
