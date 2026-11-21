# twitter-moot-radar

Suggests accounts to follow on X by listening to the people you already trust.
A **moot** — internet slang for a *mutual* — is someone you follow who follows
you back. You tell the skill
what you're interested in, it reads what your moots follow, and it suggests
only the accounts that genuinely match: each one comes with the post that
proves it, a link to that post, which of your moots follow it, and a live check
that you don't already follow it.

It can also look at one account you name directly. That account doesn't need a
moot to follow it, and it doesn't need to follow you back — its relationship to
you is reported as a fact, never treated as a test it has to pass. The skill is
for a real person curating their own feed — finding people, not audiences — and
is never for engagement farming, marketing, or brand growth.

Install it by copying the `twitter-moot-radar` folder into your skills
directory; see [Getting skills](getting-skills.md). Then ask for it in plain
language or use your app's skill syntax; see [Using skills](invoking.md).

## When it triggers

- "find people I should follow"
- "who do my moots follow that I don't?"
- "check out `@example_alice` for me"
- "is this account worth following?"
- "find accounts like the ones I follow"
- "build me a follow list from my network"
- "what are people in my circles following?"

It is explicitly **not** for mass-following, growth hacking, engagement farming,
marketing, or unfollowing, and it does not follow anything without your
approval, name by name.

## What it needs

| Need | Why |
| --- | --- |
| Browser control | Every read and action happens in the real X app, in your browser |
| A browser already signed in to X | The skill never touches passwords or codes |
| A local session | Cloud, sandboxed, and headless sessions can't run it |
| Image, video, and audio checks (optional) | Need a setup that can actually show images, video frames, or produce transcripts; if yours can't, the skill says so and works with text only |
| A progress file on your machine | Keeps your moot list, its findings, and your decisions in `~/.x-moot-radar/`; without one it still works, it just can't resume |

The progress file isn't a hard requirement: if you say no, or the folder can't
be written, the skill keeps going and shows you its progress so you can save it
yourself. The next run then starts fresh, so some work may be repeated.

## How it works

1. **Checks it can drive the browser** — confirms it's really controlling your
   signed-in X session before doing anything.
2. **Learns the current screen** — reads what the follow buttons, the "follows
   you" marker, and the lock icon actually say right now, since X changes them
   often. `Following` and `Unfollow` mean the same thing: already followed.
3. **Confirms the brief with you** — the whole moot graph or one named account,
   then 3–8 concrete interests, optional signal words, how strict to be, the
   optional evidence modes, how many suggestions you want, and a time budget. It
   reads the brief back before starting.
4. **Builds the moot list** — a moot is confirmed by the "follows you" marker
   on their profile before their list is used, never guessed from a single
   list. Moots are put in order by how close their own interests are to yours.
   A named-account run skips this.
5. **Reads the Following lists** — collects names and short bios
   from your moots' Following tabs only, counting how many distinct moots
   follow each account. Nothing comes from "Who to follow", Explore, or search.
6. **Filters early** — obvious bots, salesy accounts, and already-decided names
   are dropped before any profile is opened, so attention goes to plausible
   people.
7. **Researches the shortlist** — bio, recent posts, how recently they posted,
   follower ratio, and the live follow button. A candidate needs one quoted
   post or a bio line that really matches one of your interests. With an image
   mode on and proven, a clear image-only post or video frame can count too —
   labelled, and worth less than text.
8. **Presents with proof** — grouped by interest, strongest first: the quote,
   its date and link, the moots behind it, and the follow state. Candidates
   with many moots but no matching post go on a separate "near miss" list, so
   you can decide for yourself.
9. **Follows only on your approval** — named handles only, one at a time,
   verified in the app the same way followback does.
10. **Moves like a person** — varied pauses, scroll steps, and reading time, so
    the pace doesn't look robotic. The pacing is timing only: the checks and
    stop rules stay strict, and a verification challenge ends the run.
11. **Remembers between runs** — the moot list and its findings survive even
    when you change your interests; only the ranking is redone, never the
    whole read.

## Naming one account

