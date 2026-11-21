---
name: twitter-followback
description: >-
  Research and follow back legitimate followers on X (Twitter): real people who
  post actively, with bots, marketing, adult, crypto and impersonation accounts
  filtered out, and every completed follow verified in the UI. Handles protected
  accounts and pending follow requests, and resumes long follower queues from a
  local state file across runs. Use when asked to follow back followers or
  mutuals,
  review new followers, clean up a follow-back queue, check whether a follower is
  a bot, or decide which followers are worth following back. Not for
  mass-following, growth hacking, or unfollowing.
compatibility: >-
  Needs an agent with interactive browser control, a browser session already
  signed in to X, and local file write for the run state file. Must run locally
  on the user's machine; cloud, sandboxed, or headless sessions without browser
  access cannot complete it.
---

# X/Twitter Follow-Back

Follow back the people behind an account: real humans who follow the user, post
actively, and pass a character check — never a bot, a brand, a funnel, or a
guess. The interface is hostile to automation and changes often, so every step
below is observation-first and verified on screen.

## Operating principles

1. **Research before every follow.** No account is followed because it appeared
   in a list. Each one is read first: bio, join date, follower/following ratio,
   newest post, recent post text.
2. **Only act on follow-back rows.** On the Followers tab, `Follow back` is the
   work queue; a protected account that follows the user can show plain `Follow`
   instead. `Following` is already done and `Pending` is already requested;
   touching either is noise at best, damage at worst.
3. **Never unfollow.** Unfollowing is a different operation with different
   intent. If the user asks for it, that is a separate, explicitly confirmed task.
4. **Never follow a stranger.** Accounts suggested by the page ("You might like",
   "Who to follow") are not followers. Following one is always a mistake, even
   if the account looks good.
5. **Verify, then claim.** A follow is done only when the control this action
   targeted reads `Following`/`Unfollow` for that exact handle, after the UI has
   settled. Report only what was verified in this run. A protected account can
   reach `Pending` at best; that is a request, never a follow.
6. **Silence is a signal — but a slow one.** X updates the button state late; a
   click that looks dead can land 15+ seconds afterwards. Wait out the settle
   window before judging, and never click the same control twice inside it. A
   real miss means throttling: slow down, do not click harder.
7. **Respect the user's judgment calls.** Borderline accounts are theirs to
   decide. When asking, bring the evidence, not just the handle.
8. **Progress outlives the run.** The followers list can be far larger than one
   session can work through, and follow requests can stay pending for days.
   Persist progress and follow-ups to a local state file so the next run
   continues instead of restarting.

## Step 0 — Confirm browser control (prerequisite)

Do not start work until you can drive the user's real, signed-in browser.

1. Check the browser tool's status: connection, extension pairing, and available
   tabs. A connected relay with no tabs is fine — open one.
2. Open the target site in a tab you created and keep, and note its id. Prefer a
   tab held visible/focused; sites pause rendering and lazy-loading in hidden
   tabs, which looks like a broken page.
3. Prove control before planning: navigate to a page, read something from it
   (title or visible text), and take a screenshot.

If the browser is not connected, stop and give the user these prerequisites
rather than improvising:

- Install and enable the browser extension/relay that connects their browser to
  the agent, then complete pairing.
- Open the browser, confirm it reports as connected, and say which profile is
  signed in.
- Confirm the browser is the one holding the relevant session, and that the user
  is signed in to the site they want acted on.

Use the tool's own handoff mechanism for anything only the person can do — login,
2FA, passkey, captcha, payment, or an ambiguous security prompt.

## Step 1 — Learn the current UI before touching anything

The follow controls on X have changed repeatedly, and they vary by account state
and by layout. Establish the current behaviour from the live page, not from this
document.

1. **Confirm the signed-in identity.** Open the account's profile and read the
   handle. Several accounts may be reachable in one browser; never assume the
   active one is the intended one.
2. **Open the Followers tab** of that account (not "Following", not a suggested
   list).
