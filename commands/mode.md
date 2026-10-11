---
description: Show or switch the dev-skills autonomy mode (autonomous | balanced | guided), for this session, this project, or globally.
argument-hint: "[autonomous|balanced|guided] [project|global]"
---

Arguments: `$ARGUMENTS`

Follow the "Mode" section of the dev-skills `shared/policy.md`.

- **No arguments:** print the active mode and its source, resolved with the policy's order
  (request > session > project > global > default). Format: `Mode: <mode> (<source>)`.
- **`<mode>` only:** from now on in this conversation, use `<mode>`. Reply with one line:
  `Mode: <mode> (session)`.
- **`<mode> project`:** run the dev-skills `project-profile` skill to find this repo's profile, then
  set `mode: <mode>` in its `## Mine` section (replace an existing `mode:` line, never touch
  `## Discovered`). Also apply it to this conversation. Reply with the profile path.
- **`<mode> global`:** run
  `echo '{"mode":"<mode>"}' | claude plugin configure dev-skills --values-stdin`
  and apply it to this conversation too. It reaches new sessions through the startup hook.

Reject any mode other than `autonomous`, `balanced` or `guided` and list the three.
This command only changes Claude Code settings or files under `~/.claude/`, never a repo, so it
needs no confirmation.
