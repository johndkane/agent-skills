# resolve-worktree-to-primary

The worktree-finishing skill for Git repositories. When your work in a linked
worktree is done, it integrates that branch into the branch your repository's
primary worktree has checked out — choosing the right strategy, resolving any
merge conflicts by intent — then proves the integration and cleans up the
worktree and its branch.

Install by copying the `resolve-worktree-to-primary` folder into the skills
directory your host reads; the `SKILL.md` inside it is the whole skill. This
page explains it and is not part of the install.

## When it triggers

- "resolve this worktree", "finish the worktree", "wrap up this worktree"
- "merge this worktree back into main", "fold this back into the primary branch"
- "integrate this branch and clean up the worktree"
- "return this worktree to the primary repository"

"Primary branch" here means the branch checked out in Git's primary worktree —
the first entry of `git worktree list` — whatever it is named. It is not for
creating worktrees, merging branches that share one worktree, or pushing to a
remote.

## What it does

| Rule | What it enforces |
| --- | --- |
| Discover, never assume | Every path, worktree, and branch name comes from Git (`git worktree list --porcelain`, `git branch --show-current`). It never guesses `main` or `master`. |
| Finish the source first | Remaining changes in the worktree are reviewed, committed, and the tree left clean before any integration. |
| Primary stays untouched | Uncommitted changes in the primary worktree are never stashed, committed, or reset — the run stops instead. |
| Strategy from evidence | Fast-forward, squash, rebase-then-FF, or merge commit is chosen from documented policy, commit-history quality, whether the branch is shared, and divergence — then reported with the reason. |
| Conflicts resolved by intent | Both sides' intents are reconstructed from history and context; both aspects are integrated, superseding work defines the shape, and nothing vanishes silently. Mechanical side-picking is out. |
| Integrate, verify, clean up last | Validation runs from the primary after the merge; the worktree is removed and the branch deleted only after integration is proven. |
| No destructive shortcuts | No `reset --hard`, `clean -fd`, forced worktree removal, or forced branch deletion in normal operation; shared history is never rewritten; nothing is pushed unless you ask. |
| Asks at real forks | Obvious choices proceed and are reported; an unclear source, detached HEAD, or an equivocal strategy assessment stops for your confirmation before any Git change. |

## Requirements

| Need | Why |
| --- | --- |
| Git on PATH | It discovers everything from Git and runs the integration |
| Shell access | It works across the linked and primary worktrees |

No browser, no network, no account. It never pushes; remote branches are
deleted only if you explicitly ask.

## Safety

- Your work is preserved: uncommitted changes anywhere stop the run rather than
  being discarded, and unrelated changes are never committed just to get a
  clean tree.
- Cleanup is gated: nothing is removed or deleted until the integration
  succeeds, validation passes, and the integration is proven.
- If a worktree removal fails mid-delete, it diagnoses rather than forces, and
  reports what it left and why.
- If the branch is still not an ancestor after a merge, deletion is refused and
  reported — except the disclosed squash case, where `-d` can never succeed and
  the proof is the completed merge itself.

## Related

- [User guide](README.md) — choose a skill and what it needs
- [Invoking skills](invoking.md) — how to call it in your host
- [Skills reference](../skills/README.md) — the catalog rules behind every skill
