# Compatibility state file

Read this before the first write of a run and whenever resuming. The path is in the
skill body: `~/.x-compatibility/<handle>.json`, or
`%USERPROFILE%\.x-compatibility\<handle>.json` on Windows, with the `@` dropped.

One file per signed-in account. This file is memory, not evidence: the live profile
wins, and a saved score is never reported as current.

## Schema

```json
{
  "account": "@me",
  "scope": "all",
  "focus": [],
  "rubric": {
    "version": 1,
    "updated": "2026-11-21",
    "mode": "reply-first",
    "windowDays": 30,
    "cardFloor": 55,
    "evidenceModes": ["text"],
    "areas": [
      {
        "name": "Rust and systems programming",
        "terms": ["rust", "borrow checker", "async runtime", "unsafe"],
        "weight": 3,
        "visual": false
      },
      {
        "name": "PostgreSQL internals",
        "terms": ["postgres", "mvcc", "vacuum", "btree"],
        "weight": 2,
        "visual": false
      }
    ],
    "weights": {
      "subject": 40,
      "conversation": 25,
      "format": 15,
      "voice": 10,
      "recency": 5,
      "access": 5
    },
    "exclusions": []
  },
  "source": {
    "readOn": "2026-11-21",
    "tabs": {"posts": 38, "replies": 24, "media": 12, "likes": 0},
    "metrics": {
      "items": 74,
      "medianLength": 130,
      "questionRate": 0.18,
      "firstPersonRate": 0.45,
      "emojiRate": 0.05,
      "formats": {"text": 0.5, "image": 0.2, "video": 0.05, "link": 0.2, "thread": 0.05}
    }
  },
  "targets": {
    "@example_alice": {
      "status": "scored",
      "category": "moot",
      "scoredOn": "2026-11-21",
      "rubricVersion": 1,
      "score": 75,
      "band": "Good",
      "confidence": "high",
      "components": {
        "subject": 72,
        "conversation": 66,
        "format": 85,
        "voice": 88,
        "recency": 100,
        "access": 60
      },
      "areas": {
        "Rust and systems programming": {"score": 92, "matched": 4},
        "PostgreSQL internals": {"score": 42, "matched": 2}
      },
      "evidence": {
        "items": 38,
        "matched": 6,
        "posts": 30,
        "replies": 4,
        "reposts": 2,
        "media": 2,
        "questions": 6,
        "threads": 2,
        "quotes": 1,
        "nonText": 0
      },
      "relationship": {"followsYou": true, "repliedToYou": false, "protected": false},
      "gap": "little PostgreSQL in the window",
      "checkOn": "2026-12-05"
    }
  },
  "queue": [
    {"handle": "@example_bob", "category": "following-only"},
    {"handle": "@example_carol", "category": "followers-only"}
  ],
  "hidden": {
    "@example_dave": {"reason": "user asked to skip", "on": "2026-11-21"}
  },
  "followUps": [
    {"handle": "@example_alice", "why": "re-read after the rubric change", "on": "2026-11-22"}
  ]
}
```

## Fields

- `scope` — the current population filter: `focus`, `moots`, `following-only`,
  `followers-only`, or `all`. It selects which accounts are reported; it is not part
  of the rubric, and changing it does not invalidate scores. `focus` is driven by the
  `focus` list.
- `focus` — the handles the user named for a focus run, lowercase with `@`. Empty
  or absent outside a focus run, and an older file without it means no named focus
  handles. A focus target needs no list membership and no follow-back; its
  category may be `not-associated`.
- `rubric` — the measuring instrument. `areas` and their `terms` are frozen once
  confirmed; `visual` marks an area whose primary evidence may be images or frames;
  `weights` is the normalized component set the user approved; `evidenceModes` is
  the opt-in set — `text` plus any of `images`, `video`, `audio`. Any change bumps
  `version` and `updated`. A legacy `visualEvidence` value maps `off` to
  `["text"]` and `on` to `["text","images"]`, a legacy `evidence.visual` count maps
  to `nonText`, and the rename bumps `version`.
- `source` — aggregates only, refreshed every run. Never keep source post text,
  quotes, or permalinks here.
- `targets` — one entry per handle ever scored, keyed by lowercase handle with `@`.
  `category` is `moot`, `following-only`, `followers-only`, or `not-associated`;
  `areas` holds the
  per-area score and matched count; `evidence` holds the counts the card shows,
  including `nonText`; `gap` is a short tag, not a quote.
- `queue` — handles and categories the user chose but this run did not reach.
- `hidden` — permanent until the user asks to revisit.
- `followUps` — dated re-reads for stale, unverified, or changed items.

## Status and staleness

| Status | Meaning |
| --- | --- |
| `scored` | Current rubric, read within 14 days |
| `stale` | Older than 14 days, or a different `rubricVersion` |
| `insufficient` | Fewer than five readable items; no score |
| `unreadable` | Profile or posts did not render; no score, no inference |
| `hidden` | User asked to skip this handle |
| `excluded` | Matched a named exclusion |

A `scored` entry is a cache for queue decisions, not a report source: a target that
appears in a report is read in that run.

- A stale score may be shown only as `previous` with its date and rubric version;
  it is never ranked with current scores.
- Changing `scope` alone does not invalidate a score. It changes which accounts are
  reported; a target outside the scope keeps its entry and is not ranked this run.
- Re-read `insufficient` and `unreadable` on the next run; a wider window or a
  changed lexicon may change the first, and the second is often transient.
- `hidden` and `excluded` persist until the user asks to change them.
- Changing an area name, term, weight, component weight, mode, window, evidence
  mode, or a `visual` area flag is a new rubric. Bump the version, mark every target
  stale, and re-score before reporting.

## Writing rules

- Write after each target, at every stop, and before the run ends.
- Keep handles, scores, counts, dates, short tags, and the lexicon. No post text,
  quotes, permalinks, full timelines, emails, or private details.
- The file is the only place a real handle is written; skill text and examples use
  placeholders such as `@example_alice` and `@me`.
- Ask once for permission to write the path. If the user declines or the path cannot
  be written, say so in the state line, keep the same structure in session state,
  print it at every stop and before the report for the user to verify, and
  continue. The next run then starts fresh and may repeat work; that is an accepted
  cost, never a reason to stop.
- Never present session state as a saved file.

## State line

```text
State: ~/.x-compatibility/<handle>.json — scope moots, evidence text, rubric v1
(Rust ×3, Postgres ×2; reply-first), 12 scored, 2 stale, last write 2026-11-21.
```

A focus run names the handles instead, for example `scope focus (@example_alice, @example_bob)`;
`category not-associated` is shown there as context, not as a warning.

No file: name the path and say the run starts fresh. Writing unavailable: say
`session-only` and print the structure for verification.
