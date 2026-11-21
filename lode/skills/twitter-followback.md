# twitter-followback

The catalog's browser-driven skill. It follows back real people on X and keeps
its own run state between sessions. Instructions live in the skill's own
`SKILL.md` (this checkout: [`twitter-followback/SKILL.md`](../../.agents/skills/twitter-followback/SKILL.md));
human page:
[`docs/skills/twitter-followback.md`](../../docs/skills/twitter-followback.md).

## Invariants

1. Research before every follow; nothing is followed because it appeared in a
   list.
2. Verify after the settle window, never inside it. Checkpoints run through
   ~30 seconds, then re-reads near 60 and 120 seconds; a flip near two minutes is
   on time. A second click can unfollow or cancel a request.
3. `Following` and `Unfollow` are the same followed state; either label proves
   it, matched by the exact handle.
4. A protected account ends at `Pending`, never `Following`.
5. The queue is `Follow back` rows plus `Follow` on a confirmed protected
   follower. `Follow` without that marker is a stranger: never queued.
6. The live UI wins over saved state; a saved `followed` is not proof.
7. State lives outside the repository, one file per signed-in account.
8. Never unfollow, block, report, or message.
9. A page that rendered a notice instead of a profile — a "potentially sensitive
   content" interstitial — is recorded `unreadable`, never inferred from.
10. Cadence jitter changes timing only, never verification or the challenge
    handoff.

## Cadence

Timing is drawn from ranges, never fixed constants, so the run does not read as a
metronome. The ranges are canonical in
[`docs/skills/twitter-core.md`](../../docs/skills/twitter-core.md); `SKILL.md`
restates them so a copied skill still works alone.

```text
wait(uniform(1.5, 4.0))                   # first read of a page
move_to(control, moves=randint(2, 4)); wait(uniform(0.8, 2.5))
click(control)
poll(control, [2-4, 7-9, 14-16, 28-30])   # inside the settle window
reread(control, [60, 120])                # before calling a miss
wait(uniform(4, 12))                      # before the next candidate
```

```mermaid
flowchart LR
    A[Read page] --> B[Move + hover]
    B --> C[Click once]
    C --> D[Settle window]
    D --> E[Jittered pause]
    E --> A
```

Jitter changes timing only. One click per control, the full settle window, the
retry-once rule, and the challenge handoff stay exact. A captcha, checkpoint, or
"verify it's you" prompt ends the run; pacing is not evasion.

## Run loop

```mermaid
flowchart TD
    A[Load state] --> B{Due follow-ups, unverified, or unreadable?}
    B -- yes --> C[Check profiles, settle, record]
    B -- no --> D[Scan Followers from cursor]
    C --> D
    D --> E[Research candidates]
    E --> F[Follow with exact handle match]
    F --> G{Label after settle window}
    G -- Following / Unfollow --> H[Record followed]
    G -- Pending --> I[Record pending + follow-up date]
    G -- unchanged after ~2 min --> J[Throttled: pause, retry once, else stop]
    H --> K[Write state]
    I --> K
    J --> K
```

## State file

```text
~/.x-followback/<handle>.json
%USERPROFILE%\.x-followback\<handle>.json   (Windows)
```

The schema, writing rules, and follow-up pass are the skill's
[`references/state-file.md`](../../.agents/skills/twitter-followback/references/state-file.md);
that file is authoritative and the body names it.

States: `followed`, `already_following`, `skipped`, `pending`, `unverified`,
`blocked`, `unreadable`. `pending` is an outstanding follow request;
`unverified` is a click whose state change was never observed; `unreadable` is a
page that rendered a notice instead of a profile and carries a reason, not a
judgement. Protected accounts keep their own policy (`skipped` or `pending`).
Every pending, unverified, or unreadable entry also gets a `followUps` entry.
`queue` holds collected handles that have no verdict; the cursor alone would drop
them.

## Why a state file

- The Followers list is virtualised and can hold hundreds of rows; it keeps
  paging, so one run cannot exhaust it.
- X throttles after a short burst and the UI updates late, so runs end mid-queue.
- Follow requests resolve over days, if at all.

Without it, every run re-researches the same handles and may re-follow accounts
whose button simply had not updated.

## Why it is not in the repo

The state file is runtime data of the user's machine, not part of the skill.
Keeping it outside preserves the droppable-repository rule in
[AGENTS.md](../../AGENTS.md): no build step, no generated artifacts, no secrets.

Related: [skills summary](summary.md), [practices](../practices.md),
[terminology](../terminology.md).