3. **Discover the control vocabulary by observation.** Read the buttons on
   several rows and note every label in use. Known variants include:
   - `Follow back` — the row's account follows the user and the user does not
     follow them. This is the work queue.
   - `Following` — already followed. Nothing to do.
   - `Follow` — no follow from the user yet. On a profile page this is the
     normal control for a stranger; on a Followers row, confirm the account is a
     follower and is protected before treating it as a follow-back target.
   - `Subscribe` — the account sells subscriptions; the follow control may be
     reduced to an icon button whose accessible label is `Follow @handle` or
     `Unfollow @handle`.
   - `Pending` — a follow request is outstanding. X shows this after requesting
     to follow a protected account. Nothing is followed yet, and it can never be
     verified as `Following` until the owner accepts.
4. **Check the row anatomy.** Followers rows typically carry the display name,
   the `@handle`, a "Follows you" marker, the action button, and a bio excerpt.
   A protected account adds a lock icon beside the name. Confirm where the
   handle, the lock, and the button sit so a later click can be tied to the
   right row.
5. **Record the findings for the run.** If a label or layout does not match
   anything here, resolve it before acting — see the next section.

### Protected accounts, before you plan

A protected account hides its posts from everyone it has not approved. Recognise
one by any of these, on the row and on the profile:

- a lock icon beside the display name;
- profile text such as "These posts are protected" or "This account's posts are
  protected";
- no posts, media, or replies visible, even though the account is active
  elsewhere and has followers;
- the action offers a follow (`Follow` or `Follow back`) — or already reads
  `Pending` — on a row that appears in the user's Followers tab.

Do not misread this as an empty shell or a dormant account: the person may post
daily, you simply cannot read it. Record that the posts are unreadable, because
that blocks both the research in Step 4 and the follow verification in Step 5.

### When the UI does not make sense

Do not guess and do not derive behaviour from a single sample. In order:

1. Read the page more carefully: screenshot plus accessibility snapshot, and the
   control's accessible name — not just its visible text.
2. Compare two known states (an account already followed vs. one not followed)
   and diff the controls.
3. Consult official vendor documentation: the X Help Center for following,
   followers and account controls, and X's own product announcements.
4. If official material is thin, use recent, reputable sources (established
   outlets, well-known practitioners) and prefer the most recent.
5. If sources conflict or are stale, treat the live UI as authoritative for
   behaviour, say what remains uncertain, and ask the user before acting.

State explicitly which behaviour you confirmed, and when. A UI assumption older
than the current session is not evidence.

## Step 2 — Confirm the criteria with the user

Never assume the acceptance criteria. Confirm them up front, and re-confirm if
they change mid-run.

Ask for, and restate back:

- **Scope**: how many followers to work through, and whether to start from the
  newest or continue a previous position.
- **"Real person"**: whether project/persona/org-adjacent accounts count.
- **"Actively posting"**: the recency threshold (a default of about 30 days is
  reasonable, agreed explicitly).
- **Exclusions**: marketing/brand/affiliate, adult content, crypto/trading
  promotion, impersonation and parody, giveaways/engagement bait.
- **Character**: what "no racist or bad-character content" means for them —
  political speech alone is not disqualifying; hate, abuse, slurs, and scams are.
- **Edge cases**: whether to follow people the user already follows, and what to
  do about borderline accounts (ask, or decide and report).
- **Protected accounts**: whether to follow back accounts whose posts you cannot
  read. Ask this explicitly and explain the trade-off before they answer:
  - Their posts, replies, and media are invisible until they approve the
    request, so the activity test and the character check in Step 4 cannot be
    run. Any follow is blind.
  - Following one sends a **follow request**. The control reads `Pending`, not
    `Following`, and may stay pending indefinitely. It cannot be verified as a
    follow in this run.
  - Offer three choices: **skip and report** (the recommended default, because it
    preserves research-before-follow), **follow on non-post evidence only**
    (bio, join date, follower ratio, handle, no bait links), or **ask per
    account**. If they are followed and later accept, their posts become
    readable and the follow-up pass can flag anything that would have been
    skipped — never unfollow on your own.
