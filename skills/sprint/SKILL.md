---
name: sprint
description: >-
  Plan your sprint and your day. "/sprint" pulls the tickets assigned to you in the current (or
  next) sprint, sizes them, and lays them out across business days so everything finishes before
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
(dates), `workdays` (default `Mon-Fri`), `buffer_days` (default 1), `meetings` (e.g. `daily 15m,
planning 2h on first day`), `hours_per_day` (default 6 focused hours), `size_hours` (default
`S=3, M=8, L=16, XL=split`), `points_to_size` (e.g. `1-2=S, 3=M, 5=L, 8+=XL`).

**Business days** = `workdays` minus `holidays` and `days_off`. Work is only ever placed on business
days; weekends and days off never get rows. Dates use the user's local timezone.

## Plan (`/sprint`, `/sprint next`)
1. **Tickets:** yours in the current sprint (or the next one with `next`), with status, priority,
   estimate/points, links (blocks/is blocked by), and the sprint's start and end dates.
2. **What's left (matters mid-sprint):** get each ticket's real status (see Today, step 4).
   - Done (tracker done/closed, or PR merged with nothing left): not planned again; listed under
     `Already done`.
   - Partly done: plan only the remaining steps (e.g. PR open → review turnaround and fixes;
     changes requested → address comments; approved → merge and QA).
   - Past days are never re-planned. If a plan file for this sprint exists, keep its earlier rows as
     history and replace only the rows from today on.
3. **Size** the remaining work: estimate or points mapped to S/M/L/XL. No estimate: size from the
   description plus a quick look at the code it touches; mark `(inferred)`. XL: suggest splitting.
4. **Capacity:** business days from the first remaining business day (today if it is one, else the
   next; or the sprint start for `next`) to the sprint end, minus meeting time, times `hours_per_day`.
5. **Order:**
   - Blockers of other tickets (yours or teammates') first.
   - Then priority.
   - Risky or unclear tickets early, so surprises surface while there's room.
   - Spread work so every ticket's code is done before the last `buffer_days` business days, which
     stay for review, QA and fixes. A PR opened on the last day rarely merges.
6. **Fit:** if it doesn't fit, say so first, with what to cut or raise (lowest priority, largest,
   least started).
7. Save the plan; in `guided`, show it and wait for approval before saving.

```markdown
# <board> — <sprint> (<start> → <end>)
Business days left: <n> · Capacity: <h> h · Planned: <h> h · Buffer: <n> day(s) · Fits: yes | no (<what to cut>)
| Day | Ticket | Work | Size |
|---|---|---|---|
| Mon 10/12 | DEV-120 | implement + PR | M |
| Tue 10/13 | DEV-120 / DEV-121 | address review / start | — / L |
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
5. **Changes:** tickets added to or removed from the sprint since planning; re-estimates.
6. **Behind?** Compare done vs planned to date. If behind or the sprint changed, re-plan the
   remaining business days with the same rules and update the file (`guided`: propose and ask first).

```
Today (Tue 10/13) — on track | behind by ~<h> h | ahead
- DEV-120 changes requested → address comments (dev-skills:address-comments)
- DEV-121 not started → implement (L, split across Tue-Wed)
Carried over: <ticket — why>
Sprint changes: <added/removed>
Re-planned: <yes — what moved | no>
```
Non-business day:
```
Nothing planned today (Sunday).
Next: Mon 10/12
- DEV-120 not started → implement (M)
```
