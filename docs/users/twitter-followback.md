# twitter-followback

Follows back the people behind an X account: real humans who follow you, post
actively, and pass a character check. Bots, brands, and salesy accounts are
skipped. It's personal account-keeping for a real person on their own account —
never engagement farming, marketing, or brand growth.

Install it by copying the `twitter-followback` folder into your skills
directory; see [Getting skills](getting-skills.md). Then just ask for it in
plain language, or use your app's skill syntax; see [Using skills](invoking.md).

## When it triggers

- "follow back my followers" or "follow back my mutuals"
- "review my new followers"
- "clean up my follow-back queue"
- "is this follower a bot?"
- "which followers are worth following back?"

It is explicitly **not** for mass-following, growth hacking, engagement farming,
marketing, or unfollowing.

## What it needs

| Need | Why |
| --- | --- |
| Browser control | Every action happens in the real X app, in your browser |
| A browser already signed in to X | The skill never touches passwords or codes |
| A local session | Cloud, sandboxed, and headless sessions can't run it |
| Image, video, and audio checks (optional) | Need a setup that can actually show images, video frames, or produce transcripts; if yours can't, the skill says so and works with text only |
| A progress file on your machine | Keeps track of where it left off in `~/.x-followback/`; without one it still works, it just can't resume |

The needs are declared in the skill's own settings, so your app can skip it
up front if it can't run it. The progress file isn't a hard requirement: if you
say no, or the folder can't be written, the skill keeps going and shows you its
progress so you can save it yourself. The next run then starts fresh, so some
work may be repeated.

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
2. **Learns the current screen** — X changes its buttons often, so the skill
   looks at what the follow buttons actually say right now instead of assuming.
3. **Confirms the rules with you** — how many followers to look at, how recent
   is "active", what to skip, what to do about protected accounts, and a time
   or count budget. It reads the rules back to you before starting, and asks in
   plain words — every question explains why it's being asked and what your
   answer changes.
4. **Picks up where it left off** — reads the progress file and any due
   check-ins before scanning, so nothing gets done twice.
5. **Builds the queue** — only rows that genuinely follow you: `Follow back`
   rows, plus a plain `Follow` on a row with the protected lock (that follower
   can't see the button label). Collected while scrolling, deduplicated by
   handle. A plain `Follow` without the lock means that person stopped
   following you: a stranger, never queued. Rows showing `Pending` are noted,
   not queued. Ads X injects into the list — rows marked `Promoted` — are
   skipped too: they aren't your followers.
6. **Researches each candidate** — bio, join date, follower ratio, and recent
   posts. Protected accounts can't be checked this way, so the skill applies
   the rule you chose and says so. If you turned image checks on, it may also
   glance at the avatar and banner and a few image-only posts.
7. **Follows with an exact match** — the click is tied to that exact handle on
   that account's own profile page, never a lookalike row elsewhere.
8. **Waits for X to catch up** — X can take up to about two minutes to update
   a button after a click, so the skill re-checks well past half a minute
   before believing a follow didn't land. It never clicks twice in that time
   (a second click undoes the follow). If a follow truly doesn't land, that's
   X slowing things down: wait, re-check, try once more, then stop for the day
   rather than hammering.
9. **Moves like a person** — varied pauses, scroll steps, and reading time
   drawn from ranges, so the pace doesn't look robotic. The pacing is timing
   only: the checks and stop rules above stay strict, and a verification
   challenge still ends the run.
10. **Reports honestly** — new follows, follows you already had, pending
    requests, and anything unverified, each listed separately, plus what was
    skipped and why. Every account and post it names links to the actual page
    on X, so every claim is one click from its source.

## Protected accounts

A protected account hides its posts until it approves a follow request. The
skill asks you up front what to do about them, because it can't read their
posts and any follow would be blind. Your choices: skip and report (the
default), follow based on what little can be seen, or decide case by case.

Following one produces `Pending`, not `Following`. The skill records the
request, plans a check-in about seven days out, and never claims it as a
follow. If the request is accepted later, the posts become readable and the
check-in can flag anything that would have been skipped — without unfollowing.
If it's still pending after about a month, the skill reports it as unresolved
and stops checking.

## Image, video, and audio checks (optional)

Text comes first and is all you get by default. Image, video-frame, and audio
checks are opt-in — not every setup can show pictures to the model, and text is
cheaper and more reliable. When you turn a mode on, the skill first proves it
can really see what you asked for, then keeps itself to one profile image pair
and three media items per candidate, and twelve image or audio reads per run.

- **Avatar and banner** — a stock photo, watermark, generated look, or a
  persona that clashes with the bio is a caution, not a verdict.
- **A recent image-only post** — supports "posted recently", nothing more. A
  photo is not proof someone's a real person, so a candidate supported only by
  pictures stays your call.
- **Readable text inside an image** — may back up a bio claim, quoted with its
  date and link.
- **Audio transcript** — only if your setup can produce one; may back up a bio
  claim, never a claim about someone's voice or identity.
- **If a mode can't actually work** — the report says `unavailable`, the run
  continues on text, and the missing pictures are never counted against anyone.
- **Limits** — no identifying people from photos, and no guessing anyone's
  race, ethnicity, gender, age, disability, health, religion, or sexuality from
  an image, ever.

## Profiles it can't read

A "potentially sensitive content" warning can replace the whole profile: no
header, bio, posts, or follow button. The skill records the handle as
unreadable, with a check-in, and reports it separately from skips. Nothing is
guessed from the missing page — not the interests, the activity, or the
relationship — because a warning page isn't the account. A later visit may
render normally; until it does, the account stays out of the queue and the
report's judgements.

## When a page won't load

A page that didn't render is treated as a hiccup, not as an answer about the
account. That covers a dropped browser connection, a closed tab, network
errors, an X error page or blank screen, an expired session, and a login wall.
A tab that worked earlier and then freezes mid-run is the same thing.

The skill stops and tells you what failed, where, how many accounts were left,
and where to pick up. An account whose page never loaded gets no verdict, so
the next run tries it again instead of recording a false "skipped". A click
already made when the page dies is marked unverified with a check-in, because
it may have gone through. Login, 2FA, and verification challenges are handed
to you — the skill never tries to pass them. A visible rate-limit notice is
treated as the slow-down it is.

## Between runs

The Followers list can hold hundreds of names, and X slows down follows after
a short burst, so one pass isn't expected to finish. The skill keeps one
progress file per signed-in account at `~/.x-followback/<handle>.json`
(`%USERPROFILE%\.x-followback\<handle>.json` on Windows), in your home
directory.

Each run opens by naming that file and summarizing what it holds — the rules
in force, what's queued and decided, due check-ins, and where it stopped — or
saying that it starts fresh. If you declined file writing, no file is created:
the run holds the same information in the session, prints it for you to verify
and save, and the next run starts fresh.

The file records where scanning stopped, the waiting queue, a verdict per
handle, and dates to re-check pending requests and unverified clicks. Later
runs work through the queue, continue from where scanning stopped, skip
already-decided handles, and check due items first. What the live page says
always wins over what the file says: a saved "followed" is never reported as a
follow without re-reading the button.

## Safety boundaries

- Only your own account, only within the rules you confirmed.
- Never unfollow, block, report, or message anyone.
- Never follows accounts from suggestion lists or search results.
- Hands off for login, 2FA, captcha, or payment.
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
- [twitter-moot-radar](twitter-moot-radar.md) — find accounts to follow through your mutuals
- [twitter-compatibility](twitter-compatibility.md) — score who you interact with easily, and on what
- [twitter-following-audit](twitter-following-audit.md) — decide who still earns a place in your Following list