- **Run budget**: how much to attempt in one run — a number of verified follows,
  a wall-clock limit, or both. A Followers tab of several hundred rows cannot be
  exhausted in one session, and X throttles. Default to stopping cleanly at the
  first hard throttle (Step 6) and recording the rest for a later run.

If the user says "use your judgment", still state the rubric you will apply so
they can correct it before you act. Restate the protected-account decision and
the run budget in the same summary.

## Step 3 — Load state, then build the queue

1. **Read the state file before scanning** (location and schema in Step 7). If it
   belongs to this signed-in account and the criteria have not changed
   materially, resume instead of restarting:
   - skip handles already in `processed` — they were researched, decided, or
     attempted in an earlier run. Two exceptions: `unverified` is re-read before
     anything else, and `pending` waits for its `checkOn` date;
   - drain the saved `queue` first, in order, then continue scanning from
     `scannedThrough` rather than from the top;
   - run the follow-up pass before following anyone new (Step 7).
   If the criteria changed materially, rename the old file out of the way and
   start fresh: old verdicts no longer follow the rubric. In every case the live
   UI wins over saved state.
2. Scroll the Followers tab and collect rows whose button reads `Follow back`,
   plus protected rows that read `Follow` but are still in this tab, keyed by
   `@handle`. Record order; it reflects recency.
3. Deduplicate by handle. The list is virtualised: rows unload as they leave the
   viewport, so collect continuously while scrolling rather than at the end.
4. Continuous scrolling often stalls after roughly a hundred rows. Jumping in
   large steps, with a pause at each stop, reliably re-renders the list further
   down; alternate jumps and short scrolls.
5. Keep the queue compact (handles, not whole pages). Very large payloads get
   truncated in transit; prefer a compact string or a slice per call.
6. Treat `Pending` rows as already requested, not as work: record them and move
   on. Re-read a row's button before acting — state can change between
   collection and action, and the label may be stale.
7. Stop collecting at the run budget, or after two consecutive scroll stops that
   add nothing new. Write the state file with the cursor and what is queued, then
   work the queue in order. Finishing the whole list is not a goal; a clean
   hand-off is.

## Step 4 — Research every candidate

Minimum evidence per candidate, gathered from that account's profile:

| Signal | What it tells you |
| --- | --- |
| Bio | identity, role, links, explicit promotion, bait phrasing |
| Join date | freshly created accounts are a risk signal; long history is not proof |
| Followers / following | a few posts and thousands followed back is a follow farm |
| Newest post date | the activation test the user asked for |
| The newest two or three posts | topic, tone, and whether the account is a person |

Judge with common sense, and bias to skipping when evidence is thin: a missed
follow costs nothing, a bot in the follow list costs trust.

**Protected accounts** cannot supply the post evidence: the newest-post date and
the newest two or three posts are simply not readable. Note it as protected with
what you could see (bio, join date, ratio, handle), apply the decision from
Step 2, and never claim the activity or character check was done.
If the user chose to follow on non-post evidence, say plainly in the report that
the judgment was made without reading any posts. A skipped protected account is
recorded as `skipped` with reason `protected`, so later runs do not revisit it.

### Skip patterns (confirmed in practice)

- **Empty shell**: no bio, no posts, no followers, auto-generated handle
  (`Word` + digits) — bots and placeholders.
- **Follow farm**: thousands following, few followers, little original content.
- **Marketing/funnel**: affiliate links, product accounts, agencies, "book a
  call", shops, newsletter-only accounts, "free checklist" lead magnets.
- **Adult bait**: "dms open, try me", "exclusive access", onlyfans-style links,
  explicit bios.
- **Crypto/trading**: ticker spam, "funded account journey", airdrops,
  play-to-earn, "gospel of" any coin.
- **Scam/impersonation**: lottery winners, "my old account was hacked", copied
  names of public figures (including parody accounts of executives), handles that
  do not match the claimed identity.
- **Dormant**: last post measured in months or years.
- **Bad character**: slurs, hate, harassment, or abusive posting patterns.

## Step 5 — Follow, with exact identity matching

The single most important rule: **the control you click must be tied to that
exact handle.**

