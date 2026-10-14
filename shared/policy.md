# dev-skills policy

Every dev-skills skill follows this file. It also applies to PR, ticket, comment, message, deploy
and shared-data actions taken outside a skill.

## Paths

| What | Where |
|---|---|
| Plugin data root | `~/.dev-skills/` |
| Project profile | `~/.dev-skills/profiles/<project-slug>.md` |
| Global defaults (user-written) | `~/.dev-skills/defaults.md` |
| Work outputs (context, spec, QA plan, investigation, repro scripts) | `~/.dev-skills/work/<project-slug>/<TICKET or short-slug>/` |
| Sprint plans | `~/.dev-skills/plans/<board-slug>/<sprint-slug>.md` |
| To Do state (report, items, cache) | `~/.dev-skills/todo/` |
| Worktrees | `~/.dev-skills/worktrees/<project-slug>/<branch>/` |
| Clones of repos with no local checkout | `~/.dev-skills/repos/<project-slug>/` |
| Tool notes (trackers, PR hosts, deploys, observability) | `<plugin root>/shared/references/*.md` |

`<project-slug>`: from `git remote get-url origin`, lowercased, protocol, credentials and `.git` dropped,
`/` and `:` replaced by `__` (e.g. `github.com__acme__api`). No remote: the repo folder's absolute
path the same way. Create folders as needed.

## Never write into a repo

Skill bookkeeping (profiles, notes, plans, specs, scratch scripts, learned gotchas) goes only under
`~/.dev-skills/`. Not in the repo, not in its `.claude/`, not in `.gitignore`, not in an
untracked file. Exceptions:
- Changes that are the task itself (code, tests, the repo's own docs), made in a worktree.
- Copying the main checkout's `.env` (and similar untracked local env files the project documents)
  into a worktree so it can boot and test.

## Autonomy

### Resolving the mode
First match wins:
1. The current request (`/dev-skills:implement PROJ-1 guided`, "be strict on this one").
2. A session switch made earlier in this conversation (`/dev-skills:mode guided`).
3. `mode:` under `## Mine` in the project profile.
4. Global mode given at session start (plugin option).
5. `balanced`.

### Checkpoints
"ask" means stop and get an answer. "list" means add it to the end-of-run confirmation list.

| Checkpoint | autonomous | balanced | guided |
|---|---|---|---|
| Reads: files, git, PR/ticket reads, log/metric/trace queries, GET requests, local test runs | go | go | go |
| Start/stop local services (follow the user's and project's CLAUDE.md) | go | go | go |
| Unclear requirement | assume, record it | ask once if it changes the work materially, else assume | ask before the spec |
| Approach, design, test strategy, naming, output format | decide, record it | decide, record it | ask: options plus a recommendation, and approve spec and QA plan |
| Edits within the planned scope | go | go | go |
| Edits outside the plan, new dependencies, migrations, deleting files | go, record it | ask | ask |
| Local commit | go | ask | ask |
| Rewriting history (rebase, amend, reset) on a branch you pushed | ask | ask | ask |
| Rewriting history on a local-only branch | go | ask | ask |
| Conflict that changes behavior | resolve, flag it | ask | ask on any non-trivial one |
| Declining a reviewer's request | decide, record it | decide, list it | ask per comment |
| **Push, open/update PR, PR comments, ticket create/edit/transition, Slack/email/any message, docs or pages in shared tools, non-GET requests to non-local hosts, writes to shared DBs/caches/queues, feature flags, staging deploy** | **list** | **list** | **list** |
| **Production deploy or rollback** | **list, every time** | **list, every time** | **list, every time** |

Bold rows never loosen. These checkpoints sit on top of Claude Code's own permission prompts and
never bypass them. Never run commands against production data stores yourself: write read-only
console commands and hand them to the user.

In `autonomous` and `balanced`, do not stop mid-run for decisions: record them and keep going.
In `guided`, ask at each checkpoint as it is reached.

Ask outside these checkpoints only when truly blocked: a required input is missing and no source
can supply it (e.g. no ticket given and none can be inferred).

### Confirmation list
Collect every "list" action as a numbered draft and show them together at the end of the run:

```
Ready to send (reply with numbers, "all" or "none"):
1. Push branch proj-123-foo to origin
2. Open PR "PROJ-123: ..." into main — description below
3. Comment on PROJ-123: "..."
```

- Show the full text of anything that will be read by people.
- Include caveats from the profile that touch the action (e.g. "deploy prod — note: run billing
  backfill after").
- Execute only the approved items, each with one tool. If a call fails, do not retry it with a
  different tool (the first may have gone through): report the failure.
- Reply with links to what was created.

### Unattended runs
A run started by a routine, a scheduled task or a loop, or a request that says "unattended", has
no one to answer:
- Never stop to ask: every "ask" checkpoint becomes "list".
- Never execute the confirmation list: put it in the report for the user to approve later.
- Writes allowed without approval: local ones the mode allows, the report delivery the user
  configured (e.g. `deliver: slack-dm` to their own DM, or a file), and drafts only the user can see
  (e.g. a GitHub *pending* review, which stays invisible until they submit it).
- Don't boot apps or start local services unless the run's prompt says to.

## Writing for people
PR descriptions, comments, replies, tickets, questions:
- Short. Lead with the point. No preamble, no restating the code.
- For a problem: what is wrong, one concrete case, the fix.
- For a question: the question, why it matters, the assumption used meanwhile.
- Follow the project's templates and conventions (PR template, ticket fields) from the profile.

## Project config
Read the profile's `## Discovered` facts and the `## Mine` notes for the current skill. Precedence:
`## Mine` (project) > `~/.dev-skills/defaults.md` (global) > discovered > the skill's default.
Apply notes without asking. When the user says "remember for this project: X", add it under
`## Mine` → `### <skill>` (or `### general`) in the profile. When they say "remember everywhere: X",
add it to `defaults.md`. Neither needs confirmation.

## Tools
- Find tools by capability, not by hardcoded name: use ToolSearch with keywords (e.g. "jira issue",
  "linear issue", "bitbucket pull request", "grafana loki", "sentry issue", "slack message").
- Pick the environment that matches the task (e.g. a `-prod` server for a production incident).
- A missing source is a gap to report with what would close it, never a reason to guess.
- When the profile lists a project skill for a step (e.g. a project `deploy-to-staging` skill),
  run that skill for the step instead of the generic instructions.
- Cheap first: check whether anything changed before heavy work, and stop early when nothing did.
  Batch reads per source (one search or list call for all items), never one call per item.

## Reports
Start every final report with one line: `Mode: <mode> (<source>) · Profile: <path>`.
Then the skill's own format. End with `Assumed:` (decisions made without asking, one per line)
when there are any, then the confirmation list when there is one.

### Compact by default
Every report (chat, file, Slack digest) is as short as it can be while still useful. This
overrides longer formats in the skills: keep their sections, cut their length.
- First line after the header: the outcome (done / found / blocked) in one sentence.
- Then only what the user must act on or decide. One line per item, fragments fine.
- No preamble, no restating the request, no recap of steps taken, no "checked and fine" lists,
  no empty sections. Links and keys instead of quotes.
- `Assumed:` only for decisions that change the result.
- Evidence, queries, traces, file lists and reasoning go to the skill's work file when it writes
  one; end with `Details: <path>`. Otherwise keep them for when the user asks.
- Drafts for other people (confirmation list) are shown in full, and are short themselves.
- Show each draft exactly as it will be posted, byte for byte: any footer, signature, mention or
  template text included. Post that exact text; never add to it after approval.
- The user can ask for more ("details", "expand 2", "show the evidence"): then give the full version.
