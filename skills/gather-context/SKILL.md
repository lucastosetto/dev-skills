---
name: gather-context
description: >-
  Read and understand requirements from any source (Jira/Linear/GitHub ticket, Slack thread, Notion/
  Confluence/Google doc, PR, error traceback, pasted text), trace the code they touch, and list
  acceptance criteria, blockers and open questions. Used first by implement, spec, investigate,
  pr-review and address-comments; also on "read this ticket", "what does this ticket need",
  "understand the requirements", "map blockers".
---

# Gather context

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` if not loaded this session.
Reads only.

## 1. Fetch every input
Identify each input's type from its shape (ticket key/URL, Slack link, doc URL, PR URL, stack trace).
- **Ticket:** per `../../shared/references/trackers.md`. Description **and** comments (requirements
  often live only in comments), linked issues, parent epic, attachments list, linked docs/designs.
- **Docs/threads:** Notion, Confluence, Google Docs, Slack through connected tools (ToolSearch).
  Follow links one level deep when they look like requirements.
- **Related work:** search the tracker and PR host for the ticket key and key terms: earlier PRs,
  duplicate or sibling tickets.
- Unreachable source: note it as a gap; continue with the rest.
- Fetch in one haiku subagent (policy "Delegating big reads"), returning verbatim: description,
  comments (author, date), linked issues and docs, attachment names, related PRs and tickets. Keep
  steps 2 and 3 in the main thread.

## 2. Trace the code
Read the repo's `CLAUDE.md`/README for conventions. Find the entry points the requirement touches
and trace end to end (route → logic → data → jobs/webhooks → frontend if relevant). Note `file:line`
for each place that will change or constrain the change. Check `git log` on those files for recent
related changes.

## 3. Find the gaps
- **Acceptance criteria:** explicit ones verbatim; inferred ones marked `(inferred)`.
- **Unknowns:** anything the inputs and code cannot answer. For each: the question, why it matters,
  and the assumption to proceed with.
- **Blockers:** things that stop the work (missing access, dependency on another team's change,
  contradictory requirements).
- Resolve what you can from code, other tickets, and docs before calling it unknown.

Apply the mode (policy "Autonomy"): in `guided` ask the unknowns now; in `balanced` ask only an
unknown that would change the work materially; otherwise keep the assumptions.

## Output
Write `~/.dev-skills/work/<project-slug>/<TICKET or short-slug>/context.md`:

```markdown
# <TICKET> — <title>
Sources: <links read> · Gaps: <sources not reachable>

## Summary
<3-5 lines: what is asked and why>

## Acceptance criteria
- [ ] ...

## Code map
- `path:line` — <role in the change>

## Related
- <PR/ticket> — <relation>

## Unknowns
1. <question> — matters because <...> — assuming <...>

## Blockers
- <blocker or "none">
```

Return the path and the summary. Questions for product or the manager are drafts: they go to the
confirmation list only when the user wants them sent.
