---
name: sprint
description: >-
  Plan your sprint and your day. "/sprint" pulls the tickets assigned to you in the current (or
  next) sprint, and distributes them across business days so everything finishes before
  the sprint ends. "/sprint today" reads that plan and says what to tackle today and where each
  ticket really stands (not started, branch, PR open, changes requested, approved, merged).
  Once a plan exists, re-runs follow it, check briefly for changes and ask before re-planning. Use on "plan my sprint", "plan the next sprint", "what should I work on
  today", "plan my day", "/sprint", "/sprint today".
argument-hint: "[next | today [refresh]]"
model: sonnet
---

# Sprint

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` for the current repo to find the
tracker and board. Tracker queries: `../../shared/references/trackers.md`.
The plan belongs to the **board**, not a repo: `~/.dev-skills/plans/<board-slug>/<sprint-slug>.md`.
Never changes the tracker; ticket updates the user wants go on the confirmation list.

Config from `### sprint` (profile `## Mine`, then `defaults.md`): `days_off` (dates), `holidays`
(dates), `workdays` (default `Mon-Fri`).

**Business days** = `workdays` minus `holidays` and `days_off`. Work is only ever placed on business
days; weekends and days off never get rows. Dates use the user's local timezone.

**Everything assigned fits.** Never report that the sprint doesn't fit, never suggest cutting or
moving tickets, and don't use the tickets' estimates or story points. The job is to distribute all
remaining tickets across the remaining business days.

## Existing plan (`/sprint` when a plan file for that sprint exists)
Follow the saved plan. Don't re-read ticket descriptions, weigh tickets or re-plan unprompted.
1. Show the plan's rows from today on, in the output format below.
2. **Brief change check**, one tracker query for your tickets in that sprint (key, summary, status),
   compared with the plan file:
   - tickets added to or removed from the sprint;
   - tickets that became done;
   - status moves that change the order (To Do → In Progress).
3. Nothing changed: say `No changes since <Updated date>.` and stop.
4. Something changed: list each change on one line, then ask `Re-plan from today?`. Re-plan only on
   a yes, with the Plan steps below (unattended runs: put the question in the report, don't re-plan).

## Plan (`/sprint` with no plan file yet, `/sprint next`, or re-plan approved)
1. **Tickets:** yours in the current sprint (or the next one with `next`), with summary, status,
   priority, board rank, links (blocks/is blocked by), and the sprint's start and end dates.
2. **What's left (matters mid-sprint):** get each ticket's real status (see Today, step 4).
   - Done (tracker done/closed, or PR merged with nothing left): not planned again; listed under
     `Already done`.
   - Partly done (PR open, in review, in QA): left out of the plan; the open PRs need no row.
   - Past days are never re-planned. If a plan file for this sprint exists, keep its earlier rows as
     history and replace only the rows from today on.
3. **Relative weight:** small / normal / big, judged from the description and a quick look at the
   code it touches (not from estimates). Used only to balance days.
4. **Days:** remaining business days, from the first one (today if it is one, else the next; or the
   sprint start for `next`) to the sprint end.
5. **Order:** In Progress tickets first, then To Do tickets in the board's rank order. A recurring
   ticket (on-call, support) goes on an `Every day` line instead of a row.
6. **Distribute** in that order so each day gets a similar share:
   - Tickets ≈ days: one ticket per day.
   - More tickets than days: some days take two or more; group small ones together, and keep a big
     one alone on its day.
   - Fewer tickets than days: a big ticket may span two days; leave the last day(s) for review
     follow-ups and QA.
7. Save the plan; in `guided`, show it and wait for approval before saving.

### Output format (chat and plan file)
One row per ticket, `KEY: summary` with the tracker's summary verbatim. A ticket sharing a day gets
its own row with the same day. A ticket spanning days gets one row with a day range.

```markdown
# <board> — <sprint> (<start> → <end>)
| Day | Ticket |
|---|---|
| Mon 10/12 | PROJ-118: <summary> |
| Tue 10/13 | PROJ-120: <summary> |
| Tue 10/13 | PROJ-125: <summary> |
| Wed 10/14 – Thu 10/15 | PROJ-121: <summary> |
| Fri 10/16 | Review follow-ups and merges |
| Every day | PROJ-130: <summary> |
Risks: <one line, only if any>
Updated: <timestamp> (<reason>)
```
In chat, skip the `#` heading and `Updated` line and add nothing else besides `Risks`.

## Today (`/sprint today`)
1. Load the current sprint's plan. None: offer `/sprint` and stop.
   Without `refresh`, if `<sprint-slug>.today.md` next to the plan was made today, show it, add
   `/sprint today refresh to re-check`, and stop. The day plan is built once a day; live PR and
   message status is `dev-skills:todo`'s job.
2. **Not a business day** (weekend, holiday, day off): say `Nothing planned today (<weekday>).`, then
   show the next business day's rows as a preview with their real status (step 4). Don't re-plan.
3. Business day: today's rows plus anything planned earlier that is not done.
4. **Real status** per ticket: tracker status + branch exists (all repos in `related_repos` and the
   current one) + PR state (open, changes requested, approved, merged) + CI state. Batch it: one
   tracker query for all the tickets, one `git branch -a` and one PR list per repo (e.g.
   `gh pr list --author @me --state all --json headRefName,state,reviewDecision,statusCheckRollup`),
   then match by ticket key. Never one call per ticket.
5. **Changes:** tickets added to or removed from the sprint since planning.
6. **Behind?** Compare done vs planned to date. If behind or the sprint changed, say so and ask
   `Re-plan from today?`; re-plan only on a yes, with the Plan steps.

Save the report to `<sprint-slug>.today.md`, with a last line `Made: <YYYY-MM-DD HH:MM>`.

```
Today (Tue 10/13) — on track | behind by <n> ticket(s) | ahead
- PROJ-120: <summary> — changes requested → address comments (dev-skills:address-comments)
- PROJ-121: <summary> — not started → implement
Carried over: <ticket — why>
Sprint changes: <added/removed>
```
Non-business day:
```
Nothing planned today (Sunday).
Next: Mon 10/12
- PROJ-120: <summary> — not started → implement
```
