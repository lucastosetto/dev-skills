---
name: inbox
description: >-
  What needs you right now, across your projects: your PRs that need action (changes requested,
  new comments, failing CI, conflicts, approved but not merged), PRs waiting for your review or
  re-review, and Slack/tracker mentions and questions, each with a draft reply or next step.
  `deep` also prepares the work: drafts reviews, comment fixes and investigations. Read-only apart
  from delivering the digest. Built for routines and scheduled runs too. Use on "what needs me",
  "check my PRs", "any mentions", "follow up on my PRs", "/inbox".
argument-hint: "[deep] [here] [since <date|time>]"
---

# Inbox

Follow `../../shared/policy.md` (including **Unattended runs** when started by a routine or
schedule). Reads only; everything people would see is a draft.

Config from `### inbox` (profile `## Mine`, then `defaults.md`):
- `deliver`: `chat` (default), `slack-dm` (send the digest to your own Slack DM, no approval
  needed), or `file <path pattern>` (`{date}` allowed, outside any repo).
- `review_wait`: how long your PR may wait for review before it's flagged (default 1 business day).
- `channels`: Slack channels to scan for questions without a mention (e.g. on-call, support).

## 1. Window and scope
- **Since:** `since <...>`, else the time of the last digest (`~/.dev-skills/inbox/last-run`, or with
  `slack-dm` the last digest in your DM, which works in cloud runs), else the previous business
  day's start. Items still open are always listed, whatever the window; the window only decides
  what's marked **new**.
- **Projects:** every repo with a profile in `~/.dev-skills/profiles/` plus the current one (`here`:
  current repo only). In a cloud run, the cloned repos. Trackers and PR hosts come from the profiles,
  or `project-profile` when missing.

## 2. Collect (`../../shared/references/pr-hosts.md`, `trackers.md`)
**Your PRs** (open): state, review decision, threads unresolved and new since the window, CI,
mergeability or conflicts with the target branch, approved but not merged, waiting longer than
`review_wait`.

**Waiting on you:** PRs where your review is requested and not given; PRs you reviewed that got new
commits or replies since your review (re-review).

**Mentions and questions:** Slack mentions, DMs, and threads you're in with new replies that you
haven't answered; new questions in `channels`; tracker comments mentioning you; tickets newly
assigned to you. Skip what you already answered or reacted to as handled.

## 3. Triage
- Order: incidents and production questions, then people blocked on you (review requests, direct
  questions), then your PRs, then the rest.
- One line per item: what, who is waiting, since when, next step.
- Draft a reply for each question or mention. A question about how the system behaves, a bug or an
  incident gets a quick read-only look at the code, ticket and logs first so the draft answers it.

## 4. `deep`: prepare the work
Read-only and local only; nothing is posted or pushed:
- Waiting reviews: run `dev-skills:pr-review` (or `re-review`). Unattended on GitHub: save it as a
  pending review; elsewhere keep it in the report.
- Your PRs with comments: run `dev-skills:address-comments` up to local commits in its worktree;
  replies and push go on the confirmation list.
- Failing CI: find the cause from the logs; a fix is prepared the same way.
- Conflicts: run `dev-skills:resolve-conflicts` in the worktree, no push.
- Questions that need digging: run `dev-skills:investigate`.

## 5. Deliver
Write the digest per `deliver`, then save the run time to `~/.dev-skills/inbox/last-run` (create the
folder). Nothing else is sent.

```
Inbox — <date time> · since <window start> · <n> need you
Urgent:
- #oncall: "checkout failing for EU" (Ana, 20m, new) → looked: <finding> · draft: "<reply>"
Waiting on you:
- Review <repo>#45 "<title>" (Bob, 1d) → pending review saved, 2 findings
- Re-review <repo>#51 (3 new commits) → threads addressed: 2/3
Your PRs:
- <repo>#40 changes requested (2 new comments) → fixes committed locally in <worktree>
- <repo>#38 CI failing: <test> → cause: <...>
- <repo>#36 approved, not merged
Mentions:
- PROJ-120 comment from Carol: "<question>" → draft: "<reply>"
Quiet: <sources checked with nothing new>
Gaps: <sources not reachable, e.g. Slack not connected>
```
Leave out empty sections. Then the confirmation list (replies, comments, pushes) per the policy.
