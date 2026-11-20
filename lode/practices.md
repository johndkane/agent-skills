# Practices

## One copy, many links

Never duplicate a skill. A host that cannot read `.agents/skills` gets a link,
not a copy.

```text
.agents/skills/<name>/SKILL.md        source
.claude/skills -> ../.agents/skills   link
```

Reason: copies drift, and validation then proves only one copy is correct.

## Default to the minimum wiring

Only `claude` and `copilot` are wired by default. Other hosts read the canonical
tree already, and a second path can surface each skill twice.

```bash
./scripts/link-skills.sh          # claude + copilot
./scripts/link-skills.sh --all    # explicit opt-in
```

## Validate with the reference implementation

Do not judge a skill by eye.

```bash
.venv/bin/skills-ref validate .agents/skills/<name>
```

## Keep the description honest

The description is the only text a host sees before loading a skill. It states
what the skill does, when to use it, and what it is not for. Trigger words go
first because some hosts shorten long descriptions.

## Git writes are opt-in

Agents query Git freely and write to it only on explicit request. A request to
implement something is not a request to commit.

## Keep the scripts in step

`link-skills.sh` and `link-skills.ps1` share behaviour: the same environment
names, defaults, force flag, and placeholder recovery. A change to one is a
change to both.

Related: [layout](layout/summary.md), [skills](skills/summary.md),
[scripts](scripts/summary.md).
