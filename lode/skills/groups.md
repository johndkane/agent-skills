# Skill groups

Some skills share behavior and form a group with central files whose names carry
the group. The live instance is [twitter-group](twitter-group.md); the human
index is [`docs/skills/skill-groups.md`](../../docs/skills/skill-groups.md).

## Rules

- Name central files for the group: `<group>-core.md` for the contract and
  `<group>-shared.md` for copy-ready operative rules. A cross-group capability
  page is named for the capability, such as `browser-cadence.md`.
- Add the group to the index before creating its central files.
- Copy `<group>-shared.md` verbatim into every member at
  `references/<group>-shared.md`; the body names it and says when to read it.
  Members never link to a central file outside their own folder. A rule may also
  live in the body when that is the better place; copy it, do not link it.
- Point at the copy with a plain relative path. Never use an include, a symlink to
  a central file, or a pointer to another member: the spec does not define one,
  and a copied folder must work alone.
- One change updates the index, the central files, every copy, each docs page, and
  the lode entry. Never leave a central file ahead of a copy.
- Members may not disagree on group behavior. Settle it centrally, then copy it.
- A central file applies only to its group. If two groups need the same rule, make
  it a capability page or give each group its own named copy.
- Keep group rules specific. Browser control, exact-handle matching, cadence, the
  settle window, throttling, protected accounts, and the `~/.x-<skill>/` state
  shape belong to the X group, not to every skill.

Related: [skills](summary.md), [twitter group](twitter-group.md),
[practices](../practices.md).