1. Navigate to the profile and confirm `location.pathname` matches the handle and
   the profile header shows `@handle`.
2. Select the control by accessible name, exactly:
   - `Follow @handle`, or `Follow back @handle`, when not yet following.
   - `Following @handle` or `Unfollow @handle` when already following.
3. Reject any broader match. A prefix match such as "any button starting with
   Follow @" will happily click a suggestion elsewhere on the page and follow a
   stranger.
4. Click through the real input layer (the browser tool's click with a selector
   or ref), not an in-page synthetic `.click()`. Synthetic clicks frequently do
   not reach the app's handlers; when they appear to work, the state often
   updates late and misleads verification.
5. Verify after settling, not instantly. Re-read the same control until it
   changes or the settle window expires (Step 6). The end state depends on the
   account:
   - public account: `Following @handle` / `Unfollow @handle` — a real follow.
   - protected account: `Pending`. That is a successful request, not a follow.
     Record it as pending and never re-click to force `Following`.
   If the label never changes, treat the action as not verified.
6. Some layouts show a confirmation dialog for the inverse operation only; do not
   invent a dialog for following. If an unexpected dialog appears, dismiss it and
   re-check state rather than accepting blindly.

## Step 6 — Settle, verify, and manage rate limits

Two different problems look identical: the UI updating late, and X throttling.
Separate them with time, never with extra clicks.

**The settle window.** After each click, poll the same control at roughly 3, 8,
15, and 30 seconds. A flip that arrives after 15 or 20 seconds is on time, not
evidence of failure.

- Do not click again inside the window. On an account already followed, a second
  click unfollows it; on a pending request it may cancel the request. This is the
  most damaging timing mistake in the whole task.
- Rows lie late as well: a Followers row can still read `Follow back` for a while
  after a successful follow. Confirm on the profile, never by re-clicking the
  stale row.
- Treat a late landing as success and record it — do not "fix" it.

**When the window expires with no change.**

- Call it a miss. Stop following for a few minutes; then re-read the control
  before doing anything, because the click may still land during the pause.
- Retry that account **once** only if it still reads `Follow`/`Follow back`.
- If the retry also misses, end follow activity for this run. Expect a burst of
  roughly three follows, then a cooldown of several minutes; the limit notice may
  never be visible.
- Do not loop, do not retry in a tight cycle, and do not "verify" by clicking
  something else.
- Never work around a limit with another account, another session, or a client.
- If a visible limit notice appears, follow it. Ending the run is the normal
  outcome, not a failure — write state and hand off.

## Step 7 — Persist progress and follow-ups

The Followers tab can be longer than one run can work through, and pending
requests resolve over days. Keep one state file per signed-in account, outside
the repository:

- `~/.x-followback/<handle>.json` on macOS/Linux, or
  `%USERPROFILE%\.x-followback\<handle>.json` on Windows. Drop the leading `@`
  from the filename.
- Never write it inside the skill folder or a repo, never commit it, and keep it
  to handles, verdicts, and dates — no secrets.

```json
{
  "account": "@me",
  "criteria": "recency<=30d; skip marketing/adult/crypto; protected=skip",
  "updated": "2026-11-21T14:05:00Z",
  "scannedThrough": "@last_handle_seen",
  "queue": ["@erin", "@frank"],
  "processed": {
    "@alice": {"state": "followed", "on": "2026-11-21"},
    "@bob": {"state": "skipped", "reason": "empty shell", "on": "2026-11-21"},
    "@carol": {"state": "pending", "on": "2026-11-21", "checkOn": "2026-11-28"},
    "@dave": {"state": "unverified", "on": "2026-11-21"}
  },
  "followUps": [
    {"handle": "@carol", "checkOn": "2026-11-28", "reason": "request pending"}
  ]
}
```

`scannedThrough` is the last handle examined while scrolling; `queue` is the
ordered list of collected handles that have no verdict yet. `state` is one of
`followed`, `already_following`, `skipped`, `pending`, `unverified`, `blocked`.
`unverified` means a click was made and no state change was observed by the end
of the settle window; re-read it next run before doing anything else with that
handle. `blocked` means the account cannot be followed from this account (it
blocks the user, or the control is unavailable); record the reason rather than
retrying.

