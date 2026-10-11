---
name: observe
description: >-
  Check how a feature, endpoint, job or deploy is behaving in an environment: logs, metrics
  (rate/errors/latency), traces, error tracker, product analytics and experiments, compared to a
  baseline, ending in a health report. Use on "monitor this feature", "how is X doing in prod",
  "anything wrong after the deploy?", "check errors for Y", "experiment results", "/observe".
argument-hint: "<feature|endpoint|ticket|deploy> [env] [window]"
---

# Observe

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.
Reads only. Tool notes: `../../shared/references/observability.md`.

## 1. Frame
- **Target:** turn the feature/ticket into concrete signals: routes, controllers, job classes,
  event names, flag names, log messages (read the code to find them).
- **Environment:** default prod; match the profile's per-environment tools.
- **Window:** given, or since the feature's deploy (find it: merge time, deploy annotation, release
  list), or the last 24h. **Baseline:** the same window a week earlier, or the window before the deploy.

## 2. Collect
For target and baseline:
- Traffic, error rate, p95/p99 latency for the routes/jobs.
- Error tracker: new issues and their counts, first-seen vs deploy time.
- Logs: error/warning patterns for the target, volume change.
- Traces: slowest and failing spans for the target.
- Jobs/queues: failures, retries, queue depth.
- Analytics/experiments (if connected): event counts, funnel steps, variant metrics with sample sizes.
A source not connected is listed under Gaps with the exact query the user could run.

## 3. Judge
Separate real change from noise: compare with baseline, check whether a change is only this target
or system-wide, and line up with deploys and incidents in the window.

## Output
```
<target> — <env> — <window> vs <baseline>
Verdict: healthy | degraded | broken | not enough data
- Traffic: <n> (<±%>)
- Errors: <rate> (<±%>); new issues: <title — count — first seen>
- Latency p95: <ms> (<±%>)
- Analytics: <metric — change>
Findings: <one line each with numbers and a link>
Next: <nothing | run dev-skills:investigate on <finding> | rollback candidate>
Gaps: <missing source — query to close it>
```
When called by `deploy`, return the verdict and findings only.
