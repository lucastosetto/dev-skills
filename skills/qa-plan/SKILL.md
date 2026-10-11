---
name: qa-plan
description: >-
  Build a QA plan (automated unit/integration/E2E cases plus manual UI-first steps) from a spec,
  ticket, or the current branch's changes. Minimal by default; full BDD on request. Use on
  "write a QA plan", "test plan", "how should we test this", "/qa-plan", "/qa-plan full".
argument-hint: "[spec path|ticket] [minimal|full]"
---

# QA plan

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.

## Inputs
The spec (`spec.md`) or context for the ticket if present; otherwise the current branch's diff
against the base branch, plus the conversation. Look at how the project already tests similar code
(test folders, factories/fixtures, E2E setup) so cases fit the existing suites.

## Depth
- **minimal** (default; also "smoke", "simple"): happy paths plus the few most likely edge cases.
- **full** ("complete", "detailed"): every meaningful edge case, BDD style, with preconditions,
  steps, expected results and postconditions.

## Write it
Save `qa-plan.md` next to the spec (or in the work folder for the branch).

```markdown
# QA plan — <TICKET> <title> (<minimal|full>)

## Automated
| Tier | File / suite | Case | Covers |
|---|---|---|---|
| unit | `spec/models/foo_spec.rb` | rejects negative amount | AC2 |
| integration | ... | ... | ... |
| e2e | ... | ... | ... |

## Manual
### Setup
<data and accounts needed, through the UI where possible; API/console only when the UI cannot>
### Scenarios
1. <action> → <expected result>          (minimal)
   Given / When / Then                     (full)

## Out of scope
```

Manual steps are written for a QA engineer without deep engineering knowledge and target the UI.
When the UI does not exist yet or setup needs the API, write API steps and say why.
Every acceptance criterion maps to at least one case. The plan must be runnable by `dev-skills:qa`.
