---
name: resolve-worktree-to-primary
description: Safely finish work in the current Git linked worktree, integrate its branch into the branch checked out in the repository's primary worktree, assessing and choosing the right Git strategy (fast-forward, merge, squash, rebase) and resolving any merge conflicts by understanding both sides' intent, then verify the integration and clean up the linked worktree and merged local branch. Invoke when the user asks to resolve, merge, fold, finish, wrap up, integrate, or return the current worktree back into the primary/main repository branch. Not for creating worktrees, merging branches that share one worktree, or pushing to a remote.
compatibility: Requires Git on PATH and shell access in both worktrees.
---

# Resolve Worktree to Primary

Integrate the current linked Git worktree into the repository's primary worktree, then verify and clean up. Discover every path and name from Git — never assume repository, worktree, or branch names such as `main` or `master`. "Primary branch" means the branch checked out in Git's primary worktree (the first entry of `git worktree list`), not a branch literally named `main`.

## Safety principles

- Preserve all user work; never silently discard uncommitted changes; never stash, commit, or reset unrelated primary-worktree changes.
- No destructive Git operations (`reset --hard`, `clean -fd`, forced worktree removal, forced branch deletion) in normal operation.
- Never rewrite (rebase) pushed or shared history; never push unless explicitly requested.
- Resolve conflicts semantically, never mechanically; escalate only what repository evidence cannot settle.
- Respect repository-level instructions (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, equivalents).
- Cleanup gating lives in steps 7–9: nothing is removed or deleted until integration succeeds, validation passes, and integration is proven.

## Consultation policy

Choices that repository evidence makes obvious proceed without interruption, with the choices reported. When a choice is not obvious — several linked worktrees and the intended source is unclear, the user names a target other than the primary's checkout, detached HEAD, or an equivocal strategy assessment in step 5 — stop before any Git mutation, present what was discovered, recommend the approach you judge best for the case with reasons, and proceed only on explicit confirmation. If the user asks to force reconciliation ("force it", "use your best judgment", "don't ask"), proceed on best judgment without further consultation; this removes only the confirmation pauses — never the safety principles, the no-`--force` rule, the validation and cleanup gates, or repository instructions.

## 1. Discover the worktrees

```sh
git rev-parse --show-toplevel
git branch --show-current
git status --short --branch
git worktree list --porcelain
```

The first `worktree list` entry is the primary worktree. Record `CURRENT_WORKTREE`, `SOURCE_BRANCH`, current `HEAD`, whether changes exist, `PRIMARY_WORKTREE`, and `TARGET_BRANCH` (the branch checked out in the primary). Record what integration will carry: `git log --oneline "<TARGET_BRANCH>".."<SOURCE_BRANCH>"`, and whether the target can fast-forward: `git merge-base --is-ancestor "<TARGET_BRANCH>" "<SOURCE_BRANCH>"` (exit 0 = FF available). State the anticipated result when confirming the integration with the user.

If this is already the primary worktree: with no linked worktrees, stop — nothing to resolve; otherwise apply the consultation policy to choose among the linked worktrees. Detached HEAD on either side or any other branch-identity ambiguity is likewise a consultation-policy case before any Git mutation.

## 2. Read repository instructions

