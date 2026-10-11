---
name: sprint
description: >-
  Plan your sprint and your day. "/sprint" pulls the tickets assigned to you in the current (or
  next) sprint, and distributes them across business days so everything finishes before
  the sprint ends. "/sprint today" reads that plan and says what to tackle today and where each
  ticket really stands (not started, branch, PR open, changes requested, approved, merged),
  re-planning if behind. Use on "plan my sprint", "plan the next sprint", "what should I work on
  today", "plan my day", "/sprint", "/sprint today".
argument-hint: "[next | today]"
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

## Plan (`/sprint`, `/sprint next`)
1. **Tickets:** yours in the current sprint (or the next one with `next`), with status, priority,
   links (blocks/is blocked by), and the sprint's start and end dates.
2. **What's left (matters mid-sprint):** get each ticket's real status (see Today, step 4).
   - Done (tracker done/closed, or PR merged with nothing left): not planned again; listed under
     `Already done`.
   - Partly done: plan only the remaining steps (e.g. PR open → review turnaround and fixes;
     changes requested → address comments; approved → merge and QA). These are small.
   - Past days are never re-planned. If a plan file for this sprint exists, keep its earlier rows as
     history and replace only the rows from today on.
3. **Relative weight:** small / normal / big, judged from the description and a quick look at the
   code it touches (not from estimates). Used only to balance days.
4. **Days:** remaining business days, from the first one (today if it is one, else the next; or the
   sprint start for `next`) to the sprint end.
5. **Order:** blockers of other tickets (yours or teammates') first, then priority, then risky or
   unclear tickets early so surprises surface while there's room.
6. **Distribute** in that order so each day gets a similar share:
   - Tickets ≈ days: one ticket per day.
   - More tickets than days: some days take two or more; group small ones together, and keep a big
     one alone on its day.
   - Fewer tickets than days: a big ticket may span two days; leave the last day(s) for review
     follow-ups and QA.
7. Save the plan; in `guided`, show it and wait for approval before saving.

```markdown
# <board> — <sprint> (<start> → <end>)
Business days left: <n> · Tickets left: <n>
| Day | Tickets | Work |
|---|---|---|
| Mon 10/12 | PROJ-120 | implement + PR |
| Tue 10/13 | PROJ-121, PROJ-125 (small) | implement + PR |
...
Already done: <tickets — how (merged PR, closed)>
Risks: <unclear tickets, external dependencies>
Updated: <timestamp> (<reason>)
```

## Today (`/sprint today`)
1. Load the current sprint's plan. None: offer `/sprint` and stop.
2. **Not a business day** (weekend, holiday, day off): say `Nothing planned today (<weekday>).`, then
   show the next business day's rows as a preview with their real status (step 4). Don't re-plan.
3. Business day: today's rows plus anything planned earlier that is not done.
4. **Real status** per ticket: tracker status + branch exists (all repos in `related_repos` and the
   current one) + PR state (open, changes requested, approved, merged) + CI state.
5. **Changes:** tickets added to or removed from the sprint since planning.
6. **Behind?** Compare done vs planned to date. If behind or the sprint changed, re-plan the
   remaining tickets over the remaining business days with the same rules and update the file (`guided`: propose and ask first).

```
Today (Tue 10/13) — on track | behind by <n> ticket(s) | ahead
- PROJ-120 changes requested → address comments (dev-skills:address-comments)
- PROJ-121 not started → implement
Carried over: <ticket — why>
Sprint changes: <added/removed>
Re-planned: <yes — what moved | no>
```
Non-business day:
```
Nothing planned today (Sunday).
Next: Mon 10/12
- PROJ-120 not started → implement
```
