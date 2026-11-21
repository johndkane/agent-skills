---
name: twitter-moot-radar
description: >-
  Find accounts worth following on X (Twitter) through your mutuals: asks for
  your areas of interest, harvests what your moots follow, and suggests only the
  accounts that match, ranked by how many moots follow them and shown with
  proof — a quoted post, its permalink, the moots behind it, and live
  confirmation that you do not follow them yet. Use when asked to find people to
  follow, find accounts in my mutuals' circles, who do my moots follow that I
  don't, find similar accounts, or build a follow list from my network. Not for
  mass-following, growth hacking, or unfollowing; nothing is followed without
  your per-handle approval.
compatibility: >-
  Needs an agent with interactive browser control, a browser session already
  signed in to X, and local file write for the run state file. Must run locally
  on the user's machine; cloud, sandboxed, or headless sessions without browser
  access cannot complete it.
---

# X/Twitter Moot Radar

A **moot** is someone the user follows who follows back. Their Following lists
are the best recommendation source and the easiest to flatter with noise. Return
a short ranked list where every line is checkable; never follow without
per-handle approval.

## Rules

- Interests come from the user, restated as checkable areas before harvesting.
  "Tech" is not checkable; "Rust and systems programming" is.
- Harvest moots' Following lists only — never "Who to follow", Explore, search,
  or a moot's Followers tab.
- Overlap ranks: more distinct moots means higher. Two is the default bar; one
  moot is a weak lead and is named as such.
- No suggestion without a quoted post (date + permalink) or a bio line that
  states the interest. A post beats a bio.
- A follow relationship is relevance, not interest. Only the account's words
  prove what it posts about.
- "Not followed" is proved by a live `Follow @handle` control, not by a list.
- Report by default. Follow only handles the user approves by name.
- Filter noise at the row level; keep quote evidence dated; reuse the graph and
  re-rank when interests change.

## Human cadence

Draw every wait from a range; identical clicks are what rate limiters notice.
Pacing never excuses skipping verification or passing a challenge.

| Action | Draw each wait from |
| --- | --- |
| First read of a page | 1.5–4 s |
| Before clicking | 0.8–2.5 s, after moving the pointer |
| Between candidates | 4–12 s; 20–90 s reading pause every 4–6 |
| Scroll tick | 0.6–2 s; 1–3 viewport heights, varying |
| Stop to read rows | 2–6 s, sometimes scrolling back |
| Typing a handle | 80–250 ms per character |

- Move in two to four hops, hover, click; let the pointer rest.
- Readiness first: wait for the page or control to exist, then apply the minimum
  wait. Never sleep instead of checking.
- Scale with consequence: take the upper half of the click range and a hover
  before a state-changing click; passive navigation and re-checks need only the
  minimum.
- Dwell where a person would read — profile evidence and rows — not on every
  scroll tick.
- Open with 30–60 s of reading; break 2–5 min after ~40–60 interactions; cadence
  counts against the wall-clock budget.
- Jitter timing only: exact-handle matching, the full settle window, and the
  retry rules stay exact.
- A captcha, checkpoint, or "verify it's you" prompt ends the run. Hand off;
  never try to pass it.

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
2. On a profile, read the display name, `@handle`, `Follows you`, lock icon, and
   the control's exact label:
   - `Follow @handle` — not followed; this is the "not followed" proof.
   - `Following @handle` / `Unfollow @handle` — already followed, under either
     label; both prove the follow. Drop it.
   - `Pending` — an outstanding request on a protected account.
   - `Follows you` — a bonus signal, not a moot by itself.
3. On a moot's Following list, note where the handle, bio excerpt, and any
   mutual marker sit; confirm whether rows show `Follows you`.
4. The lists are virtualised: collect continuously while scrolling, varying
   step size and pause per Human cadence.
5. Resolve an unfamiliar label before acting: screenshot plus accessibility
   snapshot, compare two known states, check X Help; the live UI wins. Ask if it
   stays unclear.

## Step 2 — Ask for areas of interest

Never infer interests from existing follows. If state holds a profile for this
account, show it and ask whether to keep or change it.

Ask, then restate:

