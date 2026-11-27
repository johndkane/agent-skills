---
name: twitter-following-audit
description: >-
  Review the accounts you follow on X (Twitter) and suggest one of four things
  for each: keep, unfollow, mute, or recheck later. Reads each account's bio,
  newest post, and recent posts against your interests to check whether the
  connection still earns its place. Unfollow can come from a quiet account, a
  changed focus, or drifted interests, never a judgement of the person; mute
  keeps the connection and quiets the feed. Bots, scams, harassment, and
  impersonation are flagged separately with the evidence for you to act on —
  it never suggests blocking. Optimistic:
  keep is the default and thin evidence never lands a negative verdict. Use
  when asked to audit my follows, review my following list, clean up who I
  follow, who has gone quiet, or should I still follow @example_alice. Read
  only: it suggests and never unfollows, blocks, mutes, follows, likes, or
  messages. Built for a real person tending their own personal account; not
  for brands or marketers. Not for mass unfollowing, growth hacking, or
  engagement farming.
compatibility: >-
  Needs interactive browser control: a real browser the user can watch and
  take over, signed in to X by the user, via the host's own browser tool, a
  browser-control extension, or an MCP browser server. A browser off the
  user's machine needs the user's yes; a blocked sandbox is named, never
  fought. Optional local file write for cross-run state. Optional image,
  video-frame, or transcript evidence needs a model and browser tool that
  returns it, else text-only. Without control, guided setup.
---

# X/Twitter Following Audit

Review the accounts the user follows and suggest what to do with each:
**keep**, **unfollow**, **mute**, or **recheck** later. The test is fit, not
worth: does the connection still earn its place against the interests the user
names today? Unfollow can come from a quiet account, a moved focus, or drifted
interests. Keep is the default, and every card leads with what the account
gives you.

Safety findings are a separate track, not a verdict: an account that looks
like a bot, scam, harassment source, or impersonation is flagged with quoted
evidence for the user to act on. The audit never suggests block — block
severs contact, which is a safety decision, not a feed-tuning choice.

This serves a real person tending their own feed on their own account — never
engagement farming, marketing, or brand growth.

The verdicts are suggestions the user applies. Read only: the run never
unfollows, blocks, mutes, follows, likes, reposts, reports, or messages.

## Group rules

Read [references/twitter-shared.md](references/twitter-shared.md) before
starting. It carries the rules shared by every X skill — browser setup, state
line, asking the user, linked evidence, human cadence, access failures, ads
and suggestion rows, and privacy — and it is part of this skill, not optional
background.

## Rules

- Verdict set: `keep`, `unfollow`, `mute`, `recheck`, defined with their
  evidence bars in [references/verdicts.md](references/verdicts.md). Read it
  before the first verdict.
- Safety evidence never produces a verdict: it routes the account to the flag
  track, and the flag card names block and report as the user's options to
  decide. The audit never suggests block — block is a safety decision, not a
  curation choice.
- Optimism is a rule, not a tone: keep needs no evidence; every other verdict
  needs proof; thin or unreadable evidence never lands a negative verdict.
- The skill never infers disagreement from content. `disagreement` is a reason
  tag only when the user names it.
- Unfollow reasons describe what changed — inactivity, a moved focus, content
  outside the named areas, volume — never the person. No adjectives about
  people; quote, date, tag.
- Interests come from the user: 3–8 concrete, checkable areas plus signal
  terms. Checkable means specific enough to test a post against — a tool,
  project, or field. Any example shown to the user comes from what this run
  observed about them, never a fixed illustration.
- A tie tempers the verdict: moots, accounts that follow the user, and
  accounts that replied to the user get mute or recheck before unfollow. The
  tie is stated in every card for them.
- Read everything fresh this run: bio, activity, posts. State is memory, never
  evidence.
- Text is the default evidence mode. Images, video frames, and audio
  transcripts are opt-in, capability-tested per the shared gate, capped, and
  never proof of identity or a sensitive trait.
- Read only: no unfollow, block, mute, follow, like, repost, report, or
  message, not even as a test.
- Cadence and privacy follow the shared rules. Keep quotes short and infer
  nothing from hidden content.

## Step 0 — Confirm browser control

1. Discover the host's browser mechanism — its own browser tool, a
   browser-control extension, or an MCP browser server — and check its status;
   no tabs is fine — open one.
