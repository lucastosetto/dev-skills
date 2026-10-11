---
name: spec
description: >-
  Write an implementation spec for a feature or bug fix from a ticket or requirements, or, in rfc
  mode, a structured RFC for others to review (context, goals, proposal, alternatives, risks,
  rollout). Use on "write a spec", "plan the implementation", "how should we build this",
  "create an RFC", "design doc", "/spec", "/spec rfc".
argument-hint: "<ticket|url|context path> [rfc]"
---

# Spec

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.

## 1. Context
Use an existing `context.md` for this ticket if there is one; otherwise run
`dev-skills:gather-context` first.

## 2. Choose the approach
Read the code the context maps. Consider the realistic options (usually 1-3). Pick the one that
solves the requirement at the root with the smallest change that fits the codebase's existing
patterns; reuse what already exists.
- `autonomous` / `balanced`: decide and record why in the spec.
- `guided`: present the options with trade-offs and a recommendation; wait for the choice.

## 3. Write it
Save `spec.md` next to `context.md`.

**Default mode** (for the developer):
```markdown
# Spec — <TICKET> <title>
## Approach
<what and why, 3-6 lines>
## Changes
- `path` — <change>
## Data / migrations
## API / contract changes
## Flags and rollout
## Risks and edge cases
## Testing
<pointer to qa-plan.md, or the test cases if small>
## Assumed
```
Omit empty sections.

**rfc mode** (for reviewers): same research, more structure and less code detail:
Context · Problem · Goals / Non-goals · Proposal (with a diagram when flows or components change) ·
Alternatives considered (and why not) · Risks and mitigations · Rollout and rollback ·
Testing strategy · Open questions · Timeline/effort.
Save as `rfc.md`. Publishing it to Notion/Confluence/Docs goes to the confirmation list.

## 4. QA plan
Unless the caller says otherwise, run `dev-skills:qa-plan` on the spec.

In `guided`, show the spec and QA plan and wait for approval before returning. Otherwise return the
paths and a 5-line summary.
