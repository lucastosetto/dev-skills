#!/usr/bin/env bash
# Checks shared/bin/changed against a fake gh. Run: tests/changed_test.sh
set -u
repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export DEV_SKILLS_HOME="$tmp/home" PATH="$tmp/bin:$PATH"
mkdir -p "$tmp/bin"
fake_gh() { printf '#!/bin/sh\necho "$*" > %s/args\n%s\n' "$tmp" "$1" > "$tmp/bin/gh"; chmod +x "$tmp/bin/gh"; }
fails=0
check() { if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1: got $2, want $3"; fails=$((fails + 1)); fi; }
changed() { "$repo/shared/bin/changed" "$@" >/dev/null; echo $?; }

fake_gh 'printf "HTTP/2.0 200 OK\r\nLast-Modified: Tue, 13 Oct 2026 14:23:51 GMT\r\n\r\n[]\n"'
check "new activity runs" "$(changed inbox)" 0
check "stores Last-Modified" "$(cat "$tmp/home/changed/inbox.lastmod")" "Tue, 13 Oct 2026 14:23:51 GMT"
fake_gh 'printf "HTTP/2.0 304 Not Modified\r\n\r\n"; exit 1'
check "304 within max age skips" "$(changed inbox)" 1
check "sends If-Modified-Since" "$(grep -c 'If-Modified-Since: Tue, 13 Oct 2026 14:23:51 GMT' "$tmp/args")" 1
echo 0 > "$tmp/home/changed/inbox.ran"
check "304 past max age runs" "$(changed inbox)" 0
check "and records the run" "$(changed inbox)" 1
fake_gh 'echo "gh: not logged in" >&2; exit 4'
check "gh failure exits 2" "$(changed inbox)" 2

[ $fails -eq 0 ] && echo "all changed checks passed" || { echo "$fails check(s) failed"; exit 1; }