2. Open X in a tab you created and keep it visible; hidden tabs pause rendering.
3. Prove control: navigate, read text back, screenshot.
4. Control missing or blocked: run the shared browser-setup flow in
   [references/twitter-shared.md](references/twitter-shared.md) — offer a
   step-by-step walk-through, the short version, or self-setup; guide from
   official vendor documentation read this run; continue only on a passed
   proof.
5. Hand off login, 2FA, passkey, captcha, or payment; never enter credentials.

## Step 1 — Read the current UI

1. Confirm the signed-in handle; several accounts may share one browser. This
   is the **source user**.
2. Open the source profile and confirm the Following list opens from it. Note
   what a row shows today: handle, display name, bio excerpt, and the
   follow-state control.
3. Note the profile markers: `Follows you`, lock icon, join date,
   follower/following counts, pinned post, and the follow control's exact
   labels (`Follow`, `Following`, `Unfollow`, `Pending`).
4. Open one followed account's profile and confirm the same markers. A missing
   element is a named gap, not a zero.
5. A protected profile or a "potentially sensitive content" notice is
   unreadable: record it, infer nothing, move on.

## Step 2 — Load state and give the state line

1. Read [references/state-file.md](references/state-file.md), then the file at
   `~/.x-following-audit/<handle>.json`
   (`%USERPROFILE%\.x-following-audit\<handle>.json` on Windows, with the `@`
   dropped).
2. Say one state line: the path, scope, evidence modes, audit version with its
   areas and windows, audited and stale counts, due rechecks, and the last
   write. No file means the run starts fresh.
3. Ask once for file-write access. If it is refused or unavailable, say so in
   the state line and run on session state per the shared fallback.
4. A saved verdict is never reported as current: older than 90 days, or from
   another audit version, is stale until re-read.

## Step 3 — Confirm the audit brief

Ask one question at a time in the user's words, per the shared asking rules:
each question states why it is being asked and what the answer changes, and
no question ships the labels below bare — they are recorded values, not
wording. The quoted questions are models; adapt them, keep them
self-explaining. Restate the settled brief in one plain paragraph.

1. **Scope** — asked first, with no silent default. Ask: "Which accounts
   should I look at? The ones you name, the ones I haven't reviewed yet, the
   ones I reviewed a while ago, or everyone you follow over a few runs? If
   you name an account, I'll check it directly." Record as `focus` (the
   accounts the user names), `unreviewed` (followed accounts with no verdict
   yet — propose this default), `stale` (verdicts older than 90 days or from
   another audit version), or `all` (every follow, queued over runs). A named
   handle makes the scope `focus`; an explicitly named scope wins.
2. **Areas** — ask: "What subjects make an account worth following for you?
   Give me 3 to 8, as concrete as you can — specific enough that I can check
   a post against it." Build any example from the user's own world, offered
   as a guess to confirm: the signed-in profile's bio or pinned post, areas
   saved in state, or their own words — "your bio says landscape photography;
   is that the kind of subject you mean?" When nothing observed fits, name
   the kind instead: "a tool, project, or field you actually work with."
   Never plant a fixed subject or state a guess as fact. Push back once on
   vague ones, in the user's own terms.
3. **Signal terms** — say why: "These are the words I'll look for in posts to
   decide whether an account matches a subject — tool names, project names,
   jargon. I'll propose 5 to 12 per subject; correct anything that's off."
   Propose them from what this run has observed — the user's bio and words,
   areas saved in state — never a generic word list. Lowercase words or short
   phrases, frozen in state once confirmed.
4. **Strictness** — ask: "Should a post name the subject outright to count,
   or is something close enough?" Default: outright (`must-post`);
   `adjacent` lets a closely related item count.
5. **Windows** — say why: "These decide when an account counts as quiet."
   Ask: "How long can someone go without posting before you'd call them
   quiet — 90 days? And a full year of silence is long-dormant, which I'd
   revisit before unfollowing. Check-again dates land 90 days out." Record
   active window (default 90 days), dormant window (default 12 months), and
   recheck gap (default 90 days).
6. **Evidence modes** — say why: "Most posts are text, so text is what I read
   by default; the extras only work if your setup can actually show them."
   Ask: "Want me to also read images, video frames, or audio transcripts?
   I'll prove I can really see them before counting anything." Each enabled
   mode is capability-tested once per run (Step 5); a failed test keeps text
   and reports `unavailable`, never a silent zero.
7. **Batch** — ask: "How many accounts this run? About 20 is a comfortable
   session — I'll pick up the rest next time." Default 20, maximum 40, plus
   a 45-minute wall-clock budget.
