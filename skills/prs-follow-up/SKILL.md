---
name: prs-follow-up
description: >-
  Follow up on every open PR you authored in this repo: update the branch with its base and resolve
  conflicts, address review comments, and fix failed checks, then queue pushes and replies for
  confirmation. Reuses resolve-conflicts, address-comments and qa. Use on "follow up on my PRs",
  "babysit my PRs", "get my PRs green", "/prs-follow-up".
argument-hint: "[pr urls|numbers]"
---

# PRs follow-up

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. List
- The PRs given, otherwise every open PR authored by me in this repo, in one call
  (GitHub: `gh pr list --author @me --state open --json number,title,url,headRefName,baseRefName,mergeable,mergeStateStatus,statusCheckRollup`).
- Unresolved review threads for all of them in one batched query.
- Per PR, note what it needs: **behind/conflicts**, **unaddressed comments**, **failed checks**.
  Skip PRs that need nothing. None left: say `Nothing to follow up.` and stop.

## 2. Per PR, in order
Work in the PR's worktree (reuse one under `~/.dev-skills/worktrees/`, otherwise create it as in
`implement`). Load the ticket once via `dev-skills:gather-context` (reuse `context.md`).

1. **Update branch:** merge `origin/<base>` into the branch (never rebase a pushed branch). Conflicts
   go through `dev-skills:resolve-conflicts`.
2. **Comments:** run `dev-skills:address-comments` on the PR. Its rules apply: check each comment
   makes sense, reply `Done! @<commenter>` when fixed or a one-sentence reason when not, resolve bot
   threads and leave human ones open, and tag the ticket's author when a comment contradicts the ticket.
3. **Failed checks:** read the failing logs. Real failure: reproduce locally, fix, commit. Flaky or
   infra (timeout, runner, network, unrelated to the diff): queue a rerun instead of a code change.
   Failures caused by the base update or a comment change are fixed here too.
4. Run `dev-skills:qa` in `verify` mode on everything changed in this PR.

Fold the PR's push, replies, resolutions and reruns into one confirmation list for the whole run,
grouped by PR. Push comes before the replies of the same PR.

## Ask the user
Stop and ask (unattended: put it in the report instead) when:
- A fix, conflict resolution or comment would change behavior beyond what the comment or ticket says.
- A check keeps failing after one fix attempt, or its cause is unclear.
- Anything else blocks progress on a PR. Move on to the next PR while waiting when you can.

## Report
```
Mode: <mode> (<source>) · Profile: <path>
<n> PRs followed up, <m> need you.
| PR | Branch | Comments | Checks | Notes |
|---|---|---|---|---|
| #12 <title> | merged base, 1 conflict REVIEW | 3 done, 1 declined | fixed lint | |
| #15 <title> | up to date | — | rerun (flaky) | asked: <question> |
Assumed: ...
<confirmation list>
```
