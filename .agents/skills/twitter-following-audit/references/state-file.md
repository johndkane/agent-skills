# Following-audit state file

Read this before the first write of a run and whenever resuming. The path is in
the skill body: `~/.x-following-audit/<handle>.json`, or
`%USERPROFILE%\.x-following-audit\<handle>.json` on Windows, with the `@`
dropped.

One file per signed-in account. This file is memory, not evidence: the live
profile wins, and a saved verdict is never reported as current.

## Schema

```json
{
  "account": "@me",
  "scope": "unreviewed",
  "focus": [],
  "audit": {
    "version": 1,
    "updated": "2026-11-21",
    "strictness": "must-post",
    "activeWindowDays": 90,
    "dormantWindowDays": 365,
    "recheckDays": 90,
    "evidenceModes": ["text"],
    "areas": [
      {
        "name": "Rust and systems programming",
        "terms": ["rust", "borrow checker", "async runtime"],
        "weight": 3
      },
      {
        "name": "PostgreSQL internals",
        "terms": ["postgres", "mvcc", "vacuum"],
        "weight": 2
      }
    ],
    "held": [{"handle": "@example_dana", "reason": "close friend"}],
    "ties": [{"handle": "@example_alice", "note": "coworker"}]
  },
  "cursor": {"rowsRead": 340, "lastHandle": "@example_bob"},
  "follows": {
    "@example_alice": {
      "status": "audited",
      "auditedOn": "2026-11-21",
      "auditVersion": 1,
      "category": "moot",
      "verdict": "keep",
      "reason": null,
      "confidence": "high",
      "lastPostOn": "2026-11-18",
      "itemsRead": 12,
      "matchedItems": 2,
      "repostShare": 0.1,
      "followsYou": true,
      "repliedToYou": false,
      "note": "posts Rust weekly"
    },
    "@example_bob": {
      "status": "audited",
      "auditedOn": "2026-11-21",
      "auditVersion": 1,
      "category": "following-only",
      "verdict": "recheck",
      "reason": "inactive",
      "confidence": "medium",
      "lastPostOn": "2026-06-30",
      "itemsRead": 5,
      "matchedItems": 0,
      "repostShare": 0.4,
      "followsYou": false,
      "repliedToYou": false,
      "note": null
    },
    "@example_carol": {
      "status": "flagged",
      "auditedOn": "2026-11-21",
      "auditVersion": 1,
      "category": "following-only",
      "verdict": null,
      "flagReason": "impersonation",
      "confidence": "high",
      "lastPostOn": "2026-11-19",
      "itemsRead": 9,
      "matchedItems": 0,
      "repostShare": 0.1,
      "followsYou": false,
      "repliedToYou": false,
      "note": null
    }
  },
  "queue": [{"handle": "@example_erin"}],
  "followUps": [
    {"handle": "@example_bob", "why": "recheck: quiet since June", "on": "2027-02-19"}
  ]
}
```

## Fields

- `scope` — the current population: `focus`, `unreviewed`, `stale`, or `all`.
  It changes who is audited, not how; changing it never invalidates a verdict.
  `focus` is driven by the `focus` list.
- `focus` — the handles the user named for a focus run, lowercase with `@`. A
  focus target is audited whatever its relationship; not being followed is
  context, not a gate.
- `audit` — the measuring instrument. `areas` and their `terms` are frozen once
  confirmed; `strictness` is `must-post` or `adjacent`; `evidenceModes` is
  `text` plus any opt-in mode; `held` handles never receive a verdict; `ties`
  records user-named relationships. Any change to an area, term, strictness,
  window, or evidence mode bumps `version` and marks every verdict stale.
- `cursor` — Following-list progress for `all` and `unreviewed` runs: rows read
  and the last handle seen. Cleared for a focus run.
- `follows` — one entry per followed handle ever audited, keyed by lowercase
  handle with `@`. `category` is `moot` or `following-only`. `verdict` is
  `keep`, `unfollow`, `mute`, or `recheck` — null for flagged accounts, whose
  `flagReason` (`bot`, `scam`, `harassment`, `impersonation`) and quoted
  evidence stand instead of a verdict. `reason` is a tag from verdicts.md or
  null. `note` is a short tag of at most 60 characters, never a quote.
- `queue` — handles in scope the run did not reach.
- `followUps` — dated rechecks and other follow-ups.

## Status

| Status | Meaning |
| --- | --- |
| `audited` | Current audit version, read within 90 days, verdict assigned |
| `flagged` | Quoted safety evidence on file; no feed verdict; re-audit only at the user's ask |
| `stale` | Older than 90 days, or a different `auditVersion` |
| `unreadable` | Protected or notice-replaced page; nothing inferred |
| `held` | User-held; never receives a verdict |

- A stale verdict may be shown only as `previous` with its date and version;
  it is never merged into a current verdict.
- `unreadable` is retried next run; it is often transient.
- Changing only `scope` or the batch never invalidates a verdict.
- An override keeps the final verdict the user chose, with the user's word for
  why recorded in `note`.

## Writing rules

- Write after each account, at every stop, and before the run ends.
- Keep handles, verdicts, reason tags, counts, dates, and short tags. No post
  text, quotes, permalinks, images, or private details.
- The file is the only place a real handle is written; skill text and examples
  use placeholders such as `@example_alice` and `@me`.
- Ask once for permission to write the path. If the user declines or the path
  cannot be written, say so in the state line, keep the same structure in
  session state, print it at every stop and before the report for the user to
  verify, and continue. The next run starts fresh and may repeat work; that is
  an accepted cost, never a reason to stop.
- Never present session state as a saved file.

## State line

```text
State: ~/.x-following-audit/<handle>.json — scope unreviewed, evidence text,
audit v1 (Rust ×3, Postgres ×2; active 90d, dormant 365d), 34 audited, 2 stale,
1 recheck due, last write 2026-11-21.
```

A focus run names the handles instead, for example
`scope focus (@example_alice, @example_bob)`. No file: name the path and say
the run starts fresh. Writing unavailable: say `session-only` and print the
structure for verification.
