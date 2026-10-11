---
name: project-profile
description: >-
  Load, discover or update the current project's dev-skills profile: issue tracker, PR host, base
  branch, CI, test/lint/boot commands, staging and production deploy, feature flags, observability,
  analytics, console access, API docs and project-specific skills, plus the user's own notes. Every
  dev-skills skill runs this first. Also use when the user says "remember for this project: ...",
  "show project profile", "refresh profile", or a profile fact turns out to be wrong.
---

# Project profile

Follow `../../shared/policy.md` (relative to this skill's folder).

## 1. Locate
Compute `<project-slug>` (see policy "Paths") for the repo at the current working directory, or
the repo the task is about. The profile is `~/.claude/dev-skills/profiles/<project-slug>.md`.
Worktrees of the same repo share the slug, so they share the profile.

## 2. Load or discover
- **Exists:** read it. Done, unless the caller needs a field that is `unknown`: discover just that
  field (step 3) and update the file.
- **Missing:** discover everything (step 3), write the file (step 4), and print a 5-10 line summary.
  Do not ask the user to confirm anything: inferred facts are marked `inferred`.

## 3. Discover
Reads only. Record each value with its source (`file:line`, command, or `user`) and confidence
(`confirmed` when read directly from config or code, `inferred` when guessed from signals).

| Field | Signals |
|---|---|
| `pr_host` | `git remote get-url origin` host; tool available (`gh`, `glab`, Bitbucket MCP via ToolSearch) |
| `tracker`, `ticket_key` | ticket keys in `git branch -a` and recent `git log` subjects; `.github/ISSUE_TEMPLATE`; links in README/CONTRIBUTING; connected tracker MCPs (ToolSearch "jira", "linear") |
| `base_branch`, `branch_naming`, `pr_template` | `git symbolic-ref refs/remotes/origin/HEAD`; recent branch names; `.github/pull_request_template.md` or similar; docs |
| `ci` | `.github/workflows`, `bitbucket-pipelines.yml`, `.gitlab-ci.yml`, `.circleci` |
| `commands.test`, `commands.lint`, `commands.boot`, `commands.setup` | repo `CLAUDE.md`, `README`, `CONTRIBUTING`, `docs/`, `package.json` scripts, `Makefile`, `Procfile`, compose files, pre-commit config |
| `env_files` | `.env.example`/`.env.sample` and which untracked env files the docs say to create |
| `deploy.staging`, `deploy.prod`, `deploy.order` | see `../../shared/references/deploy.md` "Finding the method"; docs; deploy scripts |
| `flags` | dependency files (see deploy.md "Feature flags") |
| `errors`, `logs`, `metrics`, `traces`, `apm` | dependencies (sentry, rollbar, honeybadger, bugsnag, ddtrace, newrelic, opentelemetry, prometheus client); connected MCPs (ToolSearch "grafana", "sentry", "datadog"), mapped per environment |
| `analytics` | amplitude, mixpanel, segment, posthog, statsig, growthbook dependencies |
| `console` | `Gemfile` → Rails, `manage.py` → Django, ORM REPL; how prod console is reached if documented |
| `api_docs` | `openapi.*`, `swagger.*`, Postman collections (`*.postman_collection.json`), `docs/api`, API sections in README |
| `docs_tool`, `chat_tool` | connected Notion/Confluence/Google Drive, Slack MCPs |
| `project_skills` | `.claude/skills/*/SKILL.md` and `.claude/commands/*.md` in the repo: name + one-line purpose, and which dev-skills step each replaces (e.g. a staging deploy skill → `deploy staging`) |
| `related_repos` | sibling repos with profiles that share the same tracker board; frontend/backend pairs under one parent folder |

Leave a field `unknown` rather than guessing without a signal.

## 4. File format
```markdown
# <project-slug>
Repo: <absolute path of main checkout> · Updated: <YYYY-MM-DD>

## Discovered
<!-- Rewritten by project-profile. Edit ## Mine instead. -->
- pr_host: github (gh) — git remote · confirmed
- tracker: jira, key DEV-\d+ — branch names · inferred
- commands.test: bin/rails test — README.md:42 · confirmed
- deploy.staging: project skill deploy-to-staging — .claude/skills · confirmed
- metrics: grafana-prod (prod), grafana-dev (staging) — connected MCPs · inferred
- analytics: unknown

## Mine
<!-- Yours. Never rewritten. A key here overrides the same key above. -->
### general
### implement
### deploy
### standup
### plan
```

Rewrite only `## Discovered`. Never change `## Mine` except to append a note the user asked to
remember (policy "Project config") or a `mode:` line set by `/dev-skills:mode ... project`.

## 5. Keep it right
When a skill's command from the profile fails (wrong test command, missing tool), rediscover that
field, update it, and mention the change in one line.

## Output
For the caller: the facts it needs. For the user: the summary only when the profile was created or
changed. When the user asked to see it, print the file.
