# dev-skills

Claude Code skills for the whole engineering loop, from reading a ticket to watching it in
production. They work in any repo: each project's issue tracker, PR host, deploy method, feature
flags and observability are discovered once and cached in a profile outside the repo.

## Install

```bash
claude plugin install dev-skills --marketplace lucastosetto/dev-skills --config mode=balanced
```

Or inside Claude Code: `/plugin marketplace add lucastosetto/dev-skills`, then `/plugin install dev-skills`.

## Skills

| Skill | What it does |
|---|---|
| `implement` | Ticket → worktree → spec + QA plan → code → verify → docs → local commit → push/PR (confirmed) |
| `investigate` | Read-only root cause with logs, metrics, traces and data; drafts the ticket and support reply |
| `pr-review` | Critical-only review against the linked ticket; `re-review` checks follow-up rounds |
| `address-comments` | Works through review comments on your PR, follows the reviewer by default |
| `deploy` | `staging` or `prod`: changelog, deploy, read-only smoke test, monitoring, rollback |
| `inbox` | What needs you now: your PRs, reviews waiting on you, mentions and questions, with drafts; `deep` prepares the work |
| `sprint` | Day-by-day sprint plan over business days; `today`: today's tickets and their real status |
| `standup` | Short bullet update since the last daily from commits, PRs, reviews, tickets and sessions |
| `demo` | Presentation-friendly walkthrough of an implementation |
| `spec` | Implementation spec, or `rfc` for a structured RFC |
| `qa-plan` | Automated (unit/integration/E2E) and manual QA plan |
| `qa` | Runs checks and acceptance criteria; boots the app and drives it for real |
| `gather-context` | Reads tickets, docs and threads; maps code, criteria, unknowns, blockers |
| `observe` | Health of a feature or deploy vs a baseline |
| `document` | Updates the project's API docs (OpenAPI, Postman, README) and gives curl examples |
| `resolve-conflicts` | Judgment-based git conflict resolution with a report |
| `project-profile` | Discovers and caches the project's setup; holds your notes |

Commands are prefixed: `/dev-skills:implement PROJ-123`.

## Autonomy modes

| Mode | Asks before |
|---|---|
| `autonomous` | Only actions that leave your machine or change shared data |
| `balanced` (default) | The above, plus commits, out-of-plan changes, new dependencies, migrations, deletions, behavior-changing conflicts |
| `guided` | The above, plus approving the spec and QA plan and choosing between approaches |

Push, PRs, comments, tickets, messages, deploys, flags and shared-data writes are confirmed in every
mode, collected into one list at the end of the run. Production deploys and rollbacks are always
confirmed.

Switch with `/dev-skills:mode <mode>` (this session), `/dev-skills:mode <mode> project` or
`/dev-skills:mode <mode> global`, or add the mode to a single request: `/dev-skills:implement PROJ-123 guided`.

## Your config

Everything lives in `~/.dev-skills/`; nothing is ever written into your repos (except the
task's own changes, and env files copied into worktrees).

- `profiles/<project>.md`: `## Discovered` is maintained automatically; `## Mine` is yours, with a
  subsection per skill. Example:
  ```markdown
  ## Mine
  ### deploy
  - Run `rake billing:backfill` after any deploy touching billing.
  - Deploy api before web when both ship.
  ### standup
  - daily_time: 09:30
  - output: file ~/Documents/standups/{date}.md
  ### sprint
  - days_off: 2026-10-20
  ### inbox
  - deliver: slack-dm
  - channels: #oncall, #support
  ```
  Or just say "remember for this project: ...".
- `defaults.md`: the same sections, applied to every project.
- `work/`, `plans/`, `worktrees/`, `inbox/`: specs, investigations, sprint plans, worktrees and the last inbox run.

## Routines and scheduled runs

Skills work unattended (cloud routines, desktop scheduled tasks, `/loop`): they never stop to ask,
never send anything you haven't approved, and put the confirmation list in their report. For
example, a weekday hourly routine with the prompt `Run /inbox deep` and `deliver: slack-dm`.

## Requirements

- `git`; `gh` / `glab` or the Bitbucket MCP for your PR host.
- MCP servers for what your team uses (Jira/Linear, Grafana/Sentry, Slack, Notion...). Missing ones
  are reported as gaps, never guessed.

## License

MIT