Give it a handle and the skill assesses that account instead of searching the
graph. It skips the moot list, the graph reading, and the overlap bar entirely;
the same proof standard applies. The report gives the interest verdict, the
quoted proof, and the relationship — whether they follow you, whether you
already follow them, and how many moots follow them, including none — all as
context. A missing follow-back or a zero overlap is a fact about the
relationship, not a flaw in your request, and the skill won't push you toward
a different account.

## Why overlap is the signal

A moot is a person you chose and who chose you back, so who they follow says
something about taste rather than about reach. Two or more moots following the
same account is a meaningful coincidence; one is a lead. The skill ranks on
that count but never treats it as proof of an interest — only the account's own
posts and bio can show that.

## What counts as proof

Every suggestion must show:

- a quoted post of 200 characters or fewer, with its date and a working link —
  or a linked bio line that states the interest outright;
- the moots who follow the account, by name and count, each name linked to
  their profile. A named account may have none, and "Moots: none" is a normal,
  valid line;
- a live follow button reading: `Follow @example_alice` confirms you don't
  follow them yet, and `Following`/`Unfollow` is reported as already followed;
- an optional "follows you" note, which is context rather than a reason.

Text is the default and the cheapest. With an image mode on and proven, a
non-text match can stand in for the quoted line — `[image] "Rust code with
impl Trait"`, `[video] "…"`, or `[audio] "…"`, each with date and permalink.
It's labelled, ranks below text, and caps that suggestion at "medium"
confidence. The skill reads at most three media items per candidate and twelve
non-text reads per run; a mode that's on but can't actually work is reported
unavailable and the run stays text-only. It never identifies a person from a
photo, never guesses sensitive traits from an image, and never treats a photo
as proof of a real person.

The candidate's name links to their profile. Every handle, moot, and quote in
the report is one click from the page it came from, and only pages actually
read in that run are linked.

If the posts can't be read — a protected account, or a "potentially sensitive
content" warning standing in for the profile — there is no suggestion. The
account is reported as unreadable instead of guessed at.

An empty result is a real result: the skill reports what was filtered and
why, and offers to widen the interests, lower the bar, or read further down
the lists — rather than padding the list with weak matches.

## When a page won't load

A page that didn't render is treated as a hiccup, not as an answer about the
account: dropped browser connection, closed tab, network errors, an X error
page or blank screen, an expired session, a login wall, or a tab that freezes
mid-run.

The skill stops and tells you what failed, where, how many accounts were left,
and where to pick up. An account whose page never loaded gets no verdict, so
the next run tries it again. A click already made when the page dies is marked
unverified with a check-in. Login, 2FA, and verification challenges are handed
to you, and a visible rate-limit notice is treated as the slow-down it is.

## Between runs

Progress lives at `~/.x-moot-radar/<handle>.json`
(`%USERPROFILE%\.x-moot-radar\<handle>.json` on Windows), in your home
directory. It holds the interests in force and their image modes, the confirmed
moots and what they post about, which accounts were surfaced by which moots,
where each list-reading stopped, and every decision made so far.

Each run opens by naming that file and summarizing what it holds — or saying
it starts fresh. If you declined file writing, no file is created: the run
keeps the same information in the session, prints it for you to verify and
save, and the next run starts fresh.

Moots and findings don't depend on your interests, so changing interests just
re-ranks what's already there instead of re-reading everything. A suggestion
you've seen cools down for about 30 days unless new moots start following that
account; something you dismissed stays dismissed until you ask to revisit it.

## Safety boundaries

- Only your own account, only within the rules you confirmed.
- Nothing is followed without your approval, name by name; no unfollow, block,
  report, or message.
- Suggestions never come from "who to follow", Explore, or search results.
- Hands off for login, 2FA, captcha, or payment, and never tries to pass a
  challenge to keep going.
- Never claims to see an image, frame, or transcript the session can't produce;
  that mode is flagged unavailable and the run stays text-only.
- Never identifies a person from a photo or guesses sensitive traits from an
  image.
- Never describes a protected account's interests.
- Real handles and private details stay in the progress file on your machine,
  or in the session output you verify; never in this repository. Examples use
  invented handles like `@example_alice`.
- Stops and asks whenever identity, scope, or the screen doesn't look as
  expected.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [twitter-followback](twitter-followback.md) — follow back real, active followers
- [twitter-compatibility](twitter-compatibility.md) — score who you interact with easily, and on what