8. **Left-alone accounts** — say why: "So I never suggest anything about
   someone who matters personally." Ask: "Anyone I should leave completely
   alone — close friends, family? Name them and I'll skip them entirely."
   Record as held, with the user's reason; default none. Held is not keep:
   held means "never suggest".
9. **Named ties** — say why: "For people you know, the relationship matters
   more than the topics, so I'd lean toward muting rather than unfollowing."
   Ask: "Anyone on this list you know personally — a colleague or friend?"
   Record with the user's word for the relationship.

If the user says "use your judgement", propose the whole brief in plain
language and get a yes — every proposed area, term, and example built from
what this run observed about the user, never assumed. A changed area, term,
strictness, window, or evidence mode bumps the audit version (Step 8); a
scope or batch change does not.

## Step 4 — Build the audit queue

**Focus run:** skip this step. The named handles are the queue whatever their
relationship; a handle the user does not follow is still audited, with the
follow state reported as context.

1. Open the source's Following list and collect continuously while scrolling,
   per the shared cadence: handle, display name, bio excerpt. Two empty scroll
   stops end the list. A `Promoted` row — an ad or a suggested account — is not
   a follow: skip it, never queued or audited.
2. Skip follows that are `held`. Skip follows with a current verdict unless
   the scope is `stale` or the user asks for them this run.
3. Order: user-named first, then unreviewed in list order, then stale oldest
   verdict first. Cap at the batch; queue the rest with the cursor.
4. Category is confirmed on the profile in Step 5, never from the row: `moot`
   when `Follows you` shows on a followed profile, `following-only` when it
   does not.
5. Never take targets from suggestion modules, "who to follow" strips, or
   search.

## Step 5 — Research each account

For each queued account, in order:

1. Open the profile; confirm the exact `@handle` and display name. Record
   bio, join date, follower/following counts, `Follows you`, lock icon,
   pinned post, and the follow control — `Following`/`Unfollow` proves the
   user still follows. If the control no longer proves a follow, record the
   fact and leave the account out of this run's verdicts.
2. Sample up to 15 items from Posts (original posts and visible replies),
   recording: kind, visible text (≤200 characters), date, permalink, repost
   or not. Deduplicate by URL. Record the newest post date. Promoted rows and
   injected modules are not the account's posts: never sampled or counted.
3. Match text, captions, and alt text against the frozen signal terms; record
   matched items per area with their permalinks. A repost is secondhand and
   never proves alignment on its own.
4. Record feed-fit counts: repost share of the sample, and whether the account
   is high-volume — more than about 50 items in 7 days. Count, do not guess.
5. Capability-test each enabled evidence mode once per run before counting
   non-text evidence, per the shared gate. With a mode proven, an image,
   paused frame, or host transcript may support a match, tagged `[image]`,
   `[video]`, or `[audio]` with date and permalink, lower-weight and capped.
   Never identify a person from a photo or infer a sensitive trait.
6. Safety evidence is profile-level and quoted: bot or follow-farm patterns,
   scams or fraud, harassment toward the user, impersonation. Record it and
   mark the account flagged; Step 6 routes it to the flag track.
7. A protected profile or sensitive-content notice is `unreadable`: no
   verdict, nothing inferred, move on.
8. Media reads: at most 1 profile image pair and 3 media items per account,
   12 non-text reads per run, counted against the budget.
9. Stop at the batch, the wall clock, or two empty scroll stops. Write state
   after each account.

If the Posts tab shows nothing inside the active window, the dormancy test
still runs: the newest post date is the evidence, not a failure.

## Step 6 — Assign verdicts

Read [references/verdicts.md](references/verdicts.md) before the first
verdict; it holds the decision table, the evidence bars, the reason tags, and
the optimism wording.

1. Assign one verdict per account from the decision table — `keep`,
   `unfollow`, `mute`, or `recheck` — with one reason tag and the counted
   fact behind it: a reason never stands bare.
2. Any matched item in the window proves alignment: the verdict is `keep`.
3. A tie moves an unfollow to mute or recheck; state the tie in the card.
4. Quoted safety evidence routes the account to the flag track instead of a
   verdict, whatever its alignment. The flag card quotes the evidence and
   names block and report as the user's options to decide — with the
   calibration that block severs contact and also unfollows, while unfollow
   alone only clears the feed — never as actions this run takes.
5. Thin or unreadable evidence never lands a negative verdict: keep-noted or
   recheck.
6. The user may overrule any verdict; record the final verdict and the user's
   word for why. An override is the user's decision, not a rubric failure.

