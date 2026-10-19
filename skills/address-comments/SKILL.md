---
name: address-comments
description: >-
  Work through code review comments on your own PR: check each one makes sense against the
  requirements and code, implement the valid ones, verify, commit, then queue push, short replies
  and thread resolution (bots resolved, humans left open) for confirmation. Any PR host. Use on "address the review comments", "address CR
  comments", "fix PR feedback", "respond to review", "/address-comments".
argument-hint: "[pr url|number]"
---

# Address comments

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.
Host commands: `../../shared/references/pr-hosts.md`.

## 1. Fetch
- The PR: given, or the open PR for the current branch.
- Unresolved review threads and general comments not yet answered by you. Skip resolved, deleted and
  outdated threads whose code no longer exists (mention them). None left: say
  `Nothing to address on <PR>.` and stop, before any worktree or ticket work.
- Work in its branch (its existing worktree under `~/.dev-skills/worktrees/` if there is one;
  otherwise create one as in `implement`).
- Requirements: the ticket via `dev-skills:gather-context` (reuse `context.md` if present).

## 2. Decide per comment
Tell humans from bots: GitHub `author.__typename == "Bot"` or a login ending in `[bot]`; known review
bots (CodeRabbit, Copilot, Sonar, Codecov...) count as bots. Then check whether the comment makes
sense against the code and the requirements:
- **Valid:** implement it, including optional suggestions and nits.
- **Not valid** (wrong about the code, would introduce a bug, or adds a large change the ticket does
  not need): no change; reply with the reason in one short sentence.
- **Contradicts the ticket:** no change yet; reply tagging the ticket's author to confirm (their PR
  host handle if known, otherwise also comment on the ticket mentioning them). Keep it open.
- **Question:** answer it; change code only if the answer reveals a problem.
- Two comments conflicting with each other: follow the more senior/blocking reviewer's and note it.
- Ask the user (unattended: list it) when following a comment would change behavior well beyond what
  the comment or ticket says, or when stuck.
Declines follow the mode: `autonomous` decide and record; `balanced` decide and show in the
confirmation list; `guided` ask per comment.

## 3. Change, verify, commit
Implement the accepted changes. Run `dev-skills:qa` in `verify` mode on what changed. Commit locally
per the mode, one commit per logical change or one commit for all, following the repo's history style.
If the branch needs the latest base to pass, merge it in (conflicts via `dev-skills:resolve-conflicts`);
rebasing a pushed branch is a confirmation-list item.

## 4. Queue
Replies are short, especially to humans. Per thread:

| Comment | Reply | Thread |
|---|---|---|
| Valid, done | `Done! @<commenter>` (nothing else) | human: leave open · bot: resolve |
| Not valid | `@<commenter> <reason, one sentence>` | human: leave open · bot: resolve |
| Contradicts ticket | `@<commenter> this goes against <TICKET> (<what>). @<ticket author> can you confirm?` | leave open |

- Push first; replies go after the push.
- General (non-thread) comments: reply with a PR comment; there is nothing to resolve.
- Re-request review from humans if the host supports it.

## Report
```
PR <link>
| # | Comment (short) | Decision | Change |
|---|---|---|---|
| 1 | `file:line` "use a transaction here" | done | <sha> |
| 2 | "rename X" | declined | <reason> |
Checks: <command> → pass/fail
<confirmation list>
```
