---
name: address-comments
description: >-
  Work through code review comments on your own PR: understand each one against the requirements
  and code, implement the changes (following the reviewer by default), verify, commit, then queue
  push and replies for confirmation. Any PR host. Use on "address the review comments", "address CR
  comments", "fix PR feedback", "respond to review", "/address-comments".
argument-hint: "[pr url|number]"
---

# Address comments

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. Fetch
- The PR: given, or the open PR for the current branch. Work in its branch (its existing worktree
  under `~/.claude/dev-skills/worktrees/` if there is one; otherwise create one as in `implement`).
- Unresolved review threads and general comments not yet answered by you. Skip resolved, deleted and
  outdated threads whose code no longer exists (mention them).
- Requirements: the ticket via `dev-skills:gather-context` (reuse `context.md` if present).

## 2. Decide per comment
Classify: change requested / suggestion / question / nit. Then:
- **Follow the reviewer by default**, including optional suggestions and nits.
- **Decline** only when following it would introduce a bug, contradict the requirements, or add a
  large change the ticket does not need. A decline gets a short, concrete reason.
- **Question:** answer it; change code only if the answer reveals a problem.
- Two comments conflicting with each other: follow the more senior/blocking reviewer's and note it.
Declines follow the mode: `autonomous` decide and record; `balanced` decide and show in the
confirmation list; `guided` ask per comment.

## 3. Change, verify, commit
Implement the accepted changes. Run `dev-skills:qa` in `verify` mode on what changed. Commit locally
per the mode, one commit per logical change or one commit for all, following the repo's history style.
If the branch needs the latest base to pass, merge it in (conflicts via `dev-skills:resolve-conflicts`);
rebasing a pushed branch is a confirmation-list item.

## 4. Queue
- Push.
- A reply per thread: what changed (with the commit sha) or why it was declined, in one or two lines.
- Resolve threads only if the project's convention is that the author resolves (profile notes);
  otherwise leave resolution to the reviewer.
- Re-request review if the host supports it.

## Report
```
Mode: <mode> (<source>) · Profile: <path>
PR <link>
| # | Comment (short) | Decision | Change |
|---|---|---|---|
| 1 | `file:line` "use a transaction here" | done | <sha> |
| 2 | "rename X" | declined | <reason> |
Checks: <command> → pass/fail
<confirmation list>
```
