#!/usr/bin/env bash
# Checks shared/bin/todo-github against a fake gh. Run: tests/todo_github_test.sh
set -u
repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export PATH="$tmp/bin:$PATH"
mkdir -p "$tmp/bin"
cat > "$tmp/reviews.json" <<'JSON'
{"data": {"search": {"nodes": [{"url": "https://github.com/a/b/pull/1", "number": 1, "title": "Add x", "isDraft": false,
  "updatedAt": "2026-10-14T10:00:00Z", "additions": 10, "deletions": 2, "headRefName": "PROJ-1-x",
  "reviewDecision": "REVIEW_REQUIRED", "mergeable": "MERGEABLE", "author": {"login": "dan"},
  "repository": {"nameWithOwner": "a/b"},
  "commits": {"nodes": [{"commit": {"statusCheckRollup": {"state": "SUCCESS"}}}]},
  "reviewThreads": {"nodes": []}}]}}}
JSON
cat > "$tmp/mine.json" <<'JSON'
{"data": {"search": {"nodes": [{"url": "https://github.com/a/b/pull/2", "number": 2, "title": "Fix y", "isDraft": false,
  "updatedAt": "2026-10-14T11:00:00Z", "additions": 5, "deletions": 1, "headRefName": "PROJ-2-y",
  "reviewDecision": "CHANGES_REQUESTED", "mergeable": "CONFLICTING", "author": {"login": "me"},
  "repository": {"nameWithOwner": "a/b"},
  "commits": {"nodes": [{"commit": {"statusCheckRollup": null}}]},
  "reviewThreads": {"nodes": [
    {"isResolved": false, "comments": {"nodes": [{"author": {"login": "dan"}}]}},
    {"isResolved": false, "comments": {"nodes": [{"author": {"login": "me"}}]}},
    {"isResolved": true, "comments": {"nodes": [{"author": {"login": "dan"}}]}}]}}]}}}
JSON
cat > "$tmp/mentions.json" <<'JSON'
{"data": {"search": {"nodes": [{"url": "https://github.com/a/b/issues/3", "title": "Bug z", "updatedAt": "2026-10-13T09:00:00Z",
  "author": {"login": "eve"}, "repository": {"nameWithOwner": "a/b"}}]}}}
JSON
cat > "$tmp/bin/gh" <<SH
#!/bin/sh
case "\$2" in
  user) echo me ;;
  graphql) echo "\$*" >> "$tmp/args"
    case "\$*" in
      *review-requested:*) cat "$tmp/reviews.json" ;;
      *mentions:me*) cat "$tmp/mentions.json" ;;
      *) cat "$tmp/mine.json" ;;
    esac ;;
esac
SH
chmod +x "$tmp/bin/gh"
fails=0
check() { if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1: got $2, want $3"; fails=$((fails + 1)); fi; }

out=$("$repo/shared/bin/todo-github" 2026-10-11)
check "exit 0" $? 0
check "login" "$(jq -r .login <<<"$out")" me
check "review request" "$(jq -c '.reviews[0] | [.repo, .number, .author, .ci, .add]' <<<"$out")" '["a/b",1,"dan","SUCCESS",10]'
check "mine: decision and conflicts" "$(jq -c '.mine[0] | [.review, .mergeable, .ci]' <<<"$out")" '["CHANGES_REQUESTED","CONFLICTING",null]'
check "mine: only unresolved threads someone else spoke last on" "$(jq '.mine[0].waiting_threads' <<<"$out")" 1
check "mention" "$(jq -c '.mentions[0] | [.title, .author]' <<<"$out")" '["Bug z","eve"]'
check "one search per list" "$(grep -c graphql "$tmp/args")" 3
check "mentions use login and since" "$(grep -c 'mentions:me -author:me updated:>=2026-10-11' "$tmp/args")" 1

printf '#!/bin/sh\n[ "$2" = user ] && echo me || exit 1\n' > "$tmp/bin/gh"
"$repo/shared/bin/todo-github" >/dev/null 2>&1
check "a failing search fails the script" $? 1
exit $fails
