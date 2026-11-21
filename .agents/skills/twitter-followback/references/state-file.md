# Follow-back state file

Read this before the first write of a run, and again when resuming. The state
path is in the skill body. This file holds the schema, the verdict vocabulary, the
writing rules, and the start-of-run follow-up pass.

## Schema

```json
{
  "account": "@me",
  "criteria": "recency<=30d; skip marketing/adult/crypto; protected=skip",
  "evidenceModes": ["text"],
  "updated": "2026-11-21T14:05:00Z",
  "scannedThrough": "@last_handle_seen",
  "queue": ["@example_erin", "@example_frank"],
  "processed": {
    "@example_alice": {"state": "followed", "on": "2026-11-21"},
    "@example_bob": {"state": "skipped", "reason": "empty shell", "on": "2026-11-21"},
    "@example_carol": {"state": "pending", "on": "2026-11-21", "checkOn": "2026-11-28"},
    "@example_dave": {"state": "unverified", "on": "2026-11-21"}
  },
  "followUps": [
    {"handle": "@example_carol", "checkOn": "2026-11-28", "reason": "request pending"}
  ]
}
```

`scannedThrough` is the last handle examined while scrolling; `queue` is the
ordered list of collected handles that have no verdict yet. `evidenceModes` is the
confirmed opt-in set — `text` always, plus any of `images`, `video`, `audio` — and
a change to it rechecks affected verdicts the way a criteria change does. An older
file without the field means `["text"]`. `state` is one of
`followed`, `already_following`, `skipped`, `pending`, `unverified`, `blocked`,
`unreadable`. `unverified` means a click was made and no state change was
observed by the end of the settle window; re-read it next run before doing
anything else with that handle. `unreadable` means the page could not be read at
all — typically a "potentially sensitive content" notice where the profile should
be. It carries a `reason` and a `followUps` entry and is never a judgement about
the person. Protected accounts keep their own policy instead (`skipped` reason
`protected`, or a `pending` request): that is a decision, not an unread page.
`blocked` means the account cannot be followed from this account (it blocks the
user, or the control is unavailable); record the reason rather than retrying.

## Writing rules

- Every `pending`, `unverified`, and `unreadable` entry also gets a `followUps`
  entry, so the next run cannot forget it.
- Remove a handle from `queue` only when its verdict is written, and append newly
  collected handles in list order. Persisting only the cursor would silently drop
  rows that were collected but not yet processed.
- Write after each batch (about five decisions), at every throttle stop, and
  before ending the run. A crash should cost at most one batch.
- The file is memory, not proof. A saved `followed` never justifies reporting a
  follow; re-read the live control next run.
- Hold only what tracking needs: handle, verdict, dates, reason, and short tags.
  No emails, addresses, credentials, or private details.
- A saved `skipped` stays skipped only while the criteria are unchanged. If the
  user tunes the rubric, archive the file and revisit the affected handles.
- New followers appear above the cursor, so still scan the top of the list when
  resuming.
- If file write is refused or unavailable, keep the same structure in session
  state, print it at each stop and before the report for the user to verify and
  save, and continue the run. Resuming is then unavailable: say once that the next
  run may repeat work. Never present session state as a saved file.

## Follow-up pass (start of every run)

1. Build the check-in list from two sources: `followUps` whose `checkOn` is
   today or earlier, and every `unverified` entry from an earlier run.
2. Open each profile and read the control after the full settle window:
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
       the full settle window. If it misses again, leave it for the next run and
       end follow activity as in the settle-window rules.
   - page unreadable — still a sensitive-content notice, or replaced by
     something that renders no profile. Keep `unreadable`, push `checkOn` out,
     and infer no verdict from what did not render.
3. Report these results separately from new follows from this run.
