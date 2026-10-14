---
name: todo
description: >-
  Everything that needs you now, in one numbered report: today's tickets from your day plan (built
  from the sprint plan) with their real PR status, PRs waiting for your review, your PRs that need
  action, and unanswered Slack messages, mentions and ticket/PR comments. Builds the sprint and day
  plans first when they are missing. Report only: no drafts, nothing sent. Built for routines and
  scheduled runs too. Use on "what's on my plate", "what should I do", "to do", "any mentions",
  "check my messages", "/todo", "/todo replan".
argument-hint: "[refresh | replan | replan sprint] [json]"
model: haiku
---

# To Do

Follow `../../shared/policy.md` (including **Unattended runs** when started by a routine or
schedule). Reads only. Never drafts, replies or acts on what an item asks: the report is the output,
and other skills pick items from it.

Config from `### todo` (profile `## Mine`, then `defaults.md`):
- `deliver`: `chat` (default), `slack-dm` (send the report to your own Slack DM, no approval
  needed), or `file <path pattern>` (`{date}` allowed, outside any repo).
- `channels`: Slack channels to scan for questions without a mention (e.g. on-call, support).
- `fresh_minutes`: how long a report is reused (default 30).

State lives in `~/.dev-skills/todo/` (create it): `last.md` (report), `last.json` (items),
`items.json` (cache), `last-run`.

## Arguments
- none: use the plans as they are; re-check the live sources unless the last report is fresh.
- `refresh`: re-check the live sources now, skipping step 0.
- `replan`: rebuild today's plan (`dev-skills:sprint` `today refresh`), then report.
- `replan sprint`: re-plan the sprint from today (`dev-skills:sprint`, re-plan approved), then
  today's plan, then report.
- `json`: also end the reply with the items as one fenced ```json block (the `last.json` content).

## 0. Reuse before re-checking
Skipped with `refresh` or `replan`.
- **Recent report:** if `last.md` is younger than `fresh_minutes`, show it with
  its age, add `/todo refresh to re-check`, and stop.
- **Unattended:** run `<plugin root>/shared/bin/changed todo`. Exit 1 (no GitHub activity and the
  last full run is under 2h old): deliver nothing, reply with its output line, and stop. Exit 0 or
  2: go on.

## 1. Plans (no model work when they exist)
**Boards:** the tracker board of every project with a profile in `~/.dev-skills/profiles/` plus the
current repo (`dev-skills:project-profile` when it has none). Each project uses its own profile's
`tracker` (Jira, Linear, ClickUp, GitHub; `../../shared/references/trackers.md`). A tracker without
sprints (no sprints/cycles, no ClickUp Sprints folder) has no plan: list your open tickets there
under **Assigned** instead, from one query. No tracker: skip.

Per board:
1. **Sprint plan:** a file in `~/.dev-skills/plans/<board-slug>/` whose header end date is today or
   later. Pick it by the header; don't query the tracker for the sprint.
   - Missing, interactive: say `No sprint plan for <board>: building it first.`, run
     `dev-skills:sprint`, and go on.
   - Missing, unattended: don't build it. Add `Sprint plan missing for <board>: run /todo to build
     it` under **Needs you** and go on without that board's plan.
2. **Day plan:** `<sprint-slug>.today.md` next to it whose `Made:` line is today. Use it as it is.
   Missing or from an earlier day: say `Building today's plan for <board>.` (interactive), run
   `dev-skills:sprint` `today refresh`, and go on. Unattended runs build it too. Its
   `Re-plan from today?` question goes under **Needs you** as `run /todo replan sprint`.

`replan` and `replan sprint` rebuild as described in **Arguments** before this step reads them.

## 2. Live sources
Messages count when they are from people and you haven't answered or reacted to them as handled.
Skip any source that isn't connected and list it under **Gaps**.
- **GitHub:** run `<plugin root>/shared/bin/todo-github [since]` once: one GraphQL call returning
  review requests, your open PRs (review decision, mergeable, CI, unresolved threads where someone
  else spoke last) and open issues/PRs mentioning you. Don't call `gh` per PR.
- **Other PR hosts** (Bitbucket, GitLab; `../../shared/references/pr-hosts.md`): per repo with a
  profile on that host, one call for your open PRs and one for PRs waiting for your review.
- **Slack:** mentions, DMs, new replies in threads you're in, new questions in `channels`.
- **Tickets** (`../../shared/references/trackers.md`): one query per tracker for comments
  mentioning you or on tickets assigned to you, since the window start.

**Window:** the time in `last-run`, else the previous business day's start. Unanswered items are
listed whatever the window; the window only decides what's marked **new**.

**Item cache** `items.json`, keyed by id (PR URL, Slack permalink, comment id), holding its last
activity time and line. An item whose last activity matches the cache reuses its line as is. Only
new or changed items get a look (reading a Slack thread, a ticket comment). Save the cache after the
run, dropping items that are gone.

## 3. Match
- Today's tickets get their real status from the GitHub data: a PR whose branch or title holds the
  ticket key gives open / changes requested / approved / merged and CI. No PR: the day plan's status.
- A PR or comment that belongs to one of today's tickets goes under that ticket, not again below.

## 4. Report
Number every item once, top to bottom, so you and other skills can refer to them (`#3`). One line
each: source, who, age, what it needs. Order inside each section: incidents and production first,
then people blocked on you, then oldest first.

```
To Do — Wed 10/14 09:12 · <board> <sprint> · on track | behind by <n>
Needs you:
1. Sprint plan missing for <board>: run /todo to build it
Today:
2. PROJ-120: <summary> — a/b#40 changes requested, 2 threads waiting
3. PROJ-121: <summary> — not started
Carried over:
4. PROJ-118: <summary> — a/b#38 approved, CI failing
Assigned (<board without sprints>):
5. DEV-77: <summary> — in progress
Urgent:
6. Slack #oncall, Ana (20m, new): "checkout failing for EU"
Reviews for you:
7. a/b#52 "Add retries" by dan (2h) — +120/−30, CI passing
My PRs:
8. a/b#41 "Fix y" — conflicts
Messages:
9. Slack DM, Dan (1h): "can you check the export?"
10. PROJ-125, Carol (1d): "<question>"
FYI:
11. Slack thread #team, Eve: "<summary>"
Quiet: <sources checked with nothing new>
Gaps: <sources not reachable>
```
Leave out empty sections. Several boards: one `Today`, `Carried over` or `Assigned` section per board,
headed by the board name.

## 5. Deliver
Write the report per `deliver` and to `last.md`. Write `last.json`: `{"at": <ISO time>, "items":
[{"n", "section", "kind": "ticket"|"pr"|"slack"|"comment"|"plan", "id", "url", "title", "who",
"at", "status", "text"}]}` with the same numbers. Save the run time to `last-run`. Nothing else is
sent.
