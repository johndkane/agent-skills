# Follow-back UI vocabulary

Read this when a label, a lock icon, or a layout does not match what the skill
describes. It records the known variants and how to resolve a new one.

## Follow control variants

- `Follow back` — the row's account follows the user and the user does not follow
  them. This is the work queue.
- `Following` — already followed. Nothing to do.
- `Follow` — no follow from the user yet. On a profile page this is the normal
  control for a stranger; on a Followers row, confirm the account is a follower
  and is protected before treating it as a follow-back target.
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
