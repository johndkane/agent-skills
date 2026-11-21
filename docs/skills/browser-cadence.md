# Human cadence for browser skills

Any skill that drives a browser to navigate, scroll, click, or type runs at a
person's pace. Draw waits and steps from ranges instead of round constants:
identical click rhythms are what rate limiters and readers notice first. This is
pacing, not disguise — it never skips verification, never pads a run past its
budget, and never tries to pass a challenge.

## The ranges

| Action | Draw each wait from |
| --- | --- |
| First read of a page | 1.5–4 s |
| Before clicking a control | 0.8–2.5 s, after moving the pointer there |
| Between candidates | 4–12 s, with a 20–90 s reading pause every 4–6 |
| Scroll tick | 0.6–2 s; step 1–3 viewport heights, varying each time |
| Stop to read rows | 2–6 s, sometimes scrolling back up a little |
| Typing a handle | 80–250 ms per character |

Move to a control in two to four separate moves, pause, then press, and let the
pointer rest afterwards. Open a run with 30–60 s of reading, and break for 2–5
minutes after roughly 40–60 interactions.

## Apply proportionally

- **Readiness first.** Wait for the page or control to exist, then apply the
  minimum dwell. A sleep is never a substitute for checking.
- **Scale with consequence.** Take the upper half of the click range and a hover
  before a state-changing click; passive navigation and re-reads need only the
  minimum.
- **Scale with reading.** Dwell where a person would actually read — profile
  evidence, a list row — not on every scroll tick.
- **Budget includes cadence.** Jittered waits count against the run's wall-clock
  limit; stop when it expires.
- **Verification stays exact.** Settle-window checkpoints may be jittered; the
  maximum window, exact-handle matching, and the retry limit do not move.
- **Challenges stop the run.** A captcha, checkpoint, or "verify it's you"
  prompt goes to the user, never to a workaround.

## Keeping the practice

- This page is canonical. Copy the table into every browser-action skill body;
  skill bodies link only inside their own folder.
- Changing a range updates this page, every browser-action skill, its docs page,
  and its lode entry in the same change.
- For the X family, [`twitter-core.md`](twitter-core.md) mirrors the table and
  adds the settle-window and throttle specifics.
- A new browser-action skill includes a cadence section, these proportional
  rules, and the challenge stop; check that its body uses ranges, not constants.

## Related

- [Skills catalog](README.md)
- [X/Twitter shared core](twitter-core.md)
- [Agent instructions](../agent-instructions.md)
