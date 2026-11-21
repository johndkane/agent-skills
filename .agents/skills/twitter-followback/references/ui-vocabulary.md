# Follow-back UI vocabulary

Read this when a label, a lock icon, or a layout does not match what the skill
describes. It records the known variants and how to resolve a new one.

## Follow control variants

- `Follow back` — the row's account follows the user and the user does not follow
  them. This is the work queue.
- `Following` / `Unfollow` — already followed: one state, two labels. X uses
  either name for the same account, across accounts and over time. Neither is
  "stale": both are proof of a follow.
- `Follow` — no follow from the user yet. On a profile page this is the normal
  control for a stranger. On a Followers row it means either a protected
  follower or someone who stopped following the user after the list was built;
  only the lock icon (or the protected signs below) makes it a follow-back
  target. Without that sign it is a stranger — never queued.
- `Subscribe` — the account sells subscriptions; the follow control may be
  reduced to an icon button whose accessible label is `Follow @handle` or
  `Unfollow @handle`.
- `Pending` — a follow request is outstanding. X shows this after requesting to
  follow a protected account. Nothing is followed yet, and it can never be
  verified as `Following` until the owner accepts.

## Protected accounts, before you plan

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
that blocks both the research and the follow verification.

## Interstitials that replace a profile

"Potentially sensitive content" can stand in for the whole profile: a notice
where the header, bio, posts, and follow control should be. The DOM is the
notice, not the account's page.

- It can appear on an account that rendered normally earlier in the run; it is
  a property of the visit, not of the account.
- Nothing rendered means nothing read: `unreadable`, with the reason and the
  follow-up the skill body describes.
- It is not an empty shell, not dormant, and not a skip on merit.
- Re-read once on a later visit; if it still renders, push the follow-up out.

## When the UI does not make sense

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
