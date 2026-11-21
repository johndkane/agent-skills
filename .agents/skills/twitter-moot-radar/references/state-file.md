# Moot radar state file

Read this before the first write of a run and whenever resuming. The state path
is in the skill body. This file holds the schema, the verdict vocabulary, and the
writing rules.

## Schema

```json
{
  "account": "@me",
  "interests": {
    "version": 1,
    "areas": ["Rust and systems programming", "PostgreSQL internals"],
    "strictness": "must post about the area",
    "overlapBar": 2,
    "evidenceModes": ["text"]
  },
  "moots": {"@a": {"state": "confirmed", "topic": "compilers", "on": "2026-11-21"}},
  "sources": {"@cand": {"moots": ["@a", "@b"], "firstSeen": "2026-11-21"}},
  "cursor": {"@a": "@last_row_seen"},
  "queue": ["@a", "@b"],
  "verdicts": {
    "@cand": {"state": "suggested", "interest": "Rust and systems programming", "on": "2026-11-21"}
  }
}
```

Verdict states: `suggested`, `dismissed`, `followed`, `pending`, `unverified`,
`already_following`, `skipped` (with reason), `no_evidence`, `unreadable`.
`unreadable` means the profile could not be read at all — typically a
"potentially sensitive content" notice where the page should be. It is not a
judgement and carries no inference; re-read it next run.

## Writing rules

- `moots` and `sources` are interest-independent. When the interests change, keep
  them and re-rank; do not re-harvest the graph unless the user asks.
- `evidenceModes` is the confirmed opt-in set — `text` always, plus any of
  `images`, `video`, `audio`. A change rechecks verdicts that relied on non-text
  evidence; the graph is untouched. An older file without the field means
  `["text"]`.
- `suggested` has a cooldown of about 30 days, unless new moots follow the
  candidate — a new source is new evidence and may justify re-suggesting.
- `dismissed` is permanent unless the user asks to revisit the handle.
- `skipped` and `no_evidence` are rechecked only when the interest profile or the
  source set changes.
- Keep short tags, not quotes. The quote lives in the report with its date and
  permalink; state holds handles, verdicts, dates, and short tags — no emails,
  addresses, or private details.
- A focus account's verdict is recorded like any other, with `"focus": true` on
  its entry. It needs no moot, source, or overlap entry; the next run may re-read
  it when interests change.
- Write after each harvested moot, at every stop, and before ending the run.
- The file is memory, not proof: re-read the control and the profile next run.
- If file write is refused or unavailable, keep the same structure in session
  state, print it at each stop and before the report for the user to verify and
  save, and continue the run. Resuming is then unavailable: say once that the next
  run may repeat work. Never present session state as a saved file.