- **Areas** — 3 to 8, concrete and observable; push back once on vague ones.
- **Signal words** (optional) — tools, projects, jargon, names that count as
  evidence.
- **Strictness** — must post about the area (default), or adjacent is fine.
- **Overlap bar** — 2+ distinct moots by default, or strong single-moot
  evidence.
- **Exclusions** — marketing/affiliate, crypto/trading, adult, giveaways,
  impersonation/parody, hate/abuse; let the user add or remove.
- **Moot scope** — all confirmed moots across runs, or a named subset.
- **Budget** — suggestions to return, moots to scan, wall-clock limit.
- **Already-follows-you** — flag separately or leave out; that is a follow-back
  task.
- **Protected accounts** — posts unreadable, so no proof is possible; exclude
  and report, never offer an evidence-free shortcut.

If the user says "use your judgement", propose the list, bar, and budget, and
get a yes. Restate the brief in one paragraph.

## Step 3 — Build the moot roster

1. Confirm the account; the roster belongs to it.
2. A moot must be evidenced: the `Follows you` marker is strongest; the
   intersection of the user's Following and Followers sets is a cheap bulk
   filter, not a label. Never call someone a moot from the Following list alone.
   Collect virtualised lists once, dedupe, persist confirmed moots.
3. Label each moot with what they post about, from their bio.
4. Order by relevance to the interests first, then activity recency.
5. Cap at the budget; record the rest for the next run.
6. A protected moot may hide its Following list until the user is approved.
   Record it as unavailable, not empty; never guess.
7. Reuse a confirmed moot from state, but re-read `Follows you` when harvesting
   their list.

## Step 4 — Harvest Following lists

For each moot, in order:

1. Open `x.com/<moot>/following` directly; confirm whose list it is.
2. Collect continuously: handle, display name, short bio excerpt. Append the
   moot to each candidate's `moots` set as you go, so overlap grows during the
   harvest.
3. Skip the user, the moots, handles already decided in state, and handles the
   user already follows (a row hint; confirmed in Step 6).
4. Read the top first — recency reflects current taste. Default to roughly the
   first 60–120 rows per moot; go deeper only if the budget is unfilled.
5. Stop when the budget is full, the list ends, or two scroll stops add nothing;
   vary jumps and back-scroll occasionally.
6. Never harvest a Followers tab, Explore, search, or a "similar accounts"
   module.

Rows are cheap; profile visits are the throttled unit. Harvest broadly, research
narrowly.

## Step 5 — Filter before opening profiles

1. **Overlap** — at or above the Step 2 bar (default 2).
2. **Row exclusions** — drop obvious skip patterns before a profile visit.
3. **State** — drop `suggested` inside cooldown, `dismissed`, `followed`.
4. **Plausibility** — the bio excerpt must connect to a named interest; if
   nothing connects, do not shortlist.
5. Rank by overlap, then by the moots' relevance labels; shortlist about three
   times the suggestion budget.

Skip patterns:

- **Empty shell** — no bio, posts, or followers; auto-generated handle.
- **Follow farm** — thousands following, few followers, little original content.
- **Marketing/funnel** — affiliate links, agencies, "book a call", lead magnets.
- **Adult bait** — "DMs open", exclusive-access claims, explicit bios.
- **Crypto/trading** — ticker spam, funded-account journeys, airdrops.
- **Impersonation** — copied public-figure names, "old account was hacked".
- **Dormant** — last post in months or years.
- **Bad character** — slurs, hate, harassment, abuse.

A borderline bio is not a suggestion; skip it, or near-miss it when overlap is
strong. Count filtered items by reason for the report.

## Step 6 — Research and collect proof

For each shortlisted candidate, open the profile:

| Signal | Proves |
| --- | --- |
| Bio | identity, role, declared field or project |
| Last two or three posts | the interest is real and current; the quote |
| Post dates | recency — default activity within ~30 days |
| Followers / following | farm or echo-chamber check |
| Follow control | the user does not already follow them |
| `Follows you` | bonus: they already follow the user |
| Lock icon | posts unreadable; no proof possible |

Proof rules:

