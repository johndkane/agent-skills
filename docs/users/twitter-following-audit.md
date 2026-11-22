# twitter-following-audit

Looks at the accounts you already follow on X and suggests, for each one, what
to do next: **keep**, **unfollow**, **mute**, or **recheck** (look again
later). The test is fit, not worth — does the connection still earn its place
against the interests you care about today? An unfollow can come from a quiet
account, a focus that moved, or interests that drifted, and none of that says
anything bad about the person.

Safety problems are a separate track. If an account looks like a bot, scam,
harassment source, or impersonator, it doesn't get a feed verdict at all — it
shows up flagged, with the evidence quoted, and **you** decide whether to
block, report, or just unfollow. The audit never suggests blocking, because
block isn't a curation choice: it severs contact entirely, which is a decision
about safety, not about your feed.

It's optimistic on purpose. Keep is the default and needs no justification;
every other suggestion has to show its evidence; thin evidence never lands a
negative verdict; and every card opens with what the account gives you before
it says what changed. An unfollow is "not now", not a verdict on a person —
it's private, reversible, and X doesn't notify anyone.

It only reads and suggests. It never unfollows, blocks, mutes, follows, likes,
or messages anyone — every action is yours to take. It serves a real person
tending their own personal account — never engagement farming, marketing, or
brand growth.

Install it by copying the `twitter-following-audit` folder into your skills
directory; see [Getting skills](getting-skills.md). Then ask for it in plain
language or use your app's skill syntax; see [Using skills](invoking.md).

## When it triggers

- "audit my follows"
- "review my following list"
- "clean up who I follow"
- "who has gone quiet on my feed?"
- "should I still follow `@example_alice`?"
- "which accounts no longer match my interests?"
- "someone's flooding my feed — what should I do?"

## What it needs

| Need | Why |
| --- | --- |
| Browser control | Every read happens in the real X app, in your browser |
| A browser already signed in to X | The skill never touches passwords or codes |
| A local session | Cloud, sandboxed, and headless sessions can't run it |
| Your Following list | The population it audits; a named account is checked on its own profile instead |
| Image, video, and audio checks (optional) | Need a setup that can actually show images, video frames, or produce transcripts; if yours can't, the skill says so and works with text only |
| A progress file on your machine | Keeps the agreed settings, verdicts, and waiting list in `~/.x-following-audit/`; without one it still works, it just can't resume |

The progress file isn't a hard requirement: if you say no, or the folder can't
be written, the skill keeps going and shows you its progress so you can save it
yourself. The next run then starts fresh, so some work may be repeated.

## How it works

1. **Checks it can drive the browser** — confirms it's really controlling your
   signed-in X session before doing anything.
