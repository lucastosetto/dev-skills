---
name: implement
description: >-
  Implement a ticket end to end in an isolated git worktree: read requirements, spec, QA plan,
  code, verify, document, commit locally, then queue push, staging deploy and PR for confirmation.
  Works in any repo with any tracker. Use when the user gives a ticket key/URL or requirements and
  says "implement", "build this", "fix this bug", "work on this ticket", "pick this up", "/implement".
argument-hint: "<ticket key|url|description> [autonomous|balanced|guided]"
---

# Implement

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Input: a ticket key/URL or a written requirement. With none given and none inferable from the
conversation or current branch name, ask for it (the only upfront question).

## 1. Requirements
Run `dev-skills:gather-context`. Blockers that make the work impossible: stop and report. Unknowns:
handled by the mode inside gather-context.

## 2. Worktree
- Branch name: the profile's `branch_naming` (else `<ticket-key-lowercase>-<short-slug>`), from the
  up-to-date base branch (`git fetch origin <base>`).
- Create it outside the repo: `git worktree add ~/.dev-skills/worktrees/<project-slug>/<branch> -b <branch> origin/<base>`.
  Reuse it if it already exists for this ticket.
- Copy the main checkout's env files (profile `env_files`) into it.
- From here, every command runs in the worktree (absolute paths or `cd <worktree> && ...`).
  The user's main checkout is never touched.

## 3. Plan
Run `dev-skills:spec` (which runs `dev-skills:qa-plan`). For a small, obvious change (one or two
files, no contract or data change), a short plan in `spec.md` is enough; still write the test cases.
In `guided`, both are approved before coding.

## 4. Code
Smallest change that solves the ticket at the root cause, in the surrounding code's style, reusing
existing helpers. Whole ticket scope; if part is blocked, do the rest and report what is left.
Add/adjust the automated tests from the QA plan. Comments only for non-obvious code.
Out-of-plan edits, new dependencies, migrations, deletions: per the mode.

## 5. Verify
Run `dev-skills:qa` in `verify` mode against the QA plan and acceptance criteria. Fix what the
change broke and re-run. Never claim green on unverified work.

## 6. Document
If the change touches an API or documented behavior, run `dev-skills:document`.

## 7. Commit
Commit locally per the mode (`balanced`/`guided` ask; `autonomous` commits). Message: the repo's
convention from `git log`, referencing the ticket key.

## 8. Queue what leaves the machine
Add to the confirmation list, as applicable:
- Push the branch.
- Staging deploy, when the profile says this project deploys feature branches to staging
  (`dev-skills:deploy staging`, or the project skill the profile names).
- Open the PR: target = base branch; title and body following the profile's PR template (else:
  what changed and why, how it was tested, risks, ticket link). Show the full body.
- Ticket transition/comment only if the profile says the team does that on PR open.

## Report
```
Mode: <mode> (<source>) · Profile: <path>
<TICKET> — <title>
Worktree: <path>  Branch: <name>  Commit: <sha | not committed>
Changed:
- `file:line` — what and why
Checks: <command> → pass/fail
Criteria: <n/m met> (details from qa)
Left out: <scope skipped and why | none>
Assumed:
- ...
<confirmation list>
```
Leave the worktree in place. Remove it (`git worktree remove`) only when the user asks.
