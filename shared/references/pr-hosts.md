# PR hosts

Detect from `git remote get-url origin`. Always note the PR's **target branch**: PRs are often
stacked on an unmerged branch, not the default branch.

## GitHub
- View: `gh pr view <n> --json number,title,body,state,baseRefName,headRefName,author,reviewDecision,url`
- Diff: `gh pr diff <n>`. Full files: `git fetch origin <head> <base>`, then `git show "origin/<head>:<path>"`.
- Review threads (resolved state, my comments): `gh api graphql` on `pullRequest.reviewThreads`
  (fields `isResolved`, `comments { author { login } body path line createdAt }`).
- My PRs: `gh pr list --author @me --state all --json number,title,state,reviewDecision,updatedAt,url`.
- PRs I reviewed: `gh search prs --reviewed-by @me --updated ">=<date>"`.
- Create: `gh pr create --base <base> --title ... --body-file <file>`; template at
  `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`.
- Inline comment: `gh api repos/<o>/<r>/pulls/<n>/comments -f body=... -f commit_id=<head sha> -f path=... -F line=... -f side=RIGHT`.
  Reply to a thread: `.../pulls/<n>/comments/<id>/replies`.

## Bitbucket
- Tools: Bitbucket MCP (get pull request, diff, comments, create PR, create comment), found via
  ToolSearch "bitbucket pull request".
- List responses can be large and spill to a file: parse with `jq`.
- Comments: `inline.path` / `inline.to` for location; `parent.id` for replies; `deleted` and
  resolution state to filter.
- Templates: team description templates usually live in the repo docs or a project skill; check the profile.

## GitLab
- `glab mr view <n>`, `glab mr diff <n>`, `glab mr list --author=@me`, `glab mr create`,
  `glab mr note <n> -m ...`. Threads: `glab api projects/:id/merge_requests/<n>/discussions`.

## No tool available
Report it and hand the user the drafted title/body/comments to paste.
