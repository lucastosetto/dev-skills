---
name: pr-follow-up
description: >-
  Follow up on one PR you authored: update the branch with its base and resolve conflicts, address
  review comments, and fix failed checks, then queue the push, replies and thread resolution for
  confirmation. With no PR given, offers to scan all your open PRs. Reuses resolve-conflicts,
  address-comments and qa. Use on "follow up on this PR", "get this PR green", "/pr-follow-up <url>".
argument-hint: "[pr url|number]"
---

# PR follow-up

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. Pick the PR
- A PR url or number given: use it.
- A ticket url or key given: find its open PR (branch or title carries the key) on the project's PR host.
- Nothing given: the current branch's open PR if there is one; otherwise ask once whether to scan all
  your open PRs, and on yes run `dev-skills:prs-follow-up` and stop.

Map the PR to its checkout and worktree as in `dev-skills:prs-follow-up` step 1.

## 2. Follow up, in order
Load the ticket once via `dev-skills:gather-context` (reuse `context.md`).

1. **Update branch:** merge `origin/<base>` into the branch (never rebase a pushed branch). Conflicts
   go through `dev-skills:resolve-conflicts`.
2. **Comments:** run `dev-skills:address-comments` on the PR. Its rules apply.
3. **Failed checks:** read the failing logs. Real failure: reproduce locally, fix, commit. Flaky or
   infra: queue a rerun instead of a code change.
4. Run `dev-skills:qa` in `verify` mode on everything changed.

Queue the push, replies, resolutions and reruns as one confirmation list. Push comes before replies.

## Ask the user
Stop and ask (unattended: put it in the report) when a fix or comment would change behavior beyond
the comment or ticket, a check keeps failing after one fix, or anything else blocks progress.

## Report
```
PR <repo>#<n> <title>: <up to date | merged base, N conflicts REVIEW>
Comments: <n done, n declined> · Checks: <ok | fixed X | rerun (flaky)>
Assumed: ...
<confirmation list>
```
Nothing needed: say `Nothing to follow up.`
