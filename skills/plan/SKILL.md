---
name: plan
description: >-
  Plan your sprint and your day. "plan sprint" pulls the tickets assigned to you in the current (or
  next) sprint, sizes them, and lays them out day by day so everything finishes before the sprint
  ends. "plan day" reads that plan and says what to tackle today and where each ticket really stands
  (not started, branch, PR open, changes requested, approved, merged), re-planning if behind. Use on
  "plan my sprint", "plan the next sprint", "what should I work on today", "plan my day", "/plan".
argument-hint: "[sprint [next] | day]"
---

# Plan

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` for the current repo to find the
tracker and board. Tracker queries: `../../shared/references/trackers.md`.
The plan belongs to the **board**, not a repo: `~/.claude/dev-skills/plans/<board-slug>/<sprint-slug>.md`.
Never changes the tracker; ticket updates the user wants go on the confirmation list.

Config from `### plan` (profile `## Mine`, then `defaults.md`): `days_off` (dates), `buffer_days`
(default 1), `meetings` (e.g. `daily 15m, planning 2h on first day`), `hours_per_day` (default 6
focused hours), `size_hours` (default `S=3, M=8, L=16, XL=split`), `points_to_size` (e.g. `1-2=S, 3=M, 5=L, 8+=XL`).

## sprint (`plan sprint`, `plan sprint next`)
1. **Tickets:** yours in the current sprint (or the next one with `next`), with status, priority,
   estimate/points, links (blocks/is blocked by), and the sprint's start and end dates.
2. **Size:** estimate or points mapped to S/M/L/XL. No estimate: size from the description plus a
   quick look at the code it touches; mark `(inferred)`. XL: suggest splitting.
   Already-done work counts: tickets with merged PRs need only the remaining steps (review, QA).
3. **Capacity:** working days from today (or sprint start) to the end, minus weekends, `days_off`,
   and meeting time; times `hours_per_day`.
4. **Order:**
   - Blockers of other tickets (yours or teammates') first.
   - Then priority.
   - Risky or unclear tickets early, so surprises surface while there's room.
   - Spread work so every ticket's code is done before the last `buffer_days`, which stay for
     review, QA and fixes. Reserve review turnaround: a PR opened on the last day rarely merges.
5. **Fit:** if it doesn't fit, say so first, with what to cut or raise (lowest priority, largest,
   least started).
6. Save the plan; in `guided`, show it and wait for approval before saving.

```markdown
# <board> — <sprint> (<start> → <end>)
Capacity: <h> h · Planned: <h> h · Buffer: <n> day(s) · Fits: yes | no (<what to cut>)
| Day | Ticket | Work | Size |
|---|---|---|---|
| Mon 10/12 | DEV-120 | implement + PR | M |
| Tue 10/13 | DEV-120 / DEV-121 | address review / start | — / L |
...
Risks: <unclear tickets, external dependencies>
Updated: <timestamp> (<reason>)
```

## day (`plan day`, default)
1. Load the current sprint's plan. None: offer `plan sprint` and stop.
2. Today's rows plus anything planned earlier that is not done.
3. **Real status** per ticket: tracker status + branch exists (all repos in `related_repos` and the
   current one) + PR state (open, changes requested, approved, merged) + CI state.
4. **Changes:** tickets added to or removed from the sprint since planning; re-estimates.
5. **Behind?** Compare done vs planned to date. If behind or the sprint changed, re-plan the
   remaining days with the same rules and update the file (`guided`: propose and ask first).

```
Today (Tue 10/13) — on track | behind by ~<h> h | ahead
- DEV-120 changes requested → address comments (dev-skills:address-comments)
- DEV-121 not started → implement (L, split across Tue-Wed)
Carried over: <ticket — why>
Sprint changes: <added/removed>
Re-planned: <yes — what moved | no>
```
