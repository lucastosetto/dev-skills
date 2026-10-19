---
name: pr-follow-up
description: >-
  Follow up on PRs you authored: update the branch with its base and resolve conflicts, address
  review comments, and fix failed checks, then queue pushes, replies and thread resolution for
  confirmation. PRs given: those; one PR already discussed in the conversation: that one; "all" or
  nothing to go on: every open PR you authored across all your repos and PR hosts. Reuses
  resolve-conflicts, address-comments and qa. Use on "follow up on this PR", "follow up on my PRs",
  "babysit my PRs", "get my PRs green", "/pr-follow-up [urls]".
argument-hint: "[pr urls|numbers|all]"
---

# PR follow-up

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. Pick the PRs
- PR urls or numbers given: those.
- Ticket urls or keys given: each one's open PR (branch or title carries the key) on the project's PR host.
- `all`, "my PRs", or a request about PRs in general: every open PR authored by me, in every repo, not just the current one:
  - **GitHub, all repos:** `gh search prs --author @me --state open --json repository,number,title,url`,
    once per logged-in account (`gh auth status`).
  - **Other hosts** (Bitbucket, GitLab): each repo with a profile in `~/.dev-skills/profiles/`, plus
    the current repo, one list call per repo.
- Nothing given: the PR this conversation has been about (last PR url, number or branch discussed or
  worked on here). If none, ask once for the PR link, or whether to scan all your open PRs. Don't
  guess from the current branch.

Map each PR to its local checkout: the profile's `Repo:` path, else the current repo if it matches,
else a clone whose `origin` matches under the parent folders of known checkouts. None found: clone it
into `~/.dev-skills/repos/<project-slug>` and run `dev-skills:project-profile` there.

With several PRs, batch the reads per repo: PR state, mergeability and checks in one call, unresolved
review threads in one query. Per PR, note what it needs: **behind/conflicts**, **unaddressed
comments**, **failed checks**. Skip PRs that need nothing. None left: say `Nothing to follow up.` and stop.

## 2. Per PR, in order
Load that repo's profile (`dev-skills:project-profile` from its checkout). Work in the PR's worktree
(reuse one under `~/.dev-skills/worktrees/`, otherwise create it as in `implement`). Load the ticket
once via `dev-skills:gather-context` (reuse `context.md`).

1. **Update branch:** merge `origin/<base>` into the branch (never rebase a pushed branch). Conflicts
   go through `dev-skills:resolve-conflicts`.
2. **Comments:** run `dev-skills:address-comments` on the PR. Its rules apply: check each comment
   makes sense, reply `Done! @<commenter>` when fixed or a one-sentence reason when not, resolve bot
   threads and leave human ones open, and tag the ticket's author when a comment contradicts the ticket.
3. **Failed checks:** read the failing logs. Real failure: reproduce locally, fix, commit. Flaky or
   infra (timeout, runner, network, unrelated to the diff): queue a rerun instead of a code change.
   Failures caused by the base update or a comment change are fixed here too.
4. Run `dev-skills:qa` in `verify` mode on everything changed in this PR.

Fold every PR's push, replies, resolutions and reruns into one confirmation list for the whole run,
grouped by PR. Push comes before the replies of the same PR.

## Ask the user
Stop and ask (unattended: put it in the report instead) when:
- A fix, conflict resolution or comment would change behavior beyond what the comment or ticket says.
- A check keeps failing after one fix attempt, or its cause is unclear.
- Anything else blocks progress on a PR. Move on to the next PR while waiting when you can.

## Report
One PR:
```
PR <repo>#<n> <title>: <up to date | merged base, N conflicts REVIEW>
Comments: <n done, n declined> · Checks: <ok | fixed X | rerun (flaky)>
Assumed: ...
<confirmation list>
```
Several PRs:
```
<n> PRs followed up, <m> need you.
| Repo | PR | Branch | Comments | Checks | Notes |
|---|---|---|---|---|---|
| api | #12 <title> | merged base, 1 conflict REVIEW | 3 done, 1 declined | fixed lint | |
| web | #15 <title> | up to date | — | rerun (flaky) | asked: <question> |
Assumed: ...
<confirmation list>
```
