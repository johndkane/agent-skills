---
name: twitter-moot-radar
description: >-
  Find accounts worth following on X (Twitter) through your mutuals: asks for
  your areas of interest, harvests what your moots follow, and suggests only the
  accounts that match, ranked by how many moots follow them and shown with
  proof — a quoted post, its permalink, the moots behind it, and live
  confirmation that you do not follow them yet. Or assess one named account
  directly, with moot overlap shown as context rather than a requirement.
  Optionally reads image-only posts
  and video frames when you opt in, as labelled lower-weight proof. Use when asked to find people to
  follow, find accounts in my mutuals' circles, who do my moots follow that I
  don't, check out a specific account, find similar accounts, or build a follow list from my network. Not for
  mass-following, growth hacking, or unfollowing; nothing is followed without
  your per-handle approval.
compatibility: >-
  Needs an agent with interactive browser control, a browser session already
  signed in to X, and optional local file write for cross-run state. Optional
  image, video-frame, or transcript evidence needs a model and browser tool that
  return it; otherwise the run stays text-only. Must run locally on the user's
  machine; cloud, sandboxed, or headless sessions without browser access cannot
  complete it.
---

# X/Twitter Moot Radar

A **moot** is someone the user follows who follows back. Their Following lists
are the best recommendation source and the easiest to flatter with noise. Return
a short ranked list where every line is checkable; never follow without
per-handle approval.

A **focus account** is one the user names directly. Assess it on its own merits:
no moot has to follow it, and whether it follows the user back is context, not a
requirement. A zero overlap and a missing follow-back are facts to report, never
a reason to question the request or push the user toward a different account.

## Group rules

Read [references/twitter-shared.md](references/twitter-shared.md) before starting.
It carries the rules shared by every X skill — state line, linked evidence, human
cadence, access failures, and privacy — and it is part of this skill, not
optional background.

## Rules

- Interests come from the user, restated as checkable areas before any harvesting
  or assessment. "Tech" is not checkable; "Rust and systems programming" is.
- Harvest moots' Following lists only — never "Who to follow", Explore, search,
  or a moot's Followers tab.
- Overlap ranks a graph run: more distinct moots means higher. Two is the default
  bar; one moot is a weak lead and is named as such. A focus run has no bar.
- No suggestion without a quoted post (date + permalink) or a bio line that
  states the interest. A post beats a bio.
- A follow relationship is relevance, not interest. Only the account's words
  prove what it posts about.
- "Not followed" is proved by a live `Follow @handle` control, not by a list.
- Report by default. Follow only handles the user approves by name.
- A named handle is a focus target: research it directly, skip the roster and
  harvest, and do not ask it to justify itself through moots, a follow-back, or
  an overlap bar.
- Filter noise at the row level; keep quote evidence dated; reuse the graph and
  re-rank when interests change. For a focus target, skip patterns and the
  overlap bar become caution notes, while the interest-evidence gate still
  applies.
- Text is the default evidence mode. Images, video frames, and audio transcripts
  are opt-in, capability-tested in Step 6, capped, and labelled; a photo never
  proves a real person or a sensitive trait.

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
     label; both prove the follow. Context for a focus account; a graph run drops
     it from suggestions.
   - `Pending` — an outstanding request on a protected account.
   - `Follows you` — context, not a moot by itself and not a requirement.
3. On a moot's Following list, note where the handle, bio excerpt, and any
   mutual marker sit; confirm whether rows show `Follows you`.
4. The lists are virtualised: collect continuously while scrolling, varying
   step size and pause per Human cadence.
5. Resolve an unfamiliar label before acting: screenshot plus accessibility
   snapshot, compare two known states, check X Help; the live UI wins. Ask if it
   stays unclear.

## Step 2 — Confirm the brief

Never infer interests from existing follows. If state holds a profile for this
account, say the state line, show it, and ask whether to keep or change it.

Ask, then restate:

- **Target** — the whole moot graph (default), or one or more accounts the user
  names. A named account is in scope whatever its relationship: followed or
  unfollowed, follows back or not, moot or not.
- **Areas** — 3 to 8, concrete and observable; push back once on vague ones.
- **Signal words** (optional) — tools, projects, jargon, names that count as
  evidence.
- **Strictness** — must post about the area (default), or adjacent is fine.
- **Evidence modes** — default `text`. Offer `images` (image-only posts, profile
  avatar and banner), `video` (paused frames), and `audio` (host transcript only);
  text stays on and is the cheapest. Restate the set; each mode is capability-tested
  in Step 6.
- **Overlap bar** — graph runs only: 2+ distinct moots by default, or strong
  single-moot evidence.
- **Exclusions** — marketing/affiliate, crypto/trading, adult, giveaways,
  impersonation/parody, hate/abuse; let the user add or remove.
- **Moot scope** — graph runs only: all confirmed moots across runs, or a named
  subset.
- **Budget** — suggestions to return, moots to scan, wall-clock limit.
- **Already-follows-you** — flag separately or leave out; that is a follow-back
  task. A focus account is assessed either way.
- **Protected accounts** — posts unreadable, so no proof is possible; report the
  limit. A focus account is still reported, without an evidence-free shortcut.

If the user says "use your judgement", propose the list, bar, budget, and evidence
modes, and get a yes. Restate the brief in one paragraph.

## Step 3 — Build the moot roster

**Focus run:** skip this step and Step 4. The named account is the target, and
moots are optional context gathered later by checking whether any confirmed moot
happens to follow it. Do not harvest a graph to justify the request.

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

