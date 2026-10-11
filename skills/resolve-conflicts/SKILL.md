---
name: resolve-conflicts
description: >-
  Resolve git merge/rebase/cherry-pick/stash conflicts with judgment: resolve unambiguous cases,
  apply the autonomy mode to behavior-changing ones, and report every resolution so it can be
  checked. Use whenever a git operation reports conflicts, or on "resolve conflicts", "fix the
  conflicts", "there are merge conflicts".
---

# Resolve conflicts

Follow `../../shared/policy.md`.

## Orient
Read the actual hunks; never guess from filenames.
```bash
git status                              # which operation is in progress
git diff --name-only --diff-filter=U    # conflicted files
```
- **Merge:** `ours` = current `HEAD` (branch merged into); `theirs` = branch being merged.
- **Rebase:** inverted: `ours` = the base being replayed onto; `theirs` = your commits.
When unsure which side is which, say so before touching anything.

## Unambiguous: resolve in every mode
- Non-overlapping edits in the same hunk.
- Additive, order-independent lines: imports, dependency entries, new methods, routes, map keys.
- Generated files (lockfiles, schema dumps, generated clients, annotations): take one side and
  regenerate with the project's command when quick; say so.
- One side is a strict superset of the other.

## Behavior-changing: apply the mode
Both sides changed the same logic incompatibly; or the conflict is in a migration, auth, billing,
crypto, or other high-blast-radius code; or you cannot explain why a resolution is right.
- `autonomous`: resolve with your best judgment, mark it **REVIEW** in the report, never push it
  without the confirmation list.
- `balanced` / `guided`: abort cleanly (`git merge --abort` / `git rebase --abort` /
  `git cherry-pick --abort`), show both sides with the trade-off and a recommendation, and ask.
- `guided` also asks for any non-trivial resolution above.

## Never
- Take `--ours`/`--theirs` for a whole file just to clear the conflict.
- `git checkout .`, `reset --hard`, force-push, or anything that discards the other side's work.
- Leave an operation half-finished.

## Finish and report
`git add <files>` then `git commit --no-edit` (merge/cherry-pick) or `git rebase --continue`.
Committing a merge resolution follows the mode's commit checkpoint.

For every conflict:
> **Conflict:** `config/routes.rb` (~line 210)
> **Base had:** new `resources :webhooks`. **Your side had:** new `resources :reports`.
> **Resolved:** kept both: additive, non-overlapping.
