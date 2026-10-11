---
name: investigate
description: >-
  Read-only root-cause investigation of any reported problem (bug, incident, error traceback,
  support ticket, Slack thread, customer complaint, unexpected data or behavior), proven with the
  project's own logs, metrics, traces, error tracker and data. Considers software, client action,
  data/config, third party and working-as-designed causes. Ends with drafted ticket and support
  reply for confirmation. Use on "investigate", "debug", "look into", "diagnose", "root cause",
  "why did this happen", "/investigate", or a pasted problem report.
---

# Investigate

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Goal: explain **why** it happened, proven with data. Output is a finding, not a fix.

## Rules
- **No changes:** no code edits, commits, branches, PRs, ticket changes, messages, or writes to any
  shared DB/cache/queue/service. Local dev data during a local repro is fine. If the fix is obvious,
  name it in one line.
- **Every claim needs data**, including claims in the report itself ("it's the cron", "we changed
  nothing", "customer X has no Y"), from teammates, clients, bots or AI triage. They are
  hypotheses until a log line, metric, trace, record or code read backs them. Mark each
  confirmed / partly / refuted / unverified.
- **Never run commands against production yourself.** Hand read-only console commands to the user.
  MCP read tools (logs, metrics, traces, tickets) are fine to call directly.

## 1. Frame the case
Run `dev-skills:gather-context` on the inputs. Then write 3-5 lines: **who** (tenant/user/record ids),
**what**, **expected vs actual**, **when** (timestamp + timezone, or a window), **scope** (one client
or many). List each claim as H1, H2..., and add competing explanations from every category:
- Software: bug, regression, race, bad deploy.
- Client/user action: wrong input, misuse, steps out of order, their integration or config wrong,
  stale info. Their expectation may be the wrong part.
- Data/config: record state, flag, account/plan settings, migration leftovers.
- Third party/infra: provider outage, webhook delay, rate limit, capacity.
- Working as designed: correct per code/docs; the gap is docs, UX or communication.

## 2. Trace the code
Entry point → logic → data layer (plus jobs, webhooks, frontend). `file:line` for each decision point
that could produce the symptom, including validations the client's input could hit. `git log` on those
files around the incident time.

## 3. Evidence
Use `dev-skills:observe` for the target and window, plus:
- **What the client actually did:** their exact requests (params, order, timing, client), audit or
  activity logs, compared with what they say they did.
- Deploys, annotations, alerts in the window.
Quote the decisive line or number. Empty results count as evidence after checking labels and timezone.

## 4. Data (handed to the user)
When the answer depends on record state, give copy-paste **read-only** console commands (see the
profile's `console`), each noting which hypothesis it tests. Only reads (`find`, `where`, `count`,
`pluck`, `exists?`, `values_list`, history tables). Prefer change history (PaperTrail versions,
django-simple-history, audit logs) to tell client action from system action. Small output, no PII
dumps. Wait for the pasted output and iterate.

## 5. Reproduce (when it helps)
For a suspected software cause, run `dev-skills:qa` in `repro` mode with the client's exact steps or
payload. A matching failure is the strongest evidence; a clean run points back to data/config/client.

## 6. Conclude
The root cause must explain every observed fact (who, when, scope); if not, keep digging or say so.
Separate the **trigger** from the **root cause**. When the client caused it, say so plainly with
evidence, and note whether the product made the mistake easy.

## 7. Drafts
- **Ticket:** when the cause is a confirmed bug and no ticket exists (search the tracker first):
  draft title, description (problem, root cause with `file:line`, impact, fix direction), and fields
  per the tracker. Confirmation list.
- **Support reply:** when the input came from a support thread or customer: what happened, why, what
  happens next, in plain words for the audience, without internal details they don't need.
  Confirmation list.

## Output
Save `investigation.md` (and the final repro script, if any) in the work folder. Print:

```markdown
Mode: <mode> (<source>) · Profile: <path>
# <issue> — <one-line title>
**Problem:** <who / what / expected vs actual / when>
**Category:** software | client action | data/config | third party/infra | working as designed
**Root cause:** <mechanism, 1-3 lines> — `path:LINE`
**Trigger:** <event that set it off, if different>
**Evidence:**
- Code: `file:line` — <what it does>
- Client activity: <what they did vs reported | n/a>
- Logs/errors: <decisive line or count | none in window>
- Metrics/traces: <change + time; this client vs everyone | n/a>
- Data (user-run): <result | pending>
- Local repro: <reproduced | not reproduced | skipped> — <how>
**Claims:** H1 "<claim>" — confirmed | partly | refuted | unverified — <evidence>
**Impact:** <affected clients/records, how counted>
**Fix direction (not applied):** <one line>
**Gaps:** <missing source or question + the query that would close it>
<confirmation list: ticket draft, support reply draft>
```
With incomplete evidence, say so and give the single next step. Never present a hypothesis as the cause.
