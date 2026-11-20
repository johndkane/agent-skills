---
name: twitter-followback
description: >-
  Research and follow back legitimate followers on X (Twitter) — real people who
  are actively posting, with bots, marketing, adult, crypto and impersonation
  accounts filtered out, and every follow verified in the UI. Use when asked to
  follow back followers, clean up a follow-back queue, or judge which followers
  are worth following back. Not for mass-following, growth hacking, or unfollowing.
compatibility: >-
  Needs an agent with interactive browser control and a browser session already
  signed in to X. Must run locally on the user's machine; cloud, sandboxed, or
  headless sessions without browser access cannot complete it.
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
2. **Only act on "Follow back" rows.** On the Followers tab, a row that says
   `Following` is already done; touching it is noise at best, damage at worst.
3. **Never unfollow.** Unfollowing is a different operation with different
   intent. If the user asks for it, that is a separate, explicitly confirmed task.
4. **Never follow a stranger.** Accounts suggested by the page ("You might like",
   "Who to follow") are not followers. Following one is always a mistake, even
   if the account looks good.
5. **Verify, then claim.** A follow is done only when the control this action
   targeted reads `Following`/`Unfollow` for that exact handle. Report only what
   was verified in this run.
6. **Silence is a signal.** If a click produces no state change, something is
   throttled or blocked. Slow down; do not click harder.
7. **Respect the user's judgment calls.** Borderline accounts are theirs to
   decide. When asking, bring the evidence, not just the handle.

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
   - `Follow` — the account does not follow the user. Not a follow-back target;
     on a profile page this is the normal follow control for a stranger.
   - `Subscribe` — the account sells subscriptions; the follow control may be
     reduced to an icon button whose accessible label is `Follow @handle` or
     `Unfollow @handle`.
4. **Check the row anatomy.** Followers rows typically carry the display name,
   the `@handle`, a "Follows you" marker, the action button, and a bio excerpt.
   Confirm where the handle and the button sit so a later click can be tied to
   the right row.
5. **Record the findings for the run.** If a label or layout does not match
   anything here, resolve it before acting — see the next section.

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

If the user says "use your judgment", still state the rubric you will apply so
they can correct it before you act.

## Step 3 — Build the queue (only rows you must act on)

1. Scroll the Followers tab and collect rows whose button reads `Follow back`,
   keyed by `@handle`. Record order; it reflects recency.
2. Deduplicate by handle. The list is virtualised: rows unload as they leave the
   viewport, so collect continuously while scrolling rather than at the end.
3. Continuous scrolling often stalls after roughly a hundred rows. Jumping in
   large steps, with a pause at each stop, reliably re-renders the list further
   down; alternate jumps and short scrolls.
4. Keep the queue compact (handles, not whole pages). Very large payloads get
   truncated in transit; prefer a compact string or a slice per call.
5. Re-read a row's button before acting: state can change between collection and
   action.

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
5. Verify immediately: the same control now reads `Following @handle` (or
   `Unfollow @handle`). If it does not, treat it as not followed.
6. Some layouts show a confirmation dialog for the inverse operation only; do not
   invent a dialog for following. If an unexpected dialog appears, dismiss it and
   re-check state rather than accepting blindly.

## Step 6 — Manage rate limits

X throttles follows quickly and silently.

- Expect a burst of roughly three follows, then a cooldown of several minutes.
- The symptom is a click with no state change — not an error message, and the
  notice may never be visible.
- On the first miss: stop, wait a few minutes, retry that account **once**.
- If it fails again, wait longer. Do not loop, do not retry in a tight cycle, and
  do not "verify" by clicking something else.
- Never work around a limit with another account, another session, or a client.
- If a limit notice is visible, follow it; scale back rather than stopping unless
  the user says otherwise.

## Step 7 — Report honestly

- List what was followed, verified in this run, and how it was verified.
- Separate **newly followed by you** from **already followed before the run** —
  the distinction matters and is easy to get wrong.
- List what was skipped, grouped by reason, with a few representative handles.
- State anything unverified, blocked, or left for the user.
- Never claim a follow from an earlier run, a different diff, or an inference.

## Safety rules

- Only the user's own account, and only with the scope they confirmed.
- Never unfollow, never block, never report, never message.
- Never enter credentials; hand off for login, 2FA, captcha, or payment.
- Never follow from suggestions, "who to follow" modules, or search results.
- Stop and ask if the account identity, the scope, or the UI behaviour is unclear.

## Done checklist

- [ ] Browser control proven; signed-in account identified.
- [ ] Current button vocabulary observed and named for this run.
- [ ] Criteria confirmed with the user, including recency and exclusions.
- [ ] Queue built from `Follow back` rows only, deduplicated, in order.
- [ ] Every candidate researched before following.
- [ ] Every follow matched by exact handle and verified as `Following`.
- [ ] No unfollows, no strangers, no suggestion-module clicks.
- [ ] Report separates new follows, pre-existing follows, and skips with reasons.
