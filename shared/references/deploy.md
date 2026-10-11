# Deploys, flags and rollback

A project-specific deploy skill listed in the profile always wins over these notes. Every deploy and
rollback goes through the confirmation list.

## Finding the method
| Signal | Method |
|---|---|
| `Procfile`, `app.json`, Heroku git remote, `heroku` in CI | Heroku: git push to the app remote, pipeline promote, or CI on branch push |
| `.github/workflows/*` with `deploy`/`release` jobs | GitHub Actions: branch push, tag, or `workflow_dispatch` (`gh workflow run`) |
| `bitbucket-pipelines.yml` with `branches:` / `custom:` pipelines | Bitbucket Pipelines: push to a branch, or a custom pipeline |
| `.gitlab-ci.yml` with `environment:` | GitLab CI environments |
| `fly.toml`, `render.yaml`, `vercel.json`, `netlify.toml` | That platform's CLI or git integration |
| `helm/`, `k8s/`, `kustomization.yaml`, Argo CD app | Kubernetes: image tag bump in a deploy repo or `helm upgrade` |
| `terraform/`, `serverless.yml`, `cdk.json`, `sam` template | IaC apply / framework deploy |
| `scripts/deploy*`, `Makefile` deploy target, `bin/deploy` | Read the script: it is the source of truth |

Shared-staging-branch pattern: staging is a branch that feature branches are merged into
additively (never reset); a push triggers the pipeline. Conflicts go through `resolve-conflicts`.

## What is in production
Find the deployed ref: a release tag, a `production`/`prod` branch, the platform's current release
(`heroku releases -a <app>`, `gh api repos/<o>/<r>/deployments`), or the CI's last successful prod run.
Changelog = `git log <deployed ref>..<main>`.

## Feature flags
| Dependency | System | Toggle |
|---|---|---|
| `flipper` | Flipper | console `Flipper.disable(:name)` or Flipper UI |
| `launchdarkly*` | LaunchDarkly | dashboard/API |
| `unleash*` | Unleash | dashboard/API |
| `waffle`, `django-flags` | Django | admin or console |
| `growthbook*`, `statsig*`, `posthog*` | that platform | dashboard/API |
| env-var flags | config var | platform config set (restarts) |

Production flag changes: hand the command to the user, or list the API call.

## Rollback options (fastest first)
1. Turn the feature flag off (if the change is behind one).
2. Platform rollback to the previous release (`heroku rollback`, re-run the previous deploy job,
   Argo/helm rollback).
3. Revert PR (`git revert -m 1 <merge sha>`) through the normal pipeline.
4. Traffic shift (canary/blue-green) if the platform supports it.
Migrations: check whether the previous release still works with the new schema before choosing 2.
