---
name: standup
description: >-
  Prepare what to say at the daily standup: everything you did since the last daily (commits, your
  PRs and their state, PR reviews you gave, ticket activity, Claude Code sessions, investigations and
  specs, Slack threads), what's planned today, and blockers, as a short bullet message readable in
  under 30 seconds. Use on "standup", "daily update", "what did I do since yesterday",
  "prepare my daily", "/standup".
argument-hint: "[since <date|time>]"
---

# Standup

Follow `../../shared/policy.md`. Reads only.

## 1. Window
- Start: the previous business day's daily (business days as defined in the `sprint` skill), using `daily_time` from `### standup` in `defaults.md` or the
  current profile (default 10:00 local). Monday reaches back to Friday's daily; a holiday is skipped the same way. `since <...>` overrides.
- End: now.

## 2. Repos and boards
All repos with a profile in `~/.dev-skills/profiles/` (each profile's `Repo:` path), plus the
current repo. Their trackers and PR hosts from the profiles.

## 3. Collect (only items by you, in the window)
| Source | How |
|---|---|
| Commits | per repo: `git log --all --author="$(git config user.email)" --since=<start> --format="%h %ad %s %D"` (also try `user.name`) |
| Your PRs | opened, pushed to, merged, approved, changes requested (pr-hosts.md) |
| Reviews you gave | PRs you reviewed or commented on, with your verdict |
| Tickets | ones you moved, commented on, or created (trackers.md) |
| Claude Code sessions | `~/.claude/projects/*/*.jsonl` modified in the window: read the user prompts and final assistant replies of each session in the window; extract work that has no git trace (investigations, reviews not posted, research, plans). Summarize only. |
| dev-skills work | files under `~/.dev-skills/work/` modified in the window (`context.md`, `spec.md`, `investigation.md`, ...) |
| Slack | if connected: threads you replied in (e.g. support answers) |
| Plan | today's tickets from the current sprint plan (`dev-skills:sprint` file; on a non-business day, the next business day) |

## 4. Merge
One line per ticket or PR, combining every source ("PROJ-123: fixed and opened PR, answered the
support thread"). Drop noise: base-branch merges, staging redeploys, revert-and-redo churn, WIP commits.
Name tickets by key plus a few words of what the work *was*, not branch names.

## 5. Blockers (found automatically)
- Your PRs waiting for review longer than `review_wait` (default 1 workday).
- Questions to product/manager still unanswered (from `context.md` unknowns sent earlier).
- Tickets marked blocked, or failing CI on your PRs.

## Output
```
Done:
- PROJ-123 PR opened — <few words>
- Investigated <issue>: <cause in a clause>
- Reviewed: <repo>#45, <repo>#51
In progress:
- PROJ-130 addressing review comments
Today:
- PROJ-131, PROJ-134
Blockers:
- PROJ-128 PR waiting for review 2 days
```
Leave out empty sections. One line per item; whole message readable in under 30 seconds.
Output to chat, or also to a file when `output: file <path pattern>` is set under `### standup`
(`{date}` placeholder allowed; the file must be outside any repo).