- One clear match minimum: a post quoted at 200 characters or fewer with date
  and permalink, or a bio line that states the interest.
- A single keyword among unrelated posts is not a match; look for a body of
  posts or one substantial post.
- Display name, avatar, emoji, and the follow relationship are not evidence.
- Tag each match to a named interest; multiple matches rank up.
- No readable posts, no suggestion — record `no_evidence` and move on, whatever
  the overlap.
- If the control reads `Following` or `Unfollow`, record `already_following` and
  drop it.
- A "potentially sensitive content" interstitial is not a profile: no bio, no
  posts, no control. Record `unreadable`, report it as unreadable, and infer
  nothing — not the interest, not the activity, not the relationship.
- Note quote, date, permalink, and moots as you read them; state keeps tags, not
  quotes.

## Step 7 — Rank and present with proof

Rank by overlap, then evidence strength, then recency, then a sane follower
ratio. Present grouped by interest, strongest first.

Use the card in [references/report-format.md](references/report-format.md):
quote, date, permalink, moots by handle and count, live follow state, optional
`follows you`. Read it before the first card.

Never describe an account as an expert, founder, or practitioner unless the
profile says so.

## Step 8 — Follow only what is approved

The default is a report with zero actions.

1. Restate the approved handles and count.
2. Follow one at a time: profile, pathname and header match, then the control
   whose accessible name is exactly `Follow @handle`.
3. Reject prefix matches; they can click a suggestion elsewhere.
4. Wait out the settle window — checkpoints of roughly 2–4, 7–9, 14–16, 28–30
   seconds, then re-read at about 60 and 120 seconds. A flip near two minutes is
   on time; re-read before ever retrying. Either `Following` or `Unfollow` with
   the exact handle is a follow; `Pending` is a request.
5. Never click twice inside the window: the second click unfollows.
6. About three follows, then a cooldown: pause 2–6 minutes, re-read once, end
   follow activity for the run, record the resume point. No other account or
   client.
7. If an approved handle was flagged, restate the flag and confirm again.
8. Record `followed`, `pending`, or `unverified` with dates; add follow-ups for
   the last two.

## Step 9 — Persist progress

One file per signed-in account, outside the repository:

```text
~/.x-moot-radar/<handle>.json
%USERPROFILE%\.x-moot-radar\<handle>.json   (Windows)
```

Schema, verdicts, and writing rules are in
[references/state-file.md](references/state-file.md). Read it before the first
write and when resuming.

This file is the only place a real handle or private detail is written; it
persists between runs so the graph and verdicts carry over. Skill text and any
saved example use fictional placeholders, and the file holds only what tracking
needs.

## Step 10 — Report honestly

- Interest profile, overlap bar, and exclusions in force.
- Moots confirmed, harvested, remaining, and the resume point.
- Suggestions by interest: quote, date, permalink, moots, follow state.
- Near misses and why they fell short; filtered counts by reason.
- Protected accounts excluded, and why that is not a judgement.
- Follows: verified / pending / unverified, separately; nothing else changed.
- An empty result is valid: give counts and offer to widen the brief.
- Never claim an interest, relationship, or fit beyond what was read.

## Safety

- Only the user's own account, only the confirmed scope.
- No follow without per-handle approval; no unfollow, block, report, or message.
- No harvesting from suggestion modules, Explore, or search.
- No credentials; hand off challenges.
- Never describe a protected account's interests; keep quotes short and local.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Done checklist

- [ ] Control proven; account identified; UI labels confirmed this run.
- [ ] Interests, exclusions, overlap bar, and budget confirmed and restated.
- [ ] Roster from confirmed moots only, labelled, ordered, capped.
- [ ] Harvest from Following lists only; overlap counted per candidate.
- [ ] Every suggestion has quoted evidence with date and permalink, and a live
      "not followed" reading.
- [ ] Protected accounts excluded and reported, not guessed at.
- [ ] Near misses listed with reasons.
- [ ] Only approved handles followed and verified after settling; no double
      clicks; cadence jittered.
- [ ] State written before hand-off.
- [ ] Report separates suggestions, near misses, filtered counts, and follow
      outcomes.
