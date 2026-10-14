---
name: todo
description: >-
  Everything that needs you now, in one numbered report: today's tickets from your day plan (built
  from the sprint plan) with their real PR status, PRs waiting for your review, your PRs that need
  action, and unanswered Slack messages, mentions and ticket/PR comments. Builds the sprint and day
  plans first when they are missing. Report only: no drafts, nothing sent. Built for routines and
  scheduled runs too. Use on "what's on my plate", "what should I do", "to do", "any mentions",
  "check my messages", "/todo", "/todo replan".
argument-hint: "[refresh | replan | replan sprint] [since <n>h|<n>d] [all] [json]"
model: haiku
---

# To Do

Follow `../../shared/policy.md` (including **Unattended runs** when started by a routine or
schedule). Reads only. Never drafts, replies or acts on what an item asks: the report is the output,
and other skills pick items from it.

Config from `### todo` (profile `## Mine`, then `defaults.md`):
- `deliver`: `chat` (default), `slack-dm` (send the report to your own Slack DM, no approval
  needed), or `file <path pattern>` (`{date}` allowed, outside any repo).
- `channels`: extra Slack channels to scan for bugs, incidents and support questions without a
  mention. Optional: support and incident channels you are in are found on their own.
- `managers`: Slack names or handles of your managers. Optional: only needed when your Slack profile
  doesn't say who they are. The routine prompt can also give them (`Managers: ...`).
- `fresh_minutes`: how long a report is reused (default 30).
- `projects`: a folder. Only profiles whose `Repo:` path is inside it count, for boards, plans and
  PR hosts; every other profile and its plans belong to another account and are never read. The
  routine prompt can also give it (`Projects: <folder>`). Default: every profile.
- `on_call`: `yes` (default) or `no`. The routine prompt can also give it (`On call: no`). With `no`,
  Support only keeps threads that name you, and recurring on-call or support tickets (the plan's
  `Every day` line) are left out.

State lives in `~/.dev-skills/todo/` (create it): `last.md` (report), `last.json` (items),
`items.json` (cache), `last-run`.

## Arguments
- none: use the plans as they are; re-check the live sources unless the last report is fresh.
- `refresh`: re-check the live sources now, skipping step 0.
- `replan`: rebuild today's plan (`dev-skills:sprint` `today refresh`), then report.
- `replan sprint`: re-plan the sprint from today (`dev-skills:sprint`, re-plan approved), then
  today's plan, then report.
- `since <n>h|<n>d`: how far back Slack is read (default `24h`).
- `all`: also list Slack threads you're in that don't need you, under **FYI**.
- `json`: also end the reply with the items as one fenced ```json block (the `last.json` content).

## 0. Reuse before re-checking
Skipped with `refresh` or `replan`.
- **Recent report:** if `last.md` is younger than `fresh_minutes`, show it with
  its age, add `/todo refresh to re-check`, and stop.
- **Unattended:** run `<plugin root>/shared/bin/changed todo`. Exit 1 (no GitHub activity and the
  last full run is under 2h old): deliver nothing, reply with its output line, and stop. Exit 0 or
  2: go on.

## 1. Plans (no model work when they exist)
**Boards:** the tracker board of every project with a profile in `~/.dev-skills/profiles/` (only those
inside `projects` when set) plus the current repo (`dev-skills:project-profile` when it has none). Each project uses its own profile's
`tracker` (Jira, Linear, ClickUp, GitHub; `../../shared/references/trackers.md`). A tracker without
sprints (no sprints/cycles, no ClickUp Sprints folder), or whose current sprint holds none of your
tickets, has no plan: list under **Assigned** only your tickets in progress plus those assigned to
you or updated in the last 24h, from one query. In review or backlog tickets otherwise stay out (their
PRs show up under **My PRs**). No tracker: skip.

Per board:
1. **Sprint plan:** a file in `~/.dev-skills/plans/<board-slug>/` whose header end date is today or
   later. Pick it by the header; don't query the tracker for the sprint.
   - Missing, interactive: say `No sprint plan for <board>: building it first.`, run
     `dev-skills:sprint`, and go on.
   - Missing, unattended: don't build it. Add `Sprint plan missing for <board>: run /todo to build
     it` under **Needs you** and go on without that board's plan.
2. **Day plan:** `<sprint-slug>.today.md` next to it whose `Made:` line is today. Use it as it is.
   Missing or from an earlier day: say `Building today's plan for <board>.` (interactive), run
   `dev-skills:sprint` `today refresh`, and go on. Unattended runs build it too.
3. **Re-plan:** when the day plan says behind or lists sprint changes, re-plan the sprint from today
   (`dev-skills:sprint`, re-plan approved), then `today refresh`, in unattended runs too. Never ask
   or list it under **Needs you**; the report header says `re-planned`.

