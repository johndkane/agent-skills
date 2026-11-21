# Skill groups

Some skills share behavior and central files. A group is deliberate: its files
apply only to its members, and a skill that is not a member does not read or
copy them.

## Naming and copies

- Central files carry the group in the name: `<group>-core.md` for the contract
  and `<group>-shared.md` for copy-ready operative rules.
- A copy lives inside each member, usually `references/<group>-shared.md`, and is
  byte-identical to the central file. A member never links to a central file
  outside its own folder.
- The copy may be a reference file, an artifact, or inline body text. Put it where
  the agent reads at the right time, and keep the text exact.
- Point at the copy with a plain relative path. No include syntax, no symlink to a
  central file, and no pointer to another member's copy: the spec does not define
  one, and a copied folder must work alone.
- A cross-group capability page is named for the capability, not a group, such
  as `browser-cadence.md`.
- Central files are authoring sources. Skills are installed by copying one
  folder, so a member must work with only its own copy.

## Groups

| Group | Members | Central files | Copies |
| --- | --- | --- | --- |
| twitter | [`twitter-followback`](twitter-followback.md), [`twitter-moot-radar`](twitter-moot-radar.md) | [`twitter-core.md`](twitter-core.md) (contract), [`twitter-shared.md`](twitter-shared.md) (operative rules) | `references/twitter-shared.md` in each member |

## Cross-group pages

| Page | Applies to | Why not a group file |
| --- | --- | --- |
| [`browser-cadence.md`](browser-cadence.md) | Every browser-driven skill | The capability spans groups, so the name is the capability |

## Adding a group

1. Add a row to the table above before creating any central file.
2. Write `<group>-core.md` for the contract and `<group>-shared.md` for the
   rules that every member must carry.
3. Copy the shared file into each member at `references/<group>-shared.md`.
4. Point each member's body at its copy and say when to read it.
5. Update the catalog rows, the lode entry, and `skill-verify`'s group check.

A central file that names one group must never be copied into another group.
When two groups need the same rule, make it a capability page or give each group
its own copy with its own name.