Writing rules:

- Every `pending` and `unverified` entry also gets a `followUps` entry, so the
  next run cannot forget it.
- Remove a handle from `queue` only when its verdict is written, and append newly
  collected handles in list order. Persisting only the cursor would silently drop
  rows that were collected but not yet processed.
- Write after each batch (about five decisions), at every throttle stop, and
  before ending the run. A crash should cost at most one batch.
- The file is memory, not proof. A saved `followed` never justifies reporting a
  follow; re-read the live control next run.
- A saved `skipped` stays skipped only while the criteria are unchanged. If the
  user tunes the rubric, archive the file and revisit the affected handles.
- New followers appear above the cursor, so still scan the top of the list when
  resuming.
- If the agent cannot write files, build the same structure during the run and
  print it for the user to save. Say plainly that resuming is unavailable.

### Follow-up pass (start of every run)

1. Build the check-in list from two sources: `followUps` whose `checkOn` is
   today or earlier, and every `unverified` entry from an earlier run.
2. Open each profile and read the control after it settles:
   - `Following` / `Unfollow` — the pending request was accepted, or the late
     click landed. Record `followed`, remove the follow-up, and note that posts
     are now readable. For an accepted protected account, offer the research
     check and report anything that would have been skipped; never unfollow on
     your own.
   - `Pending` — still waiting. Push `checkOn` out about seven days and keep it.
     After about a month, stop checking and report it as unresolved; asking
     again is the user's call, not yours.
   - `Follow` / `Follow back`:
     - on a pending request — declined or withdrawn. Record `skipped` with
       reason `request declined`; do not re-request unless asked.
     - on an unverified click — the research is already done, so retry once with
       the settle window. If it misses again, leave it for the next run and end
       follow activity as in Step 6.
3. Report these results separately from new follows from this run.

## Step 8 — Report honestly

- List what was followed, verified in this run, and how it was verified.
- Use four buckets: **newly followed**, **already followed before the run**,
  **requested (pending)**, and **unverified**. The distinctions matter and are
  easy to get wrong.
- List what was skipped, grouped by reason, with a few representative handles.
- List protected accounts separately: skipped or requested, and say that the
  research was limited to non-post evidence.
- Say where the run stopped: roughly how many `Follow back` rows remain, the
  resume point, and the next `followUps` dates.
- State anything unverified, blocked, or left for the user.
- Never claim a follow from an earlier run, a different diff, or an inference.

## Safety rules

- Only the user's own account, and only with the scope they confirmed.
- Never unfollow, never block, never report, never message.
- Never enter credentials; hand off for login, 2FA, captcha, or payment.
- Never follow from suggestions, "who to follow" modules, or search results.
- Never click a follow control twice while its state is unsettled; the second
  click can undo the follow or cancel a request.
- Stop and ask if the account identity, the scope, or the UI behaviour is unclear.

## Done checklist

- [ ] Browser control proven; signed-in account identified.
- [ ] Current button vocabulary observed and named for this run.
- [ ] Criteria confirmed with the user, including recency, exclusions, the
      protected-account decision, and the run budget.
- [ ] State file loaded (or explicitly started fresh); no rework of handles
      already processed.
- [ ] Queue built from follow-back rows only (`Follow back`, or `Follow` on a
      confirmed protected follower), deduplicated, in order; `Pending` rows
      recorded, not queued.
- [ ] Every candidate researched before following, with protected accounts
      marked as limited to non-post evidence.
- [ ] Every public follow matched by exact handle and verified as `Following`
      after the settle window.
- [ ] Every protected follow recorded as `Pending` with a follow-up date; none
      re-clicked to force `Following`.
- [ ] No control clicked twice inside the settle window; no stale row trusted.
- [ ] No unfollows, no strangers, no suggestion-module clicks.
- [ ] State file written (cursor, queue, processed, follow-ups) before handing
      off.
- [ ] Report separates new follows, pre-existing follows, pending requests,
      unverified clicks, and skips with reasons.