**Focus run:** skip; go to Step 6 for the named account.

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

**Focus run:** no overlap filter and no shortlist cut. Research the named account
and turn any skip pattern into a stated caution instead of dropping it.

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
strong. Count filtered items by reason for the report. In a focus run, do not skip:
state the same point as a caution and finish the assessment.

## Step 6 — Research and collect proof

For each shortlisted candidate (in a focus run, the named account), open the
profile:

| Signal | Proves |
| --- | --- |
| Bio | identity, role, declared field or project |
| Last two or three posts | the interest is real and current; the quote |
| Post dates | recency — default activity within ~30 days |
| Followers / following | farm or echo-chamber check |
| Follow control | whether the user follows them: `Follow` proves not followed; `Following`/`Unfollow` proves already followed |
| `Follows you` | the follow-back state: context, never a requirement |
| Lock icon | posts unreadable; no proof possible |

Proof rules:

- One clear match minimum: a post quoted at 200 characters or fewer with date
  and permalink, or a bio line that states the interest.
- A single keyword among unrelated posts is not a match; look for a body of
  posts or one substantial post.
- Display name, avatar, emoji, and the follow relationship are not interest
  evidence.
- Tag each match to a named interest; multiple matches rank up.
- No readable posts, no interest claim — record `no_evidence` and say what was
  missing. A graph run drops the candidate; a focus run still reports the
  account and its follow state, without a match claim.
- **Multimodal proof (opt-in)** — gate each enabled mode with the shared capability
  test before the first read. With it proven, an image-only post, paused video
  frame, or host transcript may satisfy the one-match gate when the pictured
  subject or legible words are unambiguous and tied to the interest: quote it as
  `[image] "Rust code with impl Trait"`, `[video] "…"`, or `[audio] "…"` with date
  and permalink.
  Visual proof ranks below text proof, caps that suggestion at medium confidence,
  and never replaces a text check that failed. Avatar and banner may flag stock,
  watermark, or impersonation noise once per candidate; never identify a person
  from a photo or infer sensitive traits. Skip media reads on a candidate already
  failing the text gate; keep inside 1 profile image pair, 3 media items per
  candidate, and 12 non-text reads per run.
- If the control reads `Following` or `Unfollow`, record `already_following`.
  A graph run drops it; a focus run keeps the assessment and reports the state
  as context.
- A "potentially sensitive content" interstitial is not a profile: no bio, no
  posts, no control. Record `unreadable`, report it as unreadable, and infer
  nothing — not the interest, not the activity, not the relationship.
- Note quote, date, permalink, and moots as you read them; state keeps tags, not
  quotes.

## Step 7 — Rank and present with proof

Graph run: rank by overlap, then evidence strength, then recency, then a sane
follower ratio, grouped by interest, strongest first.

Focus run: one assessment, not a ranking. Lead with the interest verdict and the
quoted proof, then the relationship (`follows you` or not, `not followed` or
already following) and the moot count — including `Moots: none` — as context.
Never present a low or zero overlap as a shortfall.

Use the card in [references/report-format.md](references/report-format.md):
quote, date, permalink, moots by handle and count, live follow state, optional
`follows you`. Read it before the first card. Open with the evidence modes and
capability, and label every non-text proof.

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

Ask once for file-write access. If it is refused or the path cannot be written,
say so in the state line, keep the same structure in session state, print it at
every stop and before the report for the user to verify, and continue. Say once
that the next run starts fresh and may repeat decided work.

## Step 10 — Report honestly

- Interest profile, overlap bar, and exclusions in force.
- Focus run: the named account, its interest evidence, and its follow-back and
  moot overlap as context. A missing follow-back or zero overlap is not an error
  and needs no apology or alternative suggestion.
- Moots confirmed, harvested, remaining, and the resume point.
- Suggestions by interest: quote, date, permalink, moots, follow state.
- Evidence modes and capability; non-text reads counted; `[image]`, `[video]`, or
  `[audio]` proof labelled as lower-weight.
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
- Never claim to see an image, frame, or transcript you cannot; flag that mode
  `unavailable` and stay text-only.
- Never identify a person from a photo or infer sensitive traits from an image.
- Never describe a protected account's interests; keep quotes short and local.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Done checklist

- [ ] Control proven; account identified; UI labels confirmed this run.
- [ ] Interests, exclusions, overlap bar, budget, and evidence modes confirmed and
      restated.
- [ ] Every enabled evidence mode capability-tested; `unavailable` flagged;
      non-text proof labelled and never above medium confidence.
- [ ] Roster from confirmed moots only, labelled, ordered, capped — or skipped
      for a named focus account.
- [ ] Harvest from Following lists only; overlap counted per candidate.
- [ ] Every suggestion has quoted evidence with date and permalink, and a live
      "not followed" reading.
- [ ] Protected accounts excluded and reported, not guessed at.
- [ ] A named focus account was researched directly: no roster, harvest, overlap
      bar, or follow-back requirement applied to it.
- [ ] Near misses listed with reasons.
- [ ] Only approved handles followed and verified after settling; no double
      clicks; cadence jittered.
- [ ] State written before hand-off, or printed for verification when writing is
      unavailable.
- [ ] Run opened with the state line.
- [ ] Every handle the run lists, every moot, and every cited post is linked to what was read.
- [ ] Access failures flagged, not turned into verdicts.
- [ ] Report separates suggestions, near misses, filtered counts, and follow
      outcomes.