## Step 7 — Present

Read [references/report-format.md](references/report-format.md) before the
first card.

1. Open with the scope and its counts, the interests and windows in force,
   evidence modes and capability, the audit version, and the state line.
2. Verdict summary table: linked handle, category (`moot` or
   `following-only`), verdict, reason tag with the counted fact behind it —
   the silence span, match count, repost share, or volume rate — newest post
   date, confidence.
3. A card for every unfollow, mute, and recheck: what the account gives or
   gave, what changed with a quoted, dated, linked item or a counted dormancy
   fact, the alternative, and what would return it to keep.
4. Flagged accounts in their own section, after the cards: quoted, dated
   safety evidence and the user's options — block (severs contact and also
   unfollows), report where platform rules are implicated, or unfollow alone
   (feed removal only) — decided by the user, never performed. A flag never
   mixes with a verdict.
5. Keeps as one line each: the handle and what earns the slot — the matched
   area or the tie.
6. Held, unreadable, and overridden handles separately, one line each. An
   empty or all-keep result is valid and normal.
7. Link every handle and cited item per the shared rules; never invent a
   status URL.
8. Never describe an account as worthless, bad, or cringe; describe fit. No
   claims about personality, politics, health, or private life. Never describe
   an image or transcript you did not see.

## Step 8 — Persist and report

1. Write after each account and before the run ends: scope, focus handles,
   audit version, areas and terms, windows, held handles, named ties, evidence
   modes, per-account verdict, reason tag, category, counts, newest post date,
   queue, cursor, and follow-ups.
2. A changed area, term, strictness, window, or evidence mode bumps the audit
   version and marks every verdict stale. A scope or batch change does not.
3. Record `audited`, `flagged`, `stale`, `unreadable`, `held`, and overrides
   with dates. Rechecks get a dated follow-up.
4. Report what was read, what was missing, where the run stopped, and what
   remains queued.
5. Say nothing was changed on X: no unfollow, block, mute, follow, like,
   repost, report, or message. The verdicts are the user's to apply.

## Limits

- The audit reads public or self-visible posts, not intent. A quiet account
  may be a person on a break; recheck exists for that.
- Content is judged on the window and the interests named now. An account
  mid-transition can look drifted; the recheck gap catches it later.
- A verdict says fit between this account and these interests today — never
  worth, character, politics, or personality.
- Samples are small; every card shows its counts.
- Protected accounts and notice-replaced pages are unreadable, whatever the
  tie.

## Safety

- Only the user's own account, only the confirmed scope.
- Real people, personal accounts: never engagement farming, marketing, or
  brand work; no mass automation, no bulk unfollowing.
- Read only: suggestions and flags only; the run performs no action on X.
- Safety findings are flagged with quoted evidence for the user to decide;
  the audit never suggests block, and never flags for disagreement, drift,
  or volume.
- No credentials; hand off challenges. A challenge ends the run.
- No DMs, no private data, no inference from hidden content.
- Never claim to see an image, frame, or transcript you cannot; flag that mode
  `unavailable` and run text-only.
- Never identify a person from a photo or infer race, ethnicity, gender, age,
  disability, health, religion, or sexuality from any image.
- Stop and ask when identity, scope, or UI behaviour is unclear.

## Done checklist

- [ ] Control proven; source identity confirmed; UI labels read this run.
- [ ] State loaded or started fresh; state line given; audit version
      recorded.
- [ ] Scope chosen up front from focus / unreviewed / stale / all; batch and
      windows restated.
- [ ] Areas, signal terms, strictness, held handles, and named ties confirmed.
- [ ] Evidence modes confirmed; each enabled mode capability-tested or flagged
      `unavailable`; non-text evidence labelled and capped.
- [ ] Queue came from the Following list this run, `Promoted` rows skipped as
      ads; categories confirmed on profiles.
- [ ] Every non-keep verdict carries a reason tag with its counted fact
      beside it — a quoted dated item or a counted dormancy fact — and its
      tie or lack of one.
- [ ] Keeps are stated with what earns the slot; optimism wording throughout.
- [ ] Safety findings are flagged with quoted evidence in their own section;
      no verdict mixes with a flag; nothing was performed.
- [ ] Every cited item has a date and permalink from this run; every handle is
      linked.
- [ ] State written, or session state printed for verification; stale verdicts
      labelled; rechecks have dated follow-ups.
- [ ] Nothing was changed on X; overrides recorded.
- [ ] Cadence jittered; access failures flagged, not turned into verdicts.