2. **Agrees the plan with you** — which slice to audit (accounts you named,
   ones it hasn't reviewed yet, stale ones, or everything over several runs),
   the 3–8 subjects you care about and the words that count as a match, how
   fresh a "recent" post is, how big a batch to do this run, anyone to
   leave completely alone (it will never suggest anything about them), and
   anyone you know personally (the relationship counts for more than the
   topics). Everything is read back to you before any reading starts, and
   every question comes in plain words with the reason for asking and what
   your answer changes; any example in a question comes from your own bio,
   posts, or previous settings, offered for you to confirm — never a canned
   one.
3. **Walks your Following list** — collects who you follow, skips what's
   already decided, and queues the rest. Ads X injects into the list — rows
   marked `Promoted`, or suggested accounts — are skipped: you don't actually
   follow them.
4. **Reads each account** — bio, join date, whether they follow you, the
   newest post date, and a sample of recent posts. It counts matches against
   your subjects, volume, and repost share. Images, video frames, or
   transcripts are read only if you opted in and the session proves it can.
5. **Assigns one verdict per account** — keep, unfollow, mute, or recheck —
   from a fixed decision table. A tie (they follow you, they replied to you,
   you named them) moves an unfollow toward mute or recheck. Quoted safety
   evidence pulls the account out of the verdict track and flags it instead.
6. **Reports** — a summary table, a card for every non-keep verdict with the
   dated evidence, what would return the account to keep, and the alternative,
   a separate flagged section with the evidence and your options, and one line
   per keep saying what earns its slot.
7. **Remembers between runs** — verdicts, the queue, and scheduled rechecks
   survive, so next time it picks up where it stopped.

## The verdicts

| Verdict | What it means | What you'd do |
| --- | --- | --- |
| `keep` | The connection still earns its place | Nothing |
| `unfollow` | The connection doesn't earn its place right now | Unfollow (private, reversible) |
| `mute` | Stay connected, stop seeing the posts | Mute |
| `recheck` | Not now — look again on a date | Nothing; it's scheduled |

Block is deliberately not in this table. Block severs contact — the account
can no longer follow, reply, mention, or DM you, and it also unfollows — so
it's a safety decision, not a feed choice. When the audit finds quoted,
dated evidence of bots or follow farms, scams, harassment toward you, or
impersonation, it flags the account in its own section instead, names your
options (block, report, or unfollow alone for something harmful that never
interacts with you), and leaves the decision entirely to you.

The reasons behind a non-keep verdict are facts, not judgements: `inactive`
(no post inside your freshness window), `focus-moved` (they used to post in
your areas and now don't), `outside-interests` (their current content sits
outside your subjects), `volume` and `repost-heavy` (feed-fit problems), and
`disagreement` — which is recorded only when **you** name it, never guessed
from content. A reason never travels as a bare label: wherever a verdict
appears, the tag comes with the fact behind it — how long they've been
quiet, how many posts matched, what share is reposts — and the card quotes
the full evidence with dates and links. Flags (safety findings) carry their
own reason — bot or farm, scam, harassment, impersonation — and require
quoted, dated evidence.

## What optimism means here

- Keep is the default; it needs no evidence.
- A single matched post in your freshness window keeps an account, always.
- Thin or unreadable evidence never lands a negative verdict.
- Cards describe what changed, not what's wrong: "their posts now center on
  gardening; your areas are Rust and Postgres" — never "bad content".
- Every non-keep card names what would return the account to keep.
- A recheck is a plan, not a demotion — people take breaks.
- Safety problems are flagged for you with the evidence; the audit never
  converts them into a suggestion to block.

## The scope

Ask for it first; there's no silent default.

| Scope | Who it audits |
| --- | --- |
| `focus` | The accounts you name, whatever your relationship to them |
| `unreviewed` | Followed accounts with no verdict yet (the usual first run) |
| `stale` | Verdicts older than 90 days or from an older settings version |
| `all` | Every account you follow, queued over as many runs as it takes |

A large Following list is normal: each run does a batch (about 20 accounts by
default, 40 at most) and queues the rest, so an audit of several hundred
follows takes a few runs. You can set accounts aside — close friends, family —
and the skill will never make suggestions about them.

## Image and video evidence

Text is the default, because not every setup can show pictures to the model,
and text is cheaper and more reproducible. Every extra mode is opt-in, and the
skill proves it can really see what you asked for before counting anything:
images (image-only posts, avatars and banners), video (paused frames), and
audio (only a transcript the session can actually produce). A mode that fails
its test is reported `unavailable` and the run stays text-only — never a
silent zero. Non-text evidence is lower-weight, capped (one profile image pair
and three media items per account, twelve reads per run), never identifies a
person from a photo, and never guesses race, ethnicity, gender, age,
disability, health, religion, or sexuality.

## Between runs

Progress lives at `~/.x-following-audit/<handle>.json`
(`%USERPROFILE%\.x-following-audit\<handle>.json` on Windows), in your home
directory. It holds the scope in force, the interests and windows you agreed,
held handles and named ties, each account's verdict and counts, the waiting
list, and scheduled rechecks. It holds no post quotes, links, images, or
private details.

Each run opens by naming that file and summarizing what it holds — or saying
it starts fresh. If you declined file writing, no file is created: the run
keeps the same information in the session, prints it for you to verify and
save, and the next run starts fresh.

Changing a subject, a match word, the strictness, a window, or an evidence
mode is a new settings version: every old verdict becomes stale and is
re-read before it's reported again. Changing only the scope or the batch
doesn't invalidate anything.

## When a page won't load

A page that didn't render is a hiccup, not a verdict: dropped browser
connection, closed tab, network errors, an X error page or blank screen, an
expired session, a login wall, or a tab that freezes mid-run. The skill stops
and tells you what failed, where, how many accounts were left, and where to
pick up. A protected profile, or a "potentially sensitive content" warning
standing in for one, is reported unreadable: no verdict, and nothing guessed
from what didn't render. Login, 2FA, and verification challenges are handed to
you.

## Safety boundaries

- Only your own account, only the accounts you follow or name.
- Read only: it never unfollows, blocks, mutes, follows, likes, reposts,
  reports, or messages anyone.
- Safety findings are flagged with quoted evidence; the audit never suggests
  block, and never flags for disagreement, drift, or volume.
- Hands off for login, 2FA, captcha, or payment — a challenge ends the run.
- No DMs, no guessing from hidden content, no claims beyond what was sampled.
- Real handles and private details stay in the progress file on your machine,
  or in the session output you verify; never in this repository. Examples use
  invented handles like `@example_alice`.
- Stops and asks whenever identity, scope, or the screen doesn't look as
  expected.

## Related

- [User guide](README.md)
- [Getting skills](getting-skills.md)
- [Using skills](invoking.md)
- [twitter-compatibility](twitter-compatibility.md) — score how well you'd get along with an account
- [twitter-moot-radar](twitter-moot-radar.md) — find new people through your moots
- [twitter-followback](twitter-followback.md) — follow back real, active followers