Before touching Git state, check `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `README.md`, `Makefile`, `package.json`, project/solution files, and CI workflows; prefer explicit project documentation over guessing, and note the project's established validation commands. Where instructions govern Git operations (e.g., per-operation authorization for commits, merges, removals, deletions), the request to resolve this worktree authorizes exactly this workflow's operations — obtain any additional confirmation they require.

## 3. Finish the source worktree

Review remaining changes (`git status`, `git diff`, `git diff --cached`) and confirm they belong to the work being completed. Stage and commit them with a concise message from the actual work; if already clean, skip — the commits ahead of the target recorded in step 1 are what integration carries. Never commit unrelated files just to get a clean tree; if unrelated or suspicious changes cannot safely be set aside, stop and report.

Require `git status --porcelain` to be empty, then record the final source commit (`git rev-parse HEAD`).

## 4. Validate the primary worktree

`cd "<PRIMARY_WORKTREE>"`; confirm identity (`git rev-parse --show-toplevel`), that the checked-out branch is still `TARGET_BRANCH`, and that `git status --porcelain` is empty — Git recommends entering a merge with a clean worktree. If uncommitted changes exist, stop; do not stash, commit, reset, or otherwise alter them.

## 5. Integrate the source branch

### Integration objective

Retain the most current intended solution and all intended work, no matter which side it originated on. The branches are locations, not authorities — neither "ours" nor "theirs" wins by default. Judge each piece of work by what it was meant to achieve and which side carries the most current expression of that intent; recency is evidence, not a verdict. Work is only ever lost deliberately: moot or superseded changes are dropped by explicit, reported decision, and where superseded work's effect still matters it is re-expressed in the surviving shape rather than discarded with its text.

### Choose the strategy

Assess, in order:

1. **Policy first** — documented convention, or the repo's observable history (`git log --oneline --merges -20`: preserved branch history vs. one-commit squash-style landings). Policy overrides the heuristics below.
2. **Source history quality** — coherent, self-explanatory commits, or WIP noise ("fix", "typo", "again")?
3. **Sharing** — is the source branch pushed or otherwise known outside this worktree (`git branch -r --contains "<SOURCE_BRANCH>"`, upstream config)? Shared history is never rewritten.
4. **Divergence** — FF available, per step 1?

Then choose:

- **Fast-forward** — FF available and history coherent: `git merge --ff-only "<SOURCE_BRANCH>"`. Simplest correct outcome.
- **Squash** — noisy WIP history that would pollute the target: `git merge --squash "<SOURCE_BRANCH>"`, then `git commit` with a composed message summarizing the actual work. Cleanup adapts (steps 7 and 9).
- **Rebase, then fast-forward** — strictly linear repo history, coherent unshared source: in the source worktree `git rebase "<TARGET_BRANCH>"` (per-commit conflicts resolved per below), then in the primary `git merge --ff-only`; if the target moved, fall back to a normal merge rather than re-rebasing.
- **Merge commit** — meaningful parallel history on both sides, no policy against it: `git merge "<SOURCE_BRANCH>"`, composing an accurate message if Git's default is poor.

No extra flags (`--no-ff`, `--no-commit`, …) unless the chosen rationale calls for them. Report the chosen strategy and why; if the assessment is equivocal, it is a consultation-policy case — recommend one strategy and confirm before integrating.

### Resolve conflicts semantically

Resolve conflicts — do not stop merely because they exist. Judge them by the ambiguity of their intents, not their count: a hundred mechanical conflicts can be trivial; two lines of opposing business logic can be unanswerable. For each conflicted file:

1. Inventory: `git status --porcelain`, `git diff --name-only --diff-filter=U`.
2. Read the stages: `git show :1:<path>` (base), `:2:` (ours), `:3:` (theirs). Under this workflow ours is always the target side and theirs the source side — in a merge because HEAD is the target, in a rebase because HEAD is the upstream.
3. Reconstruct each side's intent: per-side commits touching the file (`git log --oneline "<SOURCE_BRANCH>".."<TARGET_BRANCH>" -- <path>` and the reverse), the surrounding code, repository instructions and domain docs.
4. Resolve conceptually, not textually:
    - Different aspects changed → integrate both.
    - Same need solved differently → keep what best represents the current intended solution, design, and conventions, adapted as needed — a conclusion from evidence, never "theirs is newer" or "ours is ours".
    - One side supersedes the other (deliberate revert, rewrite, refactor) → the superseding side defines the current shape; re-express the superseded effect within it while still applicable; what is genuinely moot is dropped only explicitly and reported.
    - Overlapping additions (functions, fields, tests, docs) → one coherent entity; remove duplicates; update callers and usages.
    - Rename/delete combinations, lockfiles, generated files → resolve from evidence (regenerate, or favor the governing intent); never hand-edit generated content.
5. Pick a side wholesale only as an evidence-based conclusion that the other side's intent is obsolete or superseded.
6. Remove all markers, stage the file; after substantial resolutions run the fastest sanity check (compile, lint, focused tests) before concluding with `git commit` (`git merge --continue` for a true merge).
7. Account for every intent reconstructed in step 3 — integrated, re-expressed, or explicitly dropped with a reason. Nothing from either side may vanish silently.
8. Record the resolution and its rationale per file for the completion report.

Stop and ask the user only when the intents are semantically incompatible and repository evidence cannot settle which represents the intended solution going forward (e.g., each side implemented a different business rule; the area needs domain knowledge neither code nor docs supply). Leave the merge state intact and report; do not remove the worktree or delete the branch. `git merge --abort` only on explicit user request, and only if this skill started the merge and the primary was clean beforehand.

## 6. Verify the integration

From the primary worktree, run the project's documented validation — strongest practical: tests, build, lint/static analysis when normally required; do not invent expensive, destructive, or deployment-affecting commands. This matters doubly after conflict resolution or a rebase: the resulting tree is new work, not just relocated pointers. With no identifiable validation, say so and inspect `git status --short --branch` and `git log --oneline --decorate -5` at minimum. On failure: preserve the merged state for diagnosis (unless instructions say otherwise), report the failing command and error, remove nothing.

## 7. Prove integration

- True merges (fast-forward, merge commit, rebase+FF): `git merge-base --is-ancestor "<SOURCE_BRANCH>" HEAD` must succeed.
- Squash: no ancestry proof exists — the proof is Git's own completed three-way merge, a clean `git status --porcelain`, and passed step-6 validation, which must not be skipped for a squash.

Also require `git status --porcelain` to be empty.

## 8. Remove the linked worktree

Only after: source committed and clean, merge succeeded, validation passed, integration proven (step 7). Then:

```sh
git worktree remove "<CURRENT_WORKTREE>"
```

No `--force` in normal cleanup. If removal fails, diagnose rather than escalate — on any OS, removal can die mid-delete while a process holds the directory (typically a shell or editor whose working directory is inside the worktree), after Git already completed the registration removal; common errors are `failed to delete: Invalid argument` (Windows) and `Device or resource busy`. Check: (1) `git worktree list --porcelain` — unregistered? (2) `git -C "<CURRENT_WORKTREE>" rev-parse --show-toplevel` — `not a git repository` confirms an orphan checkout; (3) leftovers hold no user work — empty or only rebuildable artifacts (e.g., a dependency venv). If unregistered and no longer a repository, run `git worktree prune`, continue with branch deletion and final verification, and report the inert leftover directory as intentionally left — it deletes cleanly once whatever holds it exits. This shortcut never applies to a still-registered or still-live worktree; that is exactly what the `--force` refusal protects.

## 9. Delete the local source branch

```sh
git branch -d "<SOURCE_BRANCH>"
```

Squash exception: `-d` refuses because a squashed branch is not an ancestor of the target. When the squash commit succeeded, status is clean, and validation passed, `git branch -D` is permitted and must be disclosed in the completion report. Otherwise never substitute `-D` for a refusal — preserve the branch and report why. Never delete a remote branch unless explicitly requested.

## 10. Final verification

`git worktree list`, `git status --short --branch`, `git branch --show-current`. Confirm: primary exists, `TARGET_BRANCH` checked out, primary clean, linked worktree gone (or only a reported inert husk), source branch deleted or refusal reported, validation succeeded.

## Completion report

- source branch; source worktree path; target branch; primary worktree path; source commit integrated
- integration strategy and why it was chosen
- conflicts resolved: none, or each file with its rationale, including any work deliberately dropped as superseded
- validation commands run and their result
- whether the linked worktree was removed (or only an inert, unregistered husk directory remains after a partial removal)
- whether the local source branch was deleted
- anything intentionally left for the user

Example:

```text
Worktree resolved successfully.

