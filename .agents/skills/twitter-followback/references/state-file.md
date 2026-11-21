# Follow-back state file

Read this before the first write of a run, and again when resuming. It holds the
schema, the verdict vocabulary, the writing rules, and the start-of-run follow-up
pass.

## Location

One file per signed-in account, outside the repository:

- `~/.x-followback/<handle>.json` on macOS/Linux, or
  `%USERPROFILE%\.x-followback\<handle>.json` on Windows. Drop the leading `@`
  from the filename.
- Never write it inside the skill folder or a repo, never commit it, and keep it
  to handles, verdicts, and dates — no secrets.

## Schema

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

## Writing rules

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

## Follow-up pass (start of every run)

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
       follow activity as in the settle-window rules.
3. Report these results separately from new follows from this run.
