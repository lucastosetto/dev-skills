---
name: inbox
description: >-
  Messages waiting for you across your projects: Slack mentions, DMs and threads, comments on
  issues/tickets, and PR comments addressed to you, each with a draft reply. When a message asks
  you to do something (review a PR, look into a problem), it does it draft-only. Read-only apart
  from delivering the digest. Built for routines and scheduled runs too. Use on "any mentions",
  "what did people ask me", "check my messages", "/inbox".
argument-hint: "[since <date|time>]"
---

# Inbox

Follow `../../shared/policy.md` (including **Unattended runs** when started by a routine or
schedule). Reads only; everything people would see is a draft.

Only **messages** from people count. PR state (CI, conflicts, approvals) and review requests
without a message are not inbox items.

Config from `### inbox` (profile `## Mine`, then `defaults.md`):
- `deliver`: `chat` (default), `slack-dm` (send the digest to your own Slack DM, no approval
  needed), or `file <path pattern>` (`{date}` allowed, outside any repo).
- `channels`: Slack channels to scan for questions without a mention (e.g. on-call, support).

## 1. Window and scope
- **Since:** `since <...>`, else the time of the last digest (`~/.dev-skills/inbox/last-run`, or with
  `slack-dm` the last digest in your DM, which works in cloud runs), else the previous business
  day's start. Messages still unanswered are listed whatever the window; the window only decides
  what's marked **new**.
- **Projects:** every repo with a profile in `~/.dev-skills/profiles/` plus the current one. In a cloud run, the cloned repos. Trackers and PR hosts come from the profiles,
  or `project-profile` when missing.

## 2. Collect
Messages you haven't answered or reacted to as handled:
- **Slack:** mentions, DMs, new replies in threads you're in, new questions in `channels`.
- **Tickets** (`../../shared/references/trackers.md`): comments mentioning you or on tickets
  assigned to you.
- **PRs** (`../../shared/references/pr-hosts.md`): comments and review threads on your PRs, replies
  to your review comments, and comments mentioning you on any PR.

## 3. Triage
- Order: incidents and production questions, then people blocked on you, then the rest.
- One line per message: source, who, since when, the ask, next step.
- Draft a reply for each. A question about how the system behaves, a bug or an incident gets a
  quick read-only look at the code, ticket and logs first so the draft answers it.

## 4. Requests
When a message asks you to do something, do it draft-only with the matching skill and link the
result in the draft reply:
- "review / take a look at this PR": `dev-skills:pr-review` (or `re-review`). Unattended on GitHub:
  save it as a pending review; elsewhere keep it in the report.
- "why is X happening", a bug, an incident, a data question: `dev-skills:investigate`.
- A review comment asking for a code change on your PR: next step `dev-skills:address-comments`;
  not done here.
- Anything else: the draft reply says what you'd do; nothing is done.

## 5. Deliver
Write the digest per `deliver`, then save the run time to `~/.dev-skills/inbox/last-run` (create the
folder). Nothing else is sent.

```
Inbox — <date time> · since <window start> · <n> waiting
Urgent:
- Slack #oncall, Ana (20m, new): "checkout failing for EU" → looked: <finding> · draft: "<reply>"
Asks:
- Slack DM, Dan (1h): "can you review #52?" → pending review saved, 2 findings · draft: "Left 2 comments"
- <repo>#40, Bob (3h): "can we rename this?" → address-comments · draft: "<reply>"
- PROJ-120, Carol (1d): "<question>" → draft: "<reply>"
FYI:
- Slack thread #team, Eve: "<summary>" → no reply needed
Quiet: <sources checked with nothing new>
Gaps: <sources not reachable, e.g. Slack not connected>
```
Leave out empty sections. Then the confirmation list (replies, comments) per the policy.