Source: feature/cache-fix
Target: develop
Strategy: fast-forward (coherent history, target had not diverged)
Conflicts resolved: none
Tests: passed
Worktree removed: yes
Local source branch removed: yes
```

## Stop conditions

Stop without cleanup when: no Git worktree is present and no source worktree can be established with the user; the primary cannot be identified; unrelated source changes cannot safely be committed; the primary worktree is dirty; conflict intents are unanswerable from repository evidence; integration or validation fails; integration cannot be proven; worktree removal would require `--force` (an unregistered empty husk from a partial removal is not a stop condition — finish and report it); branch deletion would require `-D` outside the proven squash exception. Consultation-policy cases stop only when the user cannot be reached or confirmation is declined.

**Integrate first, verify second, clean up last.**

## Checklist

- [ ] Source worktree committed; `git status --porcelain` empty there.
- [ ] Primary identified as `git worktree list`'s first entry, clean, on `TARGET_BRANCH`.
- [ ] Strategy chosen from policy, history quality, sharing, and divergence, and reported with the reason.
- [ ] Every reconstructed conflict intent integrated, re-expressed, or dropped with a reported reason.
- [ ] Project validation run and passed, or its absence reported.
- [ ] Integration proven: `--is-ancestor` for true merges; completed three-way merge, clean status, and passed validation for a squash.
- [ ] Linked worktree removed without `--force`, or the inert unregistered husk reported.
- [ ] Source branch deleted with `-d` (or the disclosed squash `-D`), or the refusal reported.
- [ ] Completion report delivered.
