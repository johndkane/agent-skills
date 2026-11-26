# deadpan-reductive-observation

Turns an ordinary observation into one concise, deadpan, reductive one-liner —
the kind that feels obvious in retrospect:

> a video meeting is just six people watching one person discover the mute button

Instead of adding a punchline, it strips the subject's usual framing away and
says what people are actually doing.

Install by copying the `deadpan-reductive-observation` folder into the skills
directory your host reads; the `SKILL.md` inside it is the whole skill. This
page explains it and is not part of the install.

## When it triggers

- "turn this into a one-liner" or "make this deadpan"
- "give me a funny version of this observation"
- "rewrite this as a social post" in the dry, understated style
- "give me alternatives" or "make it more topical" — the researched mode

It is not for setup/punchline comedy, puns, meme phrasing, or marketing copy:
the humor comes from the accuracy of the reduction, never from a labeled joke.

## What it does

| Mode | What happens |
| --- | --- |
| Rewrite (default) | Reduces the supplied observation to one confident, deadpan sentence: the underlying behavior, contradiction, or ritual, stripped of its conventional framing. Returns only the line. |
| Alternatives (on request) | Researches the subject — habits, frustrations, terminology, current references — then generates several genuinely different angles, strongest straightforward reduction first. |

Every line passes the same bar: recognizably true, concrete rather than
abstract, understated, with nothing removable — sounding observed rather than
written, and never explained.

## Requirements

| Need | Why |
| --- | --- |
| A capable model | The default rewrite needs no tools at all |
| Web search (optional) | Serves the researched alternatives mode |

No browser, no account, no runtime state: nothing about you or your data is
read or stored anywhere.

## Safety

- It only writes text in the conversation. It never posts, sends, or acts
  anywhere.
- Research favors primary or credible current sources; it never invents facts
  for the sake of humor, and it avoids obscure references unless they
  materially improve the line.

## Related

- [User guide](README.md) — choose a skill and what it needs
- [Invoking skills](invoking.md) — how to call it in your host
- [Skills reference](../skills/README.md) — the catalog rules behind every skill
