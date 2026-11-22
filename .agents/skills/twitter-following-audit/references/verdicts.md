# Verdict rules

Read before the first verdict and when resuming. One verdict per account, with
one reason tag. A verdict is a suggestion the user applies; this skill never
performs it.

## The verdicts

| Verdict | Means | The user's action |
| --- | --- | --- |
| `keep` | The connection still earns its place | none |
| `unfollow` | The connection does not earn its place right now | Unfollow |
| `mute` | Stay connected; stop seeing the posts | Mute |
| `block` | Safety: stop all contact from this account | Block (also unfollows) |
| `recheck` | Not now; look again on a date | none; a dated follow-up |

## Inputs

- **Alignment** — at least one item in the window matching a frozen signal
  term for a named area, or under `adjacent` strictness a closely related
  item. A matched item proves alignment; a repost alone never does.
- **Tie** — one of: moot (`Follows you` on a followed profile), replied to the
  user within the window when seen in the sample, or a named tie the user
  recorded. A tie is a profile fact or the user's word, never inferred.
- **Activity** — the newest post date against the windows: `active` (newer
  than the active window), `dormant` (older, within the dormant window),
  `long-dormant` (older than the dormant window).
- **Feed fit** — counts from the sample: `volume` when more than about 50
  items in 7 days; `repost-heavy` when more than half the sample is reposts.
- **Safety evidence** — quoted, dated, profile-level: bot or follow-farm
  patterns, scams or fraud, harassment toward the user, impersonation.

## Reason tags

| Tag | Says |
| --- | --- |
| `inactive` | No post inside the active window |
| `focus-moved` | State shows a prior `keep` with a matched item; this run finds none and the bio no longer connects to the areas |
| `outside-interests` | No matched item and no matched history; the bio or content sits outside the areas |
| `volume` | High-volume poster crowding the feed |
| `repost-heavy` | Mostly reposts; little original content |
| `disagreement` | Recorded only when the user names it; never inferred from content |
| `safety` | Quoted safety evidence; block only |

A keep carries no reason tag; it carries a fit line instead — the matched area
or the tie.

## Decision table

| Alignment | Tie | Activity | Verdict | Reason tag |
| --- | --- | --- | --- | --- |
| yes | any | any | `keep` | — |
| no | yes | active | `mute` | `outside-interests` |
| no | yes | dormant | `recheck` | `inactive` |
| no | no | active | `unfollow` | `outside-interests` |
| no | no | dormant | `recheck` | `inactive` |
| no | no | long-dormant | `recheck` default; `unfollow` at the user's call | `inactive` |
| feed-fit problem | yes | active | `mute` | `volume` / `repost-heavy` |
| feed-fit problem | no | active | `mute` or `unfollow` at the user's call | `volume` / `repost-heavy` |
| safety evidence | any | any | `block`, confirmed with the user | `safety` |
| prior matched history, now none | any | active | `recheck` | `focus-moved` |
| user names a disagreement | any | any | `unfollow` or `mute` at the user's call | `disagreement` |

Where the table offers the user's call, present the optimistic verdict first
(the one that keeps the connection), name the other in one line, and let the
user pick. Until the user picks, record the optimistic one.

## Evidence bars

- `keep` — none. Thin, insufficient, or unreadable evidence lands keep-noted
  or recheck, never a negative verdict.
- `unfollow` — all of: no alignment, no tie, and dormancy beyond the dormant
  window when inactive; plus one dated fact — the newest post date outside the
  window, or a window with zero matched items and a bio outside the areas.
- `mute` — a tie plus a feed-fit or alignment reason, quoted where
  content-based.
- `block` — quoted, dated safety evidence for every claim, confirmed with the
  user before it enters the report; the card notes that block also unfollows.
- `recheck` — one dated fact: the newest post inside the dormant window, or
  thin evidence with a positive bio. Sets the follow-up at the recheck gap.

Confidence comes from the sample: `high` at 8 or more readable items, `medium`
at 3–7, `low` below 3. Non-text-only matches cap at `medium`, per the shared
gate. Confidence sits beside a verdict and never flips one.

## Optimism wording

- Lead with what the account gives or gave: the matched area, the tie, the
  history from state.
- Describe what changed, not what is wrong — "their posts now center on
  gardening; your areas are Rust and Postgres" (a pattern to copy with the
  user's actual areas, never these sample words) — never "bad content".
- Unfollow is "not now": it is private and reversible, X does not notify, and
  the card names what would return the account to keep — posting in an area,
  becoming active again.
- A recheck is a plan, not a demotion.
- No adjectives about people. Quote, date, tag.
