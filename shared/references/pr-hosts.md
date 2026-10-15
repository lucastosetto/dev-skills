# PR hosts

Detect from `git remote get-url origin`. Always note the PR's **target branch**: PRs are often
stacked on an unmerged branch, not the default branch.

## GitHub
- View: `gh pr view <n> --json number,title,body,state,baseRefName,headRefName,author,reviewDecision,url`
- Diff: `gh pr diff <n>`. Full files: `git fetch origin <head> <base>`, then `git show "origin/<head>:<path>"`.
- Review threads (resolved state, my comments): `gh api graphql` on `pullRequest.reviewThreads`
  (fields `id isResolved isOutdated`, `comments { author { __typename login } body path line createdAt }`).
- Resolve a thread: `gh api graphql -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}' -f id=<thread id>`.
- Failed checks: `gh pr checks <n>`; logs `gh run view <run id> --log-failed`; rerun `gh run rerun <run id> --failed`.
- My PRs: `gh pr list --author @me --state all --json number,title,state,reviewDecision,updatedAt,url`.
- PRs I reviewed: `gh search prs --reviewed-by @me --updated ">=<date>"`.
- Waiting on my review: `gh search prs --review-requested=@me --state open`; across repos also
  `gh search prs --owner <org> --state open --involves @me`.
- CI and conflicts: `gh pr view <n> --json statusCheckRollup,mergeable,mergeStateStatus`.
- Pending (private draft) review: `gh api repos/<o>/<r>/pulls/<n>/reviews --input <json>` with
  `commit_id`, `body` and `comments[]` (`path`, `line`, `side`, `body`) and **no `event`**; it stays
  visible only to you until submitted.
- Create: `gh pr create --base <base> --title ... --body-file <file>`; template at
  `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`.
- Inline comment: `gh api repos/<o>/<r>/pulls/<n>/comments -f body=... -f commit_id=<head sha> -f path=... -F line=... -f side=RIGHT`.
  Reply to a thread: `.../pulls/<n>/comments/<id>/replies`.

## Bitbucket
- PR and its comments: `<plugin root>/shared/bin/bb-pr <workspace/repo> <id> [--all]` prints the PR
  (branches, head, reviewers with approval/state) and its open threads (path, line, author, body) in
  one small JSON. Use it instead of the MCP's get pull request / list comments, which return 20–30k
  characters per call. `--all` adds resolved threads.
- Other actions: Bitbucket MCP (diff, create PR, create/reply comment), found via ToolSearch
  "bitbucket pull request". List responses can be large and spill to a file: parse with `jq`.
- Waiting on my review: open PRs where I'm in `reviewers` and haven't approved (`participants[].approved`).
- No private draft reviews: keep review drafts in the report.
- Comments: `inline.path` / `inline.to` for location; `parent.id` for replies; `deleted` and
  resolution state to filter.
- Templates: team description templates usually live in the repo docs or a project skill; check the profile.

## GitLab
- `glab mr view <n>`, `glab mr diff <n>`, `glab mr list --author=@me`, `glab mr create`,
  `glab mr note <n> -m ...`. Threads: `glab api projects/:id/merge_requests/<n>/discussions`.
  Resolve: `glab api -X PUT projects/:id/merge_requests/<n>/discussions/<id> -f resolved=true`.
  Failed jobs: `glab ci view`, `glab ci trace <job>`.

## No tool available
Report it and hand the user the drafted title/body/comments to paste.
