# Twitter group rules

Shared by every X/Twitter skill in this group. This copy is the group's whole
operative rule set; every member carries the same text.

## State line

As soon as the signed-in account is known and before any scanning, give one short
state line: the state file path and what it currently holds — criteria or
interests in force, queue and verdict counts, due follow-ups, and the resume
point. If no file exists, name the path and say the run starts fresh; if writing
is unavailable, say that the run is session-only. Summarize; never dump the file.

## Linked evidence

Whenever the run lists a handle — in the state line, a question, or the report —
link it to `https://x.com/<handle>`, and link every cited post or profile fact to
the page it came from. Use full profile and status permalinks, with the handle or
quote as the link text. Link only pages read this run; never invent a URL. State
files keep handles, not report links.

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

## Access failures

A page that did not load is not evidence. Treat these as access failures: relay
disconnected, tab gone, navigation timeout, DNS or network error; an X error
page, blank shell, or spinner with no content; a title or URL that is not the
requested page; an expired session, login wall, captcha, checkpoint, or
site-wide block.

Stop the task and report the failure; never turn it into a verdict. Mid-run, a
tab that worked and then stops rendering is the same thing: re-read once after a
2–5 second pause to rule out a blip, then stop. Keep the cursor and confirmed
state; do not advance past an unread item. An item whose page never loaded gets
no verdict; if a click was already made and the page then fails, record
`unverified` with a follow-up, because the click may have landed. Say what
failed, where, how many items remain, and the resume point. A profile-level
sensitive-content notice stays `unreadable`; a visible rate-limit notice follows
the throttle rule.

## Persistence fallback

Ask once for permission to write the state path. If the user declines, or the path
cannot be written, say so in the state line and run on session state: hold the
same structure in memory, record each verdict as you go, and print it at every
stop and before the report so the user can verify and save it. Never stop the run
for lack of a state file. Say once that the next run starts fresh and may repeat
work this run already decided; that rework is an accepted cost, not a failure.

## Privacy

State lives outside the skill folder and the repository, one file per signed-in
account. It holds handles, verdicts, dates, and short tags — no credentials, no
full timelines, no bulk personal data. Skill text and examples use fictional
placeholders (`@alice`); a real handle or private detail exists only in that
account's state file, or in the session output the user verifies when writing is
unavailable.
