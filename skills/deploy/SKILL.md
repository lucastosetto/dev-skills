---
name: deploy
description: >-
  Deploy to staging or production the way this project does it. staging: ship the current branch to
  the shared/dev environment. prod: build the changelog (what ships, dependencies, migrations,
  deploy order, post-deploy tasks), deploy after confirmation, smoke test read-only, monitor, and
  roll back (flag off, platform rollback, revert PR) if the deploy caused a problem. Use on "deploy to
  staging", "ship to dev", "what will ship?", "release to production", "deploy prod", "roll back",
  "/deploy staging", "/deploy prod".
argument-hint: "staging|prod [changelog|rollback]"
---

# Deploy

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Methods, flags and rollback options: `../../shared/references/deploy.md`.
Apply the profile's `### deploy` notes (caveats, order, post-deploy tasks) and show the relevant ones
in each confirmation line. If the profile names a project skill for a step, run it for that step.

## staging
1. Method from the profile (`deploy.staging`). Unknown: discover it (deploy.md), else report the gap.
2. Make sure the branch is committed and pushed (push goes on the confirmation list).
3. Prepare locally what can be prepared: e.g. for a shared staging branch, merge the feature branch
   into an up-to-date local copy of it; conflicts via `dev-skills:resolve-conflicts`. Never reset or
   rewrite a shared staging branch.
4. Confirmation list: the push/trigger that deploys.
5. After approval: follow the pipeline (CI status via the host's CLI/MCP) and report the result and URL.

## prod
### 1. Changelog (`/deploy prod changelog` stops here)
- Find what is in production now (deploy.md "What is in production") and the ref to ship (default
  branch head unless given).
- `git log <prod ref>..<ship ref>`: group into PRs and tickets; one line each with author.
- Flag for attention: migrations (and whether they are backward compatible with the running code),
  new env vars/config, new dependencies, feature flags to create or flip, data backfills/rake/
  management tasks, cron/job changes, API contract changes that other apps consume.
- Cross-app dependencies: tickets or PRs in `related_repos` that must ship first or together; the
  profile's `deploy.order` and notes.
- Post-deploy tasks: from PR descriptions, migration notes and profile notes.
```
Shipping <ship ref> over <prod ref> (<n> PRs)
- <PR link> <title> — <ticket> — <author>
Attention:
- Migration <name>: <safe | needs X first>
- Env var <NAME> must exist in prod
Order: <app A → app B | n/a>
After deploy: <task commands>
```

### 2. Deploy
Confirmation list (always, every mode): the exact trigger (command, workflow run, promote, merge),
plus env/config changes and pre-deploy tasks in order. After approval, run it and follow the pipeline
until it finishes; report failures with the decisive log line.

### 3. Verify
- **Smoke test, read-only:** load the main pages and the changed flows with the browser and GET the
  changed/critical endpoints. Never submit forms, create, update or delete anything in production.
- **Monitor:** run `dev-skills:observe` comparing after vs the hour before the deploy, focused on the
  changed areas plus global error rate and latency. Repeat at about 5, 15 and 30 minutes after the
  deploy (or the profile's schedule), using scheduled wakeups if the session supports them.
- Post-deploy tasks: run the ones that are local/read-only; queue the rest (data tasks in prod are
  handed to the user or confirmation-listed).

### 4. Rollback (also `/deploy prod rollback`)
When verification shows a problem caused by this deploy (evidence: started at deploy time, in changed
code, not system-wide before):
- Pick the fastest safe option from deploy.md "Rollback options" (flag off first when available;
  check migration compatibility before a platform rollback).
- Confirmation list, every mode, with the evidence in one line. Execute after approval, then observe
  again to confirm recovery.
Not caused by the deploy: say so with the evidence and suggest `dev-skills:investigate`.

## Report
```
Mode: <mode> (<source>) · Profile: <path>
<env> — <ship ref> — <status>
Changelog: <n PRs> (above)
Smoke: <pass | failures>
Monitor (+5/+15/+30m): <verdicts>
Rollback: <not needed | proposed | done — how>
<confirmation list>
```
