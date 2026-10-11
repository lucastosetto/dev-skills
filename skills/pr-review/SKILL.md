---
name: pr-review
description: >-
  Review someone else's pull/merge request (GitHub, Bitbucket, GitLab) for what matters only: bugs,
  bad edge-case handling, security, performance regressions, missing tests for risky paths. Checks
  the linked ticket's requirements. re-review mode checks a follow-up round: were the requested
  changes addressed. Drafts comments; posts only what the user approves. Use on "review PR <n>",
  "/pr-review <url>", "re-review", "check if they addressed my comments".
argument-hint: "<pr url|number> [re-review]"
---

# PR review

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. Fetch
- PR metadata, diff, **target branch** (may be a stacked branch, not the default branch).
- `git fetch origin <head> <base>`; read full files with `git show "origin/<head>:<path>"` (quote the
  ref). Never review from the diff alone.
- Project rules: repo `CLAUDE.md`, `CONTRIBUTING`, `.claude/rules/`, and the profile's `### pr-review` notes.
- **Requirements:** find ticket keys in the title, branch, description and commits. If found, run
  `dev-skills:gather-context` on the ticket; if none, review against the PR description alone.

## 2. Mode
- **review** (default): full pass, steps 3-4.
- **re-review** (or the user already reviewed this PR): fetch your earlier review threads and the
  commits pushed after your last review. For each of your threads: addressed / partly / not
  addressed / answered with a reason (judge whether the reason holds). Then review only the new diff.
  Do a full pass again only if the new changes are large (rewrote the approach, many new files) or
  touch a critical path; say which you did.

## 3. Verify, don't guess
- Trace every changed function's callers and the data flowing in: filters already applied upstream,
  callbacks/validations that normalize values, other paths that bypass the change.
- A finding needs a concrete failure scenario: inputs/state → wrong result, crash, or slowdown.
  No scenario, no finding.
- Test the PR description's stated assumptions against the code.
- Check acceptance criteria from the ticket: any not implemented or implemented differently?

## 4. Filter hard
Report only:
- Correctness bugs, data loss/corruption, race conditions, broken edge cases.
- Security/authz holes (tenant scoping, IDOR, injection, secrets).
- Requirements not met, or features that silently don't work in a reachable case.
- Performance regressions on real paths (N+1, unbounded loads, missing index for a new query, extra
  calls per request/loop, quadratic work on growing data), with likely scale and a cheaper alternative.
- Missing tests for a risky path the PR changes.
Do not report: style, naming, refactors, polish, test nits, speculative micro-optimizations, things
the author called out as deliberate limits, or a "checked and fine" list.

## Output
```
Mode: <mode> (<source>) · Profile: <path>
PR <link> — <title> → <target> · Requirements: <ticket link | PR description only>
Re-review: <thread — addressed/partly/not addressed/answered> (re-review only)
Findings:
1. `file:line` — <claim>. Scenario: <...>. Fix: <...>. Test: <missing test, if relevant>
Verdict: approve | approve with nits skipped | request changes
```
No findings: one line saying so.

Then the confirmation list: one draft inline comment per finding (problem, one scenario, the fix;
no preamble), on the most relevant line of the **new** file version, plus the review verdict
(approve / request changes) when the user wants it submitted. Follow project PR-comment rules from
the profile if present. Post only approved items, one tool each, no retries with another tool.
