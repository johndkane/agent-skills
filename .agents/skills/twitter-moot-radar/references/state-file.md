# Moot radar state file

Read this before the first write of a run and whenever resuming. It holds the
schema, the verdict vocabulary, and the writing rules.

## Location

One file per signed-in account, outside the repository:

```text
~/.x-moot-radar/<handle>.json
%USERPROFILE%\.x-moot-radar\<handle>.json   (Windows)
```

## Schema

```json
{
  "account": "@me",
  "interests": {
    "version": 1,
    "areas": ["Rust and systems programming", "PostgreSQL internals"],
    "strictness": "must post about the area",
    "overlapBar": 2
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
`already_following`, `skipped` (with reason), `no_evidence`.

## Writing rules

- `moots` and `sources` are interest-independent. When the interests change, keep
  them and re-rank; do not re-harvest the graph unless the user asks.
- `suggested` has a cooldown of about 30 days, unless new moots follow the
  candidate — a new source is new evidence and may justify re-suggesting.
- `dismissed` is permanent unless the user asks to revisit the handle.
- `skipped` and `no_evidence` are rechecked only when the interest profile or the
  source set changes.
- Keep short tags, not quotes. The quote lives in the report with its date and
  permalink; state holds handles, verdicts, and dates.
- Write after each harvested moot, at every stop, and before ending the run.
- The file is memory, not proof: re-read the control and the profile next run.
- If the agent cannot write files, build the same structure and print it for the
  user to save. Say that resuming is unavailable.
