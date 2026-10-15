#!/usr/bin/env bash
# Checks shared/bin/bb-pr against a fake curl. Run: tests/bb_pr_test.sh
set -u
repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export PATH="$tmp/bin:$PATH" BITBUCKET_USERNAME=me@example.com BITBUCKET_API_TOKEN=t
mkdir -p "$tmp/bin"
cat > "$tmp/pr.json" <<'JSON'
{"id": 7, "title": "Add x", "description": "Does x", "state": "OPEN", "draft": false,
 "author": {"display_name": "Me"}, "source": {"branch": {"name": "PROJ-7-x"}, "commit": {"hash": "abc"}},
 "destination": {"branch": {"name": "main"}}, "links": {"html": {"href": "https://bitbucket.org/w/r/pull-requests/7"}},
 "participants": [{"user": {"display_name": "Dan", "account_id": "d1"}, "role": "REVIEWER", "approved": false, "state": "changes_requested"}]}
JSON
cat > "$tmp/c1.json" <<'JSON'
{"next": "https://api.bitbucket.org/2.0/repositories/w/r/pullrequests/7/comments?page=2",
 "values": [
  {"id": 1, "user": {"display_name": "Dan", "account_id": "d1"}, "created_on": "2026-10-01T10:00:00Z", "deleted": false, "pending": false,
   "content": {"raw": "use a transaction"}, "inline": {"path": "a.rb", "to": 12, "from": null}},
  {"id": 2, "user": {"display_name": "Bot", "account_id": "b1"}, "created_on": "2026-10-01T11:00:00Z", "deleted": false, "pending": false,
   "resolution": {}, "content": {"raw": "lint"}, "inline": {"path": "b.rb", "to": null, "from": 3}},
  {"id": 3, "user": {"display_name": "Dan", "account_id": "d1"}, "created_on": "2026-10-01T12:00:00Z", "deleted": true, "pending": false,
   "content": {"raw": ""}}]}
JSON
cat > "$tmp/c2.json" <<'JSON'
{"values": [
  {"id": 4, "parent": {"id": 1}, "user": {"display_name": "Me", "account_id": "m1"}, "created_on": "2026-10-02T09:00:00Z", "deleted": false, "pending": false,
   "content": {"raw": "why?"}},
  {"id": 5, "parent": {"id": 4}, "user": {"display_name": "Dan", "account_id": "d1"}, "created_on": "2026-10-02T10:00:00Z", "deleted": false, "pending": false,
   "content": {"raw": "atomicity"}},
  {"id": 6, "parent": {"id": 1}, "user": {"display_name": "Me", "account_id": "m1"}, "created_on": "2026-10-02T11:00:00Z", "deleted": false, "pending": true,
   "content": {"raw": "draft"}}]}
JSON
cat > "$tmp/bin/curl" <<SH
#!/bin/sh
for a; do u=\$a; done
case "\$u" in
  *comments\?page=2*) cat "$tmp/c2.json" ;;
  */comments*) cat "$tmp/c1.json" ;;
  *) cat "$tmp/pr.json" ;;
esac
SH
chmod +x "$tmp/bin/curl"
fails=0
check() { if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1: got $2, want $3"; fails=$((fails + 1)); fi; }

out=$("$repo/shared/bin/bb-pr" w/r 7)
check "exit 0" $? 0
check "pr fields" "$(jq -c '.pr | [.number, .branch, .base, .reviewers[0].state]' <<<"$out")" '[7,"PROJ-7-x","main","changes_requested"]'
check "resolved thread hidden" "$(jq -c '[.threads[].id]' <<<"$out")" '[1]'
check "replies across pages, nested, no pending" "$(jq -c '[.threads[0].comments[].id]' <<<"$out")" '[1,4,5]'
check "location" "$(jq -c '.threads[0] | [.path, .line, .resolved]' <<<"$out")" '["a.rb",12,false]'

all=$("$repo/shared/bin/bb-pr" w/r 7 --all)
check "--all keeps resolved, line from 'from'" "$(jq -c '[.threads[] | [.id, .line, .resolved]]' <<<"$all")" '[[1,12,false],[2,3,true]]'

[ $fails -eq 0 ] && echo "all passed" || { echo "$fails failed"; exit 1; }
