# twitter-followback

Follows back the people behind an X account: real humans who follow the user,
post actively, and pass a character check. Bots, brands, funnels, and guesses are
skipped.

Install by copying the `twitter-followback` folder into the skills directory your
host reads; the `SKILL.md` inside it is the whole skill, and everything it
references is inside the same folder. This page explains the skill and is not part
of the install.

Dense detail lives beside it in `references/` — the state schema, the follow-up
pass, and the UI ladder — and is read only when `SKILL.md` points at it.

It follows the [shared contract for X skills](twitter-core.md). Browse the
instructions in this repository:
[`twitter-followback/SKILL.md`](../../.agents/skills/twitter-followback/SKILL.md).

## When it triggers

- "follow back my followers" or "follow back my mutuals"
- "review my new followers"
- "clean up my follow-back queue"
- "is this follower a bot?"
- "which followers are worth following back?"

It is explicitly **not** for mass-following, growth hacking, or unfollowing.

## Requirements

| Need | Why |
| --- | --- |
| Interactive browser control | Every action happens through the real UI |
| A browser already signed in to X | The skill never handles credentials |
| A local session | Cloud, sandboxed, and headless sessions cannot complete it |
| Local file write | Keeps progress and pending follow-ups in `~/.x-followback/` between runs |

These limits are declared in the skill's `compatibility` field, so a host can
skip it before loading.

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
6. **Research each candidate** — bio, join date, follower ratio, newest posts,
   with protected accounts limited to non-post evidence.
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
   state-changing click. See [browser cadence](browser-cadence.md). Jitter
   applies to timing only; verification and throttle rules stay exact, and a
   challenge still ends the run.
10. **Persist and report** — save the cursor, verdicts, and follow-up dates;
    report new follows, pre-existing follows, pending requests, unverified
    clicks, and skips separately.

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

## Unreadable profiles

A "potentially sensitive content" interstitial can replace the whole profile: no
header, bio, posts, or follow control. The skill records the handle as
`unreadable`, with a follow-up, and reports it separately from skips. Nothing is
inferred from the missing page — not the interest, the activity, or the
relationship — because the notice is not the account. A later visit may render
normally; until it does, the account stays out of both the queue and the report's
judgements.

## Across runs

The Followers tab can hold hundreds of rows, and X throttles follows after a
short burst, so one pass is not expected to finish. The skill keeps one state
file per signed-in account at `~/.x-followback/<handle>.json`
(`%USERPROFILE%\.x-followback\<handle>.json` on Windows), outside the repository.

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
- Real handles and private details stay in the local state file, which persists
  between runs; examples use fictional placeholders.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Related

- [Skills catalog](README.md)
- [Architecture](../architecture.md)
- [Agent instructions](../agent-instructions.md)
