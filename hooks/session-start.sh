#!/usr/bin/env bash
# Tells Claude where the plugin lives, where its policy is, and the global autonomy mode.
root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
mode="${CLAUDE_PLUGIN_OPTION_MODE:-}"
case "$mode" in
  autonomous|balanced|guided) mode_line="Global mode: ${mode} (source: global)." ;;
  *) mode_line="Global mode: not set, so the default balanced applies (source: default)." ;;
esac

context="dev-skills: plugin root ${root}. ${mode_line} Before running any dev-skills skill, and before any push, PR, ticket, comment, message, deploy or shared-data write (even outside a skill), read and follow ${root}/shared/policy.md."

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$context"