`replan` and `replan sprint` rebuild as described in **Arguments** before this step reads them.

## 2. Live sources
Messages count when they are from people and you haven't answered them or reacted with ✅ (👀 only
means you saw it). Skip any source that isn't connected and list it under **Gaps**.
- **GitHub:** run `<plugin root>/shared/bin/todo-github [since]` once: one GraphQL call returning
  review requests, your open PRs (review decision, mergeable, CI, unresolved threads where someone
  else spoke last) and open issues/PRs mentioning you. Don't call `gh` per PR.
- **Bitbucket:** run `<plugin root>/shared/bin/todo-bitbucket <your Atlassian account id> [projects folder]` once
  (the id from the Atlassian user info; it is the same account as Jira's). It covers every repo with
  a Bitbucket profile: PRs listing you as reviewer that nobody has approved, and your open PRs with
  approvals, CI, conflicts, commits behind base and human comments. Don't call the Bitbucket MCP.
- **Other PR hosts** (GitLab; `../../shared/references/pr-hosts.md`): per repo with a profile on
  that host, one call for your open PRs and one for PRs waiting for your review.
- **Slack:** only messages from the last 24h (or `since`), in this order:
  1. **Managers:** DMs from your managers. Find them from your Slack profile (manager field, title,
     team) or the `managers` config; none found: skip this tier, no gap.
  2. **DMs:** other direct and group DMs.
  3. **Mentions:** you or a user group you're in.
  4. **Support:** bugs, incidents, customer issues and support questions about your work (your
     repos, services, tickets) in support and incident channels you're in and `channels`.

  Read a channel message's thread (by its thread timestamp), not the channel history: thread replies
  don't show there, so a mention inside a thread would look gone.

  Drop a thread as resolved when you replied after the last ask, when you or the asker reacted with
  ✅, when an incident is marked resolved, or when someone else answered it and nothing after that
  answer names you or asks you directly. Threads you're only in go under **FYI** with `all`, and are
  left out otherwise.

  Also drop a thread that is about one of your sprint tickets (it names the key, or a support ticket
  number that ticket mentions): the ticket already tracks it. Drop tracker bot DMs about tickets
  outside the sprint. Exception to the 24h limit: run one more search, keywords `<@your Slack user
  id>`, `after:` 7 days back, bots included (not `to:me`, which misses channel mentions), and keep only alerts posted by bots or apps that name you directly and that nobody has
  replied to or marked ✅, whatever their age.
- **Tickets** (`../../shared/references/trackers.md`): on a board with sprints, only tickets in the
  current sprint count; anything outside it (new assignments, comments, backlog) is left out. One
  query per tracker for comments
  mentioning you or on tickets assigned to you, since the window start.

**Reviews for you:** only PRs that list you as reviewer. **My PRs:** list one only when it needs
you, and say what: comments by others waiting on you (`waiting_on_me`, unresolved threads),
changes requested, CI failing, conflicts, behind base (needs update), approved and ready to merge,
or open over 24h (`created`) with no review or comment from a person yet (`human_feedback` is 0;
bot reviews like Cursor don't count): nudge the reviewers. Otherwise leave it
out. Ticket comments count the same whatever the ticket's status (QA, CR, ...).

**Window:** the time in `last-run`, else the previous business day's start; it decides what's marked
**new**. Unanswered GitHub and ticket items are listed whatever the window. Slack is limited to its
24h (or `since`) range.

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
then people blocked on you, then oldest first. Slack goes in the four tiers' sections, in that order.

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
Managers:
6. Slack DM, Ana (20m, new): "can we talk about the rollout?"
Reviews for you:
7. a/b#52 "Add retries" by dan (2h) — +120/−30, CI passing
My PRs:
8. a/b#41 "Fix y" — conflicts
DMs:
9. Slack DM, Dan (1h): "can you check the export?"
Mentions:
10. Slack #team, Eve (3h): "@backend who owns the importer?"
Messages:
11. PROJ-125, Carol (1d): "<question>"
Support:
12. Slack #oncall, Bo (40m, new): "checkout failing for EU"
FYI (only with `all`):
13. Slack thread #team, Eve: "<summary>"
Quiet: <sources checked with nothing new>
Gaps: <sources not reachable>
```
Leave out empty sections. Several boards: one `Today`, `Carried over` or `Assigned` section per board,
headed by the board name.

## 5. Deliver
Always save the state files below, also with `json` and in unattended runs. Write the report per `deliver` and to `last.md`. Write `last.json`: `{"at": <ISO time>, "items":
[{"n", "section", "kind": "ticket"|"pr"|"slack"|"comment"|"plan", "id", "url", "title", "who",
"at", "status", "text"}]}` with the same numbers. Save the run time to `last-run`. Nothing else is
sent.
