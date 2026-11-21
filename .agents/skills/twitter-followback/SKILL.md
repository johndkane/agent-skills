---
name: twitter-followback
description: >-
  Research and follow back legitimate followers on X (Twitter): real people who
  post actively, with bots, marketing, adult, crypto and impersonation accounts
  filtered out, and every completed follow verified in the UI. Handles protected
  accounts and pending follow requests, and resumes long follower queues from a
  local state file across runs. Use when asked to follow back followers or
  mutuals, review new followers, clean up a follow-back queue, check whether a
  follower is a bot, or decide which followers are worth following back. Not for
  mass-following, growth hacking, or unfollowing.
compatibility: >-
  Needs an agent with interactive browser control, a browser session already
  signed in to X, and local file write for the run state file. Must run locally
  on the user's machine; cloud, sandboxed, or headless sessions without browser
  access cannot complete it.
---

# X/Twitter Follow-Back

Follow back real, active followers — never a bot, brand, funnel, or guess. Work
from the live page, observation first.

## Group rules

Read [references/twitter-shared.md](references/twitter-shared.md) before starting.
It carries the rules shared by every X skill — state line, linked evidence, human
cadence, access failures, and privacy — and it is part of this skill, not
optional background.

## Rules

- Research every candidate before following: bio, join date, follower ratio,
  newest post, last two or three posts.
- Work only `Follow back` rows. Plain `Follow` counts only on a row confirmed
  this run as a protected follower; on any other Followers row it means the
  account no longer follows the user — a stranger, never queued.
- `Following`, `Unfollow`, and `Pending` are already handled — never touch them.
- Never unfollow, block, report, or message. Never follow from suggestions,
  "who to follow", or search.
- Verify before claiming: the exact handle's control must read `Following` or
  `Unfollow` — either label proves the follow — after the full settle window. A
  protected account reaches `Pending` at most — a request, not a follow.
- Never click one control twice inside the settle window.
- Persist progress and follow-ups to the state file; the live UI wins over it.
- Borderline accounts are the user's call. Bring the evidence, not just the
  handle.
- One account per action: the click must be tied to the researched `@handle`.

## Step 0 — Confirm browser control

1. Check the tool's status: connection, pairing, tabs. No tabs is fine — open
   one.
2. Open X in a tab you created and keep; keep it visible, since hidden tabs
   pause rendering.
3. Prove control: navigate, read the title or visible text, screenshot.

If control is missing, stop and give the prerequisites — pair the relay, open
the signed-in browser, name the profile — then wait. Hand off login, 2FA,
passkey, captcha, or payment; never enter credentials.

## Step 1 — Read the current UI

1. Confirm the signed-in handle; several accounts may share one browser.
2. Open that account's **Followers** tab — not Following, not a suggestion
   list.
3. Observe the labels on several rows. `Follow back` is the queue;
   `Following` and `Unfollow` are the same already-followed state under two
   labels. Other variants, `Subscribe` icon labels, and the protected-account
   signs are in [references/ui-vocabulary.md](references/ui-vocabulary.md).
4. Read the row anatomy: display name, `@handle`, "Follows you", action button,
   bio excerpt, and a lock icon on protected rows.
5. An unfamiliar label or layout is resolved before acting, using the ladder in
   [references/ui-vocabulary.md](references/ui-vocabulary.md).

## Step 2 — Confirm the criteria

Never assume them. Ask, then restate:

- **Scope** — how many followers, and start fresh or resume.
- **Real person** — do project, persona, and org-adjacent accounts count?
- **Active** — recency threshold; default about 30 days.
- **Exclusions** — marketing/brand/affiliate, adult, crypto/trading,
  impersonation/parody, giveaways and engagement bait.
- **Character** — political speech alone is fine; hate, abuse, slurs, scams are
  not.
- **Edge cases** — people already followed; borderline accounts (ask or decide
  and report).
- **Protected accounts** — posts unreadable until accepted, so the activity and
  character checks cannot run and any follow is blind; the control reads
  `Pending`. Offer: skip and report (default), follow on non-post evidence only,
  or ask per account.
- **Budget** — verified follows, wall-clock limit, or both; stop cleanly at the
  first hard throttle.

If the user says "use your judgment", state the rubric before acting. Restate
the protected decision and budget in one summary.

## Step 3 — Load state, build the queue

1. Read the state file first (Step 7) and say the state line. Same account and
   criteria: skip `processed`, except re-read `unverified` and `unreadable` and
   wait for `pending`'s `checkOn`; drain `queue`; scan from `scannedThrough`.
   Criteria changed: archive the file and start fresh. UI wins in every case.
2. Collect `Follow back` rows plus `Follow` rows confirmed this run as protected
   followers, keyed by `@handle`, in order. A `Follow` row with no lock icon is
   someone who no longer follows the user: leave it unqueued and un-researched.
3. Deduplicate; the list is virtualised, so collect while scrolling.
4. Stalls near ~100 rows: jump in large steps with pauses, vary the step, and
   scroll back occasionally.
5. Keep payloads compact — handles, not pages.
6. `Pending` is already requested: record it, do not queue it. Re-read a row's
   button before acting.
7. Stop at the budget or after two scroll stops add nothing; write state, then
   work the queue. A clean hand-off beats finishing the list.

