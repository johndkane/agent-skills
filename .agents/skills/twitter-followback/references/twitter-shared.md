# Twitter group rules

Shared by every X/Twitter skill in this group. This copy is the group's whole
operative rule set; every member carries the same text.

## State line

As soon as the signed-in account is known and before any scanning, give one short
state line: the state file path and what it currently holds — criteria or
interests in force, queue and verdict counts, due follow-ups, and the resume
point. If no file exists, name the path and say the run starts fresh; if writing
is unavailable, say that the run is session-only. Summarize; never dump the file.

## Asking the user

Every question a run puts to the user must stand alone: answerable by someone
who has never read this skill. One decision per question — split anything
compound. Each question carries its own context: plain words first, then why
it is being asked and what each answer changes, then a concrete example where
that helps. Translate every term of art inline, label first and meaning
second (`moots` — people who follow you back; `held` — accounts I will never
make suggestions about): the user never decodes skill vocabulary unaided.
Offer a default or "none" answer so nothing is demanded just to move on, and
restate the settled brief in plain language once it is agreed.

Examples come from the user's own world, never from a fixed script. Build
each one from what this run has actually observed about them — the signed-in
profile's bio and pinned post, anything already read this run (a named
account's profile, the settings saved in state), and their own words — and
offer it as something to confirm, never as a fact: "your bio says landscape
photography — is that the kind of subject you mean?" When nothing observed
fits, name the kind of answer wanted ("a tool, project, or field you actually
work with") instead of planting a specific subject the user never mentioned.

If a question cannot meet this, rephrase it before asking.

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

## Multimodal evidence

Text is the default and always-on evidence mode: captions, alt text, and
link-preview text. A screenshot used only to prove browser control is not evidence
and is not read back as one. Text is the portable, reproducible, cheapest path, and
no pixel, frame, or audio payload is read back into the model unless the user opts
in. Image, frame, and transcript matching is less reproducible than text and costs
more tokens, so it is lower-weight and capped.

The user may add one or more modes in the brief:

| Mode | Reads | What it adds |
| --- | --- | --- |
| `images` | still images, screenshots, profile avatar and banner, legible text inside an image | image-only posts and profile-identity signals |
| `video` | a few paused frames from a video or GIF; needs `images` | pictured subject matter in video posts |
| `audio` | a host-produced transcript of a clip, only when the host returns one | spoken words, never tone, accent, or identity |

- Ask once, in the brief, and restate it. A mode is off unless the user turned it on
  for this run. Text stays on in every mode.
- A mode outside this table is allowed only when the host actually returns it, the
  user opts in by name, and it passes the same capability test and caps.
- Gate each enabled mode once per run: screenshot a page whose text you already
  read, request the image content rather than a path, and state one visible detail
  the text does not contain — a colour, layout, or pictured object. For `video`,
  read a paused frame that differs from the poster; for `audio`, quote one word from
  the host's transcript. A path, filename, URL, caption, alt text, poster, or model
  name is not proof of a mode.
- Record each mode as `available` or `unavailable` and report it. A failed or missed
  test turns that mode off for the run, keeps text running, and is stated as
  `unavailable` — never a silent zero and never a guess. The host can change between
  runs, so test every run.
- Read media only where a decision turns on it, never across a whole feed. Cap
  reads at 1 profile image pair per account, 3 media items per candidate, and 12
  non-text reads per run unless the brief sets another cap; a non-text read costs
  several text items and counts against the run budget.
- Describe one short checkable phrase per image or frame: avatar or banner type,
  legible text, watermark, stock or generated look, or the pictured subject, with
  its date and permalink. Never infer race, ethnicity, gender, age, disability,
  health, religion, sexuality, or identity from an image, and never identify a
  person from a photo. A photo is not proof that an account belongs to a real
  person.
- With a mode off or unavailable, non-text content is 0 evidence and the report says
  why. With a mode on and proven, it is lower-weight evidence: it never outranks a
  text match, never carries a high-confidence claim, and an unreadable, blurry, or
  ambiguous image is 0 and noted, never guessed.
- Name the modes and outcome in the state line and the report: `evidence: text`
  (default), `text+images (available)`, or `text+images (unavailable — text-only)`.

## Privacy

State lives outside the skill folder and the repository, one file per signed-in
account. It holds handles, verdicts, dates, and short tags — no credentials, no
full timelines, no saved images, frames, or transcripts, no bulk personal data.
Skill text and examples use fictional placeholders (`@example_alice`); a real handle or
private detail exists only in that account's state file, or in the session output
the user verifies when writing is unavailable.
