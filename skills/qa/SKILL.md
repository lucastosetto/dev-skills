---
name: qa
description: >-
  Verify or reproduce behavior for real: run the project's tests, linters and type checks, check
  each acceptance criterion pass/fail, and boot the app locally (backend and/or frontend) to drive
  HTTP requests and a headless Playwright browser. Use on "test this", "verify", "run the QA plan",
  "test locally", "reproduce this bug locally", "does it work?", "/qa".
argument-hint: "[verify|repro] [qa-plan path|scenario]"
---

# QA

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.
Project-agnostic: discover how the project works from the profile and its docs; don't assume a stack.

**Modes:** `verify` (default when the branch has changes): prove the work meets its criteria.
`repro`: reproduce a reported scenario (used by `investigate`).

## 1. What to check
In order of preference: a QA plan given or found in the work folder; acceptance criteria in
`context.md`; the conversation; the branch diff against the base branch.

## 2. Automated checks
Run the profile's `commands.test` scoped to the touched area first, then the wider suite if fast
enough, then `commands.lint` / type checks / pre-commit hooks. Fix failures your change caused (when
called from a workflow that owns the change); report others as pre-existing with the decisive line.

## 3. Real run (when a criterion needs it)
Skip when automated tests already prove every criterion; say so.
- **Layout:** the project may be one app or frontend + backend as sibling/child folders. Signals:
  `package.json` with dev script, `vite.config.*`, `next.config.*` (frontend); `Gemfile`,
  `manage.py`, `pyproject.toml`, `go.mod` (backend); compose files, `Procfile`, `Makefile`.
- **Services:** follow the user's and project's `CLAUDE.md` for local services (check before
  starting, stop what you started).
- **Env:** in a worktree, copy the main checkout's env files listed in the profile (`env_files`).
- **Boot:** documented commands first. Backends before frontends; point the frontend at the local
  backend. Run servers in the background with logs to a file in the work folder.
- **API:** curl or a short script; assert status and response shape.
- **UI:** Playwright headless against the local URL with a seeded/known login (seed files or test
  credentials from the project's fixtures, never real credentials).
- `repro`: confirm the symptom first; `verify`: confirm the expected behavior (and, for a bug fix,
  that the symptom is gone).

## 4. Gotchas
- Port in use: `lsof -nP -iTCP:<port> -sTCP:LISTEN`; don't kill unrelated processes, use another port.
- macOS AirPlay Receiver holds port 5000.
- Stale servers from earlier runs: reuse or stop them.
- Per-tenant subdomains: `lvh.me` / `127.0.0.1.nip.io` resolve to localhost.
- Boots but 500s: usually missing env/config.
New project-specific gotchas you hit go under `## Mine` → `### qa` in the profile, never in the repo.

## Output
```
Checks: <command> → pass | fail (<decisive line>)
Criteria:
- [x] AC1 <text> — <evidence: test name, request/response, screenshot path>
- [ ] AC2 <text> — <what failed>
Real run: <done | skipped (why)> — tiers: <backend/frontend>
```
Keep only the final useful repro script, in the work folder. Tear down servers you started.