## Step 4 — Research every candidate

| Signal | Tells you |
| --- | --- |
| Bio | identity, role, links, promotion, bait |
| Join date | new accounts are a risk signal; age is not proof |
| Followers / following | thousands followed with few followers is a farm |
| Newest post | whether the account is active |
| Last two or three posts | topic, tone, whether it is a person |

Bias to skipping: a missed follow costs nothing; a bot costs trust.

Protected accounts supply no post evidence. Note what you saw (bio, join date,
ratio, handle), apply the Step 2 decision, and never claim the activity or
character check was done. If the user chose non-post evidence, say so. Record a
skip as `skipped`, reason `protected`.

A "potentially sensitive content" notice can replace the whole profile: no
header, bio, posts, or control. Record `unreadable` with the reason and a
follow-up, infer nothing, and never file it as a skip on merit. Recognition
signs and the re-read rule are in
[references/ui-vocabulary.md](references/ui-vocabulary.md).

Skip patterns:

- **Empty shell** — no bio, posts, or followers; auto-generated handle.
- **Follow farm** — thousands following, few followers, little original content.
- **Marketing/funnel** — affiliate links, agencies, "book a call", lead magnets.
- **Adult bait** — "DMs open", exclusive-access claims, explicit bios.
- **Crypto/trading** — ticker spam, funded-account journeys, airdrops.
- **Impersonation** — copied public-figure names, "old account was hacked".
- **Dormant** — last post measured in months or years.
- **Bad character** — slurs, hate, harassment, abuse.

## Step 5 — Follow with exact identity

1. Open the profile; confirm `location.pathname` and the header match `@handle`.
2. Target the exact accessible name: `Follow @handle` or `Follow back @handle`.
3. Reject broader matches; a prefix match can click a suggestion elsewhere.
4. Use the real input layer, not a synthetic `.click()`; move, hover briefly,
   then click.
5. Verify after settling (Step 6): public → `Following`/`Unfollow`; protected →
   `Pending` (record the request, never re-click to force `Following`); no
   change → unverified.
6. For an unexpected dialog, dismiss and re-check state; do not invent one.

## Step 6 — Settle and handle limits

After each click, poll the same control at jittered checkpoints of roughly 2–4,
7–9, 14–16, and 28–30 seconds, then re-read at about 60 and 120 seconds before
calling a miss. X flips late: a change near two minutes is on time, not a
failure.

- No second click inside the window: it unfollows or cancels the request.
- Rows lie late too; confirm on the profile, never by re-clicking the row.
- Either label lands it: `Following` or `Unfollow`.
- Treat a late landing as success and record it.
- On a miss: pause 2–6 minutes, re-read, then retry **once** only if it still
  reads `Follow`/`Follow back`. Never retry before the longer re-read.
- A second miss ends follow activity for the run — expect a burst of about
  three follows, then a cooldown, often with no visible notice.
- Never loop, never work around a limit with another account, session, or
  client. A visible limit notice ends the run: write state and hand off.

## Step 7 — Persist progress

One file per signed-in account, outside the repository:

- `~/.x-followback/<handle>.json`; on Windows
  `%USERPROFILE%\.x-followback\<handle>.json`; drop the `@`.
- Never inside the skill folder or a repo; no secrets. This file is the only
  place a real handle, name, or private detail is written; it persists between
  runs so progress carries over, and skill text and saved examples use fictional
  placeholders.

Schema, verdicts, writing rules, and the start-of-run follow-up pass are in
[references/state-file.md](references/state-file.md). Read it before the first
write and when resuming; a schema from memory drops the queue or follow-ups.

## Step 8 — Report honestly

- Four buckets: **newly followed**, **already followed**, **pending requests**,
  **unverified** — and how each was verified.
- Skips grouped by reason, with representative handles.
- Unreadable profiles — sensitive-content notices and other pages that rendered
  no profile — listed separately from skips, with what could not be read.
- Protected accounts separately, and whether research was limited to non-post
  evidence.
- Where the run stopped, how many rows remain, the resume point, next follow-up
  dates.
- Anything unverified, blocked, or left to the user.
- Never claim a follow from memory, another run, or an inference.

## Safety

- Only the user's own account, only the confirmed scope.
- No unfollow, block, report, or message; no suggestion-module follows.
- No credentials; hand off challenges.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Done checklist

- [ ] Control proven; account identified; UI labels confirmed this run.
- [ ] Criteria, protected decision, and budget confirmed and restated.
- [ ] State loaded or started fresh; no rework of processed handles.
- [ ] Run opened with the state line.
- [ ] Every handle the run lists and every cited post links to what was read.
- [ ] Access failures flagged, not turned into verdicts.
- [ ] Queue from follow-back rows only; `Follow` strangers excluded, `Pending`
      recorded, not queued.
- [ ] Every candidate researched; protected and unreadable limits stated, not
      inferred around.
- [ ] Every follow exact-handle matched and verified after settling; protected
      ones recorded `Pending` with a follow-up.
- [ ] No double clicks; no stale rows trusted; cadence jittered.
- [ ] No unfollows, strangers, or suggestion clicks.
- [ ] State written before hand-off.
- [ ] Report separates new, pre-existing, pending, unverified, and skips.
